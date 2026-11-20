import XCTest
import CoreData
import Darwin
import Common
import DependencyInjection
@testable import Persistence
@testable import Samples
import Settings

private final class RecordingUndoTestProvider: InjectionProvider {
	let types: [Any.Type] = [Database.self, Settings.self]
	let database: Database
	let settings: Settings
	init(database: Database, settings: Settings) { self.database = database; self.settings = settings }
	func get<T>(_ type: T.Type) throws -> T {
		if type == Database.self { return database as! T }
		if type == Settings.self { return settings as! T }
		throw GenericError("Unexpected activity undo dependency")
	}
}

private final class RecordingUndoFailingContext: NSManagedObjectContext {
	private(set) var saveAttempts = 0
	override func save() throws {
		saveAttempts += 1
		throw NSError(domain: "RecordingUndoSaveFailure", code: 1)
	}
}

private final class RecordingUndoDisplayShift: CoreDataSampleUtil, InjectionProvider {
	let types: [Any.Type] = [CoreDataSampleUtil.self]
	func get<T>(_ type: T.Type) throws -> T { self as! T }
	func convertTimeZoneIfApplicable(for date: Date, timeZoneId: String?) -> Date {
		date.addingTimeInterval(2 * 86400)
	}
}

final class ActivityRecordingUndoTests: XCTestCase {
	private static let model = NSManagedObjectModel.mergedModel(from: [Bundle(for: ActivityRecordingUndoTests.self)])!
	private var container: NSPersistentContainer!
	private var directory: URL!
	private var settings: SettingsImpl!
	private let now = Date(timeIntervalSince1970: 1_700_000_023.875)

	private struct Payload: Equatable {
		let definitionID: String
		let start: Date
		let startSetAt: Date?
		let startZone: String?
		let end: Date?
		let endSetAt: Date?
		let endZone: String?
		let note: String?
		let source: Int16
		let tagIDs: Set<String>
	}
	private struct StoredActivity: Equatable {
		let id: String
		let payload: Payload
	}

	override func setUpWithError() throws {
		_ = CommonInjectionProvider()
		directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
		container = try makeContainer(at: directory.appendingPathComponent("undo.sqlite"))
		settings = SettingsImpl(entity: try entity(SettingsImpl.entityName), insertInto: container.viewContext)
		try container.viewContext.save()
		settings.setAutoIgnoreEnabled(false)
		registerCurrentDatabase()
	}

	override func tearDownWithError() throws {
		if container != nil {
			container.viewContext.reset()
			for store in container.persistentStoreCoordinator.persistentStores {
				try container.persistentStoreCoordinator.remove(store)
			}
		}
		container = nil; settings = nil
		if let directory = directory { try FileManager.default.removeItem(at: directory) }
	}

