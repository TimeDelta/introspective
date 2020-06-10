//
//  InThePastXTimeUnitsDateAttributeRestrictionUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/18/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import SwiftDate
@testable import Introspective
@testable import AttributeRestrictions
@testable import Attributes
@testable import Queries

final class InThePastXTimeUnitsDateAttributeRestrictionFunctionalTests: FunctionalTest {

	private typealias Me = InThePastXTimeUnitsDateAttributeRestrictionFunctionalTests
	private static let restrictedAttribute = DateTimeAttribute(name: "restricted attribute")
	private static let timeUnitAttribute = InThePastXTimeUnitsDateAttributeRestriction.timeUnitAttribute
	private static let numberOfTimeUnitsAttribute = InThePastXTimeUnitsDateAttributeRestriction.numberOfTimeUnitsAttribute

	private var restriction: InThePastXTimeUnitsDateAttributeRestriction!

	final override func setUp() {
		super.setUp()
		restriction = InThePastXTimeUnitsDateAttributeRestriction(restrictedAttribute: Me.restrictedAttribute)
	}

	// MARK: - description

	func test_description_containsNumberOfTimeUnits() {
		// given
		let numberOfTimeUnits = 4
		restriction.numberOfTimeUnits = numberOfTimeUnits

		// when
		let description = restriction.description

		// then
		assertThat(description, containsString(String(numberOfTimeUnits)))
	}

