import XCTest
import CoreData
import Common
import DependencyInjection
import BooleanAlgebra
import AttributeRestrictions
import Attributes
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

	func testStoredExpressionEntitiesInstantiateTheirDeclaredClasses() throws {
		let context = container.viewContext
		for entity in Self.model.entities where entity.superentity?.name == "BooleanExpression" && !entity.isAbstract {
			let name = try XCTUnwrap(entity.name)
			let object = NSEntityDescription.insertNewObject(forEntityName: name, into: context)
			XCTAssertTrue(object is StoredBooleanExpression, "Wrong managed class for \(name)")
		}
		context.rollback()
	}

	func testDateTimeDurationAndDosageConditionsSurviveDiskReopen() throws {
		let time = TimeOfDay()
		time.hour = 12; time.minute = 34; time.second = 56
		let dateAttribute = MoodImpl.defaultIndependentAttribute
		let expressions: [BooleanExpression] = [
			OnDateAttributeRestriction(restrictedAttribute: dateAttribute, date: Date(timeIntervalSince1970: 1_700_000_000)),
			BeforeTimeOfDayAttributeRestriction(restrictedAttribute: dateAttribute, timeOfDay: time),
			OnDayOfWeekAttributeRestriction(restrictedAttribute: dateAttribute, daysOfWeek: [DayOfWeek.Monday, DayOfWeek.Friday]),
			InThePastXTimeUnitsDateAttributeRestriction(restrictedAttribute: dateAttribute, 7, .day),
			InCurrentTimeUnitDateAttributeRestriction(restrictedAttribute: dateAttribute, .month),
		]
		var originals: [Query] = []
		for (index, expression) in expressions.enumerated() {
			let query = injected(QueryFactory.self).moodQuery()
			query.expression = expression
			originals.append(query)
			try dao.save(query, name: "Typed \(index)")
		}
		let activity = injected(QueryFactory.self).activityQuery()
		activity.expression = EqualToDurationAttributeRestriction(restrictedAttribute: Activity.durationAttribute, value: TimeDuration(5400))
		try dao.save(activity, name: "Duration")
		let dosage = injected(QueryFactory.self).medicationDoseQuery()
		dosage.expression = EqualToDosageAttributeRestriction(restrictedAttribute: MedicationDose.dosage, value: Dosage(2.5, "mg"))
		try dao.save(dosage, name: "Dosage")
		try reopen()
		for (index, query) in originals.enumerated() {
			XCTAssertTrue(query.equalTo(try XCTUnwrap(dao.getQueryWith(name: "Typed \(index)")).convert()))
		}
		XCTAssertTrue(activity.equalTo(try XCTUnwrap(dao.getQueryWith(name: "Duration")).convert()))
		XCTAssertTrue(dosage.equalTo(try XCTUnwrap(dao.getQueryWith(name: "Dosage")).convert()))
	}

	private func fixtureValue(for attribute: Attribute, tag: Tag) throws -> Any {
		if attribute is TagsAttribute { return [tag] }
		if attribute is DaysOfWeekAttribute { return Set([DayOfWeek.Monday, DayOfWeek.Friday]) }
		if let choice = attribute as? SelectOneAttribute { return try XCTUnwrap(choice.possibleValues.first) }
		let type = attribute.valueType
		if type == String.self { return "fixture" }
		if type == Double.self { return 2.5 }
		if type == Int.self { return 3 }
		if type == Bool.self { return true }
		if type == Date.self { return Date(timeIntervalSince1970: 1_700_000_000) }
		if type == TimeDuration.self { return TimeDuration(5400) }
		if type == Dosage.self { return Dosage(2.5, "mg") }
		if type == Frequency.self { return try XCTUnwrap(Frequency("2 per day")) }
		if type == TimeOfDay.self { let time = TimeOfDay(); time.hour = 12; time.minute = 34; return time }
		if type == Tag.self { return tag }
		if type == [Tag].self || type == Set<Tag>.self { return [tag] }
		throw NSError(domain: "Missing fixture for \(type)", code: 1)
	}

	func testBuilderRestrictionFamiliesRoundTripThroughDisk() throws {
		let createdTag = try injected(TagDAO.self).getOrCreateTag(named: "fixture;tag")
		// The builder selects tags fetched into the view context, not DAO transaction objects.
		let tag = try injected(Database.self).pull(savedObject: createdTag)
		let factory = injected(AttributeRestrictionFactory.self)
		var cases: [(name: String, query: Query, tagDescription: String?)] = []
		var failures: [String] = []
		var attempted = 0
		for sampleType in injected(SampleFactory.self).allTypes() {
			for attribute in sampleType.attributes {
				for type in factory.typesFor(attribute) {
					attempted += 1
					let label = "\(sampleType.name) / \(attribute.name) / \(type)"
					do {
						let restriction = factory.initialize(type: type, forAttribute: attribute)
						for valueAttribute in restriction.attributes {
							try restriction.set(attribute: valueAttribute, to: fixtureValue(for: valueAttribute, tag: tag))
						}
						guard restriction.isValid() else { throw NSError(domain: "Invalid configured restriction", code: 1) }
						let query = try injected(QueryFactory.self).queryFor(sampleType)
						query.expression = restriction
						let name = "Family \(attempted)"
						try dao.save(query, name: name)
						let usesTags = attribute is TagAttribute || attribute is TagsAttribute
						cases.append((name, query, usesTags ? restriction.description : nil))
					} catch {
						failures.append("\(label): \(error)")
						container.viewContext.rollback()
					}
				}
			}
		}
		try reopen()
		for item in cases {
			do {
				let restored = try XCTUnwrap(dao.getQueryWith(name: item.name)).convert()
				if let text = item.tagDescription { XCTAssertEqual(restored.expression?.description, text, item.name) }
				else { XCTAssertTrue(item.query.equalTo(restored), item.name) }
			} catch { failures.append("\(item.name) failed after reopening: \(error)") }
		}
		XCTAssertGreaterThan(attempted, 30)
		XCTAssertTrue(failures.isEmpty, failures.joined(separator: "\n"))
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
	func testMoodCreationPreservesRequestedTimestampAndScaleAfterReopen() throws {
		let date = Date(timeIntervalSince1970: 1_700_000_023.75)
		let created = try injected(MoodDAO.self).createMood(timestamp: date, rating: 2.5, min: 0, max: 5, note: "Missed check-in")
		XCTAssertEqual(created.date, date)
		try reopen()
		let restored = try XCTUnwrap(injected(MoodDAO.self).getMoods(from: date.addingTimeInterval(-1), to: date.addingTimeInterval(1)).first)
		XCTAssertEqual(restored.date, date)
		XCTAssertEqual(restored.minRating, 0)
		XCTAssertEqual(restored.maxRating, 5)
		XCTAssertEqual(restored.note, "Missed check-in")
	}

	func testMoodReviewNormalizesHistoricalScalesAndExcludesInvalidRatings() throws {
		var calendar = Calendar(identifier: .gregorian)
		calendar.timeZone = try XCTUnwrap(TimeZone(identifier: "America/New_York"))
		let first = try mood(2)
		first.minRating = 0; first.maxRating = 4
		let second = try mood(75)
		second.minRating = 0; second.maxRating = 100
		second.date = calendar.date(byAdding: .day, value: 1, to: first.date)!
		let invalid = try mood(5)
		invalid.minRating = 5; invalid.maxRating = 5
		let summary = MoodReviewSummary(moods: [first, second, invalid], calendar: calendar)
		XCTAssertEqual(summary.checkInCount, 3)
		XCTAssertEqual(summary.recordedDayCount, 2)
		XCTAssertEqual(summary.ratedCheckInCount, 2)
		XCTAssertEqual(try XCTUnwrap(summary.averagePosition), 0.625, accuracy: 0.000001)
		XCTAssertNil(MoodReviewSummary(moods: []).averagePosition)
		XCTAssertNil(MoodReviewSummary(moods: [invalid]).averagePosition)
	}

	func testMoodReviewUsesCalendarBoundariesAcrossDaylightSaving() throws {
		var calendar = Calendar(identifier: .gregorian)
		calendar.timeZone = try XCTUnwrap(TimeZone(identifier: "America/New_York"))
		let date = try XCTUnwrap(calendar.date(from: DateComponents(year: 2024, month: 3, day: 10, hour: 12)))
		let today = MoodReviewSummary.dateInterval(forLastDays: 1, endingOn: date, calendar: calendar)
		XCTAssertEqual(today.duration, 23 * 3600)
		XCTAssertEqual(calendar.component(.hour, from: today.start), 0)
		let week = MoodReviewSummary.dateInterval(forLastDays: 7, endingOn: date, calendar: calendar)
		XCTAssertEqual(calendar.dateComponents([.day], from: week.start, to: week.end).day, 7)
		XCTAssertEqual(week.end, today.end)
	}

	func testEstimatedTimestampNormalizationClearsSecondsAndFractions() throws {
		let util = injected(CalendarUtil.self)
		for timestamp in [1_700_000_023.75, -0.125, 1_710_055_845.987] {
			let original = Date(timeIntervalSince1970: timestamp)
			let estimated = util.start(of: .minute, in: original)
			let components = Calendar.autoupdatingCurrent.dateComponents([.second, .nanosecond], from: estimated)
			XCTAssertEqual(components.second, 0)
			XCTAssertEqual(components.nanosecond, 0)
			XCTAssertLessThanOrEqual(estimated, original)
			XCTAssertLessThan(original.timeIntervalSince(estimated), 60)
			let wholeSecond = util.start(of: .second, in: original)
			XCTAssertEqual(Calendar.autoupdatingCurrent.component(.nanosecond, from: wholeSecond), 0)
			XCTAssertEqual(Calendar.autoupdatingCurrent.component(.second, from: wholeSecond),
				Calendar.autoupdatingCurrent.component(.second, from: original))
		}
	}

	func testSavedQuerySearchMatchesNamesTypesAndAllTermsAfterRename() throws {
		try dao.save(injected(QueryFactory.self).moodQuery(), name: "Evening Résumé")
		try dao.save(injected(QueryFactory.self).activityQuery(), name: "Morning walk")
		let queries = try dao.getAllQueries()
		XCTAssertEqual(queries.filter { $0.matchesSearchText("  resume MOOD\n") }.map { $0.name }, ["Evening Résumé"])
		XCTAssertEqual(queries.filter { $0.matchesSearchText("activity walk") }.map { $0.name }, ["Morning walk"])
		XCTAssertTrue(queries.filter { $0.matchesSearchText("evening activity") }.isEmpty)
		XCTAssertEqual(queries.filter { $0.matchesSearchText(" \n ") }.count, 2)
		let query = try XCTUnwrap(dao.getQueryWith(name: "Evening Résumé"))
		try dao.rename(query, to: "Bedtime")
		let renamed = try XCTUnwrap(dao.getQueryWith(name: "Bedtime"))
		XCTAssertFalse(renamed.matchesSearchText("resume"))
		XCTAssertTrue(renamed.matchesSearchText("bedtime mood"))
	}

}
