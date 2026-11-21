import CoreData
import Foundation

import Common
import DependencyInjection
import Persistence

/// A saved instance captured when its Split form opens. Dates are stored
/// instants, independent of legacy display-time conversion.
public struct ActivitySplitSnapshot: Equatable {
	public let activityID: String
	public let definitionID: String
	public let name: String
	public let start: Date
	public let end: Date?
	fileprivate let state: ActivitySplitState

	fileprivate init(activityID: String, name: String, state: ActivitySplitState) {
		self.activityID = activityID; self.definitionID = state.definitionID
		self.name = name; self.start = state.start; self.end = state.end; self.state = state
	}
}

fileprivate struct ActivitySplitState: Equatable {
	let definitionID: String
	let tagIDs: Set<String>
	let start: Date
	let startSetAt: Date?
	let startZone: String?
	let end: Date?
	let endSetAt: Date?
	let endZone: String?
	let note: String?
	let source: Int16
}

/// Split is an explicit edit, so both portions are retained regardless of the
/// automatic short-activity rule. Call on the main queue, like the recorder.
public enum ActivitySplitService {
	public static func snapshot(activityID: String) throws -> ActivitySplitSnapshot {
		try ActivityQuickRecorder.read { context, coordinator in
			let source = try requiredActivity(activityID, in: context, coordinator: coordinator)
			let state = try savedState(source)
			try rejectPendingChanges(activityID: activityID,
				definitionIDs: [state.definitionID], tagIDs: state.tagIDs)
			return ActivitySplitSnapshot(activityID: activityID, name: source.definition.name, state: state)
		}
	}

