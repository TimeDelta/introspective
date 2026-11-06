import XCTest
import CoreData
import UIKit
import CSV
import Common
import DependencyInjection
import BooleanAlgebra
import AttributeRestrictions
import Attributes
import DataExport
import SampleGroupInformation
@testable import Persistence
@testable import Queries
@testable import Samples
import Settings

private final class StressStoreTestProvider: InjectionProvider {
	let types: [Any.Type] = [Database.self, Settings.self]
	let database: Database
	let settings: Settings
	init(_ database: Database, _ settings: Settings) { self.database = database; self.settings = settings }
	func get<T>(_ type: T.Type) throws -> T {
		if type == Database.self { return database as! T }
		if type == Settings.self { return settings as! T }
		throw NSError(domain: "StressStoreTestProvider", code: 1)
	}
}

private final class StressFailingWriteContext: NSManagedObjectContext {
	private(set) var saveAttempts = 0
	override func save() throws {
		saveAttempts += 1
		throw NSError(domain: "StressWriteFailure", code: 1)
	}
}

final class StressTrackingIntegrationTests: XCTestCase {
	private static let bundle = Bundle(for: StressTrackingIntegrationTests.self)
	private static let model = NSManagedObjectModel.mergedModel(from: [bundle])!
	private var container: NSPersistentContainer!
	private var directory: URL!
	private var defaults: UserDefaults!
	private var defaultsSuite: String!
	private let timestamp = Date(timeIntervalSince1970: 1_700_000_023.5)

	override func setUpWithError() throws {
		_ = CommonInjectionProvider()
		directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
		container = try open(Self.model, at: directory.appendingPathComponent("stress.sqlite"))
		defaultsSuite = UUID().uuidString; defaults = UserDefaults(suiteName: defaultsSuite)!
		try register()
	}
	override func tearDownWithError() throws {
		if let container = container { try close(container) }
		container = nil
		if let defaults = defaults, let defaultsSuite = defaultsSuite {
			defaults.removePersistentDomain(forName: defaultsSuite)
		}
		defaults = nil
		if let directory = directory { try FileManager.default.removeItem(at: directory) }
	}

