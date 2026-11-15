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

public struct ActivityGapChoiceSnapshot: Equatable {
	public let definitions: [ActivityRecordingDefinition]
	public let choices: ActivityGapChoices
	public init(definitions: [ActivityRecordingDefinition], choices: ActivityGapChoices) {
		self.definitions = definitions; self.choices = choices
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

	/// Read current names and identities when the chooser opens. Suggestions never
	/// save pending editor changes or infer an activity for the user.
	public static func choices(for interval: DateInterval, asOf: Date = Date()) throws -> ActivityGapChoiceSnapshot {
		_ = try ActivityGapChoices(interval: interval, records: [], availableDefinitionIDs: [],
			recentDefinitionIDs: [], asOf: asOf)
		return try ActivityQuickRecorder.read { context, _ in
			let definitionRequest = ActivityDefinition.fetchRequest()
			definitionRequest.sortDescriptors = [NSSortDescriptor(key: "recordScreenIndex", ascending: true),
				NSSortDescriptor(key: "name", ascending: true)]
			let definitions = try context.fetch(definitionRequest).map {
				ActivityRecordingDefinition(id: identifier($0), name: $0.name)
			}
			let boundaryRequest = Activity.fetchRequest()
			boundaryRequest.predicate = NSPredicate(format:
				"definition != nil AND (endDate == %@ OR startDate == %@) AND startDate <= %@ AND (endDate == nil OR (endDate > startDate AND endDate <= %@))",
				interval.start as NSDate, interval.end as NSDate, asOf as NSDate, asOf as NSDate)
			let records = try context.fetch(boundaryRequest).map {
				ActivityReviewRecord(id: identifier($0), definitionID: identifier($0.definition), name: $0.definition.name,
					start: $0.storedStartDate, end: $0.storedEndDate)
			}

			// Aggregate in SQLite: one scalar row per used definition, even after
			// years of repeated recordings. Do not hydrate the full activity history.
			let latestStart = NSExpressionDescription()
			latestStart.name = "lastStarted"
			latestStart.expression = NSExpression(forFunction: "max:", arguments: [NSExpression(forKeyPath: "startDate")])
			latestStart.expressionResultType = .dateAttributeType
			let recentRequest = NSFetchRequest<NSDictionary>(entityName: Activity.entityName)
			recentRequest.resultType = .dictionaryResultType
			recentRequest.includesPendingChanges = false
			recentRequest.propertiesToFetch = ["definition", latestStart]
			recentRequest.propertiesToGroupBy = ["definition"]
			recentRequest.predicate = NSPredicate(format:
				"definition != nil AND startDate <= %@ AND (endDate == nil OR (endDate > startDate AND endDate <= %@))", asOf as NSDate, asOf as NSDate)
			var latestByDefinition: [String: Date] = [:]
			for row in try context.fetch(recentRequest) {
				guard let objectID = row["definition"] as? NSManagedObjectID, let date = row["lastStarted"] as? Date else {
					throw ActivityRecordingError("Could not load recent activities. Try opening the chooser again.")
				}
				latestByDefinition[objectID.uriRepresentation().absoluteString] = date
			}
			let recentIDs = definitions.enumerated().compactMap { index, definition -> (id: String, date: Date, order: Int)? in
				guard let date = latestByDefinition[definition.id] else { return nil }
				return (definition.id, date, index)
			}.sorted { $0.date == $1.date ? $0.order < $1.order : $0.date > $1.date }.map { $0.id }
			return ActivityGapChoiceSnapshot(definitions: definitions,
				choices: try ActivityGapChoices(interval: interval, records: records,
					availableDefinitionIDs: definitions.map { $0.id }, recentDefinitionIDs: recentIDs, asOf: asOf))
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
