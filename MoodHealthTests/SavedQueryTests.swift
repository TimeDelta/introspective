import XCTest
import CoreData
import Common
import DependencyInjection
import BooleanAlgebra
import AttributeRestrictions
@testable import Persistence
@testable import Queries
@testable import Samples
@testable import Settings

private final class SavedQueryTestProvider: InjectionProvider {
	let types: [Any.Type] = [Database.self, Settings.self]
	let database: Database
	let settings: Settings
	init(_ database: Database, _ settings: Settings) { self.database = database; self.settings = settings }
	func get<Type>(_ type: Type.Type) throws -> Type {
		if type == Database.self { return database as! Type }
		if type == Settings.self { return settings as! Type }
		throw NSError(domain: "SavedQueryTests", code: 1)
	}
}

final class SavedQueryTests: XCTestCase {
	private static let bundle = Bundle(for: SavedQueryTests.self)
	private static let model = NSManagedObjectModel.mergedModel(from: [bundle])!
	private var directory: URL!
	private var container: NSPersistentContainer!
	private let dao = StoredQueriesDAOImpl()

	override func setUpWithError() throws {
		_ = CommonInjectionProvider() // Register secure value transformers before opening the model.
		directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
		container = try open(Self.model, at: directory.appendingPathComponent("queries.sqlite"))
		try registerStore()
	}

	override func tearDownWithError() throws {
		container.viewContext.reset()
		for store in container.persistentStoreCoordinator.persistentStores { try container.persistentStoreCoordinator.remove(store) }
		container = nil
		try FileManager.default.removeItem(at: directory)
	}

	private func open(_ model: NSManagedObjectModel, at url: URL) throws -> NSPersistentContainer {
		let value = NSPersistentContainer(name: "SavedQueryTests", managedObjectModel: model)
		let description = NSPersistentStoreDescription(url: url)
		description.shouldAddStoreAsynchronously = false
		description.shouldMigrateStoreAutomatically = true
		description.shouldInferMappingModelAutomatically = true
		value.persistentStoreDescriptions = [description]
		var failure: Error?
		value.loadPersistentStores { _, error in failure = error }
		if let error = failure { throw error }
		value.viewContext.automaticallyMergesChangesFromParent = true
		return value
	}

