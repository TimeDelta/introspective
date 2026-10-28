import XCTest
import CoreData
import HealthKit
import Common
import DependencyInjection
@testable import Persistence
@testable import Samples
@testable import Settings

// Independent of the legacy generated mocks; uses the real Core Data model/store.
private final class HealthTestProvider: InjectionProvider {
	let types: [Any.Type] = [Database.self, Settings.self]
	let database: Database
	let settings: Settings
	init(database: Database, settings: Settings) { self.database = database; self.settings = settings }
	func get<Type>(_ type: Type.Type) throws -> Type {
		if type == Database.self { return database as! Type }
		if type == Settings.self { return settings as! Type }
		throw NSError(domain: "MoodHealthTests", code: 1)
	}
}

final class MoodHealthExchangeFunctionalTests: XCTestCase {

	private static let modelBundle = Bundle(for: MoodHealthExchangeFunctionalTests.self)
	private static let objectModel = NSManagedObjectModel.mergedModel(from: [modelBundle])!
	private var container: NSPersistentContainer!
	private var database: Database!

	override func setUpWithError() throws {
		try super.setUpWithError()
		container = NSPersistentContainer(name: "MoodHealthTests", managedObjectModel: Self.objectModel)
		let description = NSPersistentStoreDescription()
		description.type = NSInMemoryStoreType
		description.shouldAddStoreAsynchronously = false
		container.persistentStoreDescriptions = [description]
		var loadError: Error?
		container.loadPersistentStores { _, error in loadError = error }
		if let error = loadError { throw error }
		database = DatabaseImpl(container)
		let context = container.viewContext
		let entity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: SettingsImpl.entityName, in: context))
		let settings = SettingsImpl(entity: entity, insertInto: context)
		try context.save()
		DependencyInjector.register([CommonInjectionProvider(), HealthTestProvider(database: database, settings: settings)])
	}

	private func createMood(note: String, rating: Double, timestamp: Date, min: Double, max: Double) throws -> MoodImpl {
		let context = container.viewContext
		let entity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: MoodImpl.entityName, in: context))
		let mood = MoodImpl(entity: entity, insertInto: context)
		mood.setSource(.introspective)
		mood.date = timestamp
		mood.rating = rating
		mood.minRating = min
		mood.maxRating = max
		mood.note = note
		try context.save()
		return mood
	}

	func testValenceConversionUsesEachMoodsOriginalRange() throws {
		guard #available(iOS 18.0, *) else { throw XCTSkip("State of Mind requires iOS 18") }
		XCTAssertEqual(try MoodHealthExchange.valence(rating: 0, min: 0, max: 7), -1)
		XCTAssertEqual(try MoodHealthExchange.valence(rating: 3.5, min: 0, max: 7), 0)
		XCTAssertEqual(try MoodHealthExchange.valence(rating: 7, min: 0, max: 7), 1)
		XCTAssertEqual(try MoodHealthExchange.valence(rating: 2, min: -2, max: 6), 0)
		XCTAssertThrowsError(try MoodHealthExchange.valence(rating: 1, min: 1, max: 1))
		XCTAssertThrowsError(try MoodHealthExchange.valence(rating: .nan, min: 0, max: 7))
		XCTAssertThrowsError(try MoodHealthExchange.valence(rating: 8, min: 0, max: 7))
	}

	func testImportPreservesTimestampAndDoesNotDuplicateSamples() throws {
		guard #available(iOS 18.0, *) else { throw XCTSkip("State of Mind requires iOS 18") }
		injected(Settings.self).setScaleMoodsOnImport(false)
		let date = Date(timeIntervalSince1970: 1_700_000_000)
		let sample = HKStateOfMind(date: date, kind: .dailyMood, valence: 0.5, labels: [], associations: [])
		let exchange = MoodHealthExchange()
		XCTAssertEqual(try exchange.importSamples([sample, sample]), 1)
		XCTAssertEqual(try exchange.importSamples([sample]), 0)
		let moods = try injected(Database.self).query(MoodImpl.fetchRequest())
		XCTAssertEqual(moods.count, 1)
		let mood = try XCTUnwrap(moods.first)
		XCTAssertEqual(mood.originalTimestamp, date)
		XCTAssertEqual(mood.rating, 0.5)
		XCTAssertEqual(mood.minRating, -1)
		XCTAssertEqual(mood.maxRating, 1)
		XCTAssertEqual(mood.getSource(), .health)
		XCTAssertEqual(mood.healthKitUUID, sample.uuid.uuidString)
	}

	func testImportScalesToCurrentRangeAndSkipsOurExports() throws {
		guard #available(iOS 18.0, *) else { throw XCTSkip("State of Mind requires iOS 18") }
		injected(Settings.self).setScaleMoodsOnImport(true)
		injected(Settings.self).setMinMood(0)
		injected(Settings.self).setMaxMood(10)
		let imported = HKStateOfMind(date: Date(), kind: .momentaryEmotion, valence: 0,
			labels: [], associations: [])
		let exported = HKStateOfMind(date: Date(), kind: .momentaryEmotion, valence: 1,
			labels: [], associations: [], metadata: [MoodHealthExchange.exportMarker: true])
		XCTAssertEqual(try MoodHealthExchange().importSamples([imported, exported]), 1)
		let moods = try injected(Database.self).query(MoodImpl.fetchRequest())
		XCTAssertEqual(moods.first?.rating, 5)
	}
	func testExportPreservesStoredInstantAndUsesStableIdentifierWithoutNotes() throws {
		guard #available(iOS 18.0, *) else { throw XCTSkip("State of Mind requires iOS 18") }
		let date = Date(timeIntervalSince1970: 1_700_000_000)
		let mood = try createMood(note: "Private note", rating: 3.5, timestamp: date, min: 0, max: 7)
		mood.timeZone = TimeZone(secondsFromGMT: 3600)
		let first = try MoodHealthExchange.exportSample(mood)
		let retry = try MoodHealthExchange.exportSample(mood)
		XCTAssertEqual(first.startDate, date)
		XCTAssertEqual(first.kind, .momentaryEmotion)
		XCTAssertEqual(first.valence, 0)
		XCTAssertEqual(first.metadata?[HKMetadataKeySyncIdentifier] as? String,
			retry.metadata?[HKMetadataKeySyncIdentifier] as? String)
		XCTAssertEqual(first.metadata?[MoodHealthExchange.exportMarker] as? Bool, true)
		XCTAssertNil(first.metadata?["note"])
		XCTAssertTrue(first.labels.isEmpty)
		XCTAssertTrue(first.associations.isEmpty)
	}

	func testExistingMoodStoreMigratesWithoutLosingData() throws {
		let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
		defer { try? FileManager.default.removeItem(at: directory) }
		let modelDirectory = try XCTUnwrap(Self.modelBundle.url(forResource: "Introspective", withExtension: "momd"))
		let oldModel = try XCTUnwrap(NSManagedObjectModel(contentsOf: modelDirectory.appendingPathComponent("Introspective.mom")))
		let newModel = try XCTUnwrap(NSManagedObjectModel(contentsOf: modelDirectory.appendingPathComponent("HealthMood.mom")))
		let url = directory.appendingPathComponent("migration.sqlite")
		let oldCoordinator = NSPersistentStoreCoordinator(managedObjectModel: oldModel)
		let store = try oldCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url)
		let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		context.persistentStoreCoordinator = oldCoordinator
		let mood = NSEntityDescription.insertNewObject(forEntityName: "Mood", into: context)
		mood.setValue(Date(timeIntervalSince1970: 1_700_000_000), forKey: "timestamp")
		mood.setValue(3.5, forKey: "rating")
		mood.setValue("Keep this note", forKey: "note")
		try context.save()
		context.reset()
		try oldCoordinator.remove(store)
		let coordinator = NSPersistentStoreCoordinator(managedObjectModel: newModel)
		let migrated = try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url,
			options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
		let migratedContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		migratedContext.persistentStoreCoordinator = coordinator
		let records = try migratedContext.fetch(NSFetchRequest<NSManagedObject>(entityName: "Mood"))
		XCTAssertEqual(records.count, 1)
		XCTAssertEqual(records.first?.value(forKey: "note") as? String, "Keep this note")
		XCTAssertEqual(records.first?.value(forKey: "rating") as? Double, 3.5)
		XCTAssertNil(records.first?.value(forKey: "healthKitUUID"))
		migratedContext.reset()
		try coordinator.remove(migrated)
	}

}
