import XCTest
import CoreData
import Common
import DependencyInjection
@testable import Persistence
@testable import Samples
import Settings

private final class ActivityRecordingTestProvider: InjectionProvider {
	let types: [Any.Type] = [Database.self, Settings.self]
	let database: Database
	let settings: Settings
	init(database: Database, settings: Settings) { self.database = database; self.settings = settings }
	func get<T>(_ type: T.Type) throws -> T {
		if type == Database.self { return database as! T }
		if type == Settings.self { return settings as! T }
		throw GenericError("Unexpected activity recording dependency")
	}
}

private final class ActivityRecordingFailingContext: NSManagedObjectContext {
	private(set) var saveAttempts = 0
	override func save() throws {
		saveAttempts += 1
		throw NSError(domain: "ActivityRecordingWriteFailure", code: 1)
	}
}

private final class ActivityRecordingDisplayShift: CoreDataSampleUtil, InjectionProvider {
	let types: [Any.Type] = [CoreDataSampleUtil.self]
	func get<T>(_ type: T.Type) throws -> T { self as! T }
	func convertTimeZoneIfApplicable(for date: Date, timeZoneId: String?) -> Date {
		date.addingTimeInterval(2 * 86400)
	}
}

final class ActivityQuickRecorderTests: XCTestCase {
	private static let model = NSManagedObjectModel.mergedModel(from: [Bundle(for: ActivityQuickRecorderTests.self)])!
	private var container: NSPersistentContainer!
	private var directory: URL!
	private var settings: SettingsImpl!
	private let now = Date(timeIntervalSince1970: 1_700_000_023.875)

	private struct StoredActivity {
		let id: String
		let definitionID: String
		let name: String
		let start: Date
		let startSetAt: Date?
		let end: Date?
		let endSetAt: Date?
		let startZone: String?
		let endZone: String?
		let source: Sources.ActivitySourceNum
		let note: String?
		let tags: [String]
	}

	override func setUpWithError() throws {
		_ = CommonInjectionProvider()
		directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
		try open()
	}

	override func tearDownWithError() throws {
		if container != nil { try close() }
		if let directory = directory { try FileManager.default.removeItem(at: directory) }
		settings = nil
	}

	private func open() throws {
		container = NSPersistentContainer(name: "ActivityQuickRecordingTests", managedObjectModel: Self.model)
		let description = NSPersistentStoreDescription(url: directory.appendingPathComponent("activities.sqlite"))
		description.shouldAddStoreAsynchronously = false
		container.persistentStoreDescriptions = [description]
		var failure: Error?
		container.loadPersistentStores { _, error in failure = error }
		if let failure = failure { throw failure }
		container.viewContext.automaticallyMergesChangesFromParent = true
		settings = try container.viewContext.fetch(SettingsImpl.fetchRequest()).first
		if settings == nil {
			settings = SettingsImpl(entity: try entity(SettingsImpl.entityName), insertInto: container.viewContext)
			try container.viewContext.save()
		}
		settings.setAutoIgnoreEnabled(false)
		DependencyInjector.register([CommonInjectionProvider(), SamplesInjectionProvider(),
			ActivityRecordingTestProvider(database: DatabaseImpl(container), settings: settings)])
	}

	private func close() throws {
		container.viewContext.reset()
		for store in container.persistentStoreCoordinator.persistentStores { try container.persistentStoreCoordinator.remove(store) }
		container = nil
	}

	private func entity(_ name: String) throws -> NSEntityDescription {
		try XCTUnwrap(NSEntityDescription.entity(forEntityName: name, in: container.viewContext))
	}

	private func id(_ object: NSManagedObject) -> String { object.objectID.uriRepresentation().absoluteString }

	private func definition(_ name: String, order: Int16 = 0, autoNote: Bool = false) throws -> ActivityDefinition {
		let result = ActivityDefinition(entity: try entity(ActivityDefinition.entityName), insertInto: container.viewContext)
		result.name = name; result.recordScreenIndex = order; result.autoNote = autoNote; result.setSource(.introspective)
		try container.viewContext.save()
		return result
	}

	private func activity(_ definition: ActivityDefinition, start: Date, end: Date? = nil,
		source: Sources.ActivitySourceNum = .introspective, note: String? = nil) throws -> Activity {
		let result = Activity(entity: try entity(Activity.entityName), insertInto: container.viewContext)
		result.definition = definition; result.setSource(source); result.start = start; result.startSetAt = start
		result.end = end; result.endSetAt = end; result.note = note
		try container.viewContext.save()
		return result
	}

