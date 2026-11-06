import Foundation

/// Value input copied on the managed objects' owning queue before any background calculation.
public struct StressRatingObservation: Equatable {
	public let date: Date
	public let rating: Int?
	public let status: StressResponseStatus
	public let measurementKind: String
	public let scaleVersion: Int
	public init(date: Date, rating: Int?, status: StressResponseStatus = .rated,
		measurementKind: String = StressCheckInDraft.supportedMeasurementKind,
		scaleVersion: Int = StressCheckInDraft.currentScaleVersion) {
		self.date = date; self.rating = rating; self.status = status
		self.measurementKind = measurementKind; self.scaleVersion = scaleVersion
	}
}

public struct StressDailyAnalytics {
	public let date: Date
	public let offeredCount: Int
	public let ratedCount: Int
	public let skippedCount: Int
	public let notApplicableCount: Int
	public let invalidRatingCount: Int
	public let unsupportedMeasurementCount: Int
	public let averageRating: Double?
}

/// Statistics for either overall stress or one stable stressor identity, never a sum across stressors.
public struct StressPeriodAnalytics {
	public let interval: DateInterval
	/// Elapsed local dates in the window, including an incomplete today when selected.
	public let days: [StressDailyAnalytics]
	public let offeredCount: Int
	public let ratedCount: Int
	public let skippedCount: Int
	public let notApplicableCount: Int
	public let invalidRatingCount: Int
	public let unsupportedMeasurementCount: Int
	/// Non-finite dates in the supplied inputs cannot be assigned to a period.
	public let invalidTimestampCount: Int
	/// Inputs in this window after asOf are excluded from all response statistics.
	public let futureObservationCount: Int
	public let recordedDayCount: Int
	public let ratedDayCount: Int
	/// Counts for the five anchors, using only valid rated responses as the denominator.
	public let distribution: [Int]
	/// Every valid response has equal weight. Averages describe the ordinal anchor positions.
	public let averageRating: Double?
	/// Every elapsed day with a valid rating has equal weight; missing and unoffered days are not zero.
	public let dailyAverageRating: Double?
	public var excludedCount: Int { invalidRatingCount + unsupportedMeasurementCount }
	public var checkInCount: Int { offeredCount }
	public var ratedCheckInCount: Int { ratedCount }
	public var calendarDayCount: Int { days.count }

	public init(observations: [StressRatingObservation], interval: DateInterval, asOf date: Date = Date(), calendar: Calendar = .current) {
		self.interval = interval
		var buckets: [Date: Bucket] = [:]
		var total = Bucket(), bins = [Int](repeating: 0, count: StressRating.allCases.count)
		var badDates = 0, future = 0
		let validWindow = date.timeIntervalSinceReferenceDate.isFinite && interval.start.timeIntervalSinceReferenceDate.isFinite
			&& interval.end.timeIntervalSinceReferenceDate.isFinite && interval.start < interval.end
		for observation in observations {
			guard observation.date.timeIntervalSinceReferenceDate.isFinite else { badDates += 1; continue }
			guard validWindow, observation.date >= interval.start, observation.date < interval.end else { continue }
			guard observation.date <= date else { future += 1; continue }
			let day = calendar.startOfDay(for: observation.date)
			var bucket = buckets[day] ?? Bucket()
			bucket.add(observation)
			total.add(observation)
			if observation.measurementKind == StressCheckInDraft.supportedMeasurementKind,
				observation.scaleVersion == StressCheckInDraft.currentScaleVersion,
				observation.status == .rated, let rating = observation.rating, StressRating(rawValue: rating) != nil {
				bins[rating] += 1
			}
			buckets[day] = bucket
		}
		var daily: [StressDailyAnalytics] = []
		if validWindow {
			var day = calendar.startOfDay(for: interval.start)
			while day < interval.end && day <= date {
				let bucket = buckets[day] ?? Bucket()
				daily.append(StressDailyAnalytics(date: day, offeredCount: bucket.offered, ratedCount: bucket.rated,
					skippedCount: bucket.skipped, notApplicableCount: bucket.notApplicable,
					invalidRatingCount: bucket.invalid, unsupportedMeasurementCount: bucket.unsupported,
					averageRating: bucket.average))
				guard let current = calendar.dateInterval(of: .day, for: day), current.end > day else { break }
				day = current.end
			}
		}
		days = daily; offeredCount = total.offered; ratedCount = total.rated
		skippedCount = total.skipped; notApplicableCount = total.notApplicable
		invalidRatingCount = total.invalid; unsupportedMeasurementCount = total.unsupported
		invalidTimestampCount = badDates; futureObservationCount = future
		recordedDayCount = daily.filter { $0.offeredCount > 0 }.count
		ratedDayCount = daily.filter { $0.ratedCount > 0 }.count
		distribution = bins; averageRating = total.average
		let dailyValues = daily.compactMap { $0.averageRating }
		dailyAverageRating = dailyValues.isEmpty ? nil : dailyValues.reduce(0, +) / Double(dailyValues.count)
	}