	private func makeContainer(at url: URL) throws -> NSPersistentContainer {
		let result = NSPersistentContainer(name: "ActivityRecordingUndoTests", managedObjectModel: Self.model)
		let description = NSPersistentStoreDescription(url: url)
		description.shouldAddStoreAsynchronously = false
		result.persistentStoreDescriptions = [description]
		var failure: Error?
		result.loadPersistentStores { _, error in failure = error }
		if let failure = failure { throw failure }
		result.viewContext.automaticallyMergesChangesFromParent = true
		return result
	}
	private func registerCurrentDatabase() {
		DependencyInjector.register([CommonInjectionProvider(), SamplesInjectionProvider(),
			RecordingUndoTestProvider(database: DatabaseImpl(container), settings: settings)])
	}
	private func entity(_ name: String) throws -> NSEntityDescription {
		try XCTUnwrap(NSEntityDescription.entity(forEntityName: name, in: container.viewContext))
	}
	private func id(_ object: NSManagedObject) -> String { object.objectID.uriRepresentation().absoluteString }
	private func definition(_ name: String, autoNote: Bool = false) throws -> ActivityDefinition {
		let result = ActivityDefinition(entity: try entity(ActivityDefinition.entityName), insertInto: container.viewContext)
		result.name = name; result.recordScreenIndex = 0; result.autoNote = autoNote; result.setSource(.introspective)
		try container.viewContext.save()
		return result
	}
	private func activity(_ definition: ActivityDefinition, start: Date? = nil, note: String? = nil) throws -> Activity {
		let result = Activity(entity: try entity(Activity.entityName), insertInto: container.viewContext)
		result.definition = definition; result.setSource(.introspective)
		result.start = start ?? now.addingTimeInterval(-3600); result.startSetAt = result.storedStartDate
		result.note = note
		try container.viewContext.save()
		return result
	}
	private func tag(_ name: String, on activity: Activity) throws -> Tag {
		let result = Tag(entity: try entity(Tag.entityName), insertInto: container.viewContext)
		result.name = name; activity.addToTags(result)
		try container.viewContext.save()
		return result
	}
	private func independentContext(for owner: NSPersistentContainer? = nil) -> NSManagedObjectContext {
		let result = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		result.persistentStoreCoordinator = (owner ?? container).persistentStoreCoordinator
		result.mergePolicy = NSMergePolicy(merge: .errorMergePolicyType)
		return result
	}
	private func object<T: NSManagedObject>(_ identifier: String, type: T.Type,
		in context: NSManagedObjectContext) throws -> T {
		let coordinator = try XCTUnwrap(context.persistentStoreCoordinator)
		let objectID = try XCTUnwrap(coordinator.managedObjectID(forURIRepresentation: XCTUnwrap(URL(string: identifier))))
		let request = NSFetchRequest<T>(entityName: try XCTUnwrap(objectID.entity.name))
		request.predicate = NSPredicate(format: "SELF == %@", objectID)
		request.fetchLimit = 1
		return try XCTUnwrap(context.fetch(request).first)
	}
	private func mutate(_ identifier: String, _ body: (Activity, NSManagedObjectContext) throws -> Void) throws {
		let context = independentContext(); defer { context.reset() }
		try body(object(identifier, type: Activity.self, in: context), context)
		try context.save()
	}
	private func stored(in owner: NSPersistentContainer? = nil) throws -> [StoredActivity] {
		let reader = independentContext(for: owner); defer { reader.reset() }
		return try reader.fetch(Activity.fetchRequest()).map { value in
			StoredActivity(id: id(value), payload: Payload(definitionID: id(value.definition), start: value.storedStartDate,
				startSetAt: value.value(forKey: "startDateSetAt") as? Date,
				startZone: value.value(forKey: "startDateTimeZoneId") as? String,
				end: value.storedEndDate, endSetAt: value.value(forKey: "endDateSetAt") as? Date,
				endZone: value.value(forKey: "endDateTimeZoneId") as? String, note: value.note,
				source: value.source, tagIDs: Set(value.tagsArray().map(id))))
		}.sorted { $0.id < $1.id }
	}
	private func state(_ identifier: String) throws -> StoredActivity {
		try XCTUnwrap(stored().first { $0.id == identifier })
	}
	private func token(_ result: ActivityUndoableRecordingResult) throws -> ActivityRecordingUndoToken {
		XCTAssertTrue(result.recording.didChange)
		return try XCTUnwrap(result.undoToken)
	}

	func testUndoStartDeletesOnlyItsOwnRecordAndKeepsConcurrentActivityUnchanged() throws {
		let work = try definition("Work"), music = try activity(definition("Music"), note: "Keep this")
		let musicID = id(music), before = try stored()
		let started = try ActivityQuickRecorder.startWithUndo(definitionID: id(work), at: now, recordedAt: now)
		let startedID = try XCTUnwrap(started.recording.startedActivityID)
		let result = try ActivityQuickRecorder.undo(token(started))
		XCTAssertTrue(result.didChange); XCTAssertEqual(result.stoppedActivityIDs, [startedID])
		XCTAssertNil(result.startedActivityID); XCTAssertTrue(result.autoNoteActivityIDs.isEmpty)
		XCTAssertEqual(try stored(), before); XCTAssertEqual(try state(musicID).payload.note, "Keep this")
	}