	private func registerStore() throws {
		let context = container.viewContext
		let request = SettingsImpl.fetchRequest()
		let settings: SettingsImpl
		if let existing = try context.fetch(request).first { settings = existing }
		else {
			let entity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: SettingsImpl.entityName, in: context))
			settings = SettingsImpl(entity: entity, insertInto: context)
			try context.save()
		}
		DependencyInjector.register([CommonInjectionProvider(), BooleanAlgebraInjectionProvider(),
			SamplesInjectionProvider(), QueriesInjectionProvider(), AttributeRestrictionsInjectionProvider(),
			SavedQueryTestProvider(DatabaseImpl(container), settings)])
	}

	private func reopen() throws {
		let url = try XCTUnwrap(container.persistentStoreDescriptions.first?.url)
		container.viewContext.reset()
		for store in container.persistentStoreCoordinator.persistentStores { try container.persistentStoreCoordinator.remove(store) }
		container = try open(Self.model, at: url)
		try registerStore()
	}

	@discardableResult private func mood(_ rating: Double) throws -> MoodImpl {
		let context = container.viewContext
		let entity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: MoodImpl.entityName, in: context))
		let mood = MoodImpl(entity: entity, insertInto: context)
		mood.setSource(.introspective)
		mood.date = Date(timeIntervalSince1970: 1_700_000_000)
		mood.minRating = 0; mood.maxRating = 7; mood.rating = rating
		try context.save()
		return mood
	}

	func testNestedQueryAndBooleanGroupsSurviveDiskReopen() throws {
		let query = injected(QueryFactory.self).moodQuery()
		query.expression = AndExpression(
			GreaterThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 3),
			BooleanExpressionGroup(NotExpression(LessThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 1))))
		query.mostRecentEntryOnly = true
		let child = injected(QueryFactory.self).activityQuery()
		let grandchild = injected(QueryFactory.self).fatigueQuery()
		child.mostRecentEntryOnly = true
		child.subQuery = (SameEndDatesSubQueryMatcher(), grandchild)
		query.subQuery = (WithinXCalendarUnitsBeforeSubQueryMatcher(numberOfTimeUnits: 2, timeUnit: .day, mostRecentOnly: true), child)
		try dao.save(query, name: "Nested")
		try reopen()
		let stored = try XCTUnwrap(dao.getQueryWith(name: "Nested"))
		XCTAssertTrue(query.equalTo(try stored.convert()))
		XCTAssertEqual(try dao.getAllQueries().count, 1, "Subqueries must not appear as separate saved queries")
	}

	func testRestoredQueryRunsAgainstRecordedMoods() throws {
		try mood(2); try mood(6)
		let query = injected(QueryFactory.self).moodQuery()
		query.expression = GreaterThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 4)
		try dao.save(query, name: "Higher moods")
		try reopen()
		let restored = try XCTUnwrap(dao.getQueryWith(name: "Higher moods")).convert()
		var completed = false
		restored.runQuery { result, error in
			XCTAssertNil(error)
			XCTAssertEqual(result?.samples.count, 1)
			XCTAssertEqual((result?.samples.first as? MoodImpl)?.rating, 6)
			completed = true
		}
		XCTAssertTrue(completed)
	}

	func testNamesRenameAndCascadeDeletePreserveRecordedData() throws {
		try mood(5)
		let query = injected(QueryFactory.self).moodQuery()
		query.expression = NotExpression(LessThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 1))
		XCTAssertThrowsError(try dao.save(query, name: " \n "))
		try dao.save(query, name: "  Résumé  ")
		XCTAssertThrowsError(try dao.save(query, name: "RESUME"))
		let stored = try XCTUnwrap(dao.getQueryWith(name: "resume"))
		try dao.rename(stored, to: "Evening")
		XCTAssertNil(try dao.getQueryWith(name: "resume"))
		let renamed = try XCTUnwrap(dao.getQueryWith(name: "evening"))
		try dao.delete(renamed)
		XCTAssertTrue(try dao.getAllQueries().isEmpty)
		XCTAssertEqual(try container.viewContext.count(for: NSFetchRequest<NSFetchRequestResult>(entityName: "BooleanExpression")), 0)
		XCTAssertEqual(try injected(Database.self).count(MoodImpl.self), 1)
	}

	func testUpdatingSavedQueryIsAtomicAndClearsRemovedRestrictionsAndSubqueries() throws {
		let original = injected(QueryFactory.self).moodQuery()
		original.expression = GreaterThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 3)
		original.subQuery = (SameDatesSubQueryMatcher(), injected(QueryFactory.self).activityQuery())
		original.mostRecentEntryOnly = true
		try dao.save(original, name: "Editable")
		let saved = try XCTUnwrap(dao.getQueryWith(name: "Editable"))
		let id = saved.objectID
		let replacement = injected(QueryFactory.self).moodQuery()
		try dao.update(saved, with: replacement)
		let updated = try XCTUnwrap(dao.getQueryWith(name: "Editable"))
		XCTAssertEqual(updated.objectID, id)
		XCTAssertTrue(replacement.equalTo(try updated.convert()))
		XCTAssertEqual(try container.viewContext.count(for: NSFetchRequest<NSFetchRequestResult>(entityName: "Query")), 1)
		XCTAssertEqual(try container.viewContext.count(for: NSFetchRequest<NSFetchRequestResult>(entityName: "BooleanExpression")), 0)
		original.subQuery = (SameDatesSubQueryMatcher(), original)
		XCTAssertThrowsError(try dao.update(updated, with: original))
		original.subQuery = nil
		try reopen()
		XCTAssertTrue(replacement.equalTo(try XCTUnwrap(dao.getQueryWith(name: "Editable")).convert()))
	}

	func testAllDataTypesCanSaveWithoutRestrictions() throws {
		let samples = injected(SampleFactory.self)
		for (index, type) in samples.allTypes().enumerated() {
			let query = try injected(QueryFactory.self).queryFor(type)
			try dao.save(query, name: "Type \(index)")
			let loaded = try XCTUnwrap(dao.getQueryWith(name: "Type \(index)")).convert()
			XCTAssertTrue(query.equalTo(loaded))
		}
		XCTAssertEqual(try dao.getAllQueries().count, samples.allTypes().count)
	}

	func testEditorPartsPreserveNotAndMixedOperatorPrecedence() throws {
		let expression = NotExpression(OrExpression(
			GreaterThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 3),
			LessThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 1)))
		let originalParts = try expression.partsForEditing()
		let restored = try injected(BooleanExpressionParser.self).parse(originalParts)
		XCTAssertEqual(originalParts.map { String(describing: $0.type) },
			try restored.partsForEditing().map { String(describing: $0.type) })
		for rating in [0.0, 2.0, 6.0] {
			let sample = try mood(rating)
			XCTAssertEqual(try expression.evaluate([.sample: sample]), try restored.evaluate([.sample: sample]))
		}
	}

	func testEveryMatcherKindRetainsItsOptions() throws {
		for (index, type) in SubQueryMatcherFactoryImpl.allMatcherTypes.enumerated() {
			var matcher = type.init()
			matcher.mostRecentOnly = true
			let query = injected(QueryFactory.self).moodQuery()
			query.subQuery = (matcher, injected(QueryFactory.self).activityQuery())
			try dao.save(query, name: "Matcher \(index)")
			let restored = try XCTUnwrap(dao.getQueryWith(name: "Matcher \(index)")).convert()
			XCTAssertTrue(query.equalTo(restored))
		}
	}

	func testTagIdentityAndActivityDefinitionSemanticsSurviveRenameAndReopen() throws {
		let tag = try injected(TagDAO.self).getOrCreateTag(named: "work;focus")
		let other = try injected(TagDAO.self).getOrCreateTag(named: "other")
		let query = injected(QueryFactory.self).activityQuery()
		query.expression = ActivityHasOneOfTagAttributeRestriction(tags: [tag, other], restrictedAttribute: Activity.tagsAttribute)
		try dao.save(query, name: "Tagged activities")
		let editable = try container.viewContext.existingObject(with: tag.objectID) as! Tag
		editable.name = "Renamed"
		try container.viewContext.save()
		try reopen()
		let loaded = try XCTUnwrap(dao.getQueryWith(name: "Tagged activities")).convert()
		let restriction = try XCTUnwrap(loaded.expression as? ActivityHasOneOfTagAttributeRestriction)
		XCTAssertEqual(Set(restriction.tags.map { $0.name }), Set(["Renamed", "other"]))
	}

	func testCyclicQueryFailsWithoutPersistingPartialExpressionGraph() throws {
		let query = injected(QueryFactory.self).moodQuery()
		query.expression = GreaterThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 3)
		query.subQuery = (SameDatesSubQueryMatcher(), query)
		XCTAssertThrowsError(try dao.save(query, name: "Cycle"))
		query.subQuery = nil
		XCTAssertTrue(try dao.getAllQueries().isEmpty)
		XCTAssertEqual(try container.viewContext.count(for: NSFetchRequest<NSFetchRequestResult>(entityName: "BooleanExpression")), 0)
	}

	func testMigrationFromHealthModelPreservesMoodAndHealthIdentity() throws {
		let directory = try XCTUnwrap(self.directory)
		let modelURL = try XCTUnwrap(Self.bundle.url(forResource: "Introspective", withExtension: "momd"))
		let oldModel = try XCTUnwrap(NSManagedObjectModel(contentsOf: modelURL.appendingPathComponent("HealthMood.mom")))
		let url = directory.appendingPathComponent("health-migration.sqlite")
		let old = try open(oldModel, at: url)
		let record = NSEntityDescription.insertNewObject(forEntityName: "Mood", into: old.viewContext)
		record.setValue(Date(timeIntervalSince1970: 1_700_000_000), forKey: "timestamp")
		record.setValue(5.0, forKey: "rating")
		record.setValue("Existing note", forKey: "note")
		record.setValue("health-sample-id", forKey: "healthKitUUID")
		try old.viewContext.save()
		old.viewContext.reset()
		for store in old.persistentStoreCoordinator.persistentStores { try old.persistentStoreCoordinator.remove(store) }
		let migrated = try open(Self.model, at: url)
		let moods = try migrated.viewContext.fetch(MoodImpl.fetchRequest())
		XCTAssertEqual(moods.count, 1)
		XCTAssertEqual(moods.first?.rating, 5)
		XCTAssertEqual(moods.first?.note, "Existing note")
		XCTAssertEqual(moods.first?.healthKitUUID, "health-sample-id")
		migrated.viewContext.reset()
		for store in migrated.persistentStoreCoordinator.persistentStores { try migrated.persistentStoreCoordinator.remove(store) }
	}
}
