//
//  IsTodayDateAttributeRestrictionFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/16/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

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

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.value(of: Me.restrictedAttribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
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

	// MARK: - setAttributeTo()

	func testGivenUnknownAttribute_setAttributeTo_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.restrictedAttribute, to: 1 as Any)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenWrongValueTypeForTimeUnitAttribtue_setAttributeTo_throwsTypeMismatchError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.timeUnitAttribute, to: 1 as Any)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenValidValueForTimeUnitAttribute_setAttributeTo_correctlySetsTimeUnit() {
		// given
		let expectedTimeUnit = Calendar.Component.nanosecond

		// when
		try! restriction.set(attribute: Me.timeUnitAttribute, to: expectedTimeUnit)

		// then
		XCTAssertEqual(restriction.timeUnit, expectedTimeUnit)
	}

	// MARK: - samplePasses

	func testGivenSampleWithNonDateValueForGivenAttribute_samplePasses_throwsTypeMismatchError() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: 1, for: Me.restrictedAttribute)

		// when
		XCTAssertThrowsError(try restriction.samplePasses(sample)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenSampleWithDateForGivenAttributeThatIsBeforeCurrentTimeUnit_samplePasses_returnsFalse() {
		// given
		let sampleDate = Date() - 1.days
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleDate, for: Me.restrictedAttribute)
		restriction.timeUnit = .day

		// when
		let samplePasses = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(samplePasses)
	}

	func testGivenSampleWithDateForGivenAttributeThatIsAfterCurrentTimeUnit_samplePasses_returnsFalse() {
		// given
		let sampleDate = Date() + 1.weeks
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleDate, for: Me.restrictedAttribute)
		restriction.timeUnit = .weekOfYear

		// when
		let samplePasses = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(samplePasses)
	}

	func testGivenSampleWithDateForGivenAttributeThatIsInCurrentTimeUnit_samplePasses_returnsTrue() {
		// given
		let sampleDate = Date()
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleDate, for: Me.restrictedAttribute)
		restriction.timeUnit = .day

		// when
		let samplePasses = try! restriction.samplePasses(sample)

		// then
		XCTAssert(samplePasses)
	}

	func testGivenNilValueForGivenAttribute_samplePasses_returnsFalse() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as Any?, for: Me.restrictedAttribute)

		// when
		let samplePasses = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(samplePasses)
	}

	// MARK: - ==

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() {
		// when / then
		XCTAssert(restriction == restriction)
	}

	func testGivenSameClassWithDifferentRestrictedAttributes_equalToOperator_returnsFalse() {
		// given
		let otherRestriction = InCurrentTimeUnitDateAttributeRestriction(
			restrictedAttribute: DateTimeAttribute(name: "not the same attribute"),
			restriction.timeUnit)

		// when / then
		XCTAssertFalse(restriction == otherRestriction)
	}

	func testGivenSameClassWithDifferentTimeUnits_equalToOperator_returnsFalse() {
		// given
		let otherRestriction = InCurrentTimeUnitDateAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			.nanosecond)

		// when / then
		XCTAssertFalse(restriction == otherRestriction)
	}

	func testGivenSameClassWithAllSameAttributes_equalToOperator_returnsTrue() {
		// given
		let otherRestriction = InCurrentTimeUnitDateAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
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
		let otherAttributed: Attributed = InCurrentTimeUnitDateAttributeRestriction(
			restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithDifferentTimeUnits_equalToAttributed_returnsFalse() {
		// given
		let otherAttributed: Attributed = InCurrentTimeUnitDateAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			.nanosecond)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithAllSameAttributes_equalToAttributed_returnsTrue() {
		// given
		let otherAttributed: Attributed = InCurrentTimeUnitDateAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo(restriction:)

	func testGivenDifferentClass_equalToRestriction_returnsFalse() {
		// given
		let otherAttributed: AttributeRestriction = LessThanDoubleAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherAttributed)

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
		let otherAttributed: AttributeRestriction = InCurrentTimeUnitDateAttributeRestriction(
			restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"),
			restriction.timeUnit)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithDifferentTimeUnits_equalToRestriction_returnsFalse() {
		// given
		let otherAttributed: AttributeRestriction = InCurrentTimeUnitDateAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			.nanosecond)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameRestrictedAttributes_equalToRestriction_returnsTrue() {
		// given
		let otherAttributed: AttributeRestriction = InCurrentTimeUnitDateAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherAttributed)

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

	func testGivenSameClassWithDifferentRestrictedAttributes_equalTo_returnsFalse() {
		// given
		let other = InCurrentTimeUnitDateAttributeRestriction(restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithDifferentTimeUnits_equalTo_returnsFalse() {
		// given
		let other = InCurrentTimeUnitDateAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			.nanosecond)

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithSameRestrictedAttributes_equalTo_returnsTrue() {
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
