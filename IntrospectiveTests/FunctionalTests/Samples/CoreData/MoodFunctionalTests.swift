//
//  MoodFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 1/14/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
@testable import Introspective

final class MoodFunctionalTests: FunctionalTest {

	private final var mood: MoodImpl!

	public final override func setUp() {
		mood = MoodDataTestUtil.createMood()
	}

	// MARK: - equalTo()

	func testGivenSameObjectTwice_equalTo_returnsTrue() {
		// when
		let areEqual = mood.equalTo(mood)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoEqualObjects_equalTo_returnsTrue() {
		// given
		let otherMood = MoodDataTestUtil.createMood(
			note: mood.note,
			rating: mood.rating,
			timestamp: mood.timestamp,
			min: mood.minRating,
			max: mood.maxRating)

		// when
		let areEqual = mood.equalTo(otherMood)

		// then
		XCTAssert(areEqual)
	}
}