	private struct Bucket {
		var offered = 0, rated = 0, skipped = 0, notApplicable = 0, invalid = 0, unsupported = 0
		var sum = 0.0
		var average: Double? { rated == 0 ? nil : sum / Double(rated) }
		mutating func add(_ observation: StressRatingObservation) {
			offered += 1
			guard observation.measurementKind == StressCheckInDraft.supportedMeasurementKind,
				observation.scaleVersion == StressCheckInDraft.currentScaleVersion else { unsupported += 1; return }
			switch observation.status {
			case .rated:
				guard let rating = observation.rating, StressRating(rawValue: rating) != nil else { invalid += 1; return }
				rated += 1; sum += Double(rating)
			case .skipped:
				if observation.rating == nil { skipped += 1 } else { invalid += 1 }
			case .notApplicable:
				if observation.rating == nil { notApplicable += 1 } else { invalid += 1 }
			}
		}
	}
}

/// Calendar arithmetic for recent reviews and equal-length periods around a chosen change date.
public enum StressReviewWindow {
	public static func recentInterval(days: Int, asOf date: Date = Date(), calendar: Calendar = .current) -> DateInterval? {
		guard days > 0, date.timeIntervalSinceReferenceDate.isFinite,
			let today = calendar.dateInterval(of: .day, for: date),
			let first = addingDays(1 - days, to: today.start, calendar: calendar), first <= today.start else { return nil }
		return DateInterval(start: calendar.startOfDay(for: first), end: today.end)
	}

	public static func comparisonIntervals(changeDate: Date, days: Int = 7, asOf date: Date = Date(),
		calendar: Calendar = .current) -> (before: DateInterval, after: DateInterval)? {
		guard days > 0, changeDate.timeIntervalSinceReferenceDate.isFinite, date.timeIntervalSinceReferenceDate.isFinite,
			let today = calendar.dateInterval(of: .day, for: date),
			let change = calendar.dateInterval(of: .day, for: changeDate), change.start <= today.start,
			let start = addingDays(-days, to: change.start, calendar: calendar),
			let end = addingDays(days, to: change.start, calendar: calendar), start < change.start, change.start < end else { return nil }
		return (DateInterval(start: calendar.startOfDay(for: start), end: change.start),
			DateInterval(start: change.start, end: calendar.startOfDay(for: end)))
	}

	private static func addingDays(_ count: Int, to date: Date, calendar: Calendar) -> Date? {
		guard let moved = calendar.date(byAdding: .day, value: count, to: date),
			moved.timeIntervalSinceReferenceDate.isFinite,
			calendar.dateComponents([.day], from: date, to: moved).day == count else { return nil }
		return moved
	}
}

public struct StressPeriodComparison {
	public let before: StressPeriodAnalytics
	public let after: StressPeriodAnalytics
	public let changeDate: Date
	/// Positive means higher recorded stress after the chosen date; this is not a causal estimate.
	public var dailyAverageDifference: Double? {
		guard let earlier = before.dailyAverageRating, let later = after.dailyAverageRating else { return nil }
		return later - earlier
	}
	public init?(observations: [StressRatingObservation], changeDate: Date, days: Int = 7,
		asOf date: Date = Date(), calendar: Calendar = .current) {
		guard let periods = StressReviewWindow.comparisonIntervals(changeDate: changeDate, days: days, asOf: date, calendar: calendar) else { return nil }
		self.changeDate = periods.after.start
		before = StressPeriodAnalytics(observations: observations, interval: periods.before, asOf: date, calendar: calendar)
		after = StressPeriodAnalytics(observations: observations, interval: periods.after, asOf: date, calendar: calendar)
	}
}
