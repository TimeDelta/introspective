//
//  MoodDAOFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 6/27/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest

@testable import DependencyInjection
@testable import Samples
@testable import Settings

class MoodDAOFunctionalTests: FunctionalTest {

	// MARK: - Test Setup

	private typealias Me = MoodDAOFunctionalTests

	private static let moodInfo = MoodInfo(
		timestamp: Date(),
		timeZone: TimeZone.autoupdatingCurrent,
		rating: 2,
		minRating: injected(Settings.self).minMood,
		maxRating: injected(Settings.self).maxMood,
		source: .introspective)

	private var dao: MoodDAOImpl!

	public override final func setUp() {
		super.setUp()
		dao = MoodDAOImpl()
	}

	// MARK: - createMood()

	func testGivenValidData_createMood_setsCorrectValuesOnNewMood() throws {
		// when
		try dao.createMood(timestamp: Me.moodInfo.timestamp, rating: Me.moodInfo.rating, note: Me.moodInfo.note)

		// then
		assertThat(Me.moodInfo, exists(MoodImpl.self))
	}

	func testGivenNilMinAndMaxValues_createMood_usesCurrentMinAndMaxAsDefaults() throws {
		// when
		try dao.createMood(
			timestamp: Me.moodInfo.timestamp,
			rating: Me.moodInfo.rating,
			min: nil,
			max: nil,
			note: Me.moodInfo.note)

		// then
		assertThat(Me.moodInfo, exists(MoodImpl.self))
	}
}
