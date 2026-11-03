import XCTest
import CoreData
import AttributeRestrictions
import BooleanAlgebra
import Common
import DependencyInjection
@testable import Persistence
import Queries
@testable import Samples
@testable import Settings

private final class TagLookupTestProvider: InjectionProvider {
	let types: [Any.Type] = [Database.self, Settings.self]
	let database: Database
	let settings: Settings
	init(database: Database, settings: Settings) { self.database = database; self.settings = settings }
	func get<Value>(_ type: Value.Type) throws -> Value {
		if type == Database.self { return database as! Value }
		if type == Settings.self { return settings as! Value }
		throw GenericError("Unexpected saved-tag lookup dependency")
	}
}

final class SavedTagReferenceLookupTests: XCTestCase {
	private static let model = NSManagedObjectModel.mergedModel(from: [Bundle(for: SavedTagReferenceLookupTests.self)])!
	private var directory: URL!
	private var container: NSPersistentContainer!
	private let dao = StoredQueriesDAOImpl()

	override func setUpWithError() throws {
		_ = CommonInjectionProvider()
		directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
		container = NSPersistentContainer(name: "SavedTagLookupTests", managedObjectModel: Self.model)
		let description = NSPersistentStoreDescription(url: directory.appendingPathComponent("tags.sqlite"))
		description.shouldAddStoreAsynchronously = false; container.persistentStoreDescriptions = [description]
		var failure: Error?; container.loadPersistentStores { _, error in failure = error }
		if let failure = failure { throw failure }
		let root = container.viewContext
		let settings = SettingsImpl(entity: try entity(SettingsImpl.entityName, in: root), insertInto: root)
		try root.save()
		DependencyInjector.register([CommonInjectionProvider(), BooleanAlgebraInjectionProvider(), SamplesInjectionProvider(),
			QueriesInjectionProvider(), AttributeRestrictionsInjectionProvider(),
			TagLookupTestProvider(database: DatabaseImpl(container), settings: settings)])
	}

	override func tearDownWithError() throws {
		container.viewContext.reset()
		for store in container.persistentStoreCoordinator.persistentStores { try container.persistentStoreCoordinator.remove(store) }
		container = nil
		try FileManager.default.removeItem(at: directory)
	}

	private func entity(_ name: String, in context: NSManagedObjectContext) throws -> NSEntityDescription {
		try XCTUnwrap(NSEntityDescription.entity(forEntityName: name, in: context))
	}
	private func tag(_ name: String) throws -> Tag {
		let context = container.viewContext
		let tag = Tag(entity: try entity(Tag.entityName, in: context), insertInto: context)
		tag.name = name; return tag
	}
	private func save(tags: [Tag], name: String = "Tag query", single: Bool = false) throws -> StoredQuery {
		try container.viewContext.save()
		let query = ActivityQueryImpl()
		if single { query.expression = HasTagAttributeRestriction(restrictedAttribute: Activity.tagsAttribute, tag: tags[0]) }
		else { query.expression = HasOneOfTagAttributeRestriction(tags: tags, restrictedAttribute: Activity.tagsAttribute) }
		try dao.save(query, name: name)
		return try XCTUnwrap(dao.getQueryWith(name: name))
	}
	private func stored(_ id: NSManagedObjectID, in context: NSManagedObjectContext) throws -> StoredQuery {
		try XCTUnwrap(context.existingObject(with: id) as? StoredQuery)
	}
	private func referenceData(_ values: [(String, String)]) throws -> Data {
		try JSONSerialization.data(withJSONObject: values.map { ["id": $0.0, "name": $0.1] })
	}
	private func setReferences(_ values: [(String, String)], on stored: StoredQuery) throws {
		try XCTUnwrap(stored.storedExpression).setValue(referenceData(values), forKey: "tagReferencesData")
		try container.viewContext.save()
	}
	private func withReader(_ action: (NSManagedObjectContext) throws -> Void) throws {
		let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		context.persistentStoreCoordinator = container.persistentStoreCoordinator
		// This fixture keeps every materialized object, exposing the old full-tag
		// fetch's allocations instead of relying on a timing or request-flag check.
		context.retainsRegisteredObjects = true
		var failure: Error?
		context.performAndWait {
			do { try action(context) } catch { failure = error }
			context.reset()
		}
		if let failure = failure { throw failure }
	}
	private func registeredTags(in context: NSManagedObjectContext) -> Set<NSManagedObjectID> {
		Set(context.registeredObjects.filter { $0.entity.name == Tag.entityName }.map { $0.objectID })
	}
	private func assertMissing(_ stored: StoredQuery, name: String, file: StaticString = #file, line: UInt = #line) {
		do { _ = try stored.convert(); XCTFail("A missing identity must not rebind by name", file: file, line: line) }
		catch {
			XCTAssertEqual((error as? DisplayableError)?.displayableTitle,
				"The saved query's tag '\(name)' no longer exists.", file: file, line: line)
		}
	}

