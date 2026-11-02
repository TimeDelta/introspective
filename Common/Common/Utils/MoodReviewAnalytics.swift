import Foundation

/// Immutable input: analytics never read live managed objects on a worker queue.
public struct MoodReviewObservation {
	public let date: Date
	public let rating: Double
	public let minimum: Double
	public let maximum: Double
	public let source: String
	public init(date: Date, rating: Double, minimum: Double, maximum: Double, source: String = "Unspecified") {
		self.date = date; self.rating = rating; self.minimum = minimum; self.maximum = maximum
		self.source = source
	}
}

public struct MoodDailyAnalytics {
	public let date: Date
	public let checkInCount: Int
	public let ratedCheckInCount: Int
	public let averagePosition: Double?
}

/// Descriptive values on the original rating scales, normalized to 0...1, never clinical scores.
public struct MoodPeriodAnalytics {
	public let interval: DateInterval
	public let days: [MoodDailyAnalytics]
	public let checkInCount: Int
	public let ratedCheckInCount: Int
	public let recordedDayCount: Int
	public let ratedDayCount: Int
	public let invalidScaleCount: Int
	public let invalidRatingCount: Int
	public let outOfRangeCount: Int
	/// All recorded check-ins, including ratings excluded from statistics.
	public let sourceCounts: [String: Int]
	/// Every valid check-in has equal weight.
	public let averagePosition: Double?
	/// Every day containing a valid rating has equal weight. Missing days are omitted, never zero-filled.
	public let dailyAveragePosition: Double?
	public let medianPosition: Double?
	public let lowerQuartile: Double?
	public let upperQuartile: Double?
	/// Sample standard deviation (n - 1); unavailable with fewer than two valid check-ins.
	public let standardDeviation: Double?
	/// [0,.2), [.2,.4), [.4,.6), [.6,.8), [.8,1].
	public let distribution: [Int]

	fileprivate init(observations: [MoodReviewObservation], interval: DateInterval, asOf date: Date, calendar: Calendar) {
		self.interval = interval
		var daily: [Date: (total: Int, rated: Int, sum: Double)] = [:]
		var values: [Double] = [], bins = [Int](repeating: 0, count: 5)
		var badScale = 0, badRating = 0, outside = 0, count = 0
		var sources: [String: Int] = [:]
		for entry in observations where entry.date >= interval.start && entry.date < interval.end && entry.date <= date {
			count += 1
			sources[entry.source, default: 0] += 1
			let day = calendar.startOfDay(for: entry.date)
			var bucket = daily[day] ?? (0, 0, 0)
			bucket.total += 1
			let span = entry.maximum - entry.minimum
			if !entry.minimum.isFinite || !entry.maximum.isFinite || !span.isFinite || span <= 0 { badScale += 1 }
			else if !entry.rating.isFinite { badRating += 1 }
			else if entry.rating < entry.minimum || entry.rating > entry.maximum { outside += 1 }
			else {
				let position = (entry.rating - entry.minimum) / span
				values.append(position); bucket.rated += 1; bucket.sum += position
				bins[min(4, Int(position * 5))] += 1
			}
			daily[day] = bucket
		}
		checkInCount = count; ratedCheckInCount = values.count
		invalidScaleCount = badScale; invalidRatingCount = badRating; outOfRangeCount = outside
		sourceCounts = sources
		distribution = bins
		var dayValues: [MoodDailyAnalytics] = []
		var day = interval.start
		while day < interval.end {
			let bucket = daily[day] ?? (0, 0, 0)
			dayValues.append(MoodDailyAnalytics(date: day, checkInCount: bucket.total, ratedCheckInCount: bucket.rated,
				averagePosition: bucket.rated == 0 ? nil : bucket.sum / Double(bucket.rated)))
			guard let next = calendar.date(byAdding: .day, value: 1, to: day), next > day else { break }
			day = next
		}
		days = dayValues
		recordedDayCount = dayValues.filter { $0.checkInCount > 0 }.count
		ratedDayCount = dayValues.filter { $0.ratedCheckInCount > 0 }.count
		dailyAveragePosition = Self.mean(dayValues.compactMap { $0.averagePosition })
		averagePosition = Self.mean(values)
		let sorted = values.sorted()
		medianPosition = Self.percentile(0.5, sorted: sorted)
		lowerQuartile = Self.percentile(0.25, sorted: sorted); upperQuartile = Self.percentile(0.75, sorted: sorted)
		if let mean = averagePosition, values.count > 1 {
			standardDeviation = sqrt(values.reduce(0) { $0 + ($1 - mean) * ($1 - mean) } / Double(values.count - 1))
		} else { standardDeviation = nil }
	}
	private static func mean(_ values: [Double]) -> Double? { values.isEmpty ? nil : values.reduce(0, +) / Double(values.count) }
	/// Linear interpolation at (n - 1) * p, including endpoints.
	private static func percentile(_ p: Double, sorted: [Double]) -> Double? {
		guard !sorted.isEmpty else { return nil }
		let index = Double(sorted.count - 1) * p
		let lower = Int(index), upper = min(sorted.count - 1, Int(index) + 1)
		return sorted[lower] + (sorted[upper] - sorted[lower]) * (index - Double(lower))
	}
}

public struct MoodWeekComparison {
	public let current: MoodPeriodAnalytics
	public let previous: MoodPeriodAnalytics
	public let includingToday: Bool
	public let invalidTimestampCount: Int
	public let futureCheckInCount: Int
	public var matchedDayCount: Int { matchedDayChanges.count }
	/// Compares only weekday pairs with valid ratings in both periods; still descriptive.
	public var matchedDayDifference: Double? {
		let values = matchedDayChanges
		return values.isEmpty ? nil : values.reduce(0, +) / Double(values.count)
	}
	private var matchedDayChanges: [Double] {
		zip(current.days, previous.days).compactMap { latest, earlier in
			guard let latest = latest.averagePosition, let earlier = earlier.averagePosition else { return nil }
			return latest - earlier
		}
	}
	public var difference: Double? {
		guard let latest = current.dailyAveragePosition, let earlier = previous.dailyAveragePosition else { return nil }
		return latest - earlier
	}
	public static func intervals(endingOn date: Date, includingToday: Bool = false,
		calendar: Calendar = .current) -> (current: DateInterval, previous: DateInterval) {
		let today = calendar.startOfDay(for: date)
		let end = includingToday ? calendar.date(byAdding: .day, value: 1, to: today)! : today
		let start = calendar.date(byAdding: .day, value: -7, to: end)!
		return (DateInterval(start: start, end: end), DateInterval(start: calendar.date(byAdding: .day, value: -7, to: start)!, end: start))
	}
	public init(observations: [MoodReviewObservation], endingOn date: Date = Date(), includingToday: Bool = false, calendar: Calendar = .current) {
		self.includingToday = includingToday
		let windows = Self.intervals(endingOn: date, includingToday: includingToday, calendar: calendar)
		let finite = observations.filter { $0.date.timeIntervalSinceReferenceDate.isFinite }
		invalidTimestampCount = observations.count - finite.count
		futureCheckInCount = finite.filter { $0.date > date && $0.date >= windows.current.start && $0.date < windows.current.end }.count
		current = MoodPeriodAnalytics(observations: finite, interval: windows.current, asOf: date, calendar: calendar)
		previous = MoodPeriodAnalytics(observations: finite, interval: windows.previous, asOf: date, calendar: calendar)
	}
}
