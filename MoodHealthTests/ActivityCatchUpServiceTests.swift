import XCTest
import CoreData
import Darwin
import Common
import DependencyInjection
@testable import Persistence
@testable import Samples
import Settings

private final class CatchUpTestProvider: InjectionProvider {
	let types: [Any.Type] = [Database.self, Settings.self]
	let database: Database
	let settings: Settings
	init(database: Database, settings: Settings) { self.database = database; self.settings = settings }
	func get<T>(_ type: T.Type) throws -> T {
		if type == Database.self { return database as! T }
		if type == Settings.self { return settings as! T }
		throw GenericError("Unexpected catch-up dependency")
	}
}

private final class CatchUpFailingContext: NSManagedObjectContext {
	private(set) var saveAttempts = 0
	override func save() throws {
		saveAttempts += 1
		throw NSError(domain: "CatchUpWriteFailure", code: 1)
	}
}

private final class CatchUpDisplayShift: CoreDataSampleUtil, InjectionProvider {
	let types: [Any.Type] = [CoreDataSampleUtil.self]
	func get<T>(_ type: T.Type) throws -> T { self as! T }
	func convertTimeZoneIfApplicable(for date: Date, timeZoneId: String?) -> Date { date.addingTimeInterval(2 * 86400) }
}

final class ActivityCatchUpServiceTests: XCTestCase {
	private static let model = NSManagedObjectModel.mergedModel(from: [Bundle(for: ActivityCatchUpServiceTests.self)])!
	private var container: NSPersistentContainer!
	private var directory: URL!
	private var settings: SettingsImpl!
	private let day = Date(timeIntervalSince1970: 1_720_915_200) // 2024-07-14 00:00 UTC
	private var now: Date { day.addingTimeInterval(86400 + 12 * 3600 + 0.875) }
	private var calendar: Calendar { var value = Calendar(identifier: .gregorian); value.timeZone = TimeZone(secondsFromGMT: 0)!; return value }

