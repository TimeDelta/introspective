//
//  MoodUtilFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 12/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
@testable import Introspective
import CoreData

final class MoodUtilFunctionalTests: FunctionalTest {

	private final var util: MoodUtilImpl!

	final override func setUp() {
		util = MoodUtilImpl()
	}

	func testGivenExistingMoodOf6WithOriginalRange0To7AndNewRange1To8_scaleMoods_setsMoodTo7() throws {
		// given
		MoodDataTestUtil.createMood(rating: 6, min: 0, max: 7)
		DependencyInjector.settings.setMinMood(1)
		DependencyInjector.settings.setMaxMood(8)
		DependencyInjector.settings.save()

		// when
		try util.scaleMoods()

		// then
		XCTAssert(try moodExistsWith(rating: 7, min: 1, max: 8))
	}

	func testGivenExistingMoodOf6WithOriginalRange0To7AndNewRange1To15_scaleMoods_setsMoodTo13() throws {
		// given
		MoodDataTestUtil.createMood(rating: 6, min: 0, max: 7)
		DependencyInjector.settings.setMinMood(1)
		DependencyInjector.settings.setMaxMood(15)
		DependencyInjector.settings.save()

		// when
		try util.scaleMoods()

		// then
		XCTAssert(try moodExistsWith(rating: 13, min: 1, max: 15))
	}

	func testGivenExistingMoodOf10WithOriginalRange1To11AndNewRange0To5_scaleMoods_setsMoodTo4Point5() throws {
		// given
		MoodDataTestUtil.createMood(rating: 10, min: 1, max: 11)
		DependencyInjector.settings.setMinMood(0)
		DependencyInjector.settings.setMaxMood(5)
		DependencyInjector.settings.save()

		// when
		try util.scaleMoods()

		// then
		XCTAssert(try moodExistsWith(rating: 4.5, min: 0, max: 5))
	}

	func testGivenMultipleMoodsWithDifferentRatingsAndRanges_scaleMoods_correctlyScalesAllMoods() throws {
		// given
		MoodDataTestUtil.createMood(rating: 6, min: 0, max: 7)
		MoodDataTestUtil.createMood(rating: 4, min: 1, max: 4)
		DependencyInjector.settings.setMinMood(1)
		DependencyInjector.settings.setMaxMood(8)
		DependencyInjector.settings.save()

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
		return (try DependencyInjector.db.query(fetchRequest)).count > 0
	}
}
