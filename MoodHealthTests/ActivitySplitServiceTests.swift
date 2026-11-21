import XCTest
import CoreData
import Common
import DependencyInjection
@testable import Persistence
@testable import Samples
import Settings

private final class SplitTestProvider: InjectionProvider {
	let types: [Any.Type] = [Database.self, Settings.self]
	let database: Database
	let settings: Settings
	init(database: Database, settings: Settings) { self.database = database; self.settings = settings }
	func get<T>(_ type: T.Type) throws -> T {
		if type == Database.self { return database as! T }
		if type == Settings.self { return settings as! T }
		throw GenericError("Unexpected activity split dependency")
	}
}

private final class SplitFailingContext: NSManagedObjectContext {
	private(set) var saveAttempts = 0
	override func save() throws {
		saveAttempts += 1
		throw NSError(domain: "ActivitySplitWriteFailure", code: 1)
	}
}

private final class SplitDisplayShift: CoreDataSampleUtil, InjectionProvider {
	let types: [Any.Type] = [CoreDataSampleUtil.self]
	func get<T>(_ type: T.Type) throws -> T { self as! T }
	func convertTimeZoneIfApplicable(for date: Date, timeZoneId: String?) -> Date {
		date.addingTimeInterval(2 * 86400)
	}
}

final class ActivitySplitServiceTests: XCTestCase {
	private static let model = NSManagedObjectModel.mergedModel(from: [Bundle(for: ActivitySplitServiceTests.self)])!
	private var container: NSPersistentContainer!
	private var directory: URL!
	private var settings: SettingsImpl!
	private let now = Date(timeIntervalSince1970: 1_700_000_023.875)
	private var start: Date { now.addingTimeInterval(-7200.75) }
	private var boundary: Date { now.addingTimeInterval(-3600.5) }
	private var end: Date { now.addingTimeInterval(-600.125) }

	private struct StoredActivity: Equatable {
		let id: String
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

	override func setUpWithError() throws {
		_ = CommonInjectionProvider()
		directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
		try openStore()
	}

	override func tearDownWithError() throws {
		if container != nil { try closeStore() }
		settings = nil
		if let directory = directory { try FileManager.default.removeItem(at: directory) }
	}

