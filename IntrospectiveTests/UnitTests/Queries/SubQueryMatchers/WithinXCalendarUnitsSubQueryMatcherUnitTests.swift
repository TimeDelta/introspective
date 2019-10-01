//
//  WithinXCalendarUnitsSubQueryMatcherUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import SwiftDate
@testable import Introspective
@testable import Attributes
@testable import Queries
@testable import Samples

class WithinXCalendarUnitsSubQueryMatcherUnitTests: UnitTest {

	private var matcher: WithinXCalendarUnitsSubQueryMatcher!

	override func setUp() {
		super.setUp()
		matcher = WithinXCalendarUnitsSubQueryMatcher()
	}

	// MARK: - getSamples()

	func testGivenEmptyArrayOfQuerySamplesAndEmptyArrayOfSubQuerySamples_getSamples_returnsEmptyArray() {
		// given
		let querySamples = [AnySample]()
		let subQuerySamples = [Sample]()

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 0)
	}

	func testGivenEmptyArrayOfQuerySamplesAndNonEmptyArrayOfSubQuerySamples_getSamples_returnsEmptyArray() {
		// given
		let querySamples = [AnySample]()
		let subQuerySamples = SampleCreatorTestUtil.createSamples(count: 2)

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 0)
	}

	func testGivenEmptyArrayOfSubQuerySamplesAndNonEmptyArrayOfQuerySamples_getSamples_returnsEmptyArray() {
		// given
		let querySamples = SampleCreatorTestUtil.createSamples(count: 2)
		let subQuerySamples = [Sample]()

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 0)
	}

	func testGivenOneSubQuerySampleAndMultipleQuerySamples_getSamples_returnsOnlyMatchingSamples() {
		// given
		matcher.numberOfTimeUnits = 1
		matcher.timeUnit = .day
		let querySamples = SampleCreatorTestUtil.createSamples(withDates: [Date() - 1.days, Date()])
		let subQuerySamples = [SampleCreatorTestUtil.createSample(startDate: Date() + 1.days)] as [Sample]
		Given(mockSearchUtil, .closestItem(to: .value(querySamples[0]), in: .value(subQuerySamples), distance: Parameter<(Sample, Sample) -> Int>._, willReturn: subQuerySamples[0]))
		Given(mockSearchUtil, .closestItem(to: .value(querySamples[1]), in: .value(subQuerySamples), distance: Parameter<(Sample, Sample) -> Int>._, willReturn: subQuerySamples[0]))
		Given(mockSampleUtil, .distance(
			between: .value(querySamples[0]),
			and: .value(subQuerySamples[0]),
			in: .value(matcher.timeUnit),
			willReturn: matcher.numberOfTimeUnits + 1))
		Given(mockSampleUtil, .distance(
			between: .value(querySamples[1]),
			and: .value(subQuerySamples[0]),
			in: .value(matcher.timeUnit),
			willReturn: matcher.numberOfTimeUnits))

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 1)
		XCTAssert(matchingSamples[0].equalTo(querySamples[1]))
	}

	func testGivenMultipleSubQuerySamplesAndMultipleQuerySamples_getSamples_returnsOnlyMatchingSamples() {
		// given
		matcher.numberOfTimeUnits = 1
		matcher.timeUnit = .day
		let querySamples = SampleCreatorTestUtil.createSamples(withDates: [Date() - 1.days, Date()])
		let subQuerySamples = SampleCreatorTestUtil.createSamples(withDates: [Date() - 3.days + 1.hours, Date() + 1.days]) as [Sample]
		Given(mockSearchUtil, .closestItem(to: .value(querySamples[0]), in: .value(subQuerySamples), distance: Parameter<(Sample, Sample) -> Int>._, willReturn: subQuerySamples[0]))
		Given(mockSearchUtil, .closestItem(to: .value(querySamples[1]), in: .value(subQuerySamples), distance: Parameter<(Sample, Sample) -> Int>._, willReturn: subQuerySamples[1]))
		Given(mockSampleUtil, .distance(
			between: .value(querySamples[0]),
			and: .value(subQuerySamples[0]),
			in: .value(matcher.timeUnit),
			willReturn: matcher.numberOfTimeUnits + 1))
		Given(mockSampleUtil, .distance(
			between: .value(querySamples[1]),
			and: .value(subQuerySamples[1]),
			in: .value(matcher.timeUnit),
			willReturn: matcher.numberOfTimeUnits))

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 1)
		XCTAssert(matchingSamples[0].equalTo(querySamples[1]))
	}

	func testGivenMostRecentOnlyIsTrueAndMultipleSubQuerySamplesAndMultipleQuerySamples_getSamples_returnsOnlyMatchingSamples() {
		// given
		matcher.mostRecentOnly = true
		matcher.numberOfTimeUnits = 1
		matcher.timeUnit = .day
		let querySamples = SampleCreatorTestUtil.createSamples(withDates: [Date() - 1.days, Date()])
		let subQuerySamples = SampleCreatorTestUtil.createSamples(withDates: [Date() - 3.days + 1.hours, Date() + 1.days]) as [Sample]
		Given(mockSampleUtil, .sort(samples: .value(subQuerySamples), by: .value(.start), in: .value(.orderedDescending), willReturn: subQuerySamples.reversed()))
		Given(mockSampleUtil, .closestInTimeTo(sample: .value(querySamples[0]), in: .value([subQuerySamples[1]]), willReturn: subQuerySamples[1]))
		Given(mockSearchUtil, .closestItem(to: .value(querySamples[0]), in: .value([subQuerySamples[1]]), distance: Parameter<(Sample, Sample) -> Int>._, willReturn: subQuerySamples[1]))
		Given(mockSearchUtil, .closestItem(to: .value(querySamples[1]), in: .value([subQuerySamples[1]]), distance: Parameter<(Sample, Sample) -> Int>._, willReturn: subQuerySamples[1]))
		Given(mockSampleUtil, .distance(
			between: .value(querySamples[0]),
			and: .value(subQuerySamples[1]),
			in: .value(matcher.timeUnit),
			willReturn: matcher.numberOfTimeUnits + 1))
		Given(mockSampleUtil, .distance(
			between: .value(querySamples[1]),
			and: .value(subQuerySamples[1]),
			in: .value(matcher.timeUnit),
			willReturn: matcher.numberOfTimeUnits))

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 1)
		XCTAssert(matchingSamples[0].equalTo(querySamples[1]))
	}

	// MARK: - set(attribute: to:)

	func testGivenUnknownAttribute_set_throwsUnknownAttributeError() {
		// given
		let attribute = CommonSampleAttributes.endDate
		let value = 1

		// when
		XCTAssertThrowsError(try matcher.set(attribute: attribute, to: value)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenAmountOfTimeAttributeWithInvalidValue_set_throwsTypeMismatchError() {
		// given
		let attribute = WithinXCalendarUnitsSubQueryMatcher.amountOfTime
		let value = "abc"

		// when
		XCTAssertThrowsError(try matcher.set(attribute: attribute, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenAmountOfTimeAttributeWithValidValue_set_correctlySetsValue() {
		// given
		let attribute = WithinXCalendarUnitsSubQueryMatcher.amountOfTime
		let value = 5

		// when
		try! matcher.set(attribute: attribute, to: value)

		// then
		XCTAssert(matcher.numberOfTimeUnits == value)
	}

	func testGivenTimeUnitAttributeWithInvalidValue_set_throwsTypeMismatchError() {
		// given
		let attribute = WithinXCalendarUnitsSubQueryMatcher.timeUnit
		let value = "abc"

		// when
		XCTAssertThrowsError(try matcher.set(attribute: attribute, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenTimeUnitAttributeWithValidValue_set_correctlySetsValue() {
		// given
		let attribute = WithinXCalendarUnitsSubQueryMatcher.timeUnit
		let value = Calendar.Component.day

		// when
		try! matcher.set(attribute: attribute, to: value)

		// then
		XCTAssert(matcher.timeUnit == value)
	}

	func testGivenMostRecentOnlyAttributeWithInvalidValue_set_throwsTypeMismatchError() {
		// given
		let attribute = CommonSubQueryMatcherAttributes.mostRecentOnly
		let value = "abc"

		// when
		XCTAssertThrowsError(try matcher.set(attribute: attribute, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
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

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// given
		let attribute = CommonSampleAttributes.endDate

		// when
		XCTAssertThrowsError(try matcher.value(of: attribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenAmountOfTimeAttribute_valueOf_returnsCorrectValue() {
		// given
		let attribute = WithinXCalendarUnitsSubQueryMatcher.amountOfTime
		let expectedValue = 54
		matcher.numberOfTimeUnits = expectedValue

		// when
		let actualValue = try! matcher.value(of: attribute) as! Int

		// then
		XCTAssert(actualValue == expectedValue)
	}

	func testGivenTimeUnitAttribute_valueOf_returnsCorrectValue() {
		// given
		let attribute = WithinXCalendarUnitsSubQueryMatcher.timeUnit
		let expectedValue = Calendar.Component.day
		matcher.timeUnit = expectedValue

		// when
		let actualValue = try! matcher.value(of: attribute) as! Calendar.Component

		// then
		XCTAssert(actualValue == expectedValue)
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

	// MARK: - ==

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() {
		// when
		let equal = matcher == matcher

		// then
		XCTAssert(equal)
	}

	func testGivenSameMatcherTypeWithDifferentNumberOfUnits_equalToOperator_returnsFalse() {
		// given
		let other = WithinXCalendarUnitsSubQueryMatcher(numberOfTimeUnits: matcher.numberOfTimeUnits + 1)

		// when
		let equal = matcher == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithDifferentTimeUnits_equalToOperator_returnsFalse() {
		// given
		let other = WithinXCalendarUnitsSubQueryMatcher(timeUnit: Calendar.Component.hour)

		// when
		let equal = matcher == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithDifferentMostRecentOnly_equalToOperator_returnsFalse() {
		// given
		let other = WithinXCalendarUnitsSubQueryMatcher(mostRecentOnly: true)

		// when
		let equal = matcher == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToOperator_returnsTrue() {
		// given
		let other = WithinXCalendarUnitsSubQueryMatcher()

		// when
		let equal = matcher == other

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo(attributed:)

	func testGivenTwoMatchersOfDifferentTypes_equalToAttributed_returnsFalse() {
		// given
		let otherAttributed: Attributed = SameDatesSubQueryMatcher()

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

	func testGivenSameMatcherTypeWithDifferentNumberOfUnits_equalToAttributed_returnsFalse() {
		// given
		let otherAttributed: Attributed = WithinXCalendarUnitsSubQueryMatcher(numberOfTimeUnits: matcher.numberOfTimeUnits + 1)

		// when
		let equal = matcher.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithDifferentTimeUnits_equalToAttributed_returnsFalse() {
		// given
		let otherAttributed: Attributed = WithinXCalendarUnitsSubQueryMatcher(timeUnit: Calendar.Component.hour)

		// when
		let equal = matcher.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithDifferentMostRecentOnly_equalToAttributed_returnsFalse() {
		// given
		let otherAttributed: Attributed = WithinXCalendarUnitsSubQueryMatcher(mostRecentOnly: true)

		// when
		let equal = matcher.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToAttributed_returnsTrue() {
		// given
		let otherAttributed: Attributed = WithinXCalendarUnitsSubQueryMatcher()

		// when
		let equal = matcher.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo(matcher:)

	func testGivenTwoMatchersOfDifferentTypes_equalToMatcher_returnsFalse() {
		// given
		let otherMatcher: SubQueryMatcher = SameDatesSubQueryMatcher()

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

	func testGivenSameMatcherTypeWithDifferentNumberOfUnits_equalToMatcher_returnsFalse() {
		// given
		let otherMatcher: SubQueryMatcher = WithinXCalendarUnitsSubQueryMatcher(numberOfTimeUnits: matcher.numberOfTimeUnits + 1)

		// when
		let equal = matcher.equalTo(otherMatcher)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithDifferentTimeUnits_equalToMatcher_returnsFalse() {
		// given
		let otherMatcher: SubQueryMatcher = WithinXCalendarUnitsSubQueryMatcher(timeUnit: Calendar.Component.hour)

		// when
		let equal = matcher.equalTo(otherMatcher)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithDifferentMostRecentOnly_equalToMatcher_returnsFalse() {
		// given
		let otherMatcher: SubQueryMatcher = WithinXCalendarUnitsSubQueryMatcher(mostRecentOnly: true)

		// when
		let equal = matcher.equalTo(otherMatcher)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToMatcher_returnsTrue() {
		// given
		let otherMatcher: SubQueryMatcher = WithinXCalendarUnitsSubQueryMatcher()

		// when
		let equal = matcher.equalTo(otherMatcher)

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo()

	func testGivenSameObjectTwice_equalTo_returnsTrue() {
		// when
		let equal = matcher.equalTo(matcher)

		// then
		XCTAssert(equal)
	}

	func testGivenSameMatcherTypeWithDifferentNumberOfUnits_equalTo_returnsFalse() {
		// given
		let other = WithinXCalendarUnitsSubQueryMatcher(numberOfTimeUnits: matcher.numberOfTimeUnits + 1)

		// when
		let equal = matcher.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithDifferentTimeUnits_equalTo_returnsFalse() {
		// given
		let other = WithinXCalendarUnitsSubQueryMatcher(timeUnit: Calendar.Component.hour)

		// when
		let equal = matcher.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithDifferentMostRecentOnly_equalTo_returnsFalse() {
		// given
		let other = WithinXCalendarUnitsSubQueryMatcher(mostRecentOnly: true)

		// when
		let equal = matcher.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalTo_returnsTrue() {
		// given
		let other = WithinXCalendarUnitsSubQueryMatcher()

		// when
		let equal = matcher.equalTo(other)

		// then
		XCTAssert(equal)
	}
}
