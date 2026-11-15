import CoreData
import Foundation

import Common
import DependencyInjection
import Persistence

public struct ActivityCatchUpSnapshot: Equatable {
	public let review: ActivityDayReview
	public let definitions: [ActivityRecordingDefinition]
	/// All current running activities, including ones outside the selected day.
	public let running: [ActivityRecordingItem]
	public init(review: ActivityDayReview, definitions: [ActivityRecordingDefinition], running: [ActivityRecordingItem]) {
		self.review = review; self.definitions = definitions; self.running = running
	}
}

/// Call on the main queue. Snapshots contain values, while editors receive root-context objects.
public enum ActivityCatchUpService {
	public static func loadDay(_ day: Date, asOf: Date = Date(),
		calendar: Calendar = .autoupdatingCurrent) throws -> ActivityCatchUpSnapshot {
		let window = try ActivityDayReview(records: [], day: day, asOf: asOf, calendar: calendar)
		return try ActivityQuickRecorder.read { context, _ in
			let definitions = ActivityDefinition.fetchRequest()
			definitions.sortDescriptors = [NSSortDescriptor(key: "recordScreenIndex", ascending: true),
				NSSortDescriptor(key: "name", ascending: true)]
			let request = Activity.fetchRequest()
			request.predicate = NSPredicate(format: "startDate < %@ AND startDate <= %@ AND (endDate == nil OR endDate > %@ OR startDate >= %@)",
				window.dayInterval.end as NSDate, asOf as NSDate, window.dayInterval.start as NSDate, window.dayInterval.start as NSDate)
			let records = try context.fetch(request).map {
				ActivityReviewRecord(id: identifier($0), definitionID: identifier($0.definition), name: $0.definition.name,
					start: $0.storedStartDate, end: $0.storedEndDate)
			}
			let running = Activity.fetchRequest()
			running.predicate = NSPredicate(format: "endDate == nil AND startDate <= %@", asOf as NSDate)
			running.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
			return ActivityCatchUpSnapshot(
				review: try ActivityDayReview(records: records, day: day, asOf: asOf, calendar: calendar),
				definitions: try context.fetch(definitions).map { ActivityRecordingDefinition(id: identifier($0), name: $0.name) },
				running: try context.fetch(running).map {
					ActivityRecordingItem(id: identifier($0), definitionID: identifier($0.definition),
						name: $0.definition.name, start: $0.storedStartDate)
				})
		}
	}

	/// Resolve through the same persistent store and refresh the editor's root object.
	/// Pending changes in that context remain pending; this method does not save them.
	public static func activity(id: String) throws -> Activity {
		let objectID = try ActivityQuickRecorder.read { context, coordinator -> NSManagedObjectID in
			let objectID = try ActivityQuickRecorder.objectID(id, entity: Activity.entityName, coordinator: coordinator)
			let request = Activity.fetchRequest()
			request.predicate = NSPredicate(format: "SELF == %@", objectID)
			request.fetchLimit = 1
			guard try context.fetch(request).first != nil else {
				throw ActivityRecordingError("This activity no longer exists. Refresh the review and try again.")
			}
			return objectID
		}
		let root = injected(Database.self).fetchedResultsController(type: Activity.self,
			sortDescriptors: [NSSortDescriptor(key: "startDate", ascending: true)]).managedObjectContext
		guard let value = try root.existingObject(with: objectID) as? Activity, !value.isDeleted else {
			throw ActivityRecordingError("This activity no longer exists. Refresh the review and try again.")
		}
		root.refresh(value, mergeChanges: true)
		return value
	}

	@discardableResult public static func recordGap(definitionID: String, from start: Date, to end: Date,
		recordedAt: Date = Date()) throws -> ActivityRecordingResult {
		try ActivityQuickRecorder.recordGap(definitionID: definitionID, from: start, to: end, recordedAt: recordedAt)
	}

	private static func identifier(_ object: NSManagedObject) -> String {
		object.objectID.uriRepresentation().absoluteString
	}
}
