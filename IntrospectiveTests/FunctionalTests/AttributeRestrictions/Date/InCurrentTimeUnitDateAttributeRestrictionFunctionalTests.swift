//
//  IsTodayDateAttributeRestrictionFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/16/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
import Hamcrest
@testable import Introspective
@testable import AttributeRestrictions
@testable import Attributes
@testable import Queries

class InCurrentTimeUnitDateAttributeRestrictionFunctionalTests: FunctionalTest {

	private typealias Me = InCurrentTimeUnitDateAttributeRestrictionFunctionalTests
	private static let restrictedAttribute = DateTimeAttribute(name: "this is a date")
	private static let timeUnitAttribute = InCurrentTimeUnitDateAttributeRestriction.timeUnitAttribute

	private var restriction: InCurrentTimeUnitDateAttributeRestriction!

	override func setUp() {
		super.setUp()
		restriction = InCurrentTimeUnitDateAttributeRestriction(restrictedAttribute: Me.restrictedAttribute)
	}

	// MARK: - valueOf()

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() throws {
		// when
		XCTAssertThrowsError(try restriction.value(of: Me.restrictedAttribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenTimeUnitAttribute_valueOf_returnsCorrectValue() throws {
		// given
		let expectedTimeUnit = Calendar.Component.hour
		restriction.timeUnit = expectedTimeUnit

		// when
		let actualTimeUnit = try restriction.value(of: Me.timeUnitAttribute) as! Calendar.Component

		// then
		XCTAssertEqual(actualTimeUnit, expectedTimeUnit)
	}

	// MARK: - setAttributeTo()

	func testGivenUnknownAttribute_setAttributeTo_throwsUnknownAttributeError() throws {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.restrictedAttribute, to: 1 as Any)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenWrongValueTypeForTimeUnitAttribtue_setAttributeTo_throwsTypeMismatchError() throws {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.timeUnitAttribute, to: 1 as Any)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenValidValueForTimeUnitAttribute_setAttributeTo_correctlySetsTimeUnit() throws {
		// given
		let expectedTimeUnit = Calendar.Component.nanosecond

		// when
		try restriction.set(attribute: Me.timeUnitAttribute, to: expectedTimeUnit)

		// then
		XCTAssertEqual(restriction.timeUnit, expectedTimeUnit)
	}

	// MARK: - samplePasses

	func testGivenSampleWithNonDateValueForGivenAttribute_samplePasses_throwsTypeMismatchError() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: 1, for: Me.restrictedAttribute)

		// when
		XCTAssertThrowsError(try restriction.samplePasses(sample)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenSampleWithDateForGivenAttributeThatIsBeforeCurrentTimeUnit_samplePasses_returnsFalse() throws {
		// given
		let sampleDate = Date() - 1.days
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleDate, for: Me.restrictedAttribute)
		restriction.timeUnit = .day

		// when
		let samplePasses = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(samplePasses)
	}

	func testGivenSampleWithDateForGivenAttributeThatIsAfterCurrentTimeUnit_samplePasses_returnsFalse() throws {
		// given
		let sampleDate = Date() + 1.weeks
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleDate, for: Me.restrictedAttribute)
		restriction.timeUnit = .weekOfYear

		// when
		let samplePasses = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(samplePasses)
	}

	func testGivenSampleWithDateForGivenAttributeThatIsInCurrentTimeUnit_samplePasses_returnsTrue() throws {
		// given
		let sampleDate = Date()
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleDate, for: Me.restrictedAttribute)
		restriction.timeUnit = .day

		// when
		let samplePasses = try restriction.samplePasses(sample)

		// then
		XCTAssert(samplePasses)
	}

