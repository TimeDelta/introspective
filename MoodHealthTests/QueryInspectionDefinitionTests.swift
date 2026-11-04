import XCTest
import CoreData
import AttributeRestrictions
import Attributes
import BooleanAlgebra
import Common
import DependencyInjection
@testable import Persistence
import Queries
import Samples

private final class InspectionDefinitionDatabaseProbe: Database, InjectionProvider {
	let types: [Any.Type] = [Database.self]
	let base: Database
	private let lock = NSLock()
	private var reads = 0
	var globalReads: Int { lock.lock(); defer { lock.unlock() }; return reads }
	init(_ base: Database) { self.base = base }
	func get<Value>(_ type: Value.Type) throws -> Value { self as! Value }
	func transaction() -> Transaction { base.transaction() }
	func setModifiedExternally(_ modified: Bool) { base.setModifiedExternally(modified) }
	func refreshContext() { base.refreshContext() }
	func fetchedResultsController<T: NSManagedObject>(type: T.Type, sortDescriptors: [NSSortDescriptor],
		cacheName: String?) -> NSFetchedResultsController<T> {
		base.fetchedResultsController(type: type, sortDescriptors: sortDescriptors, cacheName: cacheName)
	}
	func query<T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> [T] {
		lock.lock(); reads += 1; lock.unlock()
		// No access to the main context is permitted from this read worker.
		return []
	}
	func count<T: NSManagedObject>(_ type: T.Type) throws -> Int { try base.count(type) }
	func count<T: NSFetchRequestResult>(_ request: NSFetchRequest<T>) throws -> Int { try base.count(request) }
	func pull<T: NSManagedObject>(savedObject: T) throws -> T { try base.pull(savedObject: savedObject) }
	func pull<T: NSManagedObject>(savedObject: T, fromSameContextAs otherObject: NSManagedObject) throws -> T {
		try base.pull(savedObject: savedObject, fromSameContextAs: otherObject)
	}
	func pull<T: NSManagedObject>(savedObject: T, fromContext context: NSManagedObjectContext) throws -> T {
		try base.pull(savedObject: savedObject, fromContext: context)
	}
	func deleteEverything() throws { try base.deleteEverything() }
	func cleanUpManagedObjectWithStrongReferenceCycle<T: NSManagedObject>(_ object: T) {
		base.cleanUpManagedObjectWithStrongReferenceCycle(object)
	}
}

final class QueryInspectionDefinitionTests: XCTestCase {
	private static let model = NSManagedObjectModel.mergedModel(from: [Bundle(for: QueryInspectionDefinitionTests.self)])!
	private var directory: URL!
	private var container: NSPersistentContainer!

	override func setUpWithError() throws {
		DependencyInjector.register([CommonInjectionProvider(), BooleanAlgebraInjectionProvider(),
			SamplesInjectionProvider(), QueriesInjectionProvider(), AttributeRestrictionsInjectionProvider()])
		directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
		container = NSPersistentContainer(name: "QueryInspectionDefinition", managedObjectModel: Self.model)
		let store = NSPersistentStoreDescription(url: directory.appendingPathComponent("snapshot.sqlite"))
		store.shouldAddStoreAsynchronously = false
		container.persistentStoreDescriptions = [store]
		var failure: Error?
		container.loadPersistentStores { _, error in failure = error }
		if let error = failure { throw error }
	}

	override func tearDownWithError() throws {
		container.viewContext.reset()
		for store in container.persistentStoreCoordinator.persistentStores {
			try container.persistentStoreCoordinator.remove(store)
		}
		container = nil
		try FileManager.default.removeItem(at: directory)
	}

