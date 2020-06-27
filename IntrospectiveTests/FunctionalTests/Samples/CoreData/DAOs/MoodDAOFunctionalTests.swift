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

	private static let moodInfo1 = MoodInfo(
		timestamp: Date(),
		timeZone: TimeZone.autoupdatingCurrent,
		rating: 2,
		minRating: DependencyInjector.get(Settings.self).minMood,
		maxRating: DependencyInjector.get(Settings.self).maxMood,
		source: .introspective)

	private var dao: MoodDAOImpl!

	public override final func setUp() {
		super.setUp()
		dao = MoodDAOImpl()
	}

	// MARK: - createMood()

	func testGivenValidData_createMood_setsCorrectValuesOnNewMood() throws {
		// when
		try dao.createMood(timestamp: Me.moodInfo1.timestamp, rating: Me.moodInfo1.rating, note: Me.moodInfo1.note)

		// then
		assertThat(Me.moodInfo1, exists(MoodImpl.self))
	}
}
