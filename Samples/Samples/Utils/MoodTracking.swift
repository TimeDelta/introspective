import Foundation
import CoreData
import Common
import DependencyInjection
import Persistence

public struct MoodWeeklyReview {
	/// Group actual stored instants in the review calendar's zone, without the legacy display-time shift.
	public static func timestamp(for mood: Mood) -> Date { (mood as? MoodImpl)?.timestamp ?? mood.date }
	public let analytics: MoodWeekComparison
	public var currentInterval: DateInterval { analytics.current.interval }
	public var previousInterval: DateInterval { analytics.previous.interval }
	public var current: MoodPeriodAnalytics { analytics.current }
	public var previous: MoodPeriodAnalytics { analytics.previous }
	public var distribution: [Int] { current.distribution }
	public var difference: Double? { analytics.difference }
	public static func intervals(endingOn date: Date, includingToday: Bool = false, calendar: Calendar = .current) -> (current: DateInterval, previous: DateInterval) {
		MoodWeekComparison.intervals(endingOn: date, includingToday: includingToday, calendar: calendar)
	}
	/// Call on the managed objects' queue; the returned value array can be processed independently.
	public static func observations(for moods: [Mood]) -> [MoodReviewObservation] {
		moods.map {
			MoodReviewObservation(date: Self.timestamp(for: $0), rating: $0.rating, minimum: $0.minRating, maximum: $0.maxRating,
				source: ($0 as? MoodImpl).flatMap { Sources.MoodSourceNum(rawValue: $0.source)?.description } ?? "Unknown")
		}
	}
	public init(analytics: MoodWeekComparison) { self.analytics = analytics }
	public init(moods: [Mood], endingOn date: Date = Date(), includingToday: Bool = false, calendar: Calendar = .current) {
		analytics = MoodWeekComparison(observations: Self.observations(for: moods), endingOn: date, includingToday: includingToday, calendar: calendar)
	}
}

public enum MoodPresetRecorder {
	/// Mood and its selected dated context are committed together; no partial check-in on failure.
	@discardableResult public static func record(_ preset: MoodCheckInPreset, at date: Date = Date()) throws -> Mood {
		try preset.validate()
		guard date.timeIntervalSinceReferenceDate.isFinite else { throw MoodTrackingError("Choose a valid check-in time.") }
		let categories = try preset.contexts.map { value -> ContextCategory in
			guard let category = ContextCategory(rawValue: value) else { throw MoodTrackingError("Edit this preset to update its context selections.") }
			return category
		}
		let transaction = try injected(Database.self).viewContextTransaction(for: MoodImpl.self, sortedBy: "timestamp")
		do {
			let mood = try transaction.new(MoodImpl.self)
			mood.setSource(.introspective); mood.date = date
			mood.rating = preset.rating; mood.minRating = preset.minimum; mood.maxRating = preset.maximum
			mood.note = preset.note.isEmpty ? nil : preset.note
			for category in categories {
				let entry = try transaction.new(MetricContextEntry.self)
				entry.timestamp = date; entry.category = category.rawValue; entry.metricKey = ContextMetric.mood.rawValue
			}
			try transaction.commit()
			return try injected(Database.self).pull(savedObject: mood)
		} catch { transaction.reset(); throw error }
	}
}
