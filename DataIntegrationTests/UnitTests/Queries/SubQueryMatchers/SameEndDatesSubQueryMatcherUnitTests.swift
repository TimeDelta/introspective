//
//  SameEndDatesSubQueryMatcherUnitTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
@testable import DataIntegration

class SameEndDatesSubQueryMatcherUnitTests: UnitTest {

	fileprivate var matcher: SameEndDatesSubQueryMatcher!

	override func setUp() {
		super.setUp()
		matcher = SameEndDatesSubQueryMatcher()
	}

	func testGivenUnknownAttribute_set_throwsUnknownAttributeError() {
		// given
		let attribute = CommonSampleAttributes.endDate
		let value = 1

		// when
		XCTAssertThrowsError(try matcher.set(attribute: attribute, to: value)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.unknownAttribute)
		}
	}

	func testGivenMostRecentOnlyAttributeWithInvalidValue_set_throwsTypeMismatchError() {
		// given
		let attribute = CommonSubQueryMatcherAttributes.mostRecentOnly
		let value = "abc"

		// when
		XCTAssertThrowsError(try matcher.set(attribute: attribute, to: value)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.typeMismatch)
		}
	}

	func testGivenMostRecentOnlyAttributeWithValidValue_set_correctlySetsValue() {
		// given
		let attribute = CommonSubQueryMatcherAttributes.mostRecentOnly
		let value = true

		// when
		try! matcher.set(attribute: attribute, to: value)

		// then
		XCTAssert(matcher.mostRecentOnly == value)
	}

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// given
		let attribute = CommonSampleAttributes.endDate

		// when
		XCTAssertThrowsError(try matcher.value(of: attribute)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.unknownAttribute)
		}
	}

	func testGivenMostRecentOnlyAttribute_valueOf_returnsCorrectValue() {
		// given
		let attribute = CommonSubQueryMatcherAttributes.mostRecentOnly
		let expectedValue = true
		matcher.mostRecentOnly = expectedValue

		// when
		let actualValue = try! matcher.value(of: attribute) as! Bool

		// then
		XCTAssert(actualValue == expectedValue)
	}

	func testGivenTwoMatchersOfDifferentTypes_equalToAttributed_returnsFalse() {
		// given
		let otherAttributed: Attributed = WithinXCalendarUnitsSubQueryMatcher()

		// when
		let equal = matcher.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameObjectTwice_equalToAttributed_returnsTrue() {
		// when
		let equal = matcher.equalTo(matcher as Attributed)

		// then
		XCTAssert(equal)
	}

	func testGivenSameMatcherTypeWithDifferentMostRecentOnly_equalToAttributed_returnsFalse() {
		// given
		let otherAttributed: Attributed = SameEndDatesSubQueryMatcher(mostRecentOnly: true)

		// when
		let equal = matcher.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToAttributed_returnsTrue() {
		// given
		let otherAttributed: Attributed = SameEndDatesSubQueryMatcher()

		// when
		let equal = matcher.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}

	func testGivenTwoMatchersOfDifferentTypes_equalToMatcher_returnsFalse() {
		// given
		let otherMatcher: SubQueryMatcher = WithinXCalendarUnitsSubQueryMatcher()

		// when
		let equal = matcher.equalTo(otherMatcher)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameObjectTwice_equalToMatcher_returnsTrue() {
		// when
		let equal = matcher.equalTo(matcher as SubQueryMatcher)

		// then
		XCTAssert(equal)
	}

	func testGivenSameMatcherTypeWithDifferentMostRecentOnly_equalToMatcher_returnsFalse() {
		// given
		let otherMatcher: SubQueryMatcher = SameEndDatesSubQueryMatcher(mostRecentOnly: true)

		// when
		let equal = matcher.equalTo(otherMatcher)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToMatcher_returnsTrue() {
		// given
		let otherMatcher: SubQueryMatcher = SameEndDatesSubQueryMatcher()

		// when
		let equal = matcher.equalTo(otherMatcher)

		// then
		XCTAssert(equal)
	}

	func testGivenSameObjectTwice_equalTo_returnsTrue() {
		// when
		let equal = matcher.equalTo(matcher)

		// then
		XCTAssert(equal)
	}

	func testGivenSameMatcherTypeWithDifferentMostRecentOnly_equalTo_returnsFalse() {
		// given
		let other = SameEndDatesSubQueryMatcher(mostRecentOnly: true)

		// when
		let equal = matcher.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalTo_returnsTrue() {
		// given
		let other = SameEndDatesSubQueryMatcher()

		// when
		let equal = matcher.equalTo(other)

		// then
		XCTAssert(equal)
	}
}
