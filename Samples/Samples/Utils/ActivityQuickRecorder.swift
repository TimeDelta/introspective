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
	/// A newly started activity, or the existing running target for an idempotent Start/Switch.
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

	@discardableResult internal static func start(definitionID: String, at: Date, recordedAt: Date,
		contextFactory: () -> NSManagedObjectContext) throws -> ActivityRecordingResult {
		try change(at: at, recordedAt: recordedAt, contextFactory: contextFactory) { context, coordinator in
			let definition = try requiredDefinition(definitionID, in: context, coordinator: coordinator)
			if let running = try runningActivity(for: definition, in: context) {
				return ActivityRecordingResult(startedActivityID: identifier(running))
			}
			let started = try create(definition, at: at, recordedAt: recordedAt, in: context)
			return ActivityRecordingResult(startedActivityID: identifier(started), didChange: true)
		}
	}

	@discardableResult internal static func stop(activityID: String, at: Date, recordedAt: Date,
		contextFactory: () -> NSManagedObjectContext) throws -> ActivityRecordingResult {
		try change(at: at, recordedAt: recordedAt, contextFactory: contextFactory) { context, coordinator in
			guard let activity = try activity(activityID, in: context, coordinator: coordinator),
				activity.storedEndDate == nil else { return ActivityRecordingResult() }
			try validateBoundary(at, for: activity)
			let autoNote = finish(activity, at: at, recordedAt: recordedAt, in: context)
			return ActivityRecordingResult(stoppedActivityIDs: [activityID],
				autoNoteActivityIDs: autoNote ? [activityID] : [], didChange: true)
		}
	}

	@discardableResult internal static func switchActivity(from activityID: String, to definitionID: String,
		at: Date, recordedAt: Date, contextFactory: () -> NSManagedObjectContext) throws -> ActivityRecordingResult {
		try change(at: at, recordedAt: recordedAt, contextFactory: contextFactory) { context, coordinator in
			let target = try requiredDefinition(definitionID, in: context, coordinator: coordinator)
			let existingTarget = try runningActivity(for: target, in: context)
			guard let source = try activity(activityID, in: context, coordinator: coordinator),
				source.storedEndDate == nil else {
				// A repeated Switch may observe its source already stopped (or auto-ignored).
				// It must never start a fresh timer from an old button after the target ended.
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

	private static func change(at: Date, recordedAt: Date, contextFactory: () -> NSManagedObjectContext,
		_ body: (NSManagedObjectContext, NSPersistentStoreCoordinator) throws -> ActivityRecordingResult) throws -> ActivityRecordingResult {
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
		if result.didChange { NotificationCenter.default.post(name: .activityRecordingChanged, object: nil) }
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

	private static func objectID(_ identifier: String, entity: String,
		coordinator: NSPersistentStoreCoordinator) throws -> NSManagedObjectID {
		guard let url = URL(string: identifier), let id = coordinator.managedObjectID(forURIRepresentation: url),
			id.entity.name == entity, !id.isTemporaryID else {
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