	func test_description_containsTimeUnit() {
		// given
		let timeUnit = Calendar.Component.day
		restriction.timeUnit = timeUnit

		// when
		let description = restriction.description

		// then
		assertThat(description, containsString(timeUnit.description))
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.value(of: Me.restrictedAttribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenNumberOfTimeUnitsAttribute_valueOf_returnsCorrectValue() {
		// given
		let expectedNumberOfTimeUnits = 32
		restriction.numberOfTimeUnits = expectedNumberOfTimeUnits

		// when
		let actualNumberOfTimeUnits = try! restriction.value(of: Me.numberOfTimeUnitsAttribute) as! Int

		// then
		XCTAssertEqual(actualNumberOfTimeUnits, expectedNumberOfTimeUnits)
	}

	func testGivenTimeUnitAttribute_valueOf_returnsCorrectValue() {
		// given
		let expectedTimeUnit = Calendar.Component.hour
		restriction.timeUnit = expectedTimeUnit

		// when
		let actualTimeUnit = try! restriction.value(of: Me.timeUnitAttribute) as! Calendar.Component

		// then
		XCTAssertEqual(actualTimeUnit, expectedTimeUnit)
	}

	// MARK: - set(attribute: to:)

	func testGivenUnknownAttribute_setAttributeTo_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.restrictedAttribute, to: 1 as Any)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenWrongValueTypeForNumberOfTimeUnitAttributes_setAttributeTo_throwsTypeMismatchError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.numberOfTimeUnitsAttribute, to: "string" as Any)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenWrongValueTypeForTimeUnitAttribute_setAttributeTo_throwsTypeMismatchError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.timeUnitAttribute, to: 1 as Any)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenTimeUnitAttributeAndValidValue_setAttributeTo_setsToCorrectValue() {
		// given
		let expectedTimeUnit = Calendar.Component.day

		// when
		try! restriction.set(attribute: Me.timeUnitAttribute, to: expectedTimeUnit)

		// then
		XCTAssertEqual(restriction.timeUnit, expectedTimeUnit)
	}

	func testGivenNumberOfTimeUnitsAttributeAndValidValue_setAttributeTo_setsToCorrectValue() {
		// given
		let expectedNumberOfTimeUnits = 234

		// when
		try! restriction.set(attribute: Me.numberOfTimeUnitsAttribute, to: expectedNumberOfTimeUnits)

		// then
		XCTAssertEqual(restriction.numberOfTimeUnits, expectedNumberOfTimeUnits)
	}

	// MARK: - samplePasses()

	func testGivenSampleWithNilValueForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as Any?, for: Me.restrictedAttribute)

		// when
		let samplePasses = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(samplePasses)
	}

	func testGivenSampleWithWrongValueTypeForRestrictedAttribute_samplePasses_throwsTypeMismatchError() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: 1, for: Me.restrictedAttribute)

		// when
		XCTAssertThrowsError(try restriction.samplePasses(sample)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenSampleWithDateForRestrictedAttributeThatIsMoreThanXTimeUnitsAgo1_samplePasses_returnsFalse() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: Date() - 1.days - 1.hours, for: Me.restrictedAttribute)
		restriction.numberOfTimeUnits = 1
		restriction.timeUnit = .day

		// when
		let samplePasses = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(samplePasses)
	}

	func testGivenSampleWithDateForRestrictedAttributeThatIsMoreThanXTimeUnitsAgo2_samplePasses_returnsFalse() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: Date() - 1.weeks - 1.days, for: Me.restrictedAttribute)
		restriction.numberOfTimeUnits = 1
		restriction.timeUnit = .weekOfYear

		// when
		let samplePasses = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(samplePasses)
	}

	func testGivenSampleWithDateForRestrictedAttributeThatIsInTheFuture_samplePasses_returnsFalse() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: Date() + 1.hours, for: Me.restrictedAttribute)
		restriction.numberOfTimeUnits = 1
		restriction.timeUnit = .day

		// when
		let samplePasses = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(samplePasses)
	}

	func testGivenSampleWithDateForRestrictedAttributeThatIsWithinThePastXTimeUnits_samplePasses_returnsTrue() {
		// given
		let maxNumberOfDaysAgo = 2
		restriction.numberOfTimeUnits = maxNumberOfDaysAgo
		restriction.timeUnit = .day
		let sampleDate = Date() - (maxNumberOfDaysAgo - 1).days
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleDate, for: Me.restrictedAttribute)

		// when
		let samplePasses = try! restriction.samplePasses(sample)

		// then
		XCTAssert(samplePasses)
	}

	// MARK: - copy()

	func test_copy_returnsCopy() {
		// when
		let copy = restriction.copy()

		// then
		guard let castedCopy = copy as? InThePastXTimeUnitsDateAttributeRestriction else {
			XCTFail("Wrong type returned")
			return
		}
		assertThat(castedCopy, equals(restriction))
	}

	// MARK: - ==

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() {
		// when / then
		XCTAssert(restriction == restriction)
	}

	func testGivenSameClassWithDifferentAttributes_equalToOperator_returnsFalse() {
		// given
		let otherRestriction = InThePastXTimeUnitsDateAttributeRestriction(
			restrictedAttribute: DateTimeAttribute(name: "not the same attribute"),
			restriction.numberOfTimeUnits,
			restriction.timeUnit)

		// when / then
		XCTAssertFalse(restriction == otherRestriction)
	}

	func testGivenSameClassWithSameRestrictedAttributeButDifferentNumberOfTimeUnitAttributes_equalToOperator_returnsFalse() {
		// given
		let otherRestriction = InThePastXTimeUnitsDateAttributeRestriction(
			restrictedAttribute: Me.restrictedAttribute,
			restriction.numberOfTimeUnits + 1,
			restriction.timeUnit)

		// when / then
		XCTAssertFalse(restriction == otherRestriction)
	}

	func testGivenSameClassWithSameRestrictedAttributeButDifferentTimeUnitAttribtue_equalToOperator_returnsFalse() {
		// given
		let otherRestriction = InThePastXTimeUnitsDateAttributeRestriction(
			restrictedAttribute: Me.restrictedAttribute,
			restriction.numberOfTimeUnits,
			.nanosecond)

		// when / then
		XCTAssertFalse(restriction == otherRestriction)
	}

	func testGivenSameClassWithAllSameAttributes_equalToOperator_returnsTrue() {
		// given
		let otherRestriction = InThePastXTimeUnitsDateAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			restriction.numberOfTimeUnits,
			restriction.timeUnit)

		// when / then
		XCTAssert(restriction == otherRestriction)
	}

	// MARK: - equalTo(attributed:)

	func testGivenOtherOfDifferentTypes_equalToAttributed_returnsFalse() {
		// given
		let otherAttributed: Attributed = SameDatesSubQueryMatcher()

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameObjectTwice_equalToAttributed_returnsTrue() {
		// when
		let equal = restriction.equalTo(restriction as Attributed)

		// then
		XCTAssert(equal)
	}

	func testGivenSameClassWithDifferentRestrictedAttributes_equalToAttributed_returnsFalse() {
		// given
		let otherAttributed: Attributed = InThePastXTimeUnitsDateAttributeRestriction(
			restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"),
			restriction.numberOfTimeUnits,
			restriction.timeUnit)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameRestrictedAttributeButDifferentTimeUnitAttributes_equalToAttributed_returnsFalse() {
		// given
		let otherAttributed: Attributed = InThePastXTimeUnitsDateAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			restriction.numberOfTimeUnits,
			.nanosecond)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameRestrictedAttributeButDifferentNumberOfTimeUnitsAttributes_equalToAttributed_returnsFalse() {
		// given
		let otherAttributed: Attributed = InThePastXTimeUnitsDateAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			restriction.numberOfTimeUnits + 1,
			restriction.timeUnit)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithAllSameAttributes_equalToAttributed_returnsTrue() {
		// given
		let otherAttributed: Attributed = InThePastXTimeUnitsDateAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			restriction.numberOfTimeUnits,
			restriction.timeUnit)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo(restriction:)

	func testGivenDifferentClasses_equalToRestriction_returnsFalse() {
		// given
		let otherRestriction: AttributeRestriction = BeforeDateAttributeRestriction(restrictedAttribute: Me.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherRestriction)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameObjectTwice_equalToRestriction_returnsTrue() {
		// when
		let equal = restriction.equalTo(restriction as AttributeRestriction)

		// then
		XCTAssert(equal)
	}

	func testGivenSameClassWithDifferentRestrictedAttributes_equalToRestriction_returnsFalse() {
		// given
		let otherRestriction: AttributeRestriction = InThePastXTimeUnitsDateAttributeRestriction(
			restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"),
			restriction.numberOfTimeUnits,
			restriction.timeUnit)

		// when
		let equal = restriction.equalTo(otherRestriction)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameRestrictedAttributeButDifferentTimeUnitAttributes_equalToRestriction_returnsFalse() {
		// given
		let otherRestriction: AttributeRestriction = InThePastXTimeUnitsDateAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			restriction.numberOfTimeUnits,
			.nanosecond)

		// when
		let equal = restriction.equalTo(otherRestriction)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameRestrictedAttributeButDifferentNumberOfTimeUnitsAttributes_equalToRestriction_returnsFalse() {
		// given
		let otherRestriction: AttributeRestriction = InThePastXTimeUnitsDateAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			restriction.numberOfTimeUnits + 1,
			restriction.timeUnit)

		// when
		let equal = restriction.equalTo(otherRestriction)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithAllSameAttributes_equalToRestriction_returnsTrue() {
		// given
		let otherRestriction: AttributeRestriction = InThePastXTimeUnitsDateAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			restriction.numberOfTimeUnits,
			restriction.timeUnit)

		// when
		let equal = restriction.equalTo(otherRestriction)

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo()

	func testGivenSameObjectTwice_equalTo_returnsTrue() {
		// when
		let equal = restriction.equalTo(restriction)

		// then
		XCTAssert(equal)
	}

	func testGivenSameClassWithDifferentAttributes_equalTo_returnsFalse() {
		// given
		let other = InThePastXTimeUnitsDateAttributeRestriction(restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameRestrictedAttributeButDifferentTimeUnitAttributes_equalTo_returnsFalse() {
		// given
		let other = InThePastXTimeUnitsDateAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			restriction.numberOfTimeUnits,
			.nanosecond)

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameRestrictedAttributeButDifferentNumberOfTimeUnitsAttributes_equalTo_returnsFalse() {
		// given
		let other = InThePastXTimeUnitsDateAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			restriction.numberOfTimeUnits + 1,
			restriction.timeUnit)

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalTo_returnsTrue() {
		// given
		let other = InThePastXTimeUnitsDateAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			restriction.numberOfTimeUnits,
			restriction.timeUnit)

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssert(equal)
	}
}
