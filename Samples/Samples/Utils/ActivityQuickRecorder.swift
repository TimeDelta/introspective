import CoreData
import Foundation
import Darwin

import Common
import DependencyInjection
import Persistence
import Settings

public extension Notification.Name {
	static let activityRecordingChanged = Notification.Name("activityRecordingChanged")
}

public struct ActivityRecordingError: LocalizedError, DisplayableError {
	public let message: String
	public init(_ message: String) { self.message = message }
	public var errorDescription: String? { message }
	public var displayableTitle: String { "Could not record activity" }
	public var displayableDescription: String? { message }
}

public struct ActivityRecordingDefinition: Equatable {
	public let id: String
	public let name: String
	public init(id: String, name: String) { self.id = id; self.name = name }
}

public struct ActivityRecordingItem: Equatable {
	public let id: String
	public let definitionID: String
	public let name: String
	/// The original stored instant, unaffected by legacy display-time conversion.
	public let start: Date
	public init(id: String, definitionID: String, name: String, start: Date) {
		self.id = id; self.definitionID = definitionID; self.name = name; self.start = start
	}
}

public struct ActivityRecordingSnapshot: Equatable {
	public let definitions: [ActivityRecordingDefinition]
	public let running: [ActivityRecordingItem]
	public init(definitions: [ActivityRecordingDefinition], running: [ActivityRecordingItem]) {
		self.definitions = definitions; self.running = running
	}
}

public struct ActivityRecordingResult: Equatable {
	/// A newly recorded activity, or the existing running target for an idempotent Start/Switch.
	public let startedActivityID: String?
	/// Includes short activities removed by the user's existing auto-ignore rule.
	public let stoppedActivityIDs: [String]
	public let autoNoteActivityIDs: [String]
	public let didChange: Bool
	public init(startedActivityID: String? = nil, stoppedActivityIDs: [String] = [],
		autoNoteActivityIDs: [String] = [], didChange: Bool = false) {
		self.startedActivityID = startedActivityID; self.stoppedActivityIDs = stoppedActivityIDs
		self.autoNoteActivityIDs = autoNoteActivityIDs; self.didChange = didChange
	}
}

/// An in-memory receipt for one successful recording. Only the recorder can
/// construct it, and a successful Undo consumes it before observers are notified.
public final class ActivityRecordingUndoToken {
	fileprivate let before: [String: ActivityRecordingUndoState]
	fileprivate let after: [String: ActivityRecordingUndoState]
	fileprivate let activityIDs: Set<String>
	fileprivate let definitionIDs: Set<String>
	fileprivate let runningAfter: [String: Set<String>]
	fileprivate let stores: [ActivityRecordingUndoStore]
	fileprivate var consumed = false

	fileprivate init(before: [String: ActivityRecordingUndoState], after: [String: ActivityRecordingUndoState],
		activityIDs: Set<String>, definitionIDs: Set<String>, runningAfter: [String: Set<String>],
		stores: [ActivityRecordingUndoStore]) {
		self.before = before; self.after = after; self.activityIDs = activityIDs
		self.definitionIDs = definitionIDs; self.runningAfter = runningAfter; self.stores = stores
	}
}

public struct ActivityUndoableRecordingResult {
	public let recording: ActivityRecordingResult
	public let undoToken: ActivityRecordingUndoToken?
	public init(recording: ActivityRecordingResult, undoToken: ActivityRecordingUndoToken?) {
		self.recording = recording; self.undoToken = undoToken
	}
}

fileprivate struct ActivityRecordingUndoStore: Equatable {
	let uuid: String
	let type: String
	let url: URL?
}

