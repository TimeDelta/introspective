//
//  MoodUtilFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 12/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import CoreData
import HealthKit
@testable import Introspective
@testable import DependencyInjection
@testable import Persistence
@testable import Samples
@testable import Settings

final class MoodUtilFunctionalTests: FunctionalTest {

	private final var util: MoodUtilImpl!

	final override func setUp() {
		super.setUp()
		util = MoodUtilImpl()
	}

	func testGivenExistingMoodOf6WithOriginalRange0To7AndNewRange1To8_scaleMoods_setsMoodTo7() throws {
		// given
		MoodDataTestUtil.createMood(rating: 6, min: 0, max: 7)
		injected(Settings.self).setMinMood(1)
		injected(Settings.self).setMaxMood(8)
		try injected(Settings.self).save()

		// when
		try util.scaleMoods()

		// then
		XCTAssert(try moodExistsWith(rating: 7, min: 1, max: 8))
	}

	func testGivenExistingMoodOf6WithOriginalRange0To7AndNewRange1To15_scaleMoods_setsMoodTo13() throws {
		// given
		MoodDataTestUtil.createMood(rating: 6, min: 0, max: 7)
		injected(Settings.self).setMinMood(1)
		injected(Settings.self).setMaxMood(15)
		try injected(Settings.self).save()

		// when
		try util.scaleMoods()

		// then
		XCTAssert(try moodExistsWith(rating: 13, min: 1, max: 15))
	}

	func testGivenExistingMoodOf10WithOriginalRange1To11AndNewRange0To5_scaleMoods_setsMoodTo4Point5() throws {
		// given
		MoodDataTestUtil.createMood(rating: 10, min: 1, max: 11)
		injected(Settings.self).setMinMood(0)
		injected(Settings.self).setMaxMood(5)
		try injected(Settings.self).save()

		// when
		try util.scaleMoods()

		// then
		XCTAssert(try moodExistsWith(rating: 4.5, min: 0, max: 5))
	}

	func testGivenMultipleMoodsWithDifferentRatingsAndRanges_scaleMoods_correctlyScalesAllMoods() throws {
		// given
		MoodDataTestUtil.createMood(rating: 6, min: 0, max: 7)
		MoodDataTestUtil.createMood(rating: 4, min: 1, max: 4)
		injected(Settings.self).setMinMood(1)
		injected(Settings.self).setMaxMood(8)
		try injected(Settings.self).save()

		// when
		try util.scaleMoods()

		// then
		XCTAssert(try moodExistsWith(rating: 7, min: 1, max: 8))
		XCTAssert(try moodExistsWith(rating: 8, min: 1, max: 8))
	}

	// MARK: - Helper Functions

	private final func moodExistsWith(rating: Double, min: Double, max: Double) throws -> Bool {
		let fetchRequest: NSFetchRequest<MoodImpl> = MoodImpl.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "rating == %f AND minRating == %f AND maxRating == %f", rating, min, max)
		return (try injected(Database.self).query(fetchRequest)).count > 0
	}
}


final class MoodHealthExchangeFunctionalTests: FunctionalTest {
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
	func testExistingMoodStoreMigratesWithoutLosingData() throws {
		let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
		defer { try? FileManager.default.removeItem(at: directory) }
		let modelDirectory = try XCTUnwrap(Bundle.main.url(forResource: "Introspective", withExtension: "momd"))
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