	func testGivenNilValueForGivenAttribute_samplePasses_returnsFalse() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as Any?, for: Me.restrictedAttribute)

		// when
		let samplePasses = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(samplePasses)
	}

	func testGivenDateWithTargetDayFromWrongMonthOrYear_samplePasses_returnsFalse() throws {
		// given
		let targetDay = Date().dateComponents[.day]!
		let sampleDate = Date(year: 2019, month: 1, day: targetDay, hour: 0, minute: 0)
		restriction.timeUnit = .day
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleDate, for: Me.restrictedAttribute)

		// when
		let samplePasses = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(samplePasses)
	}

	// MARK: - copy()

	func test_copy_returnsCopy() throws {
		// when
		let copy = restriction.copy()

		// then
		guard let castedCopy = copy as? InCurrentTimeUnitDateAttributeRestriction else {
			XCTFail("Wrong type returned")
			return
		}
		assertThat(castedCopy, equals(restriction))
	}

	// MARK: - ==

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() throws {
		// when / then
		XCTAssert(restriction == restriction)
	}

	func testGivenSameClassWithDifferentRestrictedAttributes_equalToOperator_returnsFalse() throws {
		// given
		let otherRestriction = InCurrentTimeUnitDateAttributeRestriction(
			restrictedAttribute: DateTimeAttribute(name: "not the same attribute"),
			restriction.timeUnit)

		// when / then
		XCTAssertFalse(restriction == otherRestriction)
	}

	func testGivenSameClassWithDifferentTimeUnits_equalToOperator_returnsFalse() throws {
		// given
		let otherRestriction = InCurrentTimeUnitDateAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			.nanosecond)

		// when / then
		XCTAssertFalse(restriction == otherRestriction)
	}

	func testGivenSameClassWithAllSameAttributes_equalToOperator_returnsTrue() throws {
		// given
		let otherRestriction = InCurrentTimeUnitDateAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			restriction.timeUnit)

		// when / then
		XCTAssert(restriction == otherRestriction)
	}

	// MARK: - equalTo(attributed:)

	func testGivenOtherOfDifferentTypes_equalToAttributed_returnsFalse() throws {
		// given
		let otherAttributed: Attributed = SameDatesSubQueryMatcher()

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameObjectTwice_equalToAttributed_returnsTrue() throws {
		// when
		let equal = restriction.equalTo(restriction as Attributed)

		// then
		XCTAssert(equal)
	}

	func testGivenSameClassWithDifferentRestrictedAttributes_equalToAttributed_returnsFalse() throws {
		// given
		let otherAttributed: Attributed = InCurrentTimeUnitDateAttributeRestriction(
			restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithDifferentTimeUnits_equalToAttributed_returnsFalse() throws {
		// given
		let otherAttributed: Attributed = InCurrentTimeUnitDateAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			.nanosecond)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithAllSameAttributes_equalToAttributed_returnsTrue() throws {
		// given
		let otherAttributed: Attributed = InCurrentTimeUnitDateAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo(restriction:)

	func testGivenDifferentClass_equalToRestriction_returnsFalse() throws {
		// given
		let otherAttributed: AttributeRestriction = LessThanDoubleAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameObjectTwice_equalToRestriction_returnsTrue() throws {
		// when
		let equal = restriction.equalTo(restriction as AttributeRestriction)

		// then
		XCTAssert(equal)
	}

	func testGivenSameClassWithDifferentRestrictedAttributes_equalToRestriction_returnsFalse() throws {
		// given
		let otherAttributed: AttributeRestriction = InCurrentTimeUnitDateAttributeRestriction(
			restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"),
			restriction.timeUnit)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithDifferentTimeUnits_equalToRestriction_returnsFalse() throws {
		// given
		let otherAttributed: AttributeRestriction = InCurrentTimeUnitDateAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			.nanosecond)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameRestrictedAttributes_equalToRestriction_returnsTrue() throws {
		// given
		let otherAttributed: AttributeRestriction = InCurrentTimeUnitDateAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo()

	func testGivenSameObjectTwice_equalTo_returnsTrue() throws {
		// when
		let equal = restriction.equalTo(restriction)

		// then
		XCTAssert(equal)
	}

	func testGivenSameClassWithDifferentRestrictedAttributes_equalTo_returnsFalse() throws {
		// given
		let other = InCurrentTimeUnitDateAttributeRestriction(restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithDifferentTimeUnits_equalTo_returnsFalse() throws {
		// given
		let other = InCurrentTimeUnitDateAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			.nanosecond)

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithSameRestrictedAttributes_equalTo_returnsTrue() throws {
		// given
		let other = InCurrentTimeUnitDateAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			restriction.timeUnit)

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssert(equal)
	}

	private final func oldDate() -> Date {
		var dateComponents: DateComponents = DateComponents()
		dateComponents.year = 1998
		dateComponents.month = 1
		dateComponents.day = 1

		return Calendar.autoupdatingCurrent.date(from: dateComponents)!
	}
}