	/// Keep the original instance as the first portion. The result identifies the
	/// second portion after the single save succeeds, without another fallible read.
	@discardableResult public static func split(_ snapshot: ActivitySplitSnapshot, at: Date,
		secondDefinitionID: String, recordedAt: Date = Date()) throws -> ActivityRecordingResult {
		try split(snapshot, at: at, secondDefinitionID: secondDefinitionID, recordedAt: recordedAt,
			contextFactory: { NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType) })
	}

	@discardableResult internal static func split(_ snapshot: ActivitySplitSnapshot, at: Date,
		secondDefinitionID: String, recordedAt: Date,
		contextFactory: () -> NSManagedObjectContext) throws -> ActivityRecordingResult {
		try ActivityQuickRecorder.change(at: at, recordedAt: recordedAt,
			contextFactory: contextFactory) { context, coordinator in
			let source = try requiredActivity(snapshot.activityID, in: context, coordinator: coordinator)
			let current = try savedState(source)
			guard current == snapshot.state else { throw conflict() }
			try rejectPendingChanges(activityID: snapshot.activityID,
				definitionIDs: [current.definitionID, secondDefinitionID], tagIDs: current.tagIDs)
			let definition = try requiredDefinition(secondDefinitionID, in: context, coordinator: coordinator)
			guard current.start.timeIntervalSinceReferenceDate.isFinite,
				current.end?.timeIntervalSinceReferenceDate.isFinite != false,
				at > current.start, at < (current.end ?? recordedAt),
				current.end.map({ $0 <= recordedAt }) ?? true else {
				throw ActivityRecordingError("Choose a split time after this activity's start and before its end or now.")
			}
			guard let entity = NSEntityDescription.entity(forEntityName: Activity.entityName, in: context) else {
				throw ActivityRecordingError("Open Introspective to set up activity recording.")
			}
			let second = Activity(entity: entity, insertInto: context)
			let zone = injected(CalendarUtil.self).currentTimeZone().identifier
			// Copy raw values rather than using display-converting getters or
			// setters that invent missing legacy provenance/time-zone values.
			second.setValue(at, forKey: "startDate")
			second.setValue(recordedAt, forKey: "startDateSetAt")
			second.setValue(zone, forKey: "startDateTimeZoneId")
			second.setValue(current.end, forKey: "endDate")
			second.setValue(current.endSetAt, forKey: "endDateSetAt")
			second.setValue(current.endZone, forKey: "endDateTimeZoneId")
			second.setValue(current.note, forKey: "note")
			second.setValue(NSNumber(value: current.source), forKey: "source")
			second.definition = definition
			second.setValue(source.tags, forKey: "tags")
			source.setValue(at, forKey: "endDate")
			source.setValue(recordedAt, forKey: "endDateSetAt")
			source.setValue(zone, forKey: "endDateTimeZoneId")
			try context.obtainPermanentIDs(for: [second])
			return ActivityRecordingResult(startedActivityID: identifier(second),
				stoppedActivityIDs: current.end == nil ? [snapshot.activityID] : [], didChange: true)
		}
	}

	private static func savedState(_ value: Activity) throws -> ActivitySplitState {
		guard let definition = value.value(forKey: "definition") as? ActivityDefinition,
			let start = value.value(forKey: "startDate") as? Date,
			let source = value.value(forKey: "source") as? NSNumber,
			let tags = value.value(forKey: "tags") as? NSSet else { throw conflict() }
		let tagObjects = tags.allObjects.compactMap { $0 as? NSManagedObject }
		guard tagObjects.count == tags.count, !definition.objectID.isTemporaryID,
			tagObjects.allSatisfy({ !$0.objectID.isTemporaryID }) else { throw conflict() }
		return ActivitySplitState(definitionID: identifier(definition), tagIDs: Set(tagObjects.map(identifier)),
			start: start, startSetAt: value.value(forKey: "startDateSetAt") as? Date,
			startZone: value.value(forKey: "startDateTimeZoneId") as? String,
			end: value.value(forKey: "endDate") as? Date, endSetAt: value.value(forKey: "endDateSetAt") as? Date,
			endZone: value.value(forKey: "endDateTimeZoneId") as? String,
			note: value.value(forKey: "note") as? String, source: source.int16Value)
	}

	private static func requiredActivity(_ id: String, in context: NSManagedObjectContext,
		coordinator: NSPersistentStoreCoordinator) throws -> Activity {
		let objectID = try ActivityQuickRecorder.objectID(id, entity: Activity.entityName, coordinator: coordinator)
		let request = Activity.fetchRequest()
		request.predicate = NSPredicate(format: "SELF == %@", objectID)
		request.fetchLimit = 1
		guard let value = try context.fetch(request).first else { throw conflict() }
		return value
	}

	private static func requiredDefinition(_ id: String, in context: NSManagedObjectContext,
		coordinator: NSPersistentStoreCoordinator) throws -> ActivityDefinition {
		let objectID = try ActivityQuickRecorder.objectID(id, entity: ActivityDefinition.entityName, coordinator: coordinator)
		let request = ActivityDefinition.fetchRequest()
		request.predicate = NSPredicate(format: "SELF == %@", objectID)
		request.fetchLimit = 1
		guard let value = try context.fetch(request).first else {
			throw ActivityRecordingError("The selected activity is no longer available. Choose another activity and try again.")
		}
		return value
	}

	private static func rejectPendingChanges(activityID: String, definitionIDs: Set<String>, tagIDs: Set<String>) throws {
		let root = injected(Database.self).fetchedResultsController(type: Activity.self,
			sortDescriptors: [NSSortDescriptor(key: "startDate", ascending: true)]).managedObjectContext
		for object in root.insertedObjects.union(root.updatedObjects).union(root.deletedObjects) {
			let id = identifier(object)
			if id == activityID { throw conflict() }
			if definitionIDs.contains(id) || tagIDs.contains(id) {
				// Another record's unsaved relationship can update an inverse
				// activities collection without editing this definition or tag.
				if object.isInserted || object.isDeleted ||
					!Set(object.changedValues().keys).subtracting(["activities"]).isEmpty { throw conflict() }
			}
		}
	}

	private static func conflict() -> ActivityRecordingError {
		ActivityRecordingError("This activity has changed. Finish or cancel any pending edits, then reopen Split and try again.")
	}

	private static func identifier(_ value: NSManagedObject) -> String {
		value.objectID.uriRepresentation().absoluteString
	}
}