	/// A separate context verifies committed values rather than relying on root-context merge timing.
	private func storedActivities() throws -> [StoredActivity] {
		let reader = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		reader.persistentStoreCoordinator = container.persistentStoreCoordinator
		defer { reader.reset() }
		return try reader.fetch(Activity.fetchRequest()).map { value in
			StoredActivity(id: id(value), definitionID: id(value.definition), name: value.definition.name,
				start: value.value(forKey: "startDate") as! Date,
				startSetAt: value.value(forKey: "startDateSetAt") as? Date,
				end: value.value(forKey: "endDate") as? Date,
				endSetAt: value.value(forKey: "endDateSetAt") as? Date,
				startZone: value.value(forKey: "startDateTimeZoneId") as? String,
				endZone: value.value(forKey: "endDateTimeZoneId") as? String,
				source: value.getSource(), note: value.note, tags: value.tagsArray().map { $0.name }.sorted())
		}
	}

	func testStartAndStopKeepAutomaticFractionsSetAtMetadataAndIdentityAcrossSQLiteReopen() throws {
		let work = try definition("Work"), definitionID = id(work)
		let started = try ActivityQuickRecorder.start(definitionID: definitionID, at: now, recordedAt: now)
		let activityID = try XCTUnwrap(started.startedActivityID)
		XCTAssertTrue(started.didChange)
		let stoppedAt = now.addingTimeInterval(625.125), recordedAt = now.addingTimeInterval(700.5)
		let stopped = try ActivityQuickRecorder.stop(activityID: activityID, at: stoppedAt, recordedAt: recordedAt)
		XCTAssertTrue(stopped.didChange); XCTAssertEqual(stopped.stoppedActivityIDs, [activityID])
		try close(); try open()
		let values = try storedActivities(), value = try XCTUnwrap(values.first)
		XCTAssertEqual(values.count, 1); XCTAssertEqual(value.id, activityID)
		XCTAssertEqual(value.definitionID, definitionID); XCTAssertEqual(value.source, .introspective)
		XCTAssertEqual(value.start, now); XCTAssertEqual(value.startSetAt, now)
		XCTAssertEqual(value.end, stoppedAt); XCTAssertEqual(value.endSetAt, recordedAt)
		XCTAssertNotNil(value.startZone); XCTAssertNotNil(value.endZone)
	}

	func testSwitchUsesOneExactBoundaryAndLeavesOtherConcurrentActivitiesRunning() throws {
		let work = try definition("Work"), music = try definition("Music"), lunch = try definition("Lunch")
		let workActivity = try activity(work, start: now.addingTimeInterval(-3600))
		let musicActivity = try activity(music, start: now.addingTimeInterval(-1800))
		let workID = id(workActivity), musicID = id(musicActivity), lunchID = id(lunch)
		let boundary = now.addingTimeInterval(-300.875)
		let result = try ActivityQuickRecorder.switchActivity(from: workID, to: lunchID, at: boundary, recordedAt: now)
		let values = try storedActivities()
		XCTAssertEqual(values.count, 3)
		let ended = try XCTUnwrap(values.first { $0.id == workID })
		let started = try XCTUnwrap(values.first { $0.id == result.startedActivityID })
		XCTAssertEqual(ended.end, boundary); XCTAssertEqual(started.start, boundary)
		XCTAssertEqual(ended.endSetAt, now); XCTAssertEqual(started.startSetAt, now)
		XCTAssertEqual(started.definitionID, lunchID); XCTAssertNil(started.end)
		XCTAssertNil(try XCTUnwrap(values.first { $0.id == musicID }).end)
		XCTAssertEqual(result.stoppedActivityIDs, [workID])
	}

	func testSnapshotSwitchValidationAndDurationUseStoredInstantsAcrossLegacyDisplayShifts() throws {
		let work = try definition("Work"), lunch = try definition("Lunch")
		let actualStart = now.addingTimeInterval(-600)
		let source = try activity(work, start: actualStart), sourceID = id(source)
		DependencyInjector.register([ActivityRecordingDisplayShift()])
		XCTAssertGreaterThan(source.start, now, "The legacy display value intentionally crosses the switch boundary")
		XCTAssertEqual(try ActivityQuickRecorder.snapshot().running.first { $0.id == sourceID }?.start, actualStart)
		let boundary = now.addingTimeInterval(-300)
		_ = try ActivityQuickRecorder.switchActivity(from: sourceID, to: id(lunch), at: boundary, recordedAt: now)
		let stored = try XCTUnwrap(storedActivities().first { $0.id == sourceID })
		XCTAssertEqual(stored.start, actualStart); XCTAssertEqual(stored.end, boundary)
		XCTAssertEqual(try XCTUnwrap(stored.end).timeIntervalSince(stored.start), 300)
	}