	private struct StoredActivity {
		let id: String
		let definitionID: String
		let start: Date
		let end: Date?
		let startSetAt: Date?
		let endSetAt: Date?
		let startZone: String?
		let endZone: String?
		let source: Sources.ActivitySourceNum
		let note: String?
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
		container = NSPersistentContainer(name: "ActivityCatchUpTests", managedObjectModel: Self.model)
		let description = NSPersistentStoreDescription(url: directory.appendingPathComponent("catch-up.sqlite"))
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
			CatchUpTestProvider(database: DatabaseImpl(container), settings: settings)])
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
	private func at(_ hours: Double) -> Date { day.addingTimeInterval(hours * 3600) }

	private func definition(_ name: String, order: Int16 = 0, autoNote: Bool = false) throws -> ActivityDefinition {
		let result = ActivityDefinition(entity: try entity(ActivityDefinition.entityName), insertInto: container.viewContext)
		result.name = name; result.recordScreenIndex = order; result.autoNote = autoNote; result.setSource(.introspective)
		try container.viewContext.save()
		return result
	}

	private func activity(_ definition: ActivityDefinition, from start: Date, to end: Date? = nil,
		source: Sources.ActivitySourceNum = .introspective, note: String? = nil) throws -> Activity {
		let result = Activity(entity: try entity(Activity.entityName), insertInto: container.viewContext)
		result.definition = definition; result.setSource(source); result.start = start; result.startSetAt = start
		result.end = end; result.endSetAt = end; result.note = note
		try container.viewContext.save()
		return result
	}

	private func storedActivities() throws -> [StoredActivity] {
		let reader = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		reader.persistentStoreCoordinator = container.persistentStoreCoordinator
		defer { reader.reset() }
		return try reader.fetch(Activity.fetchRequest()).map { value in
			StoredActivity(id: id(value), definitionID: id(value.definition), start: value.storedStartDate, end: value.storedEndDate,
				startSetAt: value.value(forKey: "startDateSetAt") as? Date, endSetAt: value.value(forKey: "endDateSetAt") as? Date,
				startZone: value.value(forKey: "startDateTimeZoneId") as? String, endZone: value.value(forKey: "endDateTimeZoneId") as? String,
				source: value.getSource(), note: value.note)
		}
	}

	func testRecordGapKeepsNeighborBoundariesFractionsAndEntryMetadataAcrossSQLiteReopen() throws {
		let walk = try definition("Walk", autoNote: true), definitionID = id(walk)
		let start = at(9).addingTimeInterval(26.125), end = at(10).addingTimeInterval(18.875)
		let result = try ActivityCatchUpService.recordGap(definitionID: definitionID, from: start, to: end, recordedAt: now)
		let activityID = try XCTUnwrap(result.startedActivityID)
		XCTAssertTrue(result.didChange); XCTAssertEqual(result.autoNoteActivityIDs, [activityID])
		try close(); try open()
		let values = try storedActivities(), value = try XCTUnwrap(values.first)
		XCTAssertEqual(values.count, 1); XCTAssertEqual(value.id, activityID); XCTAssertEqual(value.definitionID, definitionID)
		XCTAssertEqual(value.start, start); XCTAssertEqual(value.end, end)
		XCTAssertEqual(value.startSetAt, now); XCTAssertEqual(value.endSetAt, now)
		XCTAssertEqual(value.source, .introspective); XCTAssertNotNil(value.startZone); XCTAssertNotNil(value.endZone)
	}

	func testGapFillAllowsAdjacentRecordsButPreservesExistingIntentionalOverlaps() throws {
		let work = try definition("Work"), music = try definition("Music"), lunch = try definition("Lunch")
		let first = try activity(work, from: at(9), to: at(12)), nested = try activity(music, from: at(10), to: at(11))
		let originalIDs = Set([id(first), id(nested)])
		_ = try ActivityCatchUpService.recordGap(definitionID: id(lunch), from: at(8), to: at(9), recordedAt: now)
		_ = try ActivityCatchUpService.recordGap(definitionID: id(lunch), from: at(12), to: at(13), recordedAt: now)
		let result = try ActivityCatchUpService.loadDay(day, asOf: now, calendar: calendar)
		XCTAssertEqual(result.review.records.count, 4)
		XCTAssertTrue(originalIDs.isSubset(of: Set(result.review.records.map(\.id))))
		XCTAssertEqual(result.review.coveredIntervals, [DateInterval(start: at(8), end: at(13))])
		let stored = try storedActivities()
		XCTAssertEqual(stored.first { $0.id == id(first) }?.start, at(9)); XCTAssertEqual(stored.first { $0.id == id(first) }?.end, at(12))
		XCTAssertEqual(stored.first { $0.id == id(nested) }?.start, at(10)); XCTAssertEqual(stored.first { $0.id == id(nested) }?.end, at(11))
	}

	func testFreshReadRejectsAGapFilledAfterTheReviewWasDisplayed() throws {
		let work = try definition("Work"), lunch = try definition("Lunch")
		_ = try activity(work, from: at(8), to: at(9))
		let displayed = try ActivityCatchUpService.loadDay(day, asOf: now, calendar: calendar)
		let gap = try XCTUnwrap(displayed.review.gaps.first { $0.start == at(9) })
		_ = try activity(work, from: at(10), to: at(11))
		XCTAssertThrowsError(try ActivityCatchUpService.recordGap(definitionID: id(lunch), from: gap.start, to: gap.end, recordedAt: now))
		let stored = try storedActivities()
		XCTAssertEqual(stored.count, 2); XCTAssertFalse(stored.contains { $0.definitionID == id(lunch) })
		XCTAssertEqual(displayed.review.records.count, 1, "Published review values remain a snapshot")
	}

	func testAllPositiveOverlapShapesRejectTheWholeGapWithoutChangingExistingData() throws {
		let work = try definition("Work"), lunch = try definition("Lunch")
		let existing = try activity(work, from: at(10), to: at(11)), existingID = id(existing)
		for (start, end) in [(9.5, 10.5), (10.25, 10.75), (9.0, 12.0), (10.5, 11.5), (10.0, 11.0)] {
			XCTAssertThrowsError(try ActivityCatchUpService.recordGap(definitionID: id(lunch), from: at(start), to: at(end), recordedAt: now))
		}
		let values = try storedActivities()
		XCTAssertEqual(values.count, 1); XCTAssertEqual(values.first?.id, existingID)
		XCTAssertEqual(values.first?.start, at(10)); XCTAssertEqual(values.first?.end, at(11))
	}

	func testRunningActivityFromAnEarlierDayBlocksGapFillUntilItIsEnded() throws {
		let work = try definition("Work"), lunch = try definition("Lunch")
		let running = try activity(work, from: at(-4)), runningID = id(running)
		XCTAssertThrowsError(try ActivityCatchUpService.recordGap(definitionID: id(lunch), from: at(10), to: at(11), recordedAt: now))
		XCTAssertEqual(try storedActivities().count, 1); XCTAssertNil(try storedActivities().first?.end)
		_ = try ActivityQuickRecorder.stop(activityID: runningID, at: at(9), recordedAt: now)
		_ = try ActivityCatchUpService.recordGap(definitionID: id(lunch), from: at(10), to: at(11), recordedAt: now)
		let review = try ActivityCatchUpService.loadDay(day, asOf: now, calendar: calendar).review
		XCTAssertEqual(review.gaps, [DateInterval(start: at(9), end: at(10)), DateInterval(start: at(11), end: at(24))])
	}

	func testInvalidAndFutureIntervalsCannotCreatePartialOrEmptyRecords() throws {
		let work = try definition("Work"), definitionID = id(work)
		let invalid = Date(timeIntervalSinceReferenceDate: .nan)
		for (start, end) in [(at(10), at(10)), (at(11), at(10)), (now, now.addingTimeInterval(1)),
			(invalid, at(10)), (at(10), invalid), (Date(timeIntervalSinceReferenceDate: -.infinity), at(10))] {
			XCTAssertThrowsError(try ActivityCatchUpService.recordGap(definitionID: definitionID, from: start, to: end, recordedAt: now))
		}
		XCTAssertThrowsError(try ActivityCatchUpService.recordGap(definitionID: definitionID, from: at(10), to: at(11), recordedAt: invalid))
		XCTAssertTrue(try storedActivities().isEmpty)
	}

	func testMalformedWrongEntityAndDeletedDefinitionsCannotCreateAnActivity() throws {
		let work = try definition("Work"), definitionID = id(work)
		let other = try activity(work, from: at(1), to: at(2)), activityID = id(other)
		for invalid in ["", "not-a-core-data-id", activityID, id(settings)] {
			XCTAssertThrowsError(try ActivityCatchUpService.recordGap(definitionID: invalid, from: at(10), to: at(11), recordedAt: now))
		}
		container.viewContext.delete(other); container.viewContext.delete(work); try container.viewContext.save()
		XCTAssertThrowsError(try ActivityCatchUpService.recordGap(definitionID: definitionID, from: at(10), to: at(11), recordedAt: now))
		XCTAssertTrue(try storedActivities().isEmpty)
	}

	func testSuccessfulGapWriterDoesNotCommitAnUnrelatedPendingRootInsertion() throws {
		let work = try definition("Work")
		let tag = Tag(entity: try entity(Tag.entityName), insertInto: container.viewContext); tag.name = "Pending"
		_ = try ActivityCatchUpService.recordGap(definitionID: id(work), from: at(10), to: at(11), recordedAt: now)
		XCTAssertTrue(tag.isInserted); XCTAssertTrue(container.viewContext.hasChanges)
		let reader = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		reader.persistentStoreCoordinator = container.persistentStoreCoordinator
		XCTAssertEqual(try reader.count(for: Tag.fetchRequest()), 0); XCTAssertEqual(try reader.count(for: Activity.fetchRequest()), 1)
	}

	func testFailedGapWriterRollsBackAndCannotBeResurrectedByALaterRootSave() throws {
		let work = try definition("Work")
		let tag = Tag(entity: try entity(Tag.entityName), insertInto: container.viewContext); tag.name = "Pending"
		let writer = CatchUpFailingContext(concurrencyType: .mainQueueConcurrencyType)
		XCTAssertThrowsError(try ActivityQuickRecorder.recordGap(definitionID: id(work), from: at(10), to: at(11),
			recordedAt: now, contextFactory: { writer })) { error in XCTAssertEqual((error as NSError).domain, "CatchUpWriteFailure") }
		XCTAssertEqual(writer.saveAttempts, 1); XCTAssertFalse(writer.hasChanges)
		XCTAssertTrue(tag.isInserted); XCTAssertTrue(try storedActivities().isEmpty)
		try container.viewContext.save()
		XCTAssertTrue(try storedActivities().isEmpty, "A later save must not persist a failed completed entry")
	}

	func testLoadDayPreservesOriginalInstantsAcrossLegacyDisplayTimeConversion() throws {
		let work = try definition("Work", order: 1), music = try definition("Music", order: 0)
		let first = try activity(work, from: at(8).addingTimeInterval(0.125), to: at(10).addingTimeInterval(0.875))
		let other = try activity(music, from: at(9), to: at(11))
		DependencyInjector.register([CatchUpDisplayShift()])
		XCTAssertGreaterThan(first.start, now)
		let snapshot = try ActivityCatchUpService.loadDay(day, asOf: now, calendar: calendar)
		XCTAssertEqual(snapshot.definitions.map(\.id), [id(music), id(work)])
		XCTAssertEqual(snapshot.review.records.map(\.id), [id(first), id(other)])
		XCTAssertEqual(snapshot.review.records.first?.start, at(8).addingTimeInterval(0.125))
		XCTAssertEqual(snapshot.review.records.first?.end, at(10).addingTimeInterval(0.875))
		XCTAssertEqual(snapshot.review.recordedDuration, at(11).timeIntervalSince(at(8).addingTimeInterval(0.125)))
	}

	func testDayReviewAndCurrentRunningListDoNotIncludeFutureRecords() throws {
		let work = try definition("Work")
		let before = try activity(work, from: at(-2), to: at(0))
		let current = try activity(work, from: at(25)), currentID = id(current)
		let future = try activity(work, from: now.addingTimeInterval(1)), futureID = id(future)
		let snapshot = try ActivityCatchUpService.loadDay(day, asOf: now, calendar: calendar)
		XCTAssertTrue(snapshot.review.records.isEmpty)
		XCTAssertEqual(snapshot.review.gaps, [DateInterval(start: at(0), end: at(24))])
		XCTAssertEqual(snapshot.running.map(\.id), [currentID])
		XCTAssertFalse(snapshot.review.records.contains { $0.id == id(before) || $0.id == futureID })
	}

	func testExplicitShortGapEntriesIgnoreTheAutomaticShortTimerDiscardRule() throws {
		settings.setAutoIgnoreEnabled(true); settings.setAutoIgnoreSeconds(60)
		let work = try definition("Work", autoNote: true)
		let result = try ActivityCatchUpService.recordGap(definitionID: id(work), from: at(10), to: at(10).addingTimeInterval(5), recordedAt: now)
		let value = try XCTUnwrap(storedActivities().first)
		XCTAssertEqual(value.end?.timeIntervalSince(value.start), 5)
		XCTAssertEqual(result.autoNoteActivityIDs, [value.id]); XCTAssertEqual(try storedActivities().count, 1)
	}

	func testEditorLookupReturnsTheSavedRootObjectAndRejectsDeletedOrMalformedIDs() throws {
		let work = try definition("Work"), record = try activity(work, from: at(8), to: at(9)), activityID = id(record)
		let tag = Tag(entity: try entity(Tag.entityName), insertInto: container.viewContext); tag.name = "Pending"
		record.note = "Pending note"
		let resolved = try ActivityCatchUpService.activity(id: activityID)
		XCTAssertEqual(resolved.objectID, record.objectID); XCTAssertTrue(resolved.managedObjectContext === container.viewContext)
		XCTAssertTrue(tag.isInserted); XCTAssertEqual(resolved.note, "Pending note")
		XCTAssertNil(try storedActivities().first?.note, "Opening an editor must not save its pending changes")
		for invalid in ["not-an-object-id", id(work)] { XCTAssertThrowsError(try ActivityCatchUpService.activity(id: invalid)) }
		container.viewContext.delete(record)
		XCTAssertThrowsError(try ActivityCatchUpService.activity(id: activityID))
		XCTAssertTrue(record.isDeleted); XCTAssertEqual(try storedActivities().count, 1)
		try container.viewContext.save()
		XCTAssertThrowsError(try ActivityCatchUpService.activity(id: activityID))
	}

	func testPointAndBackwardsRowsRemainEditableButDoNotBlockFillingUnrecordedTime() throws {
		let work = try definition("Work"), lunch = try definition("Lunch")
		let backwards = try activity(work, from: at(11), to: at(10)), point = try activity(work, from: at(10.5), to: at(10.5))
		let backwardsID = id(backwards), pointID = id(point)
		let before = try ActivityCatchUpService.loadDay(day, asOf: now, calendar: calendar)
		XCTAssertEqual(before.review.records.count, 2); XCTAssertTrue(before.review.coveredIntervals.isEmpty)
		_ = try ActivityCatchUpService.recordGap(definitionID: id(lunch), from: at(9), to: at(12), recordedAt: now)
		let values = try storedActivities()
		XCTAssertEqual(values.count, 3)
		XCTAssertEqual(values.first { $0.id == backwardsID }?.start, at(11)); XCTAssertEqual(values.first { $0.id == backwardsID }?.end, at(10))
		XCTAssertEqual(values.first { $0.id == pointID }?.start, at(10.5)); XCTAssertEqual(values.first { $0.id == pointID }?.end, at(10.5))
		let after = try ActivityCatchUpService.loadDay(day, asOf: now, calendar: calendar)
		XCTAssertEqual(after.review.records.count, 3)
		XCTAssertEqual(after.review.coveredIntervals, [DateInterval(start: at(9), end: at(12))])
	}

	func testBusyAppGroupWriterLockCannotCreateAnActivityAndReleaseAllowsExactlyOneRecord() throws {
		let work = try definition("Work")
		let descriptor = Darwin.open(directory.appendingPathComponent("activity-recording.lock").path,
			O_CREAT | O_RDWR | O_CLOEXEC, S_IRUSR | S_IWUSR)
		guard descriptor >= 0 else { XCTFail("Could not open the independent writer lock"); return }
		defer { _ = flock(descriptor, LOCK_UN); _ = Darwin.close(descriptor) }
		XCTAssertEqual(flock(descriptor, LOCK_EX | LOCK_NB), 0)
		XCTAssertThrowsError(try ActivityCatchUpService.recordGap(definitionID: id(work), from: at(10), to: at(11), recordedAt: now)) { error in
			XCTAssertTrue(error is ActivityRecordingError)
		}
		XCTAssertTrue(try storedActivities().isEmpty)
		XCTAssertEqual(flock(descriptor, LOCK_UN), 0)
		let result = try ActivityCatchUpService.recordGap(definitionID: id(work), from: at(10), to: at(11), recordedAt: now)
		XCTAssertTrue(result.didChange); XCTAssertEqual(try storedActivities().count, 1)
	}
}
