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
		try record(preset, at: date, contextFactory: { NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType) })
	}

	/// A separate writer commits only this check-in, without saving any pending UI edits.
	/// The factory is internal so failure paths can be exercised against real stores.
	@discardableResult internal static func record(_ preset: MoodCheckInPreset, at date: Date,
		contextFactory: () -> NSManagedObjectContext) throws -> Mood {
		try preset.validate()
		guard date.timeIntervalSinceReferenceDate.isFinite else { throw MoodTrackingError("Choose a valid check-in time.") }
		let categories = try preset.contexts.map { value -> ContextCategory in
			guard let category = ContextCategory(rawValue: value) else { throw MoodTrackingError("Edit this preset to update its context selections.") }
			return category
		}
		guard Thread.isMainThread else { throw GenericError("Preset check-ins require the main queue.") }
		let root = injected(Database.self).fetchedResultsController(type: MoodImpl.self,
			sortDescriptors: [NSSortDescriptor(key: "timestamp", ascending: true)]).managedObjectContext
		guard let coordinator = root.persistentStoreCoordinator else { throw GenericError("Missing persistent store coordinator for preset check-in.") }
		let context = contextFactory()
		guard context !== root, context.concurrencyType == .mainQueueConcurrencyType, context.parent == nil,
			context.persistentStoreCoordinator == nil, !context.hasChanges else {
			throw GenericError("Preset check-ins require a new independent main-queue context.")
		}
		context.persistentStoreCoordinator = coordinator
		do {
			guard let moodEntity = NSEntityDescription.entity(forEntityName: MoodImpl.entityName, in: context),
				moodEntity.managedObjectClassName == NSStringFromClass(MoodImpl.self),
				let contextEntity = NSEntityDescription.entity(forEntityName: MetricContextEntry.entityName, in: context) else {
				throw GenericError("Missing mood or context entity for preset check-in.")
			}
			let mood = MoodImpl(entity: moodEntity, insertInto: context)
			mood.setSource(.introspective); mood.date = date
			mood.rating = preset.rating; mood.minRating = preset.minimum; mood.maxRating = preset.maximum
			mood.note = preset.note.isEmpty ? nil : preset.note
			for category in categories {
				let entry = MetricContextEntry(entity: contextEntity, insertInto: context)
				entry.timestamp = date; entry.category = category.rawValue; entry.metricKey = ContextMetric.mood.rawValue
			}
			try context.save()
			// The successful save gives a permanent ID in this same coordinator. A
			// root-context fault keeps the result usable without a second throwing
			// fetch/save that could report failure after the check-in was committed.
			return root.object(with: mood.objectID) as! MoodImpl
		} catch { context.rollback(); throw error }
	}
}
