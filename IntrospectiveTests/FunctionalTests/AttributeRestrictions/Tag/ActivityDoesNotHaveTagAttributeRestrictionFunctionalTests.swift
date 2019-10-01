//
//  ActivityDoesNotHaveTagAttributeRestrictionFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/12/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import CoreData
import Hamcrest
@testable import Introspective
@testable import AttributeRestrictions
@testable import Samples

final class ActivityDoesNotHaveTagAttributeRestrictionFunctionalTests: FunctionalTest {

	private final var restriction: ActivityDoesNotHaveTagAttributeRestriction!

	final override func setUp() {
		super.setUp()
		restriction = ActivityDoesNotHaveTagAttributeRestriction(restrictedAttribute: AttributeMock())
	}

	// MARK: - predicate()

	func testGivenActivityWithSpecifiedTag_predicate_properlyFilters() throws {
		// given
		let tag = TagDataTestUtil.createTag(name: "tag1")
		ActivityDataTestUtil.createActivity(tags: [tag])
		restriction.restrictedAttribute = Activity.tagsAttribute
		restriction.tag = tag
		let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
		fetchRequest.predicate = restriction.predicate()

		// when
		let activities = try database.query(fetchRequest)

		// then
		assertThat(activities, hasCount(0))
	}

	func testGivenActivityWithoutSpecifiedTag_predicate_properlyFilters() throws {
		// given
		let tag = TagDataTestUtil.createTag(name: "tag1")
		let activity = ActivityDataTestUtil.createActivity()
		restriction.restrictedAttribute = Activity.tagsAttribute
		restriction.tag = tag
		let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
		fetchRequest.predicate = restriction.predicate()

		// when
		let activities = try database.query(fetchRequest)

		// then
		assertThat(activities, arrayHasExactly([activity], areEqual: { $0.equalTo($1) }))
	}
}