	private func tag(_ name: String, save: Bool = true) throws -> Tag {
		let context = container.viewContext
		let entity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: Tag.entityName, in: context))
		let tag = Tag(entity: entity, insertInto: context); tag.name = name
		if save { try context.save() }
		return tag
	}

	func testCompoundDefinitionRoundTripsAllOperatorsAndNestedQueryWithoutSharingState() throws {
		let query = MoodQueryImpl()
		let condition = ContainsStringAttributeRestriction(restrictedAttribute: MoodImpl.note, substring: "quiet")
		query.expression = AndExpression(BooleanExpressionGroup(OrExpression(condition,
			NotExpression(EmptyStringAttributeRestriction(restrictedAttribute: MoodImpl.note)))),
			InThePastXTimeUnitsDateAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp, 3, .day))
		let child = MedicationDoseQueryImpl()
		query.subQuery = (WithinXCalendarUnitsBeforeSubQueryMatcher(numberOfTimeUnits: 12, timeUnit: .hour, mostRecentOnly: true), child)
		query.mostRecentEntryOnly = true
		let definition = try QueryInspectionDefinition.capture(query)
		let restored = try definition.restore(in: container.viewContext)
		XCTAssertTrue(query.equalTo(restored))
		XCTAssertFalse(query === restored)
		XCTAssertFalse(query.subQuery!.query === restored.subQuery!.query)
		XCTAssertEqual(definition, try QueryInspectionDefinition.capture(restored))
		condition.substring = "changed"
		XCTAssertNotEqual(definition, try QueryInspectionDefinition.capture(query))
		XCTAssertEqual(definition, try QueryInspectionDefinition.capture(restored))
	}

	func testCapturedDosageIsIndependentOfLaterEditsAndEveryRestoreHasItsOwnValue() throws {
		let value = Dosage(5, "mg")
		let query = MedicationDoseQueryImpl()
		query.expression = GreaterThanDosageAttributeRestriction(restrictedAttribute: MedicationDose.dosage, value: value)
		let definition = try QueryInspectionDefinition.capture(query)
		value.amount = 100; value.unit = "g"
		let first = try XCTUnwrap(try definition.restore(in: container.viewContext).expression as? GreaterThanDosageAttributeRestriction)
		let second = try XCTUnwrap(try definition.restore(in: container.viewContext).expression as? GreaterThanDosageAttributeRestriction)
		XCTAssertEqual(first.typedValue.amount, 5); XCTAssertEqual(first.typedValue.unit, "mg")
		XCTAssertFalse(first.typedValue === value); XCTAssertFalse(first.typedValue === second.typedValue)
		first.typedValue.amount = 8
		XCTAssertEqual(second.typedValue.amount, 5)
	}

	func testTimeOfDayAndDurationValuesRoundTripWithoutSharingMutableClock() throws {
		let time = TimeOfDay(); time.hour = 18; time.minute = 24; time.second = 32
		let query = ActivityQueryImpl()
		query.expression = AndExpression(
			BeforeTimeOfDayAttributeRestriction(restrictedAttribute: CommonSampleAttributes.startDate, timeOfDay: time),
			GreaterThanDurationAttributeRestriction(restrictedAttribute: Activity.durationAttribute, value: TimeDuration(123.456)))
		let definition = try QueryInspectionDefinition.capture(query)
		time.hour = 3
		let restored = try XCTUnwrap(try definition.restore(in: container.viewContext).expression as? AndExpression)
		let clock = try XCTUnwrap(restored.expression1 as? BeforeTimeOfDayAttributeRestriction)
		let duration = try XCTUnwrap(restored.expression2 as? GreaterThanDurationAttributeRestriction)
		XCTAssertEqual(clock.timeOfDay.hour, 18); XCTAssertEqual(clock.timeOfDay.minute, 24); XCTAssertEqual(clock.timeOfDay.second, 32)
		XCTAssertFalse(clock.timeOfDay === time)
		XCTAssertEqual(duration.typedValue.inUnit(.second), 123.456, accuracy: 1e-12)
	}

	func testTagUsesPermanentIdentityAndRestoresOnPrivateQueue() throws {
		let original = try tag("Quiet")
		let query = ActivityQueryImpl()
		query.expression = ActivityHasTagAttributeRestriction(restrictedAttribute: Activity.tagsAttribute, tag: original)
		let definition = try QueryInspectionDefinition.capture(query)
		let id = original.objectID
		let context = container.newBackgroundContext()
		let done = expectation(description: "Definition restored on private context")
		context.perform {
			defer { done.fulfill() }
			do {
				XCTAssertFalse(Thread.isMainThread)
				let restored = try XCTUnwrap(try definition.restore(in: context).expression as? ActivityHasTagAttributeRestriction)
				XCTAssertEqual(restored.tag.objectID, id)
				XCTAssertTrue(restored.tag.managedObjectContext === context)
				XCTAssertEqual(restored.tag.name, "Quiet")
				XCTAssertEqual(definition, try QueryInspectionDefinition.capture(try definition.restore(in: context)))
			} catch { XCTFail("Definition could not be restored: \(error.localizedDescription)") }
		}
		wait(for: [done], timeout: 3)
	}

	func testDeletedTagCannotRebindToNewTagWithSameName() throws {
		let original = try tag("Same name")
		let query = ActivityQueryImpl()
		query.expression = ActivityHasTagAttributeRestriction(restrictedAttribute: Activity.tagsAttribute, tag: original)
		let definition = try QueryInspectionDefinition.capture(query)
		container.viewContext.delete(original); try container.viewContext.save()
		let replacement = try tag("Same name")
		XCTAssertNotEqual(replacement.objectID, original.objectID)
		XCTAssertThrowsError(try definition.restore(in: container.viewContext))
	}

	func testTagNameEditsInvalidateSingleAndMultipleReferenceDefinitionsWithoutChangingIdentity() throws {
		let original = try tag("Before")
		let single = ActivityQueryImpl(), multiple = ActivityQueryImpl()
		single.expression = ActivityHasTagAttributeRestriction(restrictedAttribute: Activity.tagsAttribute, tag: original)
		multiple.expression = ActivityHasOneOfTagAttributeRestriction(tags: [original, original], restrictedAttribute: Activity.tagsAttribute)
		let singleDefinition = try QueryInspectionDefinition.capture(single)
		let multipleDefinition = try QueryInspectionDefinition.capture(multiple)
		let id = original.objectID
		original.name = "After"
		XCTAssertEqual(original.objectID, id)
		XCTAssertNotEqual(singleDefinition, try QueryInspectionDefinition.capture(single))
		XCTAssertNotEqual(multipleDefinition, try QueryInspectionDefinition.capture(multiple))
		XCTAssertThrowsError(try singleDefinition.restore(in: container.viewContext))
		XCTAssertThrowsError(try multipleDefinition.restore(in: container.viewContext))
	}

	func testTagRenameRestoresOnlyInMatchingPinnedGenerationAndNeverMixesNewNameWithOldDefinition() throws {
		let original = try tag("Pinned name")
		let query = ActivityQueryImpl()
		query.expression = ActivityHasTagAttributeRestriction(restrictedAttribute: Activity.tagsAttribute, tag: original)
		let definition = try QueryInspectionDefinition.capture(query)
		let reader = container.newBackgroundContext()
		reader.performAndWait {
			do {
				try reader.setQueryGenerationFrom(.current)
				let read = Tag.fetchRequest(); read.fetchLimit = 1; read.returnsObjectsAsFaults = false
				_ = try reader.fetch(read)
				XCTAssertNotNil(reader.queryGenerationToken)
				XCTAssertFalse(reader.queryGenerationToken === NSQueryGenerationToken.current)
			} catch { XCTFail("Could not pin tag generation: \(error.localizedDescription)") }
		}
		original.name = "New committed name"
		try container.viewContext.save()
		XCTAssertNotEqual(definition, try QueryInspectionDefinition.capture(query), "A caller must discard counts after a referenced name edit")
		reader.performAndWait {
			do {
				let restored = try XCTUnwrap(try definition.restore(in: reader).expression as? ActivityHasTagAttributeRestriction)
				XCTAssertEqual(restored.tag.name, "Pinned name")
			} catch { XCTFail("Pinned reference should retain its original semantics: \(error.localizedDescription)") }
			reader.reset(); try? reader.setQueryGenerationFrom(nil)
		}
		let fresh = container.newBackgroundContext()
		fresh.performAndWait {
			do {
				_ = try definition.restore(in: fresh)
				XCTFail("A fresh generation must not use a renamed reference with an old definition")
			} catch { /* Expected: this generation contains the edited tag name. */ }
		}
	}

	func testUnsavedAndAlreadyDeletedReferencesAreRejectedDuringCapture() throws {
		let original = try tag("Unsaved", save: false)
		let query = ActivityQueryImpl()
		query.expression = ActivityHasTagAttributeRestriction(restrictedAttribute: Activity.tagsAttribute, tag: original)
		XCTAssertThrowsError(try QueryInspectionDefinition.capture(query))
		try container.viewContext.save()
		container.viewContext.delete(original)
		XCTAssertThrowsError(try QueryInspectionDefinition.capture(query))
	}

	func testReferenceCannotResolveInDifferentStore() throws {
		let original = try tag("Local")
		let query = ActivityQueryImpl()
		query.expression = ActivityHasTagAttributeRestriction(restrictedAttribute: Activity.tagsAttribute, tag: original)
		let definition = try QueryInspectionDefinition.capture(query)
		let coordinator = NSPersistentStoreCoordinator(managedObjectModel: Self.model)
		let store = try coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil)
		defer { try? coordinator.remove(store) }
		let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		context.persistentStoreCoordinator = coordinator
		XCTAssertThrowsError(try definition.restore(in: context))
	}

	func testTagOrderAndDuplicatesArePreserved() throws {
		let first = try tag("First"), second = try tag("Second")
		let query = ActivityQueryImpl()
		query.expression = ActivityHasOneOfTagAttributeRestriction(tags: [second, first, second], restrictedAttribute: Activity.tagsAttribute)
		let definition = try QueryInspectionDefinition.capture(query)
		let restored = try XCTUnwrap(try definition.restore(in: container.viewContext).expression as? ActivityHasOneOfTagAttributeRestriction)
		XCTAssertEqual(restored.tags.map { $0.objectID }, [second.objectID, first.objectID, second.objectID])
	}

	@MainActor func testCanonicalTagAndForcedEvaluatorReadNeverQueryGlobalDatabase() throws {
		let original = try tag("Quiet")
		let context = container.viewContext
		let activityEntity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: Activity.entityName, in: context))
		let definitionEntity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: ActivityDefinition.entityName, in: context))
		let activity = Activity(entity: activityEntity, insertInto: context)
		let activityDefinition = ActivityDefinition(entity: definitionEntity, insertInto: context)
		activityDefinition.setValue("Reading", forKey: "name")
		activityDefinition.setValue(0, forKey: "recordScreenIndex")
		activity.setValue(activityDefinition, forKey: "definition")
		activity.setValue(NSSet(object: original), forKey: "tags")
		let noon = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 10, hour: 12)))
		activity.setValue(noon, forKey: "startDate")
		try context.save()
		let query = ActivityQueryImpl()
		let time = TimeOfDay(); time.hour = 23; time.minute = 59; time.second = 59
		query.expression = AndExpression(
			ActivityHasTagAttributeRestriction(restrictedAttribute: Activity.tagsAttribute, tag: original),
			BeforeTimeOfDayAttributeRestriction(restrictedAttribute: CommonSampleAttributes.startDate, timeOfDay: time))
		let definition = try QueryInspectionDefinition.capture(query)
		let database = InspectionDefinitionDatabaseProbe(DatabaseImpl(container))
		DependencyInjector.register([database])
		let worker = container.newBackgroundContext()
		let environment = QueryReadContext(context: worker, date: noon, convertTimeZones: false)
		let done = expectation(description: "Actual evaluator query finished without global reads")
		environment.perform {
			do {
				XCTAssertFalse(Thread.isMainThread)
				let metadata = HasTagAttributeRestriction.tagAttribute
				XCTAssertTrue(metadata.equalTo(metadata))
				let restored = try definition.restore(in: worker)
				XCTAssertNil(restored.expression?.predicate(), "Time-of-day forces the same evaluator fallback as the app")
				try configureReadContext(restored, context: environment)
				restored.runQuery { (result: QueryResult?, error: Error?) in
					XCTAssertNil(error); XCTAssertEqual(result?.samples.count, 1)
					XCTAssertEqual(database.globalReads, 0)
					done.fulfill()
				}
			} catch { XCTFail("Scoped query failed: \(error.localizedDescription)"); done.fulfill() }
		}
		wait(for: [done], timeout: 3)
		XCTAssertEqual(database.globalReads, 0)
	}

	func testScalarSelectOneAndHealthEnumsPreserveExactChoice() throws {
		let queries: [Query] = [MoodQueryImpl(), SleepQueryImpl(), SexualActivityQueryImpl()]
		let values: [(SelectOneAttribute, Any)] = [
			(MoodImpl.sourceAttribute, MoodImpl.sourceAttribute.possibleValues.last!),
			(Sleep.stateAttribute, Sleep.State.asleep),
			(SexualActivity.protectionUsed, SexualActivity.Protection.used),
		]
		for (query, value) in zip(queries, values) {
			query.expression = EqualToSelectOneAttributeRestriction(restrictedAttribute: value.0, value: value.1, valueAttribute: value.0)
			let definition = try QueryInspectionDefinition.capture(query)
			let restored = try definition.restore(in: container.viewContext)
			XCTAssertTrue(query.equalTo(restored))
			XCTAssertEqual(definition, try QueryInspectionDefinition.capture(restored))
		}
	}

	func testSnapshotEqualityDetectsMatcherAndRootFlagChanges() throws {
		let query = MoodQueryImpl(), child = MoodQueryImpl()
		let matcher = WithinXCalendarUnitsSubQueryMatcher(numberOfTimeUnits: 3, timeUnit: .day)
		query.subQuery = (matcher, child)
		let original = try QueryInspectionDefinition.capture(query)
		matcher.numberOfTimeUnits = 4
		XCTAssertNotEqual(original, try QueryInspectionDefinition.capture(query))
		matcher.numberOfTimeUnits = 3; query.mostRecentEntryOnly = true
		XCTAssertNotEqual(original, try QueryInspectionDefinition.capture(query))
	}

	func testQueryAndExpressionCyclesAreRejectedBeforeCopyOrEvaluation() throws {
		let query = MoodQueryImpl()
		query.subQuery = (SameDatesSubQueryMatcher(), query)
		XCTAssertThrowsError(try QueryInspectionDefinition.capture(query))
		query.subQuery = nil
		let expression = NotExpression(); expression.subExpression = expression; query.expression = expression
		XCTAssertThrowsError(try QueryInspectionDefinition.capture(query))
		// Release the deliberately cyclic fixtures.
		expression.subExpression = nil
	}

	func testIncompleteAndOverDeepConditionsAreRejected() throws {
		let query = MoodQueryImpl()
		query.expression = AndExpression()
		XCTAssertThrowsError(try QueryInspectionDefinition.capture(query))
		var expression: BooleanExpression = EmptyStringAttributeRestriction(restrictedAttribute: MoodImpl.note)
		for _ in 0..<33 { expression = NotExpression(expression) }
		query.expression = expression
		XCTAssertThrowsError(try QueryInspectionDefinition.capture(query))
	}

	func testRepeatedSharedLeafIsCopiedWhileUnsupportedAttributeCannotReachInitializer() throws {
		let query = MoodQueryImpl()
		let leaf = EmptyStringAttributeRestriction(restrictedAttribute: MoodImpl.note)
		query.expression = OrExpression(leaf, leaf)
		let definition = try QueryInspectionDefinition.capture(query)
		let restored = try XCTUnwrap(try definition.restore(in: container.viewContext).expression as? OrExpression)
		XCTAssertFalse((restored.expression1 as AnyObject) === (restored.expression2 as AnyObject))
		query.expression = EqualToSelectOneAttributeRestriction(restrictedAttribute: Sleep.stateAttribute,
			value: Sleep.State.inBed, valueAttribute: Sleep.stateAttribute)
		XCTAssertThrowsError(try QueryInspectionDefinition.capture(query))
	}

	func testLargeTreeIsBoundedWithoutRunningAnyQuery() throws {
		let query = MoodQueryImpl()
		func tree(_ depth: Int) -> BooleanExpression {
			if depth == 0 { return EmptyStringAttributeRestriction(restrictedAttribute: MoodImpl.note) }
			return OrExpression(tree(depth - 1), tree(depth - 1))
		}
		query.expression = tree(9)
		XCTAssertThrowsError(try QueryInspectionDefinition.capture(query))
	}
}