	func testConversionMaterializesOnlyRequestedTagsFromLargeSQLiteHistoryAndStillMatchesActivities() throws {
		for index in 0..<1_024 { _ = try tag("Unrelated \(index)") }
		let first = try tag("First selected"), second = try tag("Second selected")
		let root = container.viewContext
		let definition = ActivityDefinition(entity: try entity(ActivityDefinition.entityName, in: root), insertInto: root)
		definition.name = "Lookup activity"; definition.recordScreenIndex = 0
		let matched = Activity(entity: try entity(Activity.entityName, in: root), insertInto: root)
		matched.definition = definition; matched.tags = NSSet(array: [second]); matched.setValue(Date(), forKey: "startDate")
		let other = Activity(entity: try entity(Activity.entityName, in: root), insertInto: root)
		other.definition = definition; other.setValue(Date(), forKey: "startDate")
		let saved = try save(tags: [second, first])
		let queryID = saved.objectID, expectedTags = [second.objectID, first.objectID], matchedID = matched.objectID
		try withReader { context in
			let query = try stored(queryID, in: context).convert()
			let restriction = try XCTUnwrap(query.expression as? HasOneOfTagAttributeRestriction)
			XCTAssertEqual(restriction.tags.map { $0.objectID }, expectedTags)
			XCTAssertTrue(restriction.tags.allSatisfy { $0.managedObjectContext === context })
			XCTAssertEqual(registeredTags(in: context), Set(expectedTags), "Unrelated tags must not be materialized during conversion")
			let environment = QueryReadContext(context: context, date: Date(), convertTimeZones: false)
			try configureReadContext(query, context: environment)
			var callbacks = 0
			environment.execute {
				query.runQuery { (result: QueryResult?, error: Error?) in
					callbacks += 1; XCTAssertNil(error)
					XCTAssertEqual(result?.samples.compactMap { ($0 as? NSManagedObject)?.objectID }, [matchedID])
				}
			}
			XCTAssertEqual(callbacks, 1)
		}
	}

	func testRepeatedReferencesPreserveTheirOriginalOrderAndDuplicates() throws {
		let first = try tag("One"), second = try tag("Two")
		let saved = try save(tags: [first, second])
		let one = first.objectID.uriRepresentation().absoluteString, two = second.objectID.uriRepresentation().absoluteString
		try setReferences([(two, "Two"), (one, "One"), (two, "Two again")], on: saved)
		let queryID = saved.objectID, expected = [second.objectID, first.objectID, second.objectID]
		try withReader { context in
			let restriction = try XCTUnwrap(stored(queryID, in: context).convert().expression as? HasOneOfTagAttributeRestriction)
			XCTAssertEqual(restriction.tags.map { $0.objectID }, expected)
			XCTAssertTrue(restriction.tags[0] === restriction.tags[2])
			XCTAssertEqual(registeredTags(in: context), Set(expected))
		}
	}

	func testRenameKeepsTheSavedIdentityAndReadsItsCurrentName() throws {
		let selected = try tag("Original")
		let saved = try save(tags: [selected], single: true)
		let queryID = saved.objectID, tagID = selected.objectID
		selected.name = "Renamed"; try container.viewContext.save()
		try withReader { context in
			let restriction = try XCTUnwrap(stored(queryID, in: context).convert().expression as? HasTagAttributeRestriction)
			XCTAssertEqual(restriction.tag.objectID, tagID); XCTAssertEqual(restriction.tag.name, "Renamed")
			XCTAssertEqual(registeredTags(in: context), Set([tagID]))
		}
	}

	func testDeletedIdentityNeverRebindsToANewTagWithTheSameName() throws {
		let selected = try tag("Same name")
		let saved = try save(tags: [selected], single: true), queryID = saved.objectID, deletedID = selected.objectID
		container.viewContext.delete(selected); try container.viewContext.save()
		let replacement = try tag("Same name"); try container.viewContext.save()
		XCTAssertNotEqual(replacement.objectID, deletedID)
		try withReader { context in
			assertMissing(try stored(queryID, in: context), name: "Same name")
			XCTAssertTrue(registeredTags(in: context).isEmpty)
		}
	}

	func testMalformedForeignEntityAndNoncanonicalURIsRemainUnavailable() throws {
		let selected = try tag("Selected")
		let saved = try save(tags: [selected]), queryID = saved.objectID
		let canonical = selected.objectID.uriRepresentation().absoluteString
		var foreign = try XCTUnwrap(URLComponents(string: canonical)); foreign.host = UUID().uuidString
		for bad in ["not-a-core-data-uri", queryID.uriRepresentation().absoluteString,
			canonical.replacingOccurrences(of: "x-coredata:", with: "X-COREDATA:"), try XCTUnwrap(foreign.string)] {
			try setReferences([(bad, "Invalid identity")], on: saved)
			try withReader { context in
				assertMissing(try stored(queryID, in: context), name: "Invalid identity")
				XCTAssertTrue(registeredTags(in: context).isEmpty)
			}
		}
	}