	func testUndoStopRestoresAllRawMetadataAndRelationshipsIncludingMissingProvenance() throws {
		let source = try activity(definition("Imported", autoNote: true), note: "Original note")
		let originalTag = try tag("Original tag", on: source), sourceID = id(source)
		source.setValue(nil, forKey: "startDateSetAt")
		source.setValue("Asia/Tokyo", forKey: "startDateTimeZoneId")
		source.setValue(nil, forKey: "endDateSetAt")
		source.setValue("America/New_York", forKey: "endDateTimeZoneId")
		source.setSource(.aTracker); try container.viewContext.save()
		let before = try state(sourceID)
		DependencyInjector.register([RecordingUndoDisplayShift()])
		let stopped = try ActivityQuickRecorder.stopWithUndo(activityID: sourceID,
			at: now.addingTimeInterval(-17.125), recordedAt: now)
		XCTAssertEqual(stopped.recording.autoNoteActivityIDs, [sourceID])
		let undone = try ActivityQuickRecorder.undo(token(stopped))
		XCTAssertEqual(undone.startedActivityID, sourceID); XCTAssertTrue(undone.autoNoteActivityIDs.isEmpty)
		XCTAssertEqual(try state(sourceID), before)
		XCTAssertEqual(try state(sourceID).payload.tagIDs, [id(originalTag)])
	}

	func testUndoSwitchRestoresSourceAndRemovesOnlyTheNewTargetInOneCommit() throws {
		let source = try activity(definition("Work"), note: "Source note")
		let other = try activity(definition("Music")), target = try definition("Lunch")
		let sourceID = id(source), before = try stored()
		let switched = try ActivityQuickRecorder.switchActivityWithUndo(from: sourceID, to: id(target),
			at: now.addingTimeInterval(-300.875), recordedAt: now)
		let targetID = try XCTUnwrap(switched.recording.startedActivityID)
		let undone = try ActivityQuickRecorder.undo(token(switched))
		XCTAssertEqual(undone.startedActivityID, sourceID); XCTAssertEqual(undone.stoppedActivityIDs, [targetID])
		XCTAssertTrue(undone.autoNoteActivityIDs.isEmpty); XCTAssertEqual(try stored(), before)
		XCTAssertNil(try state(id(other)).payload.end)
	}

	func testUndoSwitchLeavesAnAlreadyRunningTargetWithItsExactOriginalValues() throws {
		let source = try activity(definition("Work")), targetDefinition = try definition("Lunch")
		let target = try activity(targetDefinition, start: now.addingTimeInterval(-120), note: "Existing target")
		let targetID = id(target), before = try stored()
		let switched = try ActivityQuickRecorder.switchActivityWithUndo(from: id(source), to: id(targetDefinition),
			at: now, recordedAt: now)
		XCTAssertEqual(switched.recording.startedActivityID, targetID)
		let undone = try ActivityQuickRecorder.undo(token(switched))
		XCTAssertTrue(undone.stoppedActivityIDs.isEmpty); XCTAssertEqual(try stored(), before)
		XCTAssertEqual(try state(targetID).payload.note, "Existing target")
	}

	func testUndoAutoIgnoredStopRestoresExactPayloadWithANewSavedIdentity() throws {
		settings.setAutoIgnoreEnabled(true); settings.setAutoIgnoreSeconds(60)
		let source = try activity(definition("Short", autoNote: true), start: now.addingTimeInterval(-5.125), note: "Keep")
		_ = try tag("Retain", on: source)
		let sourceID = id(source), before = try state(sourceID).payload
		let stopped = try ActivityQuickRecorder.stopWithUndo(activityID: sourceID, at: now, recordedAt: now)
		XCTAssertTrue(try stored().isEmpty); XCTAssertTrue(stopped.recording.autoNoteActivityIDs.isEmpty)
		let undone = try ActivityQuickRecorder.undo(token(stopped))
		let restoredID = try XCTUnwrap(undone.startedActivityID)
		XCTAssertNotEqual(restoredID, sourceID); XCTAssertTrue(undone.autoNoteActivityIDs.isEmpty)
		XCTAssertEqual(try state(restoredID).payload, before)
		XCTAssertFalse(try ActivityQuickRecorder.stop(activityID: sourceID, at: now, recordedAt: now).didChange)
		XCTAssertNil(try state(restoredID).payload.end, "A stale old Stop cannot affect the restored identity")
	}