/// Values are copied from storage, without display-time conversion or setter
/// defaults. In particular, a legacy nil time-zone or provenance value stays nil.
fileprivate struct ActivityRecordingUndoState: Equatable {
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

/// Explicit operations share one independent writer. They never toggle a stale widget's state,
/// stop unrelated overlapping activities, or save pending edits in the app's view context.
/// Call from the main queue, as required by the injected database and settings.
public enum ActivityQuickRecorder {
	public static func snapshot() throws -> ActivityRecordingSnapshot {
		try withContext { context, _ in
			let definitions = ActivityDefinition.fetchRequest()
			definitions.sortDescriptors = [NSSortDescriptor(key: "recordScreenIndex", ascending: true),
				NSSortDescriptor(key: "name", ascending: true)]
			let running = Activity.fetchRequest()
			running.predicate = NSPredicate(format: "endDate == nil")
			running.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
			return ActivityRecordingSnapshot(definitions: try context.fetch(definitions).map {
				ActivityRecordingDefinition(id: identifier($0), name: $0.name)
			}, running: try context.fetch(running).map {
				ActivityRecordingItem(id: identifier($0), definitionID: identifier($0.definition),
					name: $0.definition.name, start: $0.storedStartDate)
			})
		}
	}

	@discardableResult public static func start(definitionID: String, at: Date = Date(),
		recordedAt: Date = Date()) throws -> ActivityRecordingResult {
		try start(definitionID: definitionID, at: at, recordedAt: recordedAt, contextFactory: newContext)
	}

	@discardableResult public static func stop(activityID: String, at: Date = Date(),
		recordedAt: Date = Date()) throws -> ActivityRecordingResult {
		try stop(activityID: activityID, at: at, recordedAt: recordedAt, contextFactory: newContext)
	}

	@discardableResult public static func switchActivity(from activityID: String, to definitionID: String,
		at: Date = Date(), recordedAt: Date = Date()) throws -> ActivityRecordingResult {
		try switchActivity(from: activityID, to: definitionID, at: at, recordedAt: recordedAt,
			contextFactory: newContext)
	}

	/// Add a missed completed activity only while the selected interval is still unrecorded.
	/// Manual catch-up entries retain short intervals instead of applying auto-ignore.
	@discardableResult public static func recordGap(definitionID: String, from start: Date, to end: Date,
		recordedAt: Date = Date()) throws -> ActivityRecordingResult {
		try recordGap(definitionID: definitionID, from: start, to: end, recordedAt: recordedAt, contextFactory: newContext)
	}

	@discardableResult internal static func recordGap(definitionID: String, from start: Date, to end: Date,
		recordedAt: Date, contextFactory: () -> NSManagedObjectContext) throws -> ActivityRecordingResult {
		guard end.timeIntervalSinceReferenceDate.isFinite, end > start, end <= recordedAt else {
			throw ActivityRecordingError("Choose a positive activity interval ending at or before now.")
		}
		return try change(at: start, recordedAt: recordedAt, contextFactory: contextFactory) { context, coordinator in
			let definition = try requiredDefinition(definitionID, in: context, coordinator: coordinator)
			let occupied = Activity.fetchRequest()
			occupied.predicate = NSPredicate(format: "startDate < %@ AND (endDate == nil OR (endDate > startDate AND endDate > %@))",
				end as NSDate, start as NSDate)
			occupied.fetchLimit = 1
			guard try context.fetch(occupied).isEmpty else {
				throw ActivityRecordingError("This interval now contains an activity. Refresh the review before recording it.")
			}
			let recorded = try create(definition, at: start, recordedAt: recordedAt, in: context)
			recorded.end = end; recorded.endSetAt = recordedAt
			let id = identifier(recorded)
			return ActivityRecordingResult(startedActivityID: id,
				autoNoteActivityIDs: definition.autoNote ? [id] : [], didChange: true)
		}
	}

	/// Share the existing queue and fresh-context rules with catch-up snapshots.
	internal static func read<T>(_ body: (NSManagedObjectContext, NSPersistentStoreCoordinator) throws -> T) throws -> T {
		try withContext(body)
	}

	@discardableResult public static func startWithUndo(definitionID: String, at: Date = Date(),
		recordedAt: Date = Date()) throws -> ActivityUndoableRecordingResult {
		try startWithUndo(definitionID: definitionID, at: at, recordedAt: recordedAt, contextFactory: newContext)
	}

	@discardableResult public static func stopWithUndo(activityID: String, at: Date = Date(),
		recordedAt: Date = Date()) throws -> ActivityUndoableRecordingResult {
		try stopWithUndo(activityID: activityID, at: at, recordedAt: recordedAt, contextFactory: newContext)
	}

	@discardableResult public static func switchActivityWithUndo(from activityID: String, to definitionID: String,
		at: Date = Date(), recordedAt: Date = Date()) throws -> ActivityUndoableRecordingResult {
		try switchActivityWithUndo(from: activityID, to: definitionID, at: at, recordedAt: recordedAt,
			contextFactory: newContext)
	}

	@discardableResult public static func undo(_ token: ActivityRecordingUndoToken) throws -> ActivityRecordingResult {
		try undo(token, contextFactory: newContext)
	}

	@discardableResult internal static func start(definitionID: String, at: Date, recordedAt: Date,
		contextFactory: () -> NSManagedObjectContext) throws -> ActivityRecordingResult {
		try perform(.start(definitionID), at: at, recordedAt: recordedAt, captureUndo: false,
			contextFactory: contextFactory).recording
	}

	@discardableResult internal static func stop(activityID: String, at: Date, recordedAt: Date,
		contextFactory: () -> NSManagedObjectContext) throws -> ActivityRecordingResult {
		try perform(.stop(activityID), at: at, recordedAt: recordedAt, captureUndo: false,
			contextFactory: contextFactory).recording
	}

	@discardableResult internal static func switchActivity(from activityID: String, to definitionID: String,
		at: Date, recordedAt: Date, contextFactory: () -> NSManagedObjectContext) throws -> ActivityRecordingResult {
		try perform(.switchActivity(activityID, definitionID), at: at, recordedAt: recordedAt, captureUndo: false,
			contextFactory: contextFactory).recording
	}

	@discardableResult internal static func startWithUndo(definitionID: String, at: Date, recordedAt: Date,
		contextFactory: () -> NSManagedObjectContext) throws -> ActivityUndoableRecordingResult {
		try perform(.start(definitionID), at: at, recordedAt: recordedAt, captureUndo: true, contextFactory: contextFactory)
	}

	@discardableResult internal static func stopWithUndo(activityID: String, at: Date, recordedAt: Date,
		contextFactory: () -> NSManagedObjectContext) throws -> ActivityUndoableRecordingResult {
		try perform(.stop(activityID), at: at, recordedAt: recordedAt, captureUndo: true, contextFactory: contextFactory)
	}

	@discardableResult internal static func switchActivityWithUndo(from activityID: String, to definitionID: String,
		at: Date, recordedAt: Date, contextFactory: () -> NSManagedObjectContext) throws -> ActivityUndoableRecordingResult {
		try perform(.switchActivity(activityID, definitionID), at: at, recordedAt: recordedAt,
			captureUndo: true, contextFactory: contextFactory)
	}

	private enum Operation {
		case start(String)
		case stop(String)
		case switchActivity(String, String)
	}

	private static func perform(_ operation: Operation, at: Date, recordedAt: Date, captureUndo: Bool,
		contextFactory: () -> NSManagedObjectContext) throws -> ActivityUndoableRecordingResult {
		var token: ActivityRecordingUndoToken?
		let recording = try change(at: at, recordedAt: recordedAt, contextFactory: contextFactory) { context, coordinator in
			var before: [String: ActivityRecordingUndoState] = [:]
			var definitionIDs = Set<String>()
			if captureUndo {
				let objects = try undoObjects(for: operation, in: context, coordinator: coordinator)
				definitionIDs = objects.definitionIDs
				for value in objects.activities { before[identifier(value)] = try undoState(value) }
			}
			let result = try apply(operation, at: at, recordedAt: recordedAt, in: context, coordinator: coordinator)
			if captureUndo, result.didChange {
				var activityIDs = Set(before.keys)
				if let id = result.startedActivityID { activityIDs.insert(id) }
				var after: [String: ActivityRecordingUndoState] = [:]
				for id in activityIDs {
					if let value = try activity(id, in: context, coordinator: coordinator), !value.isDeleted {
						after[id] = try undoState(value)
					}
				}
				token = ActivityRecordingUndoToken(before: before, after: after, activityIDs: activityIDs,
					definitionIDs: definitionIDs, runningAfter: try runningIDs(for: definitionIDs, in: context,
						coordinator: coordinator), stores: try undoStores(coordinator))
			}
			return result
		}
		return ActivityUndoableRecordingResult(recording: recording, undoToken: token)
	}

	/// The same operation bodies serve existing controls and Undo-enabled app actions.
	private static func apply(_ operation: Operation, at: Date, recordedAt: Date,
		in context: NSManagedObjectContext, coordinator: NSPersistentStoreCoordinator) throws -> ActivityRecordingResult {
		switch operation {
		case let .start(definitionID):
			let definition = try requiredDefinition(definitionID, in: context, coordinator: coordinator)
			if let running = try runningActivity(for: definition, in: context) {
				return ActivityRecordingResult(startedActivityID: identifier(running))
			}
			let started = try create(definition, at: at, recordedAt: recordedAt, in: context)
			return ActivityRecordingResult(startedActivityID: identifier(started), didChange: true)
		case let .stop(activityID):
			guard let value = try activity(activityID, in: context, coordinator: coordinator),
				value.storedEndDate == nil else { return ActivityRecordingResult() }
			try validateBoundary(at, for: value)
			let autoNote = finish(value, at: at, recordedAt: recordedAt, in: context)
			return ActivityRecordingResult(stoppedActivityIDs: [activityID],
				autoNoteActivityIDs: autoNote ? [activityID] : [], didChange: true)
		case let .switchActivity(activityID, definitionID):
			let target = try requiredDefinition(definitionID, in: context, coordinator: coordinator)
			let existingTarget = try runningActivity(for: target, in: context)
			guard let source = try activity(activityID, in: context, coordinator: coordinator),
				source.storedEndDate == nil else {
				// Repeated Switch cannot create a fresh target from a stopped source.
				if let existingTarget = existingTarget {
					return ActivityRecordingResult(startedActivityID: identifier(existingTarget))
				}
				throw ActivityRecordingError("The selected activity is no longer running. Choose a current activity and try again.")
			}
			if source.definition.objectID == target.objectID {
				return ActivityRecordingResult(startedActivityID: identifier(source))
			}
			try validateBoundary(at, for: source)
			let autoNote = finish(source, at: at, recordedAt: recordedAt, in: context)
			let started = try existingTarget ?? create(target, at: at, recordedAt: recordedAt, in: context)
			return ActivityRecordingResult(startedActivityID: identifier(started), stoppedActivityIDs: [activityID],
				autoNoteActivityIDs: autoNote ? [activityID] : [], didChange: true)
		}
	}

	private static func undoObjects(for operation: Operation, in context: NSManagedObjectContext,
		coordinator: NSPersistentStoreCoordinator) throws -> (activities: [Activity], definitionIDs: Set<String>) {
		var objects: [Activity] = [], definitions = Set<String>()
		switch operation {
		case let .start(definitionID):
			let definition = try requiredDefinition(definitionID, in: context, coordinator: coordinator)
			definitions.insert(definitionID)
			if let running = try runningActivity(for: definition, in: context) { objects.append(running) }
		case let .stop(activityID):
			if let value = try activity(activityID, in: context, coordinator: coordinator) {
				objects.append(value); definitions.insert(identifier(value.definition))
			}
		case let .switchActivity(activityID, definitionID):
			let definition = try requiredDefinition(definitionID, in: context, coordinator: coordinator)
			definitions.insert(definitionID)
			if let target = try runningActivity(for: definition, in: context) { objects.append(target) }
			if let source = try activity(activityID, in: context, coordinator: coordinator) {
				objects.append(source); definitions.insert(identifier(source.definition))
			}
		}
		return (objects, definitions)
	}

	@discardableResult internal static func undo(_ token: ActivityRecordingUndoToken,
		contextFactory: () -> NSManagedObjectContext) throws -> ActivityRecordingResult {
		let now = Date()
		return try change(at: now, recordedAt: now, contextFactory: contextFactory,
			beforeNotification: { token.consumed = true }) { context, coordinator in
			guard !token.consumed, try undoStores(coordinator) == token.stores else {
				throw undoConflict()
			}
			let allStates = Array(token.before.values) + Array(token.after.values)
			let tagIDs = allStates.reduce(into: Set<String>()) { $0.formUnion($1.tagIDs) }
			try rejectPendingUndoChanges(activityIDs: token.activityIDs, definitionIDs: token.definitionIDs, tagIDs: tagIDs)
			for id in token.definitionIDs { _ = try requiredDefinition(id, in: context, coordinator: coordinator) }
			var tags: [String: NSManagedObject] = [:]
			for id in tagIDs { tags[id] = try requiredUndoTag(id, in: context, coordinator: coordinator) }
			for id in token.activityIDs {
				let current = try activity(id, in: context, coordinator: coordinator)
				let state = try current.map(undoState)
				guard state == token.after[id] else { throw undoConflict() }
			}
			guard try runningIDs(for: token.definitionIDs, in: context, coordinator: coordinator) == token.runningAfter else {
				throw undoConflict()
			}
			var restoredID: String?
			var removedIDs: [String] = []
			for id in token.activityIDs.sorted() {
				guard let before = token.before[id] else {
					if let created = try activity(id, in: context, coordinator: coordinator) {
						context.delete(created); removedIDs.append(id)
					}
					continue
				}
				guard token.after[id] != before else { continue }
				let value: Activity
				if let existing = try activity(id, in: context, coordinator: coordinator) { value = existing }
				else {
					// A committed deletion cannot reuse its old URI. Restore the data
					// under a new permanent identity; stale widget actions remain stale.
					guard let entity = NSEntityDescription.entity(forEntityName: Activity.entityName, in: context) else {
						throw undoConflict()
					}
					value = Activity(entity: entity, insertInto: context)
				}
				let definition = try requiredDefinition(before.definitionID, in: context, coordinator: coordinator)
				restore(before, to: value, definition: definition, tags: tags)
				if value.objectID.isTemporaryID { try context.obtainPermanentIDs(for: [value]) }
				if before.end == nil { restoredID = identifier(value) }
			}
			return ActivityRecordingResult(startedActivityID: restoredID, stoppedActivityIDs: removedIDs, didChange: true)
		}
	}

	private static func undoState(_ value: Activity) throws -> ActivityRecordingUndoState {
		guard let definition = value.value(forKey: "definition") as? ActivityDefinition,
			let start = value.value(forKey: "startDate") as? Date,
			let source = value.value(forKey: "source") as? NSNumber,
			let tags = value.value(forKey: "tags") as? NSSet else { throw undoConflict() }
		let tagObjects = tags.allObjects.compactMap { $0 as? NSManagedObject }
		guard tagObjects.count == tags.count, !definition.objectID.isTemporaryID,
			tagObjects.allSatisfy({ !$0.objectID.isTemporaryID }) else { throw undoConflict() }
		return ActivityRecordingUndoState(definitionID: identifier(definition), tagIDs: Set(tagObjects.map(identifier)),
			start: start, startSetAt: value.value(forKey: "startDateSetAt") as? Date,
			startZone: value.value(forKey: "startDateTimeZoneId") as? String,
			end: value.value(forKey: "endDate") as? Date, endSetAt: value.value(forKey: "endDateSetAt") as? Date,
			endZone: value.value(forKey: "endDateTimeZoneId") as? String, note: value.value(forKey: "note") as? String,
			source: source.int16Value)
	}

	private static func restore(_ state: ActivityRecordingUndoState, to value: Activity,
		definition: ActivityDefinition, tags: [String: NSManagedObject]) {
		value.setValue(state.start, forKey: "startDate")
		value.setValue(state.startSetAt, forKey: "startDateSetAt")
		value.setValue(state.startZone, forKey: "startDateTimeZoneId")
		value.setValue(state.end, forKey: "endDate")
		value.setValue(state.endSetAt, forKey: "endDateSetAt")
		value.setValue(state.endZone, forKey: "endDateTimeZoneId")
		value.setValue(state.note, forKey: "note")
		value.setValue(NSNumber(value: state.source), forKey: "source")
		value.setValue(definition, forKey: "definition")
		value.setValue(NSSet(array: state.tagIDs.sorted().compactMap { tags[$0] }), forKey: "tags")
	}

	private static func runningIDs(for definitionIDs: Set<String>, in context: NSManagedObjectContext,
		coordinator: NSPersistentStoreCoordinator) throws -> [String: Set<String>] {
		var values: [String: Set<String>] = [:]
		for id in definitionIDs {
			let definition = try requiredDefinition(id, in: context, coordinator: coordinator)
			let request = Activity.fetchRequest()
			request.predicate = NSPredicate(format: "definition == %@ AND endDate == nil", definition)
			values[id] = Set(try context.fetch(request).filter { !$0.isDeleted }.map(identifier))
		}
		return values
	}

	private static func requiredUndoTag(_ id: String, in context: NSManagedObjectContext,
		coordinator: NSPersistentStoreCoordinator) throws -> NSManagedObject {
		let objectID = try self.objectID(id, entity: Tag.entityName, coordinator: coordinator)
		let request = NSFetchRequest<NSManagedObject>(entityName: Tag.entityName)
		request.predicate = NSPredicate(format: "SELF == %@", objectID)
		request.fetchLimit = 1
		guard let value = try context.fetch(request).first else { throw undoConflict() }
		return value
	}

	private static func rejectPendingUndoChanges(activityIDs: Set<String>, definitionIDs: Set<String>, tagIDs: Set<String>) throws {
		let root = injected(Database.self).fetchedResultsController(type: Activity.self,
			sortDescriptors: [NSSortDescriptor(key: "startDate", ascending: true)]).managedObjectContext
		for object in root.insertedObjects.union(root.updatedObjects).union(root.deletedObjects) {
			let id = identifier(object)
			if activityIDs.contains(id) || definitionIDs.contains(id) || tagIDs.contains(id) { throw undoConflict() }
			if object.entity.name == Activity.entityName,
				let definition = object.value(forKey: "definition") as? NSManagedObject,
				definitionIDs.contains(identifier(definition)) { throw undoConflict() }
		}
	}

	private static func undoStores(_ coordinator: NSPersistentStoreCoordinator) throws -> [ActivityRecordingUndoStore] {
		try coordinator.persistentStores.map { store in
			guard let uuid = coordinator.metadata(for: store)[NSStoreUUIDKey] as? String else {
				throw undoConflict()
			}
			return ActivityRecordingUndoStore(uuid: uuid, type: store.type, url: store.url?.standardizedFileURL)
		}.sorted { ($0.uuid, $0.url?.absoluteString ?? "") < ($1.uuid, $1.url?.absoluteString ?? "") }
	}

	private static func undoConflict() -> ActivityRecordingError {
		ActivityRecordingError("This activity has changed since recording. Finish or cancel any pending edits, or choose a current activity instead.")
	}

	private static func newContext() -> NSManagedObjectContext {
		NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
	}

	/// Independent main-queue contexts make managed-object access queue-correct while
	/// keeping the single save separate from any unfinished activity-editor changes.
	private static func withContext<T>(contextFactory: () -> NSManagedObjectContext = newContext,
		_ body: (NSManagedObjectContext, NSPersistentStoreCoordinator) throws -> T) throws -> T {
		guard Thread.isMainThread else {
			throw ActivityRecordingError("Activity recording requires the main queue.")
		}
		let root = injected(Database.self).fetchedResultsController(type: Activity.self,
			sortDescriptors: [NSSortDescriptor(key: "startDate", ascending: true)]).managedObjectContext
		guard let coordinator = root.persistentStoreCoordinator else {
			throw ActivityRecordingError("Open Introspective to set up activity recording.")
		}
		let context = contextFactory()
		guard context !== root, context.concurrencyType == .mainQueueConcurrencyType, context.parent == nil,
			context.persistentStoreCoordinator == nil, !context.hasChanges else {
			throw ActivityRecordingError("Activity recording requires a new independent context.")
		}
		context.persistentStoreCoordinator = coordinator
		context.mergePolicy = NSMergePolicy(merge: .errorMergePolicyType)
		context.undoManager = nil
		do { return try body(context, coordinator) }
		catch { context.rollback(); throw error }
	}

	internal static func change(at: Date, recordedAt: Date, contextFactory: () -> NSManagedObjectContext,
		beforeNotification: (() -> Void)? = nil, _ body: (NSManagedObjectContext, NSPersistentStoreCoordinator) throws -> ActivityRecordingResult) throws -> ActivityRecordingResult {
		guard at.timeIntervalSinceReferenceDate.isFinite, recordedAt.timeIntervalSinceReferenceDate.isFinite,
			at <= recordedAt else { throw ActivityRecordingError("Choose an activity time at or before now.") }
		let result = try withContext(contextFactory: contextFactory) { context, coordinator in
			// Coordinate our app and widget writers across processes. A busy operation
			// fails before changing anything instead of freezing the UI or duplicating a timer.
			let descriptor = try acquireWriterLock(coordinator)
			defer {
				if let descriptor = descriptor { _ = flock(descriptor, LOCK_UN); _ = close(descriptor) }
			}
			let result = try body(context, coordinator)
			if result.didChange { try context.save() }
			return result
		}
		if result.didChange {
			beforeNotification?()
			NotificationCenter.default.post(name: .activityRecordingChanged, object: nil)
		}
		return result
	}

	private static func acquireWriterLock(_ coordinator: NSPersistentStoreCoordinator) throws -> Int32? {
		guard let store = coordinator.persistentStores.first(where: { $0.type == NSSQLiteStoreType }),
			let url = store.url else { return nil }
		let path = url.deletingLastPathComponent().appendingPathComponent("activity-recording.lock").path
		let descriptor = open(path, O_CREAT | O_RDWR | O_CLOEXEC, S_IRUSR | S_IWUSR)
		guard descriptor >= 0 else { throw ActivityRecordingError("Activity recording is unavailable. Unlock the device and try again.") }
		guard flock(descriptor, LOCK_EX | LOCK_NB) == 0 else {
			_ = close(descriptor)
			throw ActivityRecordingError("Another activity action is finishing. Please try again.")
		}
		return descriptor
	}

	private static func identifier(_ object: NSManagedObject) -> String {
		object.objectID.uriRepresentation().absoluteString
	}

	internal static func objectID(_ identifier: String, entity: String,
		coordinator: NSPersistentStoreCoordinator) throws -> NSManagedObjectID {
		// Core Data raises an Objective-C exception for malformed URLs; validate
		// their shape before calling its resolver so callers receive a Swift error.
		guard let url = URL(string: identifier), url.scheme == "x-coredata", url.host?.isEmpty == false,
			url.path.split(separator: "/").count == 2, url.path.split(separator: "/").first == Substring(entity),
			url.user == nil, url.password == nil, url.port == nil, url.query == nil, url.fragment == nil,
			let id = coordinator.managedObjectID(forURIRepresentation: url),
			id.entity.name == entity, !id.isTemporaryID, id.uriRepresentation().absoluteString == identifier else {
			throw ActivityRecordingError("This activity is no longer available. Open Introspective to choose another.")
		}
		return id
	}

	private static func requiredDefinition(_ identifier: String, in context: NSManagedObjectContext,
		coordinator: NSPersistentStoreCoordinator) throws -> ActivityDefinition {
		let id = try objectID(identifier, entity: ActivityDefinition.entityName, coordinator: coordinator)
		let request = ActivityDefinition.fetchRequest()
		request.predicate = NSPredicate(format: "SELF == %@", id)
		request.fetchLimit = 1
		guard let value = try context.fetch(request).first else {
			throw ActivityRecordingError("This activity is no longer available. Open Introspective to choose another.")
		}
		return value
	}

	private static func activity(_ identifier: String, in context: NSManagedObjectContext,
		coordinator: NSPersistentStoreCoordinator) throws -> Activity? {
		let id = try objectID(identifier, entity: Activity.entityName, coordinator: coordinator)
		let request = Activity.fetchRequest()
		request.predicate = NSPredicate(format: "SELF == %@", id)
		request.fetchLimit = 1
		return try context.fetch(request).first
	}

	private static func runningActivity(for definition: ActivityDefinition, in context: NSManagedObjectContext) throws -> Activity? {
		let request = Activity.fetchRequest()
		request.predicate = NSPredicate(format: "definition == %@ AND endDate == nil", definition)
		request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
		request.fetchLimit = 1
		return try context.fetch(request).first
	}

	private static func validateBoundary(_ date: Date, for activity: Activity) throws {
		guard date >= activity.storedStartDate else {
			throw ActivityRecordingError("The stop or switch time cannot be earlier than this activity's start.")
		}
	}

	private static func create(_ definition: ActivityDefinition, at: Date, recordedAt: Date,
		in context: NSManagedObjectContext) throws -> Activity {
		guard let entity = NSEntityDescription.entity(forEntityName: Activity.entityName, in: context) else {
			throw ActivityRecordingError("Open Introspective to set up activity recording.")
		}
		let value = Activity(entity: entity, insertInto: context)
		value.setSource(.introspective)
		value.definition = definition
		value.start = at; value.startSetAt = recordedAt
		definition.addToActivities(value)
		// Results and widgets must never retain temporary object-ID URLs.
		try context.obtainPermanentIDs(for: [value])
		return value
	}

	/// Returns whether the successfully ended activity needs the existing note editor.
	private static func finish(_ activity: Activity, at: Date, recordedAt: Date,
		in context: NSManagedObjectContext) -> Bool {
		let settings = injected(Settings.self)
		if settings.autoIgnoreEnabled,
			at.timeIntervalSince(activity.storedStartDate) < Double(settings.autoIgnoreSeconds) {
			context.delete(activity)
			return false
		}
		activity.end = at; activity.endSetAt = recordedAt
		return activity.definition.autoNote
	}
}