	func testRepeatedStartIsIdempotentAndCannotCreateAnotherRunningInstance() throws {
		let work = try definition("Work"), definitionID = id(work)
		let first = try ActivityQuickRecorder.start(definitionID: definitionID, at: now, recordedAt: now)
		let retry = try ActivityQuickRecorder.start(definitionID: definitionID,
			at: now.addingTimeInterval(10), recordedAt: now.addingTimeInterval(10))
		XCTAssertEqual(retry.startedActivityID, first.startedActivityID); XCTAssertFalse(retry.didChange)
		XCTAssertEqual(try storedActivities().count, 1)
		XCTAssertEqual(try storedActivities().first?.start, now)
	}

	func testSwitchToAlreadyRunningTargetStopsOnlyTheChosenSourceWithoutDuplicatingTheTarget() throws {
		let work = try definition("Work"), lunch = try definition("Lunch")
		let source = try activity(work, start: now.addingTimeInterval(-3600))
		let target = try activity(lunch, start: now.addingTimeInterval(-120))
		let sourceID = id(source), targetID = id(target)
		let result = try ActivityQuickRecorder.switchActivity(from: sourceID, to: id(lunch), at: now, recordedAt: now)
		XCTAssertEqual(result.startedActivityID, targetID)
		let values = try storedActivities()
		XCTAssertEqual(values.count, 2); XCTAssertEqual(values.filter { $0.end == nil }.map { $0.id }, [targetID])
		XCTAssertEqual(try XCTUnwrap(values.first { $0.id == sourceID }).end, now)
		XCTAssertEqual(try XCTUnwrap(values.first { $0.id == targetID }).start, now.addingTimeInterval(-120))
	}

	func testStaleStopCannotEndANewlyRestartedTimer() throws {
		let work = try definition("Work"), definitionID = id(work)
		let original = try ActivityQuickRecorder.start(definitionID: definitionID,
			at: now.addingTimeInterval(-1200), recordedAt: now.addingTimeInterval(-1200))
		let oldID = try XCTUnwrap(original.startedActivityID)
		_ = try ActivityQuickRecorder.stop(activityID: oldID, at: now.addingTimeInterval(-600), recordedAt: now)
		let restarted = try ActivityQuickRecorder.start(definitionID: definitionID,
			at: now.addingTimeInterval(-300), recordedAt: now)
		let retry = try ActivityQuickRecorder.stop(activityID: oldID, at: now, recordedAt: now)
		XCTAssertFalse(retry.didChange)
		let values = try storedActivities()
		XCTAssertEqual(values.filter { $0.end == nil }.map { $0.id }, [try XCTUnwrap(restarted.startedActivityID)])
		XCTAssertEqual(try XCTUnwrap(values.first { $0.id == oldID }).end, now.addingTimeInterval(-600))
	}

	func testRetryingAnAlreadyCompletedSwitchDoesNotEndTheTargetOrRestartIt() throws {
		let work = try definition("Work"), lunch = try definition("Lunch")
		let source = try activity(work, start: now.addingTimeInterval(-3600)), sourceID = id(source)
		let first = try ActivityQuickRecorder.switchActivity(from: sourceID, to: id(lunch), at: now, recordedAt: now)
		let retry = try ActivityQuickRecorder.switchActivity(from: sourceID, to: id(lunch),
			at: now.addingTimeInterval(10), recordedAt: now.addingTimeInterval(10))
		XCTAssertFalse(retry.didChange); XCTAssertEqual(retry.startedActivityID, first.startedActivityID)
		XCTAssertEqual(try storedActivities().count, 2)
		XCTAssertEqual(try storedActivities().filter { $0.end == nil }.map { $0.id }, [try XCTUnwrap(first.startedActivityID)])
	}