	private func open(_ model: NSManagedObjectModel, at url: URL) throws -> NSPersistentContainer {
		let value = NSPersistentContainer(name: "StressTrackingTests", managedObjectModel: model)
		let description = NSPersistentStoreDescription(url: url)
		description.shouldAddStoreAsynchronously = false
		description.shouldMigrateStoreAutomatically = true
		description.shouldInferMappingModelAutomatically = true
		value.persistentStoreDescriptions = [description]
		var failure: Error?
		value.loadPersistentStores { _, error in failure = error }
		if let failure = failure { throw failure }
		value.viewContext.automaticallyMergesChangesFromParent = true
		return value
	}
	private func close(_ value: NSPersistentContainer) throws {
		value.viewContext.reset()
		for store in value.persistentStoreCoordinator.persistentStores { try value.persistentStoreCoordinator.remove(store) }
	}
	private func register() throws {
		let settings: SettingsImpl
		if let existing = try container.viewContext.fetch(SettingsImpl.fetchRequest()).first { settings = existing }
		else {
			let entity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: SettingsImpl.entityName, in: container.viewContext))
			settings = SettingsImpl(entity: entity, insertInto: container.viewContext)
			try container.viewContext.save()
		}
		DependencyInjector.register([CommonInjectionProvider(), BooleanAlgebraInjectionProvider(),
			SamplesInjectionProvider(), QueriesInjectionProvider(), AttributeRestrictionsInjectionProvider(),
			StressStoreTestProvider(DatabaseImpl(container), settings)])
	}
	private func reopen() throws {
		let url = try XCTUnwrap(container.persistentStoreDescriptions.first?.url)
		try close(container)
		container = try open(Self.model, at: url)
		try register()
	}
	private func storedCount(_ entity: String) throws -> Int {
		let reader = try open(Self.model, at: directory.appendingPathComponent("stress.sqlite"))
		defer { try? close(reader) }
		return try reader.viewContext.count(for: NSFetchRequest<NSFetchRequestResult>(entityName: entity))
	}
	private func storedTagNames() throws -> [String] {
		let reader = try open(Self.model, at: directory.appendingPathComponent("stress.sqlite"))
		defer { try? close(reader) }
		return try reader.viewContext.fetch(Tag.fetchRequest()).map { $0.name }.sorted()
	}
	private func tag(_ name: String) throws -> Tag {
		let entity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: Tag.entityName, in: container.viewContext))
		let value = Tag(entity: entity, insertInto: container.viewContext); value.name = name
		return value
	}
	private func response(_ definition: StressorDefinition, order: Int = 0,
		status: StressResponseStatus = .rated, rating: Int? = 0) -> StressResponseDraft {
		StressResponseDraft(stressorID: definition.id, nameSnapshot: definition.name, order: order,
			status: status, rating: rating)
	}
	private func checkIns() throws -> [StressCheckIn] { try container.viewContext.fetch(StressCheckIn.fetchRequest()) }
	private func responses() throws -> [StressorResponse] { try container.viewContext.fetch(StressorResponse.fetchRequest()) }

	func testZeroRatingSkippedAndNotApplicableRemainDistinctAfterSQLiteReopen() throws {
		let work = try StressTrackingStore.createStressor(name: "Work")
		let travel = try StressTrackingStore.createStressor(name: "Travel")
		let money = try StressTrackingStore.createStressor(name: "Finances")
		let draft = StressCheckInDraft(date: timestamp, overallRating: 0, note: "A quiet check-in",
			responses: [response(work), response(travel, order: 1, status: .notApplicable, rating: nil),
				response(money, order: 2, status: .skipped, rating: nil)])
		let saved = try StressTrackingStore.save(draft: draft)
		let identity = saved.id
		XCTAssertFalse(saved.objectID.isTemporaryID)
		try reopen()
		let restored = try XCTUnwrap(checkIns().first)
		XCTAssertEqual(restored.id, identity); XCTAssertEqual(restored.timestamp, timestamp)
		XCTAssertEqual(restored.overallRating, 0); XCTAssertEqual(restored.note, draft.note)
		XCTAssertEqual(restored.measurementKind, "momentary"); XCTAssertEqual(restored.scaleVersion, 1)
		XCTAssertEqual(restored.draft, draft)
		XCTAssertEqual(restored.orderedResponses.map { $0.status }, [.rated, .notApplicable, .skipped])
		XCTAssertEqual(restored.orderedResponses.map { $0.rating }, [0, nil, nil])
		XCTAssertTrue(restored.orderedResponses.allSatisfy { $0.timestamp == timestamp && $0.checkIn.id == identity })
	}

	func testOverallOnlyCheckInNeedsNoPersonalDefinitionsOrResponses() throws {
		let saved = try StressTrackingStore.save(draft: StressCheckInDraft(date: timestamp, overallRating: 4))
		let identity = saved.id
		try reopen()
		let restored = try XCTUnwrap(checkIns().first)
		XCTAssertEqual(restored.id, identity); XCTAssertEqual(restored.overallRating, 4)
		XCTAssertTrue(restored.responses.isEmpty)
		XCTAssertEqual(try StressTrackingStore.definitions(includeArchived: true).count, 0)
		XCTAssertEqual(try responses().count, 0)
	}

	func testEightStressorsCanBeOfferedAndSavedWithoutAnArtificialThreeItemLimit() throws {
		let definitions = try (0..<8).map { try StressTrackingStore.createStressor(name: "Stressor \($0)") }
		let offered = definitions.enumerated().map {
			response($0.element, order: $0.offset, status: .skipped, rating: nil)
		}
		let saved = try StressTrackingStore.save(draft: StressCheckInDraft(date: timestamp, overallRating: 2, responses: offered))
		XCTAssertEqual(saved.orderedResponses.count, 8)
		XCTAssertEqual(saved.orderedResponses.map { $0.stressorID }, definitions.map { $0.id })
		XCTAssertTrue(saved.orderedResponses.allSatisfy { $0.rating == nil && $0.status == .skipped })
		XCTAssertEqual(try storedCount(StressorResponse.entityName), 8)
	}

	func testRenameArchiveAndRestoreKeepHistoricalIdentityAndNameSnapshots() throws {
		let definition = try StressTrackingStore.createStressor(name: "Original work")
		let identity = definition.id
		let saved = try StressTrackingStore.save(draft: StressCheckInDraft(date: timestamp, overallRating: 3,
			responses: [response(definition, rating: 4)]))
		let checkInID = saved.id
		try StressTrackingStore.renameStressor(id: identity, to: "Work and study")
		try StressTrackingStore.setArchived(id: identity, archived: true)
		XCTAssertTrue(try StressTrackingStore.definitions().isEmpty)
		let archived = try XCTUnwrap(StressTrackingStore.definitions(includeArchived: true).first)
		XCTAssertEqual(archived.id, identity); XCTAssertEqual(archived.name, "Work and study"); XCTAssertTrue(archived.archived)
		try reopen()
		let historical = try XCTUnwrap(checkIns().first)
		XCTAssertEqual(historical.id, checkInID)
		XCTAssertEqual(historical.orderedResponses.first?.stressorID, identity)
		XCTAssertEqual(historical.orderedResponses.first?.nameSnapshot, "Original work")
		try StressTrackingStore.setArchived(id: identity, archived: false)
		let restored = try XCTUnwrap(StressTrackingStore.definitions().first)
		XCTAssertEqual(restored.id, identity); XCTAssertEqual(restored.name, "Work and study")
		XCTAssertFalse(restored.archived)
	}

	func testReorderingDefinitionsPersistsWithoutChangingSavedResponseOrder() throws {
		let definitions = try ["Work", "Health", "Caregiving"].map { try StressTrackingStore.createStressor(name: $0) }
		let saved = try StressTrackingStore.save(draft: StressCheckInDraft(date: timestamp, overallRating: 2,
			responses: definitions.enumerated().map { response($0.element, order: $0.offset, rating: 1) }))
		let originalIDs = saved.orderedResponses.map { $0.stressorID }
		let reordered = [definitions[2].id, definitions[0].id, definitions[1].id]
		try StressTrackingStore.reorderStressors(ids: reordered)
		try reopen()
		XCTAssertEqual(try StressTrackingStore.definitions().map { $0.id }, reordered)
		XCTAssertEqual(try XCTUnwrap(checkIns().first).orderedResponses.map { $0.stressorID }, originalIDs)
	}

	func testInvalidDefinitionNamesAndMalformedCheckInsCannotPersistPartialRecords() throws {
		for name in ["", " \n ", String(repeating: "a", count: 121)] {
			XCTAssertThrowsError(try StressTrackingStore.createStressor(name: name))
		}
		XCTAssertTrue(try StressTrackingStore.definitions(includeArchived: true).isEmpty)
		let definition = try StressTrackingStore.createStressor(name: "Work")
		let invalid = [
			StressCheckInDraft(date: timestamp, overallRating: nil),
			StressCheckInDraft(date: timestamp, overallRating: 5),
			StressCheckInDraft(date: Date(timeIntervalSinceReferenceDate: .nan), overallRating: 2),
			StressCheckInDraft(date: timestamp, overallRating: 2, responses: [response(definition, status: .skipped, rating: 0)]),
			StressCheckInDraft(date: timestamp, overallRating: 2, responses: [response(definition), response(definition)]),
			StressCheckInDraft(date: timestamp, overallRating: 2, measurementKind: "daily"),
		]
		for draft in invalid { XCTAssertThrowsError(try StressTrackingStore.save(draft: draft)) }
		XCTAssertEqual(try storedCount(StressCheckIn.entityName), 0)
		XCTAssertEqual(try storedCount(StressorResponse.entityName), 0)
	}

	func testFailedWriterRollsBackTheWholeCheckInAndDoesNotSaveUnrelatedEdits() throws {
		let definition = try StressTrackingStore.createStressor(name: "Work")
		let unrelated = try tag("Saved tag"); try container.viewContext.save()
		unrelated.name = "Pending tag edit"
		let writer = StressFailingWriteContext(concurrencyType: .mainQueueConcurrencyType)
		let draft = StressCheckInDraft(date: timestamp, overallRating: 3, responses: [response(definition, rating: 4)])
		XCTAssertThrowsError(try StressTrackingStore.save(draft: draft, editing: nil, contextFactory: { writer })) {
			XCTAssertEqual(($0 as NSError).domain, "StressWriteFailure")
		}
		XCTAssertEqual(writer.saveAttempts, 1); XCTAssertFalse(writer.hasChanges)
		XCTAssertTrue(unrelated.isUpdated)
		XCTAssertEqual(try storedTagNames(), ["Saved tag"])
		XCTAssertEqual(try storedCount(StressCheckIn.entityName), 0)
		XCTAssertEqual(try storedCount(StressorResponse.entityName), 0)
		try container.viewContext.save()
		XCTAssertEqual(try storedTagNames(), ["Pending tag edit"])
		XCTAssertEqual(try storedCount(StressCheckIn.entityName), 0, "An unrelated later save must not resurrect a failed check-in")
		XCTAssertEqual(try storedCount(StressorResponse.entityName), 0)
	}

	func testSuccessfulWriterCommitsOnlyTheCheckInAndItsResponses() throws {
		let definition = try StressTrackingStore.createStressor(name: "Work")
		let unrelated = try tag("Not yet saved")
		let draft = StressCheckInDraft(date: timestamp, overallRating: 2, responses: [response(definition, rating: 1)])
		let saved = try StressTrackingStore.save(draft: draft)
		XCTAssertTrue(saved.managedObjectContext === container.viewContext)
		XCTAssertFalse(saved.objectID.isTemporaryID)
		XCTAssertTrue(unrelated.isInserted); XCTAssertTrue(container.viewContext.hasChanges)
		XCTAssertEqual(try storedTagNames(), [])
		XCTAssertEqual(try storedCount(StressCheckIn.entityName), 1)
		XCTAssertEqual(try storedCount(StressorResponse.entityName), 1)
		try container.viewContext.save()
		XCTAssertEqual(try storedTagNames(), ["Not yet saved"])
		XCTAssertEqual(try storedCount(StressCheckIn.entityName), 1)
	}

	func testEditingKeepsCheckInIDAndUpdatesEveryResponseTimestampAtomically() throws {
		let definition = try StressTrackingStore.createStressor(name: "Work")
		let saved = try StressTrackingStore.save(draft: StressCheckInDraft(date: timestamp, overallRating: 1,
			responses: [response(definition, rating: 0)]))
		let identity = saved.id
		let revisedTime = timestamp.addingTimeInterval(123.125)
		var revised = saved.draft
		revised.date = revisedTime; revised.overallRating = 4; revised.note = "After an adjustment"
		revised.responses[0].status = .notApplicable; revised.responses[0].rating = nil
		let updated = try StressTrackingStore.save(draft: revised, editing: saved)
		XCTAssertEqual(updated.id, identity)
		try reopen()
		let restored = try XCTUnwrap(checkIns().first)
		XCTAssertEqual(try checkIns().count, 1); XCTAssertEqual(try responses().count, 1)
		XCTAssertEqual(restored.id, identity); XCTAssertEqual(restored.draft, revised)
		XCTAssertEqual(restored.orderedResponses.first?.timestamp, revisedTime)
		XCTAssertEqual(restored.orderedResponses.first?.checkIn.id, identity)
	}

	func testFailedEditPreservesTheOriginalParentAndAllAnswers() throws {
		let definition = try StressTrackingStore.createStressor(name: "Work")
		let original = StressCheckInDraft(date: timestamp, overallRating: 1, note: "Original",
			responses: [response(definition, rating: 0)])
		let saved = try StressTrackingStore.save(draft: original)
		var revised = original; revised.overallRating = 4; revised.responses = []
		let writer = StressFailingWriteContext(concurrencyType: .mainQueueConcurrencyType)
		XCTAssertThrowsError(try StressTrackingStore.save(draft: revised, editing: saved, contextFactory: { writer }))
		XCTAssertFalse(writer.hasChanges)
		try reopen()
		XCTAssertEqual(try XCTUnwrap(checkIns().first).draft, original)
		XCTAssertEqual(try responses().count, 1)
	}

	func testDeletingCheckInCascadesResponsesAndKeepsReusableDefinitions() throws {
		let definition = try StressTrackingStore.createStressor(name: "Work")
		let definitionID = definition.id
		let saved = try StressTrackingStore.save(draft: StressCheckInDraft(date: timestamp, overallRating: 2,
			responses: [response(definition, rating: 1)]))
		try StressTrackingStore.delete(saved)
		try reopen()
		XCTAssertTrue(try checkIns().isEmpty); XCTAssertTrue(try responses().isEmpty)
		XCTAssertEqual(try StressTrackingStore.definitions().map { $0.id }, [definitionID])
	}

	func testDeletingCheckInRejectsPendingAnswerButDoesNotSaveUnrelatedEdits() throws {
		let unrelated = try tag("Saved tag"); try container.viewContext.save()
		unrelated.name = "Pending tag edit"
		let definition = try StressTrackingStore.createStressor(name: "Work")
		let saved = try StressTrackingStore.save(draft: StressCheckInDraft(date: timestamp, overallRating: 2,
			responses: [response(definition, rating: 1)]))
		let answer = try XCTUnwrap(saved.orderedResponses.first)
		answer.ratingValue = NSNumber(value: 3)
		XCTAssertFalse(saved.hasChanges, "The conflict is in an answer rather than its parent")

		XCTAssertThrowsError(try StressTrackingStore.delete(saved)) { error in
			XCTAssertNotNil(error as? StressTrackingError)
		}

		XCTAssertEqual(answer.rating, 3); XCTAssertTrue(answer.hasChanges)
		XCTAssertFalse(saved.isDeleted)
		XCTAssertEqual(try storedCount(StressCheckIn.entityName), 1)
		XCTAssertEqual(try storedCount(StressorResponse.entityName), 1)
		XCTAssertEqual(try storedTagNames(), ["Saved tag"])
		XCTAssertEqual(unrelated.name, "Pending tag edit"); XCTAssertTrue(unrelated.hasChanges)

		// Cancelling only the answer's edit permits the deliberate cascade delete;
		// unrelated pending work still must not be committed by that operation.
		container.viewContext.refresh(answer, mergeChanges: false)
		try StressTrackingStore.delete(saved)
		XCTAssertEqual(try storedCount(StressCheckIn.entityName), 0)
		XCTAssertEqual(try storedCount(StressorResponse.entityName), 0)
		XCTAssertEqual(try storedTagNames(), ["Saved tag"])
		XCTAssertEqual(unrelated.name, "Pending tag edit"); XCTAssertTrue(unrelated.hasChanges)
		try container.viewContext.save()
		XCTAssertEqual(try storedTagNames(), ["Pending tag edit"])
		XCTAssertEqual(try storedCount(StressCheckIn.entityName), 0)
	}

	func testBulkDeletionIsAtomicAndDoesNotCommitUnrelatedPendingEdits() throws {
		let unrelated = try tag("Saved tag"); try container.viewContext.save()
		unrelated.name = "Pending tag edit"
		let definition = try StressTrackingStore.createStressor(name: "Work")
		let first = try StressTrackingStore.save(draft: StressCheckInDraft(date: timestamp, overallRating: 1,
			responses: [response(definition, rating: 1)]))
		let second = try StressTrackingStore.save(draft: StressCheckInDraft(date: timestamp.addingTimeInterval(60), overallRating: 2,
			responses: [response(definition, rating: 2)]))
		let unselected = try StressTrackingStore.save(draft: StressCheckInDraft(date: timestamp.addingTimeInterval(120), overallRating: 0,
			note: "Outside the displayed selection"))
		let unselectedID = unselected.id
		let pendingAnswer = try XCTUnwrap(second.orderedResponses.first)
		pendingAnswer.ratingValue = NSNumber(value: 4)

		XCTAssertThrowsError(try StressTrackingStore.delete([first, second]))

		XCTAssertFalse(first.isDeleted); XCTAssertFalse(second.isDeleted)
		XCTAssertEqual(pendingAnswer.rating, 4); XCTAssertTrue(pendingAnswer.hasChanges)
		XCTAssertEqual(try storedCount(StressCheckIn.entityName), 3)
		XCTAssertEqual(try storedCount(StressorResponse.entityName), 2)
		XCTAssertEqual(try storedTagNames(), ["Saved tag"])
		XCTAssertEqual(unrelated.name, "Pending tag edit"); XCTAssertTrue(unrelated.hasChanges)

		container.viewContext.refresh(pendingAnswer, mergeChanges: false)
		// Duplicate selection must not turn a valid bulk operation into a second
		// deletion of the same managed record.
		try StressTrackingStore.delete([first, second, first])
		XCTAssertEqual(try checkIns().map { $0.id }, [unselectedID])
		XCTAssertEqual(try storedCount(StressCheckIn.entityName), 1)
		XCTAssertEqual(try storedCount(StressorResponse.entityName), 0)
		XCTAssertEqual(try StressTrackingStore.definitions().count, 1)
		XCTAssertEqual(try storedTagNames(), ["Saved tag"])
		XCTAssertEqual(unrelated.name, "Pending tag edit"); XCTAssertTrue(unrelated.hasChanges)
		try container.viewContext.save()
		XCTAssertEqual(try storedTagNames(), ["Pending tag edit"])
		XCTAssertEqual(try storedCount(StressCheckIn.entityName), 1)
		XCTAssertEqual(try storedCount(StressorResponse.entityName), 0)
	}

	func testReleasingReviewSnapshotsReleasesResponseGraphWithoutChangingStoredValues() throws {
		let definition = try StressTrackingStore.createStressor(name: "Work")
		weak var releasedAnswer: StressorResponse?
		let (saved, snapshot, answerID) = try autoreleasepool {
			let saved = try StressTrackingStore.save(draft: StressCheckInDraft(date: timestamp, overallRating: 2,
				responses: [response(definition, rating: 1)]))
			let snapshot = saved.draft, answers = Array(saved.responses)
			let answer = try XCTUnwrap(answers.first)
			releasedAnswer = answer
			XCTAssertFalse(saved.isFault); XCTAssertTrue(answers.allSatisfy { !$0.isFault })
			// A context retains objects involved in pending change notifications until
			// processing them, independently of any parent/response reference cycle.
			container.viewContext.processPendingChanges()
			return (saved, snapshot, answer.objectID)
		}
		autoreleasepool {
			XCTAssertNotNil(releasedAnswer, "The realized parent initially owns its response graph")
			StressTrackingStore.releaseSnapshots(of: [saved])
			container.viewContext.processPendingChanges()
			XCTAssertTrue(saved.isFault)
		}
		// A response's instantaneous isFault state does not prove graph release.
		// Keeping a faulted parent alive must not retain its responses once the
		// caller drops those values, or leave their realized payloads registered.
		XCTAssertNil(releasedAnswer, "A released review must not retain a parent/response cycle")
		XCTAssertTrue(container.viewContext.registeredObject(for: answerID)?.isFault ?? true,
			"Releasing a review must leave no realized response payload registered")
		XCTAssertEqual(saved.draft, snapshot, "Releasing review memory must not lose any persisted answers")
	}

	func testReleasingReviewSnapshotsPreservesPendingParentAndResponseEdits() throws {
		let definition = try StressTrackingStore.createStressor(name: "Work")
		let saved = try StressTrackingStore.save(draft: StressCheckInDraft(date: timestamp, overallRating: 2,
			responses: [response(definition, rating: 1)]))
		let answer = try XCTUnwrap(saved.orderedResponses.first)
		answer.ratingValue = NSNumber(value: 3)
		StressTrackingStore.releaseSnapshots(of: [saved])
		XCTAssertFalse(answer.isFault); XCTAssertEqual(answer.rating, 3)
		XCTAssertTrue(answer.hasChanges)
		saved.note = "Uncommitted note"
		StressTrackingStore.releaseSnapshots(of: [saved])
		XCTAssertFalse(saved.isFault); XCTAssertEqual(saved.note, "Uncommitted note")
		XCTAssertTrue(saved.hasChanges)
		let reader = try open(Self.model, at: directory.appendingPathComponent("stress.sqlite"))
		defer { try? close(reader) }
		let stored = try XCTUnwrap(reader.viewContext.fetch(StressCheckIn.fetchRequest()).first)
		XCTAssertNil(stored.note); XCTAssertEqual(stored.orderedResponses.first?.rating, 1)
	}

	func testNewStressSampleIDsAppendAfterExistingTypesAndSavedNumericQueriesExcludeMissingAnswers() throws {
		let factory = injected(SampleFactory.self)
		XCTAssertEqual(factory.sampleTypeId(for: MoodImpl.self), 8)
		XCTAssertEqual(factory.sampleTypeId(for: LostItemEvent.self), 17)
		XCTAssertEqual(factory.sampleTypeId(for: MetricContextEntry.self), 18)
		XCTAssertEqual(factory.sampleTypeId(for: StressCheckIn.self), 19)
		XCTAssertEqual(factory.sampleTypeId(for: StressorResponse.self), 20)
		XCTAssertTrue(try factory.sampleType(for: 19) == StressCheckIn.self)
		XCTAssertTrue(try factory.sampleType(for: 20) == StressorResponse.self)
		let definitions = try ["Zero", "N/A", "Skipped"].map { try StressTrackingStore.createStressor(name: $0) }
		_ = try StressTrackingStore.save(draft: StressCheckInDraft(date: timestamp, overallRating: 0,
			responses: [response(definitions[0]), response(definitions[1], order: 1, status: .notApplicable, rating: nil),
				response(definitions[2], order: 2, status: .skipped, rating: nil)]))
		let rating = try XCTUnwrap(StressorResponse.attributes.first { $0.variableName == "ratingValue" })
		let query = try injected(QueryFactory.self).queryFor(StressorResponse.self)
		query.expression = EqualToIntegerAttributeRestriction(restrictedAttribute: rating, value: 0)
		let dao = StoredQueriesDAOImpl()
		try dao.save(query, name: "Explicit no stress")
		try reopen()
		let restored = try XCTUnwrap(dao.getQueryWith(name: "Explicit no stress")).convert()
		let result = try run(restored)
		XCTAssertEqual(result.count, 1)
		let answer = try XCTUnwrap(result.first as? StressorResponse)
		XCTAssertEqual(answer.status, .rated); XCTAssertEqual(answer.rating, 0)
		XCTAssertEqual(answer.nameSnapshot, "Zero")
	}

	func testSavedStatusAndNameQueriesKeepNotApplicableSeparateFromSkipped() throws {
		let definition = try StressTrackingStore.createStressor(name: "Caregiving")
		_ = try StressTrackingStore.save(draft: StressCheckInDraft(date: timestamp, overallRating: 2,
			responses: [response(definition, status: .notApplicable, rating: nil)]))
		_ = try StressTrackingStore.save(draft: StressCheckInDraft(date: timestamp.addingTimeInterval(60), overallRating: 2,
			responses: [response(definition, status: .skipped, rating: nil)]))
		let status = try XCTUnwrap(StressorResponse.attributes.first { $0.variableName == "statusKey" } as? SelectOneAttribute)
		let query = try injected(QueryFactory.self).queryFor(StressorResponse.self)
		query.expression = EqualToSelectOneAttributeRestriction(restrictedAttribute: status,
			value: StressResponseStatus.notApplicable.rawValue, valueAttribute: status)
		let dao = StoredQueriesDAOImpl(); try dao.save(query, name: "Not relevant")
		try reopen()
		let restored = try XCTUnwrap(dao.getQueryWith(name: "Not relevant")).convert()
		let selected = try run(restored).compactMap { $0 as? StressorResponse }
		XCTAssertEqual(selected.count, 1); XCTAssertEqual(selected.first?.status, .notApplicable)
		XCTAssertNil(selected.first?.rating)
		XCTAssertTrue(try XCTUnwrap(selected.first).matchesSearchString("CAREGIVING"))
	}

	func testSavedStableStressorIDQueryFindsItsOldAndRenamedSnapshots() throws {
		let definition = try StressTrackingStore.createStressor(name: "Original work")
		let identity = definition.id
		_ = try StressTrackingStore.save(draft: StressCheckInDraft(date: timestamp, overallRating: 2,
			responses: [response(definition, rating: 1)]))
		try StressTrackingStore.renameStressor(id: identity, to: "Renamed work")
		let renamed = try XCTUnwrap(StressTrackingStore.definitions().first)
		_ = try StressTrackingStore.save(draft: StressCheckInDraft(date: timestamp.addingTimeInterval(60), overallRating: 2,
			responses: [response(renamed, rating: 3)]))
		let unrelated = try StressTrackingStore.createStressor(name: "Caregiving")
		_ = try StressTrackingStore.save(draft: StressCheckInDraft(date: timestamp.addingTimeInterval(120), overallRating: 2,
			responses: [response(unrelated, rating: 1)]))
		let identifier = try XCTUnwrap(StressorResponse.attributes.first { $0.variableName == "stressorKey" })
		let query = try injected(QueryFactory.self).queryFor(StressorResponse.self)
		query.expression = ContainsStringAttributeRestriction(restrictedAttribute: identifier, substring: identity.uuidString)
		let dao = StoredQueriesDAOImpl(); try dao.save(query, name: "Work across renames")
		try reopen()
		let restored = try XCTUnwrap(dao.getQueryWith(name: "Work across renames")).convert()
		let selected = try run(restored).compactMap { $0 as? StressorResponse }
		XCTAssertEqual(selected.count, 2)
		XCTAssertEqual(Set(selected.map { $0.stressorID }), Set([identity]))
		XCTAssertEqual(Set(selected.map { $0.nameSnapshot }), Set(["Original work", "Renamed work"]))
	}

	func testOverallStressQueryCanBeSavedReopenedAndFilteredByItsActualNumericRating() throws {
		_ = try StressTrackingStore.save(draft: StressCheckInDraft(date: timestamp, overallRating: 0))
		_ = try StressTrackingStore.save(draft: StressCheckInDraft(date: timestamp.addingTimeInterval(60), overallRating: 4))
		let factory = injected(QueryFactory.self)
		let query = try factory.queryFor(StressCheckIn.self)
		XCTAssertTrue(try factory.sampleTypeFor(query) == StressCheckIn.self)
		let rating = try XCTUnwrap(StressCheckIn.attributes.first { $0.variableName == "overallRating" })
		query.expression = EqualToIntegerAttributeRestriction(restrictedAttribute: rating, value: 4)
		let dao = StoredQueriesDAOImpl(); try dao.save(query, name: "Overwhelming check-ins")
		try reopen()
		let restored = try XCTUnwrap(dao.getQueryWith(name: "Overwhelming check-ins")).convert()
		let selected = try run(restored).compactMap { $0 as? StressCheckIn }
		XCTAssertEqual(selected.count, 1); XCTAssertEqual(selected.first?.overallRating, 4)
		XCTAssertEqual(selected.first?.timestamp, timestamp.addingTimeInterval(60))
	}

	func testOverallFileExportRetainsIdentityQuestionVersionAndQuotedMultilineNotes() throws {
		let note = "Work, \"adjusted\"\nFollow up 🧠"
		let saved = try StressTrackingStore.save(draft: StressCheckInDraft(date: timestamp, overallRating: 0, note: note))
		let identity = saved.id
		let url = directory.appendingPathComponent("stress-check-ins.csv")
		let exporter = StressCheckInExporter(coordinator: container.persistentStoreCoordinator, url: url)
		try exporter.exportData()
		let rows = try exportRows(at: url)
		XCTAssertEqual(rows, [
			["Check-in ID", "Timestamp", "Overall Stress", "Measurement Kind", "Scale Version", "Note", "Timestamp Reference Seconds"],
			[identity.uuidString, "2023-11-14T22:13:43.500Z", "0", "momentary", "1", note, String(timestamp.timeIntervalSinceReferenceDate)],
		])
		XCTAssertEqual(exporter.percentComplete(), 1)
		XCTAssertNil(exporter.context)
	}

	func testResponseFileExportKeepsOriginalNamesAndEmptyMissingRatingsDistinctFromZero() throws {
		let definition = try StressTrackingStore.createStressor(name: "Work, \"projects\"\nteam")
		let notApplicable = try StressTrackingStore.createStressor(name: "Travel")
		let skipped = try StressTrackingStore.createStressor(name: "Money")
		let note = "A note, \"quoted\"\nsecond line"
		let saved = try StressTrackingStore.save(draft: StressCheckInDraft(date: timestamp, overallRating: 3, note: note,
			responses: [response(definition), response(notApplicable, order: 1, status: .notApplicable, rating: nil),
				response(skipped, order: 2, status: .skipped, rating: nil)]))
		let checkInID = saved.id
		let originalID = definition.id
		try StressTrackingStore.renameStressor(id: originalID, to: "Future name")
		try reopen()
		let url = directory.appendingPathComponent("stressor-responses.csv")
		let exporter = StressorResponseExporter(coordinator: container.persistentStoreCoordinator, url: url)
		try exporter.exportData()
		let rows = try exportRows(at: url)
		XCTAssertEqual(rows.first, ["Check-in ID", "Timestamp", "Stressor ID", "Stressor", "Status", "Rating", "Measurement Kind", "Scale Version", "Note", "Timestamp Reference Seconds"])
		XCTAssertEqual(rows.count, 4)
		let byStatus = Dictionary(uniqueKeysWithValues: rows.dropFirst().map { ($0[4], $0) })
		XCTAssertEqual(byStatus["rated"], [checkInID.uuidString, "2023-11-14T22:13:43.500Z", originalID.uuidString,
			"Work, \"projects\"\nteam", "rated", "0", "momentary", "1", note, String(timestamp.timeIntervalSinceReferenceDate)])
		XCTAssertEqual(byStatus["notApplicable"]?[5], "")
		XCTAssertEqual(byStatus["skipped"]?[5], "")
		XCTAssertEqual(Set(rows.dropFirst().map { $0[0] }), Set([checkInID.uuidString]))
		XCTAssertTrue(rows.dropFirst().allSatisfy { $0[6] == "momentary" && $0[7] == "1" && $0[8] == note })
		XCTAssertTrue(rows.dropFirst().allSatisfy { $0[9] == String(timestamp.timeIntervalSinceReferenceDate) })
		XCTAssertNil(exporter.context)
	}

	func testStressExportsPreserveSubmillisecondTimestampForEstimatedDateAnalysis() throws {
		let precise = Date(timeIntervalSince1970: 1_700_000_040).addingTimeInterval(0.000001)
		let definition = try StressTrackingStore.createStressor(name: "Work")
		_ = try StressTrackingStore.save(draft: StressCheckInDraft(date: precise, overallRating: 2,
			responses: [response(definition, rating: 3)]))
		try reopen()
		let stored = try XCTUnwrap(checkIns().first)
		XCTAssertEqual(stored.timestamp, precise, "SQLite must retain the captured instant")
		let metric = EstimatedDatesInformation(CommonSampleAttributes.timestamp)
		XCTAssertEqual(try Double(metric.computeGraphable(forSamples: [stored])), 0)
		let overallURL = directory.appendingPathComponent("precise-stress.csv")
		let responsesURL = directory.appendingPathComponent("precise-responses.csv")
		try StressCheckInExporter(coordinator: container.persistentStoreCoordinator, url: overallURL).exportData()
		try StressorResponseExporter(coordinator: container.persistentStoreCoordinator, url: responsesURL).exportData()
		let iso = ISO8601DateFormatter(); iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
		let original = stored.timestamp
		defer { stored.timestamp = original }
		for url in [overallURL, responsesURL] {
			let rows = try exportRows(at: url)
			XCTAssertEqual(rows.first?.last, "Timestamp Reference Seconds")
			let row = try XCTUnwrap(rows.dropFirst().first)
			let referenceSeconds = try XCTUnwrap(Double(try XCTUnwrap(row.last)))
			let restored = Date(timeIntervalSinceReferenceDate: referenceSeconds)
			XCTAssertEqual(restored, precise, "The raw reference-time column must round-trip the Date exactly")
			let displayed = try XCTUnwrap(iso.date(from: row[1]))
			XCTAssertEqual(row[1], "2023-11-14T22:14:00.000Z")
			XCTAssertNotEqual(displayed, precise, "The readable ISO column alone loses this submillisecond fraction")
			stored.timestamp = displayed
			XCTAssertEqual(try Double(metric.computeGraphable(forSamples: [stored])), 100,
				"Using only the rounded ISO display would change the estimated-date heuristic")
			stored.timestamp = restored
			XCTAssertEqual(try Double(metric.computeGraphable(forSamples: [stored])), 0,
				"The raw reference-time column preserves the captured timestamp's precision signal")
		}
	}

	func testStressModelMigratesExistingActivityTagsMoodsQueriesAndContext() throws {
		let modelURL = try XCTUnwrap(Self.bundle.url(forResource: "Introspective", withExtension: "momd"))
		let oldModel = try XCTUnwrap(NSManagedObjectModel(contentsOf: modelURL.appendingPathComponent("ActivityTags.mom")))
		let url = directory.appendingPathComponent("stress-migration.sqlite")
		let old = try open(oldModel, at: url)
		let definition = NSEntityDescription.insertNewObject(forEntityName: "ActivityDefinition", into: old.viewContext)
		definition.setValue("Existing activity", forKey: "name"); definition.setValue(0, forKey: "recordScreenIndex")
		let activity = NSEntityDescription.insertNewObject(forEntityName: "Activity", into: old.viewContext)
		activity.setValue(definition, forKey: "definition"); activity.setValue(timestamp, forKey: "startDate")
		let tag = NSEntityDescription.insertNewObject(forEntityName: "Tag", into: old.viewContext)
		tag.setValue("Keep tag", forKey: "name"); activity.setValue(NSSet(object: tag), forKey: "tags")
		let mood = NSEntityDescription.insertNewObject(forEntityName: "Mood", into: old.viewContext)
		mood.setValue(timestamp, forKey: "timestamp"); mood.setValue(4.5, forKey: "rating"); mood.setValue("Keep mood", forKey: "note")
		let query = NSEntityDescription.insertNewObject(forEntityName: "Query", into: old.viewContext)
		query.setValue("Keep query", forKey: "name"); query.setValue(8, forKey: "sampleTypeId")
		let context = NSEntityDescription.insertNewObject(forEntityName: "MetricContextEntry", into: old.viewContext)
		context.setValue(timestamp, forKey: "timestamp"); context.setValue("Illness", forKey: "category")
		context.setValue("mood", forKey: "metricKey"); context.setValue("Keep context", forKey: "note")
		try old.viewContext.save(); try close(old)
		let migrated = try open(Self.model, at: url)
		defer { try? close(migrated) }
		XCTAssertEqual(try migrated.viewContext.fetch(MoodImpl.fetchRequest()).first?.originalTimestamp, timestamp)
		XCTAssertEqual(try migrated.viewContext.fetch(MoodImpl.fetchRequest()).first?.note, "Keep mood")
		XCTAssertEqual(try migrated.viewContext.fetch(StoredQuery.fetchRequest()).first?.name, "Keep query")
		XCTAssertEqual(try migrated.viewContext.fetch(MetricContextEntry.fetchRequest()).first?.note, "Keep context")
		let kept = try XCTUnwrap(migrated.viewContext.fetch(Activity.fetchRequest()).first)
		XCTAssertEqual(kept.definition.name, "Existing activity")
		XCTAssertEqual(kept.tagsArray().map { $0.name }, ["Keep tag"])
		XCTAssertEqual(try migrated.viewContext.count(for: StressCheckIn.fetchRequest()), 0)
		XCTAssertEqual(try migrated.viewContext.count(for: StressorResponse.fetchRequest()), 0)
		XCTAssertEqual(try migrated.viewContext.count(for: StressorDefinition.fetchRequest()), 0)
	}

	@MainActor func testNewFormRequiresOverallButSavesExplicitNoneWithoutPersonalStressors() throws {
		let form = makeForm()
		form.loadViewIfNeeded(); form.viewWillAppear(false)
		XCTAssertNil(form.draft.overallRating); XCTAssertTrue(form.draft.responses.isEmpty)
		XCTAssertFalse(form.navigationItem.rightBarButtonItems?.first?.isEnabled ?? true)
		form.setOverallRating(0)
		XCTAssertTrue(form.navigationItem.rightBarButtonItems?.first?.isEnabled ?? false)
		form.save()
		let saved = try XCTUnwrap(checkIns().first)
		XCTAssertEqual(saved.overallRating, 0); XCTAssertEqual(saved.timestamp, timestamp)
		XCTAssertTrue(saved.responses.isEmpty)
	}

	@MainActor func testFormOffersEightUnansweredStressorsAndSavesZeroNotApplicableAndSkippedSeparately() throws {
		for index in 0..<8 { _ = try StressTrackingStore.createStressor(name: "Personal \(index)") }
		let form = makeForm()
		form.loadViewIfNeeded(); form.viewWillAppear(false)
		XCTAssertEqual(form.draft.responses.count, 8)
		XCTAssertTrue(form.draft.responses.allSatisfy { $0.status == .skipped && $0.rating == nil })
		form.setOverallRating(2)
		form.setResponse(at: 0, status: .rated, rating: 0)
		form.setResponse(at: 1, status: .notApplicable, rating: nil)
		form.save()
		let saved = try XCTUnwrap(checkIns().first)
		XCTAssertEqual(saved.orderedResponses.count, 8)
		XCTAssertEqual(saved.orderedResponses.prefix(3).map { $0.status }, [.rated, .notApplicable, .skipped])
		XCTAssertEqual(saved.orderedResponses.prefix(3).map { $0.rating }, [0, nil, nil])
	}

	@MainActor func testExistingEditorKeepsHistoricalOfferedListAfterRenameArchiveAndNewDefinitions() throws {
		let original = try StressTrackingStore.createStressor(name: "Old label")
		let saved = try StressTrackingStore.save(draft: StressCheckInDraft(date: timestamp, overallRating: 1,
			responses: [response(original, rating: 0)]))
		try StressTrackingStore.renameStressor(id: original.id, to: "New label")
		try StressTrackingStore.setArchived(id: original.id, archived: true)
		_ = try StressTrackingStore.createStressor(name: "Added later")
		let form = StressCheckInViewController(checkIn: saved)
		form.guideDefaults = defaults
		form.loadStressors = { XCTFail("Historical editing must not replace its offered list"); return [] }
		form.loadViewIfNeeded(); form.viewWillAppear(false)
		XCTAssertEqual(form.draft.responses.map { $0.nameSnapshot }, ["Old label"])
		XCTAssertEqual(form.draft.responses.map { $0.stressorID }, [original.id])
		XCTAssertEqual(form.draft.date, timestamp)
		form.setOverallRating(3); form.save()
		XCTAssertEqual(try XCTUnwrap(checkIns().first).orderedResponses.first?.nameSnapshot, "Old label")
		XCTAssertEqual(try checkIns().count, 1)
	}

	@MainActor func testNewDraftRefreshPreservesItsAnswersButNextCheckInStartsUnanswered() throws {
		let work = try StressTrackingStore.createStressor(name: "Work")
		let travel = try StressTrackingStore.createStressor(name: "Travel")
		let workID = work.id, travelID = travel.id
		let form = makeForm(); form.loadViewIfNeeded(); form.viewWillAppear(false)
		form.setOverallRating(2); form.setResponse(at: 0, status: .rated, rating: 0)
		form.setResponse(at: 1, status: .notApplicable, rating: nil)
		try StressTrackingStore.renameStressor(id: workID, to: "Work and study")
		try StressTrackingStore.setArchived(id: travelID, archived: true)
		let caregiving = try StressTrackingStore.createStressor(name: "Caregiving")
		form.viewWillAppear(false)
		XCTAssertEqual(form.draft.responses.map { $0.stressorID }, [workID, caregiving.id])
		XCTAssertEqual(form.draft.responses.map { $0.nameSnapshot }, ["Work and study", "Caregiving"])
		XCTAssertEqual(form.draft.responses.map { $0.status }, [.rated, .skipped])
		XCTAssertEqual(form.draft.responses.map { $0.rating }, [0, nil])
		form.save()
		let next = makeForm(); next.loadViewIfNeeded(); next.viewWillAppear(false)
		XCTAssertNil(next.draft.overallRating)
		XCTAssertTrue(next.draft.responses.allSatisfy { $0.status == .skipped && $0.rating == nil })
	}

	@MainActor func testManagementScreenCreatesRenamesReordersArchivesAndRestoresDefinitions() throws {
		let manager = StressorsViewController(style: .grouped)
		manager.loadViewIfNeeded(); manager.viewWillAppear(false)
		manager.saveName("Work", id: nil); manager.saveName("Family", id: nil)
		XCTAssertEqual(manager.active.map { $0.name }, ["Work", "Family"])
		let workID = try XCTUnwrap(manager.active.first?.id)
		manager.saveName("Work and study", id: workID)
		manager.tableView(manager.tableView, moveRowAt: IndexPath(row: 0, section: 0),
			to: IndexPath(row: 1, section: 0))
		XCTAssertEqual(manager.active.map { $0.name }, ["Family", "Work and study"])
		manager.setArchived(workID, archived: true)
		XCTAssertEqual(manager.active.map { $0.name }, ["Family"])
		XCTAssertEqual(manager.archived.map { $0.id }, [workID])
		manager.setArchived(workID, archived: false)
		XCTAssertEqual(Set(manager.active.map { $0.name }), Set(["Family", "Work and study"]))
		XCTAssertTrue(manager.archived.isEmpty)
	}

	@MainActor func testManualTimeClearsSecondsAndFractionsWhileNowRetainsFullPrecision() throws {
		var calendar = Calendar(identifier: .gregorian); calendar.timeZone = TimeZone(secondsFromGMT: 0)!
		let form = makeForm()
		let precise = Date(timeIntervalSince1970: 1_700_000_023.875)
		form.setManualDate(precise, calendar: calendar)
		XCTAssertEqual(calendar.component(.second, from: form.draft.date), 0)
		XCTAssertEqual(form.draft.date.timeIntervalSince1970.truncatingRemainder(dividingBy: 1), 0)
		form.clock = { precise }; form.useNow()
		XCTAssertEqual(form.draft.date, precise)
	}

	@MainActor func testFailedDefinitionLoadPreventsPartialSaveAndCanRecoverWithoutLosingOverallAnswer() throws {
		let form = makeForm()
		form.loadStressors = { throw NSError(domain: "StressDefinitionLoad", code: 1) }
		form.loadViewIfNeeded(); form.viewWillAppear(false)
		form.setOverallRating(2)
		XCTAssertFalse(form.navigationItem.rightBarButtonItems?.first?.isEnabled ?? true)
		form.save()
		XCTAssertTrue(try checkIns().isEmpty)
		XCTAssertTrue(form.tableView(form.tableView, titleForFooterInSection: 2)?.contains("Could not load") == true)
		form.loadStressors = { [] }; form.reloadStressors()
		XCTAssertEqual(form.draft.overallRating, 2)
		XCTAssertTrue(form.navigationItem.rightBarButtonItems?.first?.isEnabled ?? false)
		form.save()
		XCTAssertEqual(try checkIns().count, 1)
	}

	@MainActor func testIntroductionCanBeDismissedWithoutHidingReplayableUseCaseGuide() {
		let first = makeForm(); first.loadViewIfNeeded()
		XCTAssertTrue(first.showsIntroduction)
		first.dismissIntroduction()
		XCTAssertFalse(first.showsIntroduction)
		let next = makeForm(); next.loadViewIfNeeded()
		XCTAssertFalse(next.showsIntroduction)
		XCTAssertEqual(next.navigationItem.rightBarButtonItems?.last?.accessibilityLabel, "Stress check-in guide")
		let guide = StressGuideViewController(style: .grouped); guide.loadViewIfNeeded()
		let headers = (0..<guide.numberOfSections(in: guide.tableView)).compactMap {
			guide.tableView(guide.tableView, titleForHeaderInSection: $0)
		}
		XCTAssertTrue(headers.contains("Evaluate a change"))
		XCTAssertTrue(headers.contains("Prepare for an appointment"))
	}

	@MainActor private func makeForm() -> StressCheckInViewController {
		let form = StressCheckInViewController(now: timestamp)
		form.guideDefaults = defaults
		return form
	}
	private func run(_ query: Query) throws -> [Sample] {
		var selected: [Sample] = []; var failure: Error?; var completed = false
		query.runQuery { result, error in selected = result?.samples ?? []; failure = error; completed = true }
		XCTAssertTrue(completed, "A local Core Data query must complete")
		if let failure = failure { throw failure }
		return selected
	}
	private func exportRows(at url: URL) throws -> [[String]] {
		let reader = try CSVReader(stream: XCTUnwrap(InputStream(url: url)), hasHeaderRow: false)
		var rows = [[String]]()
		while let row = reader.next() { rows.append(row) }
		return rows
	}
}
