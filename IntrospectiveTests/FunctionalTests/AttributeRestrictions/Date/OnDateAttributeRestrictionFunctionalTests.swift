//
//  OnDateAttributeRestrictionFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 6/10/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Hamcrest
import SwiftDate
import XCTest

@testable import Attributes
@testable import AttributeRestrictions
@testable import Samples

class OnDateAttributeRestrictionFunctionalTests: FunctionalTest {

	private typealias Me = OnDateAttributeRestrictionFunctionalTests
	private static let restrictedAttribute = CommonSampleAttributes.startDate

	private var restriction: OnDateAttributeRestriction!

	public final override func setUp() {
		restriction = OnDateAttributeRestriction(restrictedAttribute: Me.restrictedAttribute)
	}

	// MARK: - predicate()

	func testGivenValidInput_predicate_returnsPredicateThatCorrectlyFilters() {
		// given
		let now = Date()
		let restrictionDate = now - 2.days
		let activity1 = ActivityDataTestUtil.createActivity(name: "a", startDate: restrictionDate)
		let activity2 = ActivityDataTestUtil.createActivity(name: "b", startDate: restrictionDate)
		let activities = [activity1, activity2]
		restriction.date = restrictionDate

		// when
		guard let predicate = restriction.predicate() else {
			XCTFail("No predicate produced")
			return
		}

		// then
		assertThat(
			(activities as NSArray).filtered(using: predicate),
			hasCount(2)
		)
	}
}
