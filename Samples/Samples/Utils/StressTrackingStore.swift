import Foundation
import CoreData
import Common
import DependencyInjection
import Persistence

/// Isolated writes never commit unrelated changes pending in the view context.
public enum StressTrackingStore {
	public static func definitions(includeArchived: Bool = false) throws -> [StressorDefinition] {
		guard Thread.isMainThread else { throw StressTrackingError("Load stressors on the main queue.") }
		let request = StressorDefinition.fetchRequest()
		if !includeArchived { request.predicate = NSPredicate(format: "archived == NO") }
		request.sortDescriptors = [NSSortDescriptor(key: "displayOrder", ascending: true), NSSortDescriptor(key: "createdAt", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
		return try injected(Database.self).query(request)
	}

	@discardableResult public static func createStressor(name: String, at date: Date = Date()) throws -> StressorDefinition {
		let name = try validName(name)
		guard date.timeIntervalSinceReferenceDate.isFinite else { throw StressTrackingError("Choose a valid stressor creation time.") }
		let result = try write { context -> NSManagedObject? in
			let request = StressorDefinition.fetchRequest()
			request.sortDescriptors = [NSSortDescriptor(key: "displayOrder", ascending: false)]
			request.fetchLimit = 1
			let previousOrder = try context.fetch(request).first?.displayOrder ?? -1
			guard previousOrder < Int64.max else { throw StressTrackingError("Reorder stressors before adding another.") }
			let definition: StressorDefinition = try insert(StressorDefinition.self, into: context)
			definition.id = UUID(); definition.name = name; definition.createdAt = date
			definition.archived = false; definition.displayOrder = previousOrder + 1
			return definition
		}
		return result.root.object(with: result.objectID!) as! StressorDefinition
	}

	public static func renameStressor(id: UUID, to name: String) throws {
		let name = try validName(name)
		_ = try write { context in
			let definition = try findDefinition(id, in: context)
			definition.name = name
			return definition
		}
	}

	public static func setArchived(id: UUID, archived: Bool) throws {
		_ = try write { context in
			let definition = try findDefinition(id, in: context)
			definition.archived = archived
			return definition
		}
	}

	/// Reorders every active definition; archived definitions retain their own history and order.
	public static func reorderStressors(ids: [UUID]) throws {
		guard Set(ids).count == ids.count else { throw StressTrackingError("List each stressor once when reordering.") }
		_ = try write { context in
			let request = StressorDefinition.fetchRequest()
			request.predicate = NSPredicate(format: "archived == NO")
			let definitions = try context.fetch(request)
			guard Set(definitions.map { $0.id }) == Set(ids) else { throw StressTrackingError("Reload the stressor list before reordering.") }
			let byID = Dictionary(uniqueKeysWithValues: definitions.map { ($0.id, $0) })
			for (index, id) in ids.enumerated() { byID[id]?.displayOrder = Int64(index) }
			return nil
		}
	}

	@discardableResult public static func save(draft: StressCheckInDraft, editing existing: StressCheckIn? = nil) throws -> StressCheckIn {
		try save(draft: draft, editing: existing, contextFactory: { NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType) })
	}

	/// Supplies a fresh writer in integration tests to exercise real save failures.
	@discardableResult internal static func save(draft: StressCheckInDraft, editing existing: StressCheckIn? = nil,
		contextFactory: () -> NSManagedObjectContext) throws -> StressCheckIn {
		try draft.validate()
		guard Thread.isMainThread else { throw StressTrackingError("Save stress check-ins on the main queue.") }
		if let existing = existing {
			guard !existing.objectID.isTemporaryID, !existing.isDeleted else { throw StressTrackingError("This check-in is no longer available.") }
		}
		let objectID = existing?.objectID
		let result = try write(contextFactory: contextFactory) { context -> NSManagedObject? in
			let checkIn: StressCheckIn
			if let objectID = objectID {
				guard let stored = try context.existingObject(with: objectID) as? StressCheckIn else {
					throw StressTrackingError("This check-in is no longer available.")
				}
				checkIn = stored
				for response in checkIn.responses { context.delete(response) }
			} else {
				checkIn = try insert(StressCheckIn.self, into: context)
				checkIn.id = UUID()
			}
			checkIn.timestamp = draft.date; checkIn.overallRating = Int16(draft.overallRating!)
			checkIn.note = draft.note?.isEmpty == false ? draft.note : nil
			checkIn.measurementKind = draft.measurementKind; checkIn.scaleVersion = Int16(draft.scaleVersion)
			for answer in draft.responses {
				let response: StressorResponse = try insert(StressorResponse.self, into: context)
				response.checkIn = checkIn; response.timestamp = draft.date
				response.stressorID = answer.stressorID; response.stressorKey = answer.stressorID.uuidString
				response.nameSnapshot = answer.nameSnapshot; response.displayOrder = Int64(answer.order)
				response.statusKey = answer.status.rawValue; response.ratingValue = answer.rating.map { NSNumber(value: $0) }
			}
			return checkIn
		}
		return result.root.object(with: result.objectID!) as! StressCheckIn
	}

	public static func delete(_ checkIn: StressCheckIn) throws {
		try delete([checkIn])
	}

	/// Validate the whole selection, then cascade-delete it in one isolated commit.
	/// Repeated selections of the same saved check-in are deleted only once.
	public static func delete(_ checkIns: [StressCheckIn]) throws {
		guard Thread.isMainThread else { throw StressTrackingError("Delete stress check-ins on the main queue.") }
		guard !checkIns.isEmpty else { return }
		var identifiers: [NSManagedObjectID] = []
		var seen = Set<NSManagedObjectID>()
		for checkIn in checkIns {
			guard !checkIn.objectID.isTemporaryID, !checkIn.isDeleted else {
				throw StressTrackingError("Choose a saved check-in to delete.")
			}
			// Cascade deletes can reach responses only when the writer processes its
			// delete rules. Check every live form first, before any SQLite write, so
			// an unsaved answer cannot be discarded with an otherwise clean parent.
			guard !checkIn.hasChanges, checkIn.responses.allSatisfy({ !$0.hasChanges }) else {
				throw StressTrackingError("Finish or cancel pending changes to this record before deleting.")
			}
			if seen.insert(checkIn.objectID).inserted { identifiers.append(checkIn.objectID) }
		}
		_ = try write { context in
			let records = try identifiers.map { id -> StressCheckIn in
				guard let stored = try context.existingObject(with: id) as? StressCheckIn else {
					throw StressTrackingError("This check-in is no longer available.")
				}
				return stored
			}
			for stored in records { context.delete(stored) }
			return nil
		}
	}

	/// Release inverse relationship cycles after a review has copied immutable values.
	/// Pending edits are preserved; call on the managed objects' main queue.
	public static func releaseSnapshots(of checkIns: [StressCheckIn]) {
		guard Thread.isMainThread else { return }
		for checkIn in checkIns {
			guard !checkIn.hasChanges, !checkIn.isDeleted, let context = checkIn.managedObjectContext else { continue }
			// Releasing a screen must not fetch a relationship solely to discard it.
			if !checkIn.isFault, !checkIn.hasFault(forRelationshipNamed: "responses") {
				let responses = checkIn.responses
				guard responses.allSatisfy({ !$0.hasChanges && !$0.isDeleted }) else { continue }
				for response in responses where !response.isFault { context.refresh(response, mergeChanges: false) }
			}
			context.refresh(checkIn, mergeChanges: false)
		}
	}

	private static func validName(_ value: String) throws -> String {
		let name = value.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !name.isEmpty, name.count <= 120 else { throw StressTrackingError("Give the stressor a name of up to 120 characters.") }
		return name
	}

	private static func findDefinition(_ id: UUID, in context: NSManagedObjectContext) throws -> StressorDefinition {
		let request = StressorDefinition.fetchRequest(); request.fetchLimit = 1
		request.predicate = NSPredicate(format: "id == %@", id as NSUUID)
		guard let value = try context.fetch(request).first else { throw StressTrackingError("This stressor is no longer available.") }
		return value
	}

	private static func insert<Record: NSManagedObject & CoreDataObject>(_ type: Record.Type,
		into context: NSManagedObjectContext) throws -> Record {
		guard let entity = NSEntityDescription.entity(forEntityName: Record.entityName, in: context),
			entity.managedObjectClassName == NSStringFromClass(Record.self) else {
			throw StressTrackingError("The stress data store is unavailable. Reopen Introspective after updating.")
		}
		guard let record = NSManagedObject(entity: entity, insertInto: context) as? Record else {
			throw StressTrackingError("The stress data store could not create the requested record.")
		}
		return record
	}

	/// The root context is used only for identity and refreshing the records deliberately updated.
	/// Every actual write occurs in a fresh peer context and one SQLite commit.
	private static func write(contextFactory: () -> NSManagedObjectContext = { NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType) },
		changes: (NSManagedObjectContext) throws -> NSManagedObject?) throws -> (root: NSManagedObjectContext, objectID: NSManagedObjectID?) {
		guard Thread.isMainThread else { throw StressTrackingError("Modify stress tracking on the main queue.") }
		let root = injected(Database.self).fetchedResultsController(type: StressCheckIn.self,
			sortDescriptors: [NSSortDescriptor(key: "timestamp", ascending: true)]).managedObjectContext
		guard let coordinator = root.persistentStoreCoordinator else { throw StressTrackingError("The stress data store is unavailable.") }
		let context = contextFactory()
		guard context !== root, context.concurrencyType == .mainQueueConcurrencyType, context.parent == nil,
			context.persistentStoreCoordinator == nil, !context.hasChanges else {
			throw StressTrackingError("Stress check-ins require a new independent main-queue writer.")
		}
		context.persistentStoreCoordinator = coordinator
		defer { context.reset() }
		var saveNotification: Notification?
		let observer = NotificationCenter.default.addObserver(forName: .NSManagedObjectContextDidSave,
			object: context, queue: nil) { notification in saveNotification = notification }
		defer { NotificationCenter.default.removeObserver(observer) }
		do {
			let result = try changes(context)
			// Reject a conflict before the SQLite write rather than silently replacing
			// unsaved UI edits to the same parent, response, or stressor definition.
			for object in context.updatedObjects.union(context.deletedObjects) {
				if let registered = root.registeredObject(for: object.objectID), registered.hasChanges {
					throw StressTrackingError("Finish or cancel pending changes to this record before saving.")
				}
			}
			try context.save()
			let resultID = result?.objectID
			// Merge this writer synchronously so immediate readers also see deletions.
			// Changes to unrelated view-context objects remain pending and unsaved.
			if let notification = saveNotification { root.mergeChanges(fromContextDidSave: notification) }
			return (root, resultID)
		} catch { context.rollback(); throw error }
	}
}
