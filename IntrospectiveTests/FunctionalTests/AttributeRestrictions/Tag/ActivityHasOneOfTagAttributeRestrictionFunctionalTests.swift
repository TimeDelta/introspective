//
//  ActivityHasOneOfTagAttributeRestrictionFunctionalTests.swift
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

final class ActivityHasOneOfTagAttributeRestrictionFunctionalTests: FunctionalTest {

	private final var restriction: ActivityHasOneOfTagAttributeRestriction!

	final override func setUp() {
		super.setUp()
		restriction = ActivityHasOneOfTagAttributeRestriction(restrictedAttribute: AttributeMock())
	}

	// MARK: - predicate()

	func testGivenActivityWithOneOfSpecifiedTags_predicate_properlyFilters() throws {
		// given
		let tag1 = TagDataTestUtil.createTag(name: "tag1")
		let tag2 = TagDataTestUtil.createTag(name: "tag2")
		let activity = ActivityDataTestUtil.createActivity(tags: [tag2])
		restriction.restrictedAttribute = Activity.tagsAttribute
		restriction.tags = [tag1, tag2]
		let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
		fetchRequest.predicate = restriction.predicate()

		// when
		let activities = try database.query(fetchRequest)

		// then
		assertThat(activities, arrayHasExactly([activity], areEqual: { $0.equalTo($1) }))
	}

	func testGivenActivityWithoutOneOfSpecifiedTags_predicate_properlyFilters() throws {
		// given
		let tag = TagDataTestUtil.createTag(name: "tag1")
		ActivityDataTestUtil.createActivity()
		restriction.restrictedAttribute = Activity.tagsAttribute
		restriction.tags = [tag]
		let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
		fetchRequest.predicate = restriction.predicate()

		// when
		let activities = try database.query(fetchRequest)

		// then
		assertThat(activities, hasCount(0))
	}
}