	func testStaleSwitchCannotRestartATargetThatHasSinceStopped() throws {
		let work = try definition("Work"), lunch = try definition("Lunch")
		let source = try activity(work, start: now.addingTimeInterval(-3600)), sourceID = id(source)
		let first = try ActivityQuickRecorder.switchActivity(from: sourceID, to: id(lunch), at: now, recordedAt: now)
		_ = try ActivityQuickRecorder.stop(activityID: XCTUnwrap(first.startedActivityID),
			at: now.addingTimeInterval(120), recordedAt: now.addingTimeInterval(120))
		XCTAssertThrowsError(try ActivityQuickRecorder.switchActivity(from: sourceID, to: id(lunch),
			at: now.addingTimeInterval(180), recordedAt: now.addingTimeInterval(180)))
		XCTAssertEqual(try storedActivities().count, 2); XCTAssertTrue(try storedActivities().allSatisfy { $0.end != nil })
	}

	func testInvalidSwitchBoundariesAndTargetIdentifiersCannotLeaveAPartialStop() throws {
		let work = try definition("Work"), lunch = try definition("Lunch")
		let source = try activity(work, start: now.addingTimeInterval(-600)), sourceID = id(source)
		let invalidTimes = [now.addingTimeInterval(-601), now.addingTimeInterval(1),
			Date(timeIntervalSinceReferenceDate: .nan)]
		for boundary in invalidTimes {
			XCTAssertThrowsError(try ActivityQuickRecorder.switchActivity(from: sourceID, to: id(lunch), at: boundary, recordedAt: now))
		}
		let targetID = id(lunch)
		var foreign = try XCTUnwrap(URLComponents(string: targetID))
		foreign.host = UUID().uuidString
		for target in ["", "not-an-object-id", "https://example.com/ActivityDefinition/p1",
			"x-coredata://missing-path", targetID + "?unexpected=true", targetID + "#unexpected",
			targetID.replacingOccurrences(of: "x-coredata:", with: "X-COREDATA:"),
			try XCTUnwrap(foreign.string), sourceID] {
			XCTAssertThrowsError(try ActivityQuickRecorder.switchActivity(from: sourceID, to: target, at: now, recordedAt: now))
		}
		let values = try storedActivities()
		XCTAssertEqual(values.count, 1); XCTAssertEqual(values.first?.id, sourceID); XCTAssertNil(values.first?.end)
	}

	func testMissingDefinitionAndWrongEntityIDsCannotCreateAnActivity() throws {
		let work = try definition("Work"), definitionID = id(work)
		container.viewContext.delete(work); try container.viewContext.save()
		XCTAssertThrowsError(try ActivityQuickRecorder.start(definitionID: definitionID, at: now, recordedAt: now))
		XCTAssertThrowsError(try ActivityQuickRecorder.start(definitionID: id(settings), at: now, recordedAt: now))
		XCTAssertTrue(try storedActivities().isEmpty)
	}

	func testStopRejectsABoundaryBeforeStartWithoutChangingTheRecord() throws {
		let work = try definition("Work"), source = try activity(work, start: now.addingTimeInterval(-60))
		XCTAssertThrowsError(try ActivityQuickRecorder.stop(activityID: id(source),
			at: now.addingTimeInterval(-61), recordedAt: now))
		XCTAssertNil(try storedActivities().first?.end)
		XCTAssertNil(try storedActivities().first?.endSetAt)
	}

	func testSwitchHonorsAutoIgnoreInTheSameSaveAndDoesNotOfferDeletedActivityForAutoNote() throws {
		settings.setAutoIgnoreEnabled(true); settings.setAutoIgnoreSeconds(60)
		let work = try definition("Work", autoNote: true), lunch = try definition("Lunch")
		let source = try activity(work, start: now.addingTimeInterval(-30)), sourceID = id(source)
		let result = try ActivityQuickRecorder.switchActivity(from: sourceID, to: id(lunch), at: now, recordedAt: now)
		let values = try storedActivities()
		XCTAssertEqual(values.count, 1); XCTAssertEqual(values.first?.id, result.startedActivityID)
		XCTAssertEqual(values.first?.start, now); XCTAssertEqual(result.stoppedActivityIDs, [sourceID])
		XCTAssertTrue(result.autoNoteActivityIDs.isEmpty)
	}

	func testAutoIgnoreThresholdIsStrictAndRetainedActivitiesOfferAutoNote() throws {
		settings.setAutoIgnoreEnabled(true); settings.setAutoIgnoreSeconds(60)
		let work = try definition("Work", autoNote: true)
		let source = try activity(work, start: now.addingTimeInterval(-60)), sourceID = id(source)
		let result = try ActivityQuickRecorder.stop(activityID: sourceID, at: now, recordedAt: now)
		XCTAssertEqual(try storedActivities().count, 1); XCTAssertEqual(try storedActivities().first?.end, now)
		XCTAssertEqual(result.autoNoteActivityIDs, [sourceID])
	}