	private func openStore() throws {
		container = NSPersistentContainer(name: "ActivitySplitTests", managedObjectModel: Self.model)
		let description = NSPersistentStoreDescription(url: directory.appendingPathComponent("split.sqlite"))
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
			SplitTestProvider(database: DatabaseImpl(container), settings: settings)])
	}

	private func closeStore() throws {
		container.viewContext.reset()
		for store in container.persistentStoreCoordinator.persistentStores {
			try container.persistentStoreCoordinator.remove(store)
		}
		container = nil
	}

	private func entity(_ name: String) throws -> NSEntityDescription {
		try XCTUnwrap(NSEntityDescription.entity(forEntityName: name, in: container.viewContext))
	}
	private func id(_ value: NSManagedObject) -> String { value.objectID.uriRepresentation().absoluteString }
	private func definition(_ name: String, autoNote: Bool = false) throws -> ActivityDefinition {
		let value = ActivityDefinition(entity: try entity(ActivityDefinition.entityName), insertInto: container.viewContext)
		value.name = name; value.recordScreenIndex = 0; value.autoNote = autoNote; value.setSource(.introspective)
		try container.viewContext.save()
		return value
	}
	private func activity(_ definition: ActivityDefinition, from: Date? = nil, to: Date? = nil,
		note: String? = nil) throws -> Activity {
		let value = Activity(entity: try entity(Activity.entityName), insertInto: container.viewContext)
		value.definition = definition; value.setSource(.introspective)
		value.start = from ?? start; value.startSetAt = now.addingTimeInterval(-120)
		value.end = to; value.endSetAt = to == nil ? nil : now.addingTimeInterval(-60)
		value.note = note
		try container.viewContext.save()
		return value
	}
	private func tag(_ name: String, on value: Activity) throws -> Tag {
		let result = Tag(entity: try entity(Tag.entityName), insertInto: container.viewContext)
		result.name = name; value.addToTags(result)
		try container.viewContext.save()
		return result
	}
	private func independentContext() -> NSManagedObjectContext {
		let value = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		value.persistentStoreCoordinator = container.persistentStoreCoordinator
		value.mergePolicy = NSMergePolicy(merge: .errorMergePolicyType)
		return value
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
		let writer = independentContext(); defer { writer.reset() }
		try body(object(identifier, type: Activity.self, in: writer), writer)
		try writer.save()
	}
	private func stored() throws -> [StoredActivity] {
		let reader = independentContext(); defer { reader.reset() }
		return try reader.fetch(Activity.fetchRequest()).map { value in
			StoredActivity(id: id(value), definitionID: id(value.definition), start: value.storedStartDate,
				startSetAt: value.value(forKey: "startDateSetAt") as? Date,
				startZone: value.value(forKey: "startDateTimeZoneId") as? String,
				end: value.storedEndDate, endSetAt: value.value(forKey: "endDateSetAt") as? Date,
				endZone: value.value(forKey: "endDateTimeZoneId") as? String, note: value.note,
				source: value.source, tagIDs: Set(value.tagsArray().map(id)))
		}.sorted { $0.id < $1.id }
	}
	private func state(_ identifier: String) throws -> StoredActivity {
		try XCTUnwrap(stored().first { $0.id == identifier })
	}

	func testEndedSplitPreservesOuterBoundariesMetadataNotesAndTagsAfterSQLiteReopen() throws {
		let work = try definition("Work"), lunch = try definition("Lunch")
		let source = try activity(work, to: end, note: "Keep both parts"), sourceID = id(source)
		_ = try tag("Original", on: source)
		let before = try state(sourceID)
		let snapshot = try ActivitySplitService.snapshot(activityID: sourceID)
		let second = try ActivitySplitService.split(snapshot, at: boundary, secondDefinitionID: id(lunch), recordedAt: now)
		let secondID = try XCTUnwrap(second.startedActivityID), lunchID = id(lunch)
		XCTAssertTrue(second.didChange)
		try closeStore(); try openStore()
		XCTAssertEqual(try stored().count, 2)
		let first = try state(sourceID), later = try state(secondID)
		XCTAssertEqual(first.definitionID, before.definitionID); XCTAssertEqual(later.definitionID, lunchID)
		XCTAssertEqual(first.start, before.start); XCTAssertEqual(first.startSetAt, before.startSetAt)
		XCTAssertEqual(first.startZone, before.startZone); XCTAssertEqual(first.end, boundary)
		XCTAssertEqual(first.endSetAt, now); XCTAssertNotNil(first.endZone)
		XCTAssertEqual(later.start, boundary); XCTAssertEqual(later.startSetAt, now)
		XCTAssertEqual(later.startZone, first.endZone)
		XCTAssertEqual(later.end, before.end); XCTAssertEqual(later.endSetAt, before.endSetAt)
		XCTAssertEqual(later.endZone, before.endZone)
		for value in [first, later] {
			XCTAssertEqual(value.note, before.note); XCTAssertEqual(value.tagIDs, before.tagIDs)
			XCTAssertEqual(value.source, before.source)
		}
		XCTAssertEqual(try XCTUnwrap(first.end).timeIntervalSince(first.start)
			+ XCTUnwrap(later.end).timeIntervalSince(later.start), end.timeIntervalSince(start))
	}

	func testRunningSplitKeepsTheSecondPartRunningAndLeavesOtherTimersUnchanged() throws {
		let work = try definition("Work"), lunch = try definition("Lunch")
		let source = try activity(work, note: "Still going"), sourceID = id(source)
		let other = try activity(lunch, from: start.addingTimeInterval(60), note: "Independent")
		let otherBefore = try state(id(other))
		let snapshot = try ActivitySplitService.snapshot(activityID: sourceID)
		let second = try ActivitySplitService.split(snapshot, at: boundary, secondDefinitionID: id(lunch), recordedAt: now)
		XCTAssertEqual(try stored().count, 3)
		XCTAssertEqual(try state(sourceID).end, boundary)
		let later = try state(XCTUnwrap(second.startedActivityID))
		XCTAssertEqual(later.start, boundary); XCTAssertNil(later.end)
		XCTAssertNil(later.endSetAt); XCTAssertNil(later.endZone)
		XCTAssertEqual(later.note, "Still going"); XCTAssertEqual(try state(id(other)), otherBefore)
	}

	func testSameActivityDefinitionCanBeSplitIntoTwoExplicitRecords() throws {
		let work = try definition("Work"), source = try activity(work, to: end)
		let snapshot = try ActivitySplitService.snapshot(activityID: id(source))
		_ = try ActivitySplitService.split(snapshot, at: boundary, secondDefinitionID: id(work), recordedAt: now)
		let values = try stored()
		XCTAssertEqual(values.count, 2); XCTAssertTrue(values.allSatisfy { $0.definitionID == id(work) })
		XCTAssertEqual(values.filter { $0.end == boundary }.count, 1)
		XCTAssertEqual(values.filter { $0.start == boundary }.count, 1)
	}

	func testExplicitShortPartsAreKeptWhenAutomaticShortTimerIgnoringIsEnabled() throws {
		settings.setAutoIgnoreEnabled(true); settings.setAutoIgnoreSeconds(60)
		let work = try definition("Work", autoNote: true)
		let source = try activity(work, from: now.addingTimeInterval(-10), to: now.addingTimeInterval(-2))
		let snapshot = try ActivitySplitService.snapshot(activityID: id(source))
		_ = try ActivitySplitService.split(snapshot, at: now.addingTimeInterval(-6), secondDefinitionID: id(work), recordedAt: now)
		let values = try stored()
		XCTAssertEqual(values.count, 2)
		for value in values { XCTAssertEqual(try XCTUnwrap(value.end).timeIntervalSince(value.start), 4) }
	}

	func testBackdatedBoundaryZerosLowerUnitsWithoutRoundingOriginalBounds() throws {
		let work = try definition("Work"), source = try activity(work, to: end), sourceID = id(source)
		let snapshot = try ActivitySplitService.snapshot(activityID: sourceID)
		var calendar = Calendar(identifier: .gregorian); calendar.timeZone = TimeZone(secondsFromGMT: 0)!
		let chosen = try ActivityBackdate.date(value: 30, unit: .minute, now: now, calendar: calendar)
		let second = try ActivitySplitService.split(snapshot, at: chosen, secondDefinitionID: id(work), recordedAt: now)
		XCTAssertEqual(calendar.component(.second, from: chosen), 0)
		XCTAssertEqual(chosen.timeIntervalSince1970.rounded(.down), chosen.timeIntervalSince1970)
		XCTAssertEqual(try state(sourceID).start, start); XCTAssertEqual(try state(sourceID).end, chosen)
		XCTAssertEqual(try state(XCTUnwrap(second.startedActivityID)).start, chosen)
		XCTAssertEqual(try state(XCTUnwrap(second.startedActivityID)).end, end)
	}

	func testNilLegacyOuterMetadataAndImportedSourceArePreserved() throws {
		let work = try definition("Imported"), source = try activity(work, to: end), sourceID = id(source)
		source.setSource(.aTracker)
		for key in ["startDateSetAt", "startDateTimeZoneId", "endDateSetAt", "endDateTimeZoneId"] {
			source.setValue(nil, forKey: key)
		}
		try container.viewContext.save()
		let snapshot = try ActivitySplitService.snapshot(activityID: sourceID)
		let second = try ActivitySplitService.split(snapshot, at: boundary, secondDefinitionID: id(work), recordedAt: now)
		let first = try state(sourceID), later = try state(XCTUnwrap(second.startedActivityID))
		XCTAssertNil(first.startSetAt); XCTAssertNil(first.startZone)
		XCTAssertNil(later.endSetAt); XCTAssertNil(later.endZone)
		XCTAssertEqual(first.source, Sources.ActivitySourceNum.aTracker.rawValue)
		XCTAssertEqual(later.source, Sources.ActivitySourceNum.aTracker.rawValue)
	}

	func testSnapshotAndSplitUseStoredInstantsDespiteLegacyDisplayConversion() throws {
		let work = try definition("Work"), source = try activity(work, to: end), sourceID = id(source)
		DependencyInjector.register([SplitDisplayShift()])
		XCTAssertGreaterThan(source.start, now)
		let snapshot = try ActivitySplitService.snapshot(activityID: sourceID)
		XCTAssertEqual(snapshot.start, start); XCTAssertEqual(snapshot.end, end)
		let second = try ActivitySplitService.split(snapshot, at: boundary, secondDefinitionID: id(work), recordedAt: now)
		XCTAssertEqual(try state(sourceID).start, start); XCTAssertEqual(try state(sourceID).end, boundary)
		XCTAssertEqual(try state(XCTUnwrap(second.startedActivityID)).start, boundary)
		XCTAssertEqual(try state(XCTUnwrap(second.startedActivityID)).end, end)
	}

	func testBoundaryAndInvalidTimesAreRejectedWithoutChangingEitherPart() throws {
		let work = try definition("Work"), source = try activity(work, to: end)
		let snapshot = try ActivitySplitService.snapshot(activityID: id(source)), before = try stored()
		for chosen in [start.addingTimeInterval(-1), start, end, end.addingTimeInterval(1), now.addingTimeInterval(1),
			Date(timeIntervalSinceReferenceDate: .nan), Date(timeIntervalSinceReferenceDate: .infinity)] {
			XCTAssertThrowsError(try ActivitySplitService.split(snapshot, at: chosen, secondDefinitionID: id(work), recordedAt: now))
			XCTAssertEqual(try stored(), before)
		}
		XCTAssertThrowsError(try ActivitySplitService.split(snapshot, at: boundary, secondDefinitionID: id(work),
			recordedAt: Date(timeIntervalSinceReferenceDate: .nan)))
		XCTAssertEqual(try stored(), before)
	}

	func testRunningSplitCannotCreateAFutureOrEmptySecondPart() throws {
		let work = try definition("Work"), source = try activity(work)
		let snapshot = try ActivitySplitService.snapshot(activityID: id(source)), before = try stored()
		for chosen in [start, now, now.addingTimeInterval(1)] {
			XCTAssertThrowsError(try ActivitySplitService.split(snapshot, at: chosen, secondDefinitionID: id(work), recordedAt: now))
		}
		XCTAssertEqual(try stored(), before)
	}

	func testSavedSourceEditsAfterSnapshotRejectSplitAndPreserveTheNewerValues() throws {
		let work = try definition("Work")
		let mutations: [(Activity) -> Void] = [
			{ $0.note = "Later note" }, { $0.start = self.start.addingTimeInterval(1) },
			{ $0.end = self.end.addingTimeInterval(-1) }, { $0.startSetAt = nil },
			{ $0.endSetAt = nil }, { $0.setSource(.aTracker) },
		]
		for mutation in mutations {
			let source = try activity(work, to: end), sourceID = id(source)
			let snapshot = try ActivitySplitService.snapshot(activityID: sourceID)
			try mutate(sourceID) { value, _ in mutation(value) }
			let afterEdit = try stored()
			XCTAssertThrowsError(try ActivitySplitService.split(snapshot, at: boundary, secondDefinitionID: id(work), recordedAt: now))
			XCTAssertEqual(try stored(), afterEdit)
		}
	}

	func testSavedTagChangesAndDeletedSourceRejectTheOldSnapshot() throws {
		let work = try definition("Work"), source = try activity(work, to: end), sourceID = id(source)
		let originalTag = try tag("Keep", on: source), tagID = id(originalTag)
		let snapshot = try ActivitySplitService.snapshot(activityID: sourceID)
		try mutate(sourceID) { value, context in value.removeFromTags(try self.object(tagID, type: Tag.self, in: context)) }
		let afterTagChange = try stored()
		XCTAssertThrowsError(try ActivitySplitService.split(snapshot, at: boundary, secondDefinitionID: id(work), recordedAt: now))
		XCTAssertEqual(try stored(), afterTagChange)
		let fresh = try ActivitySplitService.snapshot(activityID: sourceID)
		try mutate(sourceID) { value, context in context.delete(value) }
		XCTAssertThrowsError(try ActivitySplitService.split(fresh, at: boundary, secondDefinitionID: id(work), recordedAt: now))
		XCTAssertTrue(try stored().isEmpty)
	}

	func testMalformedWrongEntityAndDeletedDestinationCannotChangeTheSource() throws {
		let work = try definition("Work"), lunch = try definition("Lunch")
		let source = try activity(work, to: end), sourceID = id(source), lunchID = id(lunch)
		let snapshot = try ActivitySplitService.snapshot(activityID: sourceID), before = try stored()
		for invalid in ["", "not-an-object-id", sourceID, id(settings)] {
			XCTAssertThrowsError(try ActivitySplitService.split(snapshot, at: boundary, secondDefinitionID: invalid, recordedAt: now))
		}
		container.viewContext.delete(lunch); try container.viewContext.save()
		XCTAssertThrowsError(try ActivitySplitService.split(snapshot, at: boundary, secondDefinitionID: lunchID, recordedAt: now))
		XCTAssertEqual(try stored(), before)
	}

	func testSnapshotRejectsMalformedWrongEntityAndDeletedSourceIDs() throws {
		let work = try definition("Work"), source = try activity(work, to: end), sourceID = id(source)
		for invalid in ["", "not-an-object-id", id(work), id(settings)] {
			XCTAssertThrowsError(try ActivitySplitService.snapshot(activityID: invalid))
		}
		container.viewContext.delete(source); try container.viewContext.save()
		XCTAssertThrowsError(try ActivitySplitService.snapshot(activityID: sourceID))
	}

	func testAffectedPendingEditsRejectSplitWithoutSavingOrDiscardingEditorText() throws {
		let work = try definition("Work"), source = try activity(work, to: end), sourceID = id(source)
		let snapshot = try ActivitySplitService.snapshot(activityID: sourceID), before = try stored()
		source.note = "Unsaved editor text"
		XCTAssertThrowsError(try ActivitySplitService.split(snapshot, at: boundary, secondDefinitionID: id(work), recordedAt: now))
		XCTAssertEqual(source.note, "Unsaved editor text"); XCTAssertTrue(container.viewContext.hasChanges)
		XCTAssertEqual(try stored(), before)
		container.viewContext.rollback()
		_ = try ActivitySplitService.split(snapshot, at: boundary, secondDefinitionID: id(work), recordedAt: now)
		XCTAssertEqual(try stored().count, 2)
	}

	func testSuccessfulSplitDoesNotSaveOrDiscardUnrelatedPendingWork() throws {
		let work = try definition("Work"), source = try activity(work, to: end)
		let other = try activity(definition("Music"), note: "Saved music"), otherID = id(other)
		let snapshot = try ActivitySplitService.snapshot(activityID: id(source))
		other.note = "Pending music"
		let pending = Tag(entity: try entity(Tag.entityName), insertInto: container.viewContext); pending.name = "Pending tag"
		_ = try ActivitySplitService.split(snapshot, at: boundary, secondDefinitionID: id(work), recordedAt: now)
		XCTAssertEqual(try stored().count, 3); XCTAssertEqual(try state(otherID).note, "Saved music")
		XCTAssertEqual(other.note, "Pending music"); XCTAssertTrue(pending.isInserted)
		XCTAssertTrue(container.viewContext.hasChanges)
		let reader = independentContext(); defer { reader.reset() }
		XCTAssertEqual(try reader.count(for: Tag.fetchRequest()), 0)
	}

	func testUnrelatedPendingRecordCanShareTheOriginalDefinitionAndTagWithoutBeingSaved() throws {
		let work = try definition("Work"), source = try activity(work, to: end)
		let shared = try tag("Shared", on: source)
		let snapshot = try ActivitySplitService.snapshot(activityID: id(source))
		let pending = Activity(entity: try entity(Activity.entityName), insertInto: container.viewContext)
		pending.definition = work; pending.start = now.addingTimeInterval(-10); pending.note = "Pending instance"
		pending.addToTags(shared)
		_ = try ActivitySplitService.split(snapshot, at: boundary, secondDefinitionID: id(work), recordedAt: now)
		XCTAssertEqual(try stored().count, 2)
		XCTAssertTrue(pending.isInserted); XCTAssertEqual(pending.note, "Pending instance")
		XCTAssertTrue(container.viewContext.hasChanges)
		XCTAssertFalse(try stored().contains { $0.note == "Pending instance" })
	}

	func testPendingDefinitionOrTagEditsRejectSplitAndPreserveThoseDrafts() throws {
		let work = try definition("Work"), lunch = try definition("Lunch")
		let source = try activity(work, to: end), originalTag = try tag("Original", on: source)
		let snapshot = try ActivitySplitService.snapshot(activityID: id(source)), before = try stored()
		for object in [work as NSManagedObject, lunch as NSManagedObject, originalTag as NSManagedObject] {
			object.setValue("Pending rename", forKey: "name")
			XCTAssertThrowsError(try ActivitySplitService.split(snapshot, at: boundary, secondDefinitionID: id(lunch), recordedAt: now))
			XCTAssertEqual(object.value(forKey: "name") as? String, "Pending rename")
			XCTAssertTrue(container.viewContext.hasChanges); XCTAssertEqual(try stored(), before)
			container.viewContext.rollback()
		}
	}

	func testSavedDefinitionAndTagRenamesRemainIntactAndDoNotInvalidateTheSnapshot() throws {
		let work = try definition("Old activity"), source = try activity(work, to: end)
		let originalTag = try tag("Old tag", on: source), tagID = id(originalTag), workID = id(work)
		let snapshot = try ActivitySplitService.snapshot(activityID: id(source))
		let writer = independentContext(); defer { writer.reset() }
		try object(workID, type: ActivityDefinition.self, in: writer).name = "New activity"
		try object(tagID, type: Tag.self, in: writer).name = "New tag"
		try writer.save()
		_ = try ActivitySplitService.split(snapshot, at: boundary, secondDefinitionID: workID, recordedAt: now)
		XCTAssertEqual(try stored().count, 2)
		XCTAssertTrue(try stored().allSatisfy { $0.tagIDs == [tagID] && $0.definitionID == workID })
		let reader = independentContext(); defer { reader.reset() }
		XCTAssertEqual(try object(workID, type: ActivityDefinition.self, in: reader).name, "New activity")
		XCTAssertEqual(try object(tagID, type: Tag.self, in: reader).name, "New tag")
	}

	func testSaveFailureRollsBackBothPartsAndALaterRootSaveCannotResurrectThem() throws {
		let work = try definition("Work"), source = try activity(work, to: end)
		let snapshot = try ActivitySplitService.snapshot(activityID: id(source)), before = try stored()
		let pending = Tag(entity: try entity(Tag.entityName), insertInto: container.viewContext); pending.name = "Pending"
		let writer = SplitFailingContext(concurrencyType: .mainQueueConcurrencyType)
		XCTAssertThrowsError(try ActivitySplitService.split(snapshot, at: boundary, secondDefinitionID: id(work),
			recordedAt: now, contextFactory: { writer })) { error in
			XCTAssertEqual((error as NSError).domain, "ActivitySplitWriteFailure")
		}
		XCTAssertEqual(writer.saveAttempts, 1); XCTAssertFalse(writer.hasChanges)
		XCTAssertEqual(try stored(), before); XCTAssertTrue(pending.isInserted)
		try container.viewContext.save()
		XCTAssertEqual(try stored(), before)
		_ = try ActivitySplitService.split(snapshot, at: boundary, secondDefinitionID: id(work), recordedAt: now)
		XCTAssertEqual(try stored().count, 2)
	}
}