	func testFirstMissingReferenceErrorKeepsInputOrder() throws {
		let selected = try tag("Valid")
		let saved = try save(tags: [selected]), queryID = saved.objectID
		let valid = selected.objectID.uriRepresentation().absoluteString
		try setReferences([(valid, "Valid"), ("invalid-first", "First missing"), ("invalid-second", "Second missing")], on: saved)
		try withReader { context in assertMissing(try stored(queryID, in: context), name: "First missing") }
	}

	@MainActor func testChildContextResolvesItsCoordinatorAndKeepsTagsOnTheChild() throws {
		let selected = try tag("Child tag"), saved = try save(tags: [selected], single: true)
		let child = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		child.parent = container.viewContext
		defer { child.reset() }
		let query = try stored(saved.objectID, in: child).convert()
		let restriction = try XCTUnwrap(query.expression as? HasTagAttributeRestriction)
		XCTAssertEqual(restriction.tag.objectID, selected.objectID)
		XCTAssertTrue(restriction.tag.managedObjectContext === child)
	}

	func testPendingDeletionStaysMissingAndIsNotSavedByConversion() throws {
		let selected = try tag("Pending deletion"), saved = try save(tags: [selected], single: true)
		container.viewContext.delete(selected)
		assertMissing(saved, name: "Pending deletion")
		XCTAssertTrue(selected.isDeleted); XCTAssertTrue(container.viewContext.hasChanges)
	}

	func testPendingPermanentInsertionRemainsVisibleWithoutBeingSaved() throws {
		let original = try tag("Original"), saved = try save(tags: [original], single: true)
		let pending = try tag("Pending new tag")
		try container.viewContext.obtainPermanentIDs(for: [pending])
		let data = try referenceData([(pending.objectID.uriRepresentation().absoluteString, pending.name)])
		try XCTUnwrap(saved.storedExpression).setValue(data, forKey: "tagReferencesData")
		let restriction = try XCTUnwrap(saved.convert().expression as? HasTagAttributeRestriction)
		XCTAssertTrue(restriction.tag === pending)
		XCTAssertTrue(pending.isInserted); XCTAssertTrue(container.viewContext.hasChanges)
	}

	func testEmptyReferenceListDoesNotMaterializeAnyTags() throws {
		let selected = try tag("Unused")
		for index in 0..<32 { _ = try tag("Other \(index)") }
		let saved = try save(tags: [selected]), queryID = saved.objectID
		try setReferences([], on: saved)
		try withReader { context in
			let restriction = try XCTUnwrap(stored(queryID, in: context).convert().expression as? HasOneOfTagAttributeRestriction)
			XCTAssertTrue(restriction.tags.isEmpty); XCTAssertTrue(registeredTags(in: context).isEmpty)
		}
	}

	func testInMemoryStoreRetainsTheExistingIdentityConversionPath() throws {
		let value = NSPersistentContainer(name: "InMemoryTagLookup", managedObjectModel: Self.model)
		let description = NSPersistentStoreDescription(); description.type = NSInMemoryStoreType
		description.shouldAddStoreAsynchronously = false; value.persistentStoreDescriptions = [description]
		var failure: Error?; value.loadPersistentStores { _, error in failure = error }
		if let failure = failure { throw failure }
		let context = value.viewContext
		defer {
			context.reset()
			for store in value.persistentStoreCoordinator.persistentStores { try? value.persistentStoreCoordinator.remove(store) }
		}
		let selected = Tag(entity: try entity(Tag.entityName, in: context), insertInto: context); selected.name = "In memory"
		try context.save()
		let restriction = StoredSingleTagAttributeRestriction(
			entity: try entity(StoredSingleTagAttributeRestriction.entityName, in: context), insertInto: context)
		restriction.setValue(injected(SampleFactory.self).sampleTypeId(for: Activity.self), forKey: "sampleTypeId")
		restriction.setValue(Activity.tagsAttribute.id, forKey: "attributeId")
		restriction.setValue(0, forKey: "operation"); restriction.setValue(selected.name, forKey: "tagName")
		restriction.setValue(try referenceData([(selected.objectID.uriRepresentation().absoluteString, selected.name)]), forKey: "tagReferencesData")
		let query = StoredQuery(entity: try entity(StoredQuery.entityName, in: context), insertInto: context)
		query.name = "In-memory query"; query.sampleTypeId = injected(SampleFactory.self).sampleTypeId(for: Activity.self)
		query.storedExpression = restriction
		try context.save()
		let converted = try XCTUnwrap(query.convert().expression as? HasTagAttributeRestriction)
		XCTAssertTrue(converted.tag === selected)
		XCTAssertTrue(converted.tag.managedObjectContext === context)
	}
}