	func testStoppingKeepsOriginalNotesTagsSourceAndStartTimeZone() throws {
		let work = try definition("Imported work")
		let source = try activity(work, start: now.addingTimeInterval(-3600), source: .aTracker, note: "Original note")
		source.setStartTimeZone(TimeZone(identifier: "Asia/Tokyo"))
		let tag = Tag(entity: try entity(Tag.entityName), insertInto: container.viewContext); tag.name = "Original tag"
		source.addToTags(tag); try container.viewContext.save()
		let sourceID = id(source)
		_ = try ActivityQuickRecorder.stop(activityID: sourceID, at: now, recordedAt: now)
		let value = try XCTUnwrap(storedActivities().first)
		XCTAssertEqual(value.source, .aTracker); XCTAssertEqual(value.note, "Original note")
		XCTAssertEqual(value.tags, ["Original tag"]); XCTAssertEqual(value.startZone, "Asia/Tokyo")
		XCTAssertEqual(value.start, now.addingTimeInterval(-3600))
	}

	func testFailedSwitchRollsBackBothSidesAndDoesNotSaveAnUnrelatedPendingEdit() throws {
		let work = try definition("Work"), lunch = try definition("Lunch")
		let source = try activity(work, start: now.addingTimeInterval(-3600)), sourceID = id(source)
		let tag = Tag(entity: try entity(Tag.entityName), insertInto: container.viewContext); tag.name = "Pending edit"
		let writer = ActivityRecordingFailingContext(concurrencyType: .mainQueueConcurrencyType)
		XCTAssertThrowsError(try ActivityQuickRecorder.switchActivity(from: sourceID, to: id(lunch), at: now,
			recordedAt: now, contextFactory: { writer })) { error in
			XCTAssertEqual((error as NSError).domain, "ActivityRecordingWriteFailure")
		}
		XCTAssertEqual(writer.saveAttempts, 1); XCTAssertFalse(writer.hasChanges)
		XCTAssertTrue(tag.isInserted); XCTAssertTrue(container.viewContext.hasChanges)
		XCTAssertEqual(try storedActivities().count, 1); XCTAssertNil(try storedActivities().first?.end)
		try container.viewContext.save()
		XCTAssertEqual(try storedActivities().count, 1); XCTAssertNil(try storedActivities().first?.end,
			"A later root save must not resurrect either half of the failed switch")
	}

	func testSuccessfulRecordingDoesNotSaveUnrelatedPendingRootChanges() throws {
		let work = try definition("Work"), definitionID = id(work)
		let pending = Tag(entity: try entity(Tag.entityName), insertInto: container.viewContext); pending.name = "Not saved"
		_ = try ActivityQuickRecorder.start(definitionID: definitionID, at: now, recordedAt: now)
		XCTAssertTrue(pending.isInserted); XCTAssertTrue(container.viewContext.hasChanges)
		let reader = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		reader.persistentStoreCoordinator = container.persistentStoreCoordinator
		XCTAssertEqual(try reader.count(for: Tag.fetchRequest()), 0)
		XCTAssertEqual(try reader.count(for: Activity.fetchRequest()), 1)
	}

	func testSnapshotKeepsStableSavedIdentityAndAllConcurrentActivities() throws {
		let work = try definition("Work", order: 1), music = try definition("Music", order: 0)
		let workActivity = try activity(work, start: now.addingTimeInterval(-3600))
		let musicActivity = try activity(music, start: now.addingTimeInterval(-1800))
		_ = try activity(work, start: now.addingTimeInterval(-7200), end: now.addingTimeInterval(-4000))
		let snapshot = try ActivityQuickRecorder.snapshot()
		XCTAssertEqual(snapshot.definitions.map { $0.id }, [id(music), id(work)])
		XCTAssertEqual(Set(snapshot.running.map { $0.id }), Set([id(workActivity), id(musicActivity)]))
		XCTAssertEqual(Set(snapshot.running.map { $0.definitionID }), Set([id(work), id(music)]))
		XCTAssertEqual(snapshot.running.first { $0.id == id(workActivity) }?.start, now.addingTimeInterval(-3600))
		work.name = "Pending rename"
		XCTAssertTrue(snapshot.definitions.contains { $0.name == "Work" }, "Published values must not turn into live managed objects")
	}
}