	func testUndoAutoIgnoredSwitchRestoresSourceWithoutKeepingItsNewTarget() throws {
		settings.setAutoIgnoreEnabled(true); settings.setAutoIgnoreSeconds(60)
		let source = try activity(definition("Short", autoNote: true), start: now.addingTimeInterval(-3), note: "Original")
		let target = try definition("Target"), sourceID = id(source), before = try state(sourceID).payload
		let switched = try ActivityQuickRecorder.switchActivityWithUndo(from: sourceID, to: id(target), at: now, recordedAt: now)
		let targetID = try XCTUnwrap(switched.recording.startedActivityID)
		let undone = try ActivityQuickRecorder.undo(token(switched))
		let restoredID = try XCTUnwrap(undone.startedActivityID)
		XCTAssertNotEqual(restoredID, sourceID); XCTAssertEqual(undone.stoppedActivityIDs, [targetID])
		XCTAssertEqual(try stored().count, 1); XCTAssertEqual(try state(restoredID).payload, before)
		XCTAssertTrue(undone.autoNoteActivityIDs.isEmpty)
	}

	func testLaterNoteBoundaryAndTagEditsRejectUndoWithoutChangingThoseEdits() throws {
		for kind in ["note", "boundary", "tags"] {
			let source = try activity(definition(kind)), sourceID = id(source)
			let stopped = try ActivityQuickRecorder.stopWithUndo(activityID: sourceID, at: now, recordedAt: now)
			try mutate(sourceID) { value, context in
				switch kind {
				case "note": value.note = "Saved after stopping"
				case "boundary": value.setValue(self.now.addingTimeInterval(0.125), forKey: "endDate")
				default:
					let entity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: Tag.entityName, in: context))
					let tag = Tag(entity: entity, insertInto: context); tag.name = "Added later"; value.addToTags(tag)
				}
			}
			let beforeUndo = try stored()
			XCTAssertThrowsError(try ActivityQuickRecorder.undo(token(stopped)))
			XCTAssertEqual(try stored(), beforeUndo)
		}
	}

	func testDeletedAffectedRecordAndNewRunningInstanceEachRejectUndo() throws {
		let deleted = try activity(definition("Deleted")), deletedID = id(deleted)
		let first = try ActivityQuickRecorder.stopWithUndo(activityID: deletedID, at: now, recordedAt: now)
		try mutate(deletedID) { value, context in context.delete(value) }
		XCTAssertThrowsError(try ActivityQuickRecorder.undo(token(first))); XCTAssertTrue(try stored().isEmpty)
		let work = try definition("Restarted"), source = try activity(work), sourceID = id(source)
		let stopped = try ActivityQuickRecorder.stopWithUndo(activityID: sourceID, at: now, recordedAt: now)
		_ = try ActivityQuickRecorder.start(definitionID: id(work), at: now.addingTimeInterval(1), recordedAt: now.addingTimeInterval(1))
		let beforeUndo = try stored()
		XCTAssertThrowsError(try ActivityQuickRecorder.undo(token(stopped)))
		XCTAssertEqual(try stored(), beforeUndo)
	}

	func testChangedExistingSwitchTargetIsNotOverwrittenByUndo() throws {
		let source = try activity(definition("Work")), targetDefinition = try definition("Target")
		let target = try activity(targetDefinition), targetID = id(target)
		let switched = try ActivityQuickRecorder.switchActivityWithUndo(from: id(source), to: id(targetDefinition), at: now, recordedAt: now)
		try mutate(targetID) { value, _ in value.note = "Later target edit" }
		let beforeUndo = try stored()
		XCTAssertThrowsError(try ActivityQuickRecorder.undo(token(switched)))
		XCTAssertEqual(try stored(), beforeUndo)
	}

	func testLaterEditsToANewStartOrSwitchTargetCannotBeDeletedByUndo() throws {
		for switches in [false, true] {
			let target = try definition(switches ? "Switch target" : "Start target")
			let result: ActivityUndoableRecordingResult
			if switches {
				let source = try activity(definition("Switch source"))
				result = try ActivityQuickRecorder.switchActivityWithUndo(from: id(source), to: id(target), at: now, recordedAt: now)
			} else {
				result = try ActivityQuickRecorder.startWithUndo(definitionID: id(target), at: now, recordedAt: now)
			}
			let startedID = try XCTUnwrap(result.recording.startedActivityID)
			try mutate(startedID) { value, _ in value.note = "Later note must survive" }
			let beforeUndo = try stored()
			XCTAssertThrowsError(try ActivityQuickRecorder.undo(token(result)))
			XCTAssertEqual(try stored(), beforeUndo)
		}
	}

	func testUndoStopPreservesAnotherAlreadyRunningInstanceOfTheSameDefinition() throws {
		let work = try definition("Work"), first = try activity(work), second = try activity(work, start: now.addingTimeInterval(-120))
		let firstID = id(first), secondID = id(second), before = try stored()
		let stopped = try ActivityQuickRecorder.stopWithUndo(activityID: firstID, at: now, recordedAt: now)
		_ = try ActivityQuickRecorder.undo(token(stopped))
		XCTAssertEqual(try stored(), before)
		XCTAssertNil(try state(firstID).payload.end); XCTAssertNil(try state(secondID).payload.end)
	}

	func testAffectedUnsavedRootEditsRejectUndoAndTheTokenWorksAfterDiscardingThem() throws {
		let source = try activity(definition("Work")), sourceID = id(source)
		let stopped = try ActivityQuickRecorder.stopWithUndo(activityID: sourceID, at: now, recordedAt: now)
		container.viewContext.refresh(source, mergeChanges: false)
		source.note = "Unsaved editor text"
		let beforeUndo = try stored(), undoToken = try token(stopped)
		XCTAssertThrowsError(try ActivityQuickRecorder.undo(undoToken))
		XCTAssertEqual(source.note, "Unsaved editor text"); XCTAssertTrue(container.viewContext.hasChanges)
		XCTAssertEqual(try stored(), beforeUndo)
		container.viewContext.rollback()
		_ = try ActivityQuickRecorder.undo(undoToken)
		XCTAssertNil(try state(sourceID).payload.end)
	}

	func testUndoDoesNotSaveOrDiscardUnrelatedPendingRootWork() throws {
		let work = try definition("Work"), music = try activity(definition("Music"), note: "Saved music")
		let musicID = id(music), started = try ActivityQuickRecorder.startWithUndo(definitionID: id(work), at: now, recordedAt: now)
		music.note = "Pending music"
		let pending = Tag(entity: try entity(Tag.entityName), insertInto: container.viewContext); pending.name = "Pending tag"
		_ = try ActivityQuickRecorder.undo(token(started))
		XCTAssertEqual(music.note, "Pending music"); XCTAssertTrue(pending.isInserted)
		XCTAssertTrue(container.viewContext.hasChanges)
		XCTAssertEqual(try state(musicID).payload.note, "Saved music")
		let reader = independentContext(); defer { reader.reset() }
		XCTAssertEqual(try reader.count(for: Tag.fetchRequest()), 0)
	}

	func testPendingNewInstanceOfTheAffectedDefinitionRejectsUndoWithoutSavingIt() throws {
		let work = try definition("Work"), source = try activity(work), sourceID = id(source)
		let stopped = try ActivityQuickRecorder.stopWithUndo(activityID: sourceID, at: now, recordedAt: now)
		let pending = Activity(entity: try entity(Activity.entityName), insertInto: container.viewContext)
		pending.definition = work; pending.start = now.addingTimeInterval(1); pending.note = "Pending restart"
		let beforeUndo = try stored()
		XCTAssertThrowsError(try ActivityQuickRecorder.undo(token(stopped)))
		XCTAssertTrue(pending.isInserted); XCTAssertEqual(pending.note, "Pending restart")
		XCTAssertEqual(try stored(), beforeUndo)
	}

	func testDeletedReferencesPreventRestoringAutoIgnoredRecords() throws {
		settings.setAutoIgnoreEnabled(true); settings.setAutoIgnoreSeconds(60)
		for removeDefinition in [false, true] {
			let work = try definition(removeDefinition ? "Deleted definition" : "Deleted tag")
			let source = try activity(work, start: now.addingTimeInterval(-3))
			let originalTag = try tag("Original", on: source), sourceID = id(source)
			let stopped = try ActivityQuickRecorder.stopWithUndo(activityID: sourceID, at: now, recordedAt: now)
			let writer = independentContext()
			if removeDefinition { writer.delete(try object(id(work), type: ActivityDefinition.self, in: writer)) }
			else { writer.delete(try object(id(originalTag), type: Tag.self, in: writer)) }
			try writer.save(); writer.reset()
			XCTAssertThrowsError(try ActivityQuickRecorder.undo(token(stopped)))
			XCTAssertTrue(try stored().isEmpty)
		}
	}

	func testSavedDefinitionAndTagRenamesRemainIntactWhenUndoRestoresTheActivity() throws {
		let work = try definition("Old name"), source = try activity(work)
		let originalTag = try tag("Old tag", on: source), sourceID = id(source)
		let before = try state(sourceID).payload
		let stopped = try ActivityQuickRecorder.stopWithUndo(activityID: sourceID, at: now, recordedAt: now)
		let writer = independentContext(); defer { writer.reset() }
		let renamedDefinition = try object(id(work), type: ActivityDefinition.self, in: writer)
		let renamedTag = try object(id(originalTag), type: Tag.self, in: writer)
		renamedDefinition.name = "New name"; renamedTag.name = "New tag"
		try writer.save()
		_ = try ActivityQuickRecorder.undo(token(stopped))
		XCTAssertEqual(try state(sourceID).payload, before)
		let reader = independentContext(); defer { reader.reset() }
		XCTAssertEqual(try object(id(work), type: ActivityDefinition.self, in: reader).name, "New name")
		XCTAssertEqual(try object(id(originalTag), type: Tag.self, in: reader).name, "New tag")
	}

	func testTokenCannotOperateOnAnotherStoreAndRemainsUsableOnItsOriginalStore() throws {
		let work = try definition("Work")
		let started = try ActivityQuickRecorder.startWithUndo(definitionID: id(work), at: now, recordedAt: now)
		let undoToken = try token(started), before = try stored()
		let foreign = try makeContainer(at: directory.appendingPathComponent("foreign.sqlite"))
		defer {
			registerCurrentDatabase(); foreign.viewContext.reset()
			for store in foreign.persistentStoreCoordinator.persistentStores { try? foreign.persistentStoreCoordinator.remove(store) }
		}
		let settingsEntity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: SettingsImpl.entityName, in: foreign.viewContext))
		let foreignSettings = SettingsImpl(entity: settingsEntity, insertInto: foreign.viewContext)
		try foreign.viewContext.save()
		DependencyInjector.register([RecordingUndoTestProvider(database: DatabaseImpl(foreign), settings: foreignSettings)])
		XCTAssertThrowsError(try ActivityQuickRecorder.undo(undoToken))
		XCTAssertTrue(try stored(in: foreign).isEmpty); XCTAssertEqual(try stored(), before)
		registerCurrentDatabase()
		_ = try ActivityQuickRecorder.undo(undoToken)
		XCTAssertTrue(try stored().isEmpty)
	}

	func testReplacingTheStoreAtTheSameURLInvalidatesItsOldToken() throws {
		let work = try definition("Old store")
		let started = try ActivityQuickRecorder.startWithUndo(definitionID: id(work), at: now, recordedAt: now)
		let undoToken = try token(started)
		container.viewContext.reset()
		for store in container.persistentStoreCoordinator.persistentStores { try container.persistentStoreCoordinator.remove(store) }
		container = nil
		for name in ["undo.sqlite", "undo.sqlite-wal", "undo.sqlite-shm"] {
			let url = directory.appendingPathComponent(name)
			if FileManager.default.fileExists(atPath: url.path) { try FileManager.default.removeItem(at: url) }
		}
		container = try makeContainer(at: directory.appendingPathComponent("undo.sqlite"))
		settings = SettingsImpl(entity: try entity(SettingsImpl.entityName), insertInto: container.viewContext)
		try container.viewContext.save(); settings.setAutoIgnoreEnabled(false); registerCurrentDatabase()
		_ = try activity(definition("New store"), note: "Do not touch")
		let beforeUndo = try stored()
		XCTAssertThrowsError(try ActivityQuickRecorder.undo(undoToken))
		XCTAssertEqual(try stored(), beforeUndo)
	}

	func testUndoSaveFailureRollsBackBothSwitchSidesAndDoesNotConsumeTheToken() throws {
		let source = try activity(definition("Work")), target = try definition("Lunch")
		let before = try stored()
		let switched = try ActivityQuickRecorder.switchActivityWithUndo(from: id(source), to: id(target), at: now, recordedAt: now)
		let undoToken = try token(switched), after = try stored()
		let writer = RecordingUndoFailingContext(concurrencyType: .mainQueueConcurrencyType)
		XCTAssertThrowsError(try ActivityQuickRecorder.undo(undoToken, contextFactory: { writer })) { error in
			XCTAssertEqual((error as NSError).domain, "RecordingUndoSaveFailure")
		}
		XCTAssertEqual(writer.saveAttempts, 1); XCTAssertFalse(writer.hasChanges); XCTAssertEqual(try stored(), after)
		_ = try ActivityQuickRecorder.undo(undoToken)
		XCTAssertEqual(try stored(), before)
	}

	func testBusyWriterLockRejectsUndoWithoutMutationAndReleaseAllowsOneUndo() throws {
		let source = try activity(definition("Work")), sourceID = id(source)
		let stopped = try ActivityQuickRecorder.stopWithUndo(activityID: sourceID, at: now, recordedAt: now)
		let undoToken = try token(stopped), beforeUndo = try stored()
		let descriptor = open(directory.appendingPathComponent("activity-recording.lock").path,
			O_CREAT | O_RDWR | O_CLOEXEC, S_IRUSR | S_IWUSR)
		guard descriptor >= 0 else { XCTFail("Could not open independent writer lock"); return }
		defer { _ = flock(descriptor, LOCK_UN); _ = close(descriptor) }
		XCTAssertEqual(flock(descriptor, LOCK_EX | LOCK_NB), 0)
		XCTAssertThrowsError(try ActivityQuickRecorder.undo(undoToken)); XCTAssertEqual(try stored(), beforeUndo)
		XCTAssertEqual(flock(descriptor, LOCK_UN), 0)
		_ = try ActivityQuickRecorder.undo(undoToken)
		XCTAssertNil(try state(sourceID).payload.end)
		XCTAssertThrowsError(try ActivityQuickRecorder.undo(undoToken))
	}

	func testConsumedTokenCannotReplayEvenIfTheExactExpectedPostStateIsRecreated() throws {
		let source = try activity(definition("Work")), sourceID = id(source)
		let stopped = try ActivityQuickRecorder.stopWithUndo(activityID: sourceID, at: now, recordedAt: now)
		let undoToken = try token(stopped), expectedPost = try state(sourceID).payload
		_ = try ActivityQuickRecorder.undo(undoToken)
		try mutate(sourceID) { value, _ in
			value.setValue(expectedPost.end, forKey: "endDate")
			value.setValue(expectedPost.endSetAt, forKey: "endDateSetAt")
			value.setValue(expectedPost.endZone, forKey: "endDateTimeZoneId")
		}
		XCTAssertEqual(try state(sourceID).payload, expectedPost)
		XCTAssertThrowsError(try ActivityQuickRecorder.undo(undoToken))
		XCTAssertEqual(try state(sourceID).payload, expectedPost)
	}

	func testIdempotentStartStopAndSwitchDoNotOfferUndo() throws {
		let work = try definition("Work"), source = try activity(work), sourceID = id(source)
		let started = try ActivityQuickRecorder.startWithUndo(definitionID: id(work), at: now, recordedAt: now)
		XCTAssertFalse(started.recording.didChange); XCTAssertNil(started.undoToken)
		let same = try ActivityQuickRecorder.switchActivityWithUndo(from: sourceID, to: id(work), at: now, recordedAt: now)
		XCTAssertFalse(same.recording.didChange); XCTAssertNil(same.undoToken)
		_ = try ActivityQuickRecorder.stop(activityID: sourceID, at: now, recordedAt: now)
		let stoppedAgain = try ActivityQuickRecorder.stopWithUndo(activityID: sourceID, at: now, recordedAt: now)
		XCTAssertFalse(stoppedAgain.recording.didChange); XCTAssertNil(stoppedAgain.undoToken)
	}
}
