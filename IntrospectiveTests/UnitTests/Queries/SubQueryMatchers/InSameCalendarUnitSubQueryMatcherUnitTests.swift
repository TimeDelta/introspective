//
//  InSameCalendarUnitSubQueryMatcherUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
import SwiftyMocky
@testable import Introspective
@testable import Attributes
@testable import Queries
@testable import Samples

final class InSameCalendarUnitSubQueryMatcherUnitTests: UnitTest {

	private final var matcher: InSameCalendarUnitSubQueryMatcher!

	final override func setUp() {
		super.setUp()
		matcher = InSameCalendarUnitSubQueryMatcher()
	}

	// MARK: - getSamples()

	func testGivenEmptyArrayOfQuerySamplesAndEmptyArrayOfSubQuerySamples_getSamples_returnsEmptyArray() throws {
		// given
		let querySamples = [AnySample]()
		let subQuerySamples = [Sample]()
		let timeUnit: Calendar.Component = .day
		matcher.timeUnit = timeUnit
		Given(mockSampleUtil,
			.aggregate(samples: .value(subQuerySamples), by: .value(timeUnit), for: .value(CommonSampleAttributes.startDate),
			willReturn: [Date: [Sample]]()))
		Given(mockSampleUtil,
			.aggregate(samples: .value(subQuerySamples), by: .value(timeUnit), for: .value(CommonSampleAttributes.endDate),
			willReturn: [Date: [Sample]]()))

		// when
		let matchingSamples = try matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 0, "Found \(matchingSamples.count) samples")
	}

	func testGivenEmptyArrayOfQuerySamplesAndNonEmptyArrayOfSubQuerySamples_getSamples_returnsEmptyArray() throws {
		// given
		let querySamples = [AnySample]()
		let subQuerySamples = SampleCreatorTestUtil.createSamples(count: 2)
		let timeUnit: Calendar.Component = .day
		matcher.timeUnit = timeUnit
		Given(mockSampleUtil, .aggregate(samples: .value(subQuerySamples), by: .value(timeUnit), for: .value(CommonSampleAttributes.startDate), willReturn: [Date: [Sample]]()))
		Given(mockSampleUtil, .aggregate(samples: .value(subQuerySamples), by: .value(timeUnit), for: .value(CommonSampleAttributes.endDate), willReturn: [Date: [Sample]]()))

		// when
		let matchingSamples = try matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 0, "Found \(matchingSamples.count) samples")
	}

	func testGivenEmptyArrayOfSubQuerySamplesAndNonEmptyArrayOfQuerySamples_getSamples_returnsEmptyArray() throws {
		// given
		let querySamples = SampleCreatorTestUtil.createSamples(count: 2)
		let subQuerySamples = [Sample]()
		let timeUnit: Calendar.Component = .day
		matcher.timeUnit = timeUnit
		Given(mockSampleUtil, .aggregate(samples: .value(subQuerySamples), by: .value(timeUnit), for: .value(CommonSampleAttributes.startDate), willReturn: [Date: [Sample]]()))
		Given(mockSampleUtil, .aggregate(samples: .value(subQuerySamples), by: .value(timeUnit), for: .value(CommonSampleAttributes.endDate), willReturn: [Date: [Sample]]()))
		Given(mockCalendarUtil, .start(of: .value(timeUnit), in: .any(Date.self), willReturn: Date()))

		// when
		let matchingSamples = try matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 0, "Found \(matchingSamples.count) samples")
	}

	func testGivenOneSubQuerySampleAndMultipleQuerySamples_getSamples_returnsOnlyMatchingSamples() throws {
		// given
		let querySampleDate1 = Date() - 1.days
		let querySampleDate2 = Date()
		let subQuerySampleDate = querySampleDate1
		let querySamples = SampleCreatorTestUtil.createSamples(withDates: [querySampleDate1, querySampleDate2])
		let subQuerySamples: [Sample] = [SampleCreatorTestUtil.createSample(startDate: subQuerySampleDate)]
		let timeUnit: Calendar.Component = .day
		matcher.timeUnit = timeUnit
		Given(mockSampleUtil, .aggregate(samples: .value(subQuerySamples), by: .value(timeUnit), for: .value(CommonSampleAttributes.startDate), willReturn: [subQuerySampleDate: subQuerySamples]))
		Given(mockSampleUtil, .aggregate(samples: .value(subQuerySamples), by: .value(timeUnit), for: .value(CommonSampleAttributes.endDate), willReturn: [Date: [Sample]]()))
		Given(mockCalendarUtil, .start(of: .value(timeUnit), in: .value(querySampleDate1), willReturn: subQuerySampleDate))
		Given(mockCalendarUtil, .start(of: .value(timeUnit), in: .value(querySampleDate2), willReturn: querySampleDate2))

		// when
		let matchingSamples = try matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 1, "Found \(matchingSamples.count) samples")
		if matchingSamples.count > 0 {
			XCTAssert(
				matchingSamples[0].equalTo(querySamples[0]),
				"Expected \(querySamples[0].debugDescription) but got \(matchingSamples[0].debugDescription)")
		}
	}

	func testGivenMultipleSubQuerySamplesAndMultipleQuerySamples_getSamples_returnsOnlyMatchingSamples() throws {
		// given
		let querySampleDate1 = Date() - 1.days
		let querySampleDate2 = Date()
		let subQuerySampleDate1 = querySampleDate1
		let subQuerySampleDate2 = Date() + 1.days
		let querySamples = SampleCreatorTestUtil.createSamples(withDates: [querySampleDate1, querySampleDate2])
		let subQuerySamples: [Sample] = SampleCreatorTestUtil.createSamples(withDates: [subQuerySampleDate1, subQuerySampleDate2])
		let timeUnit: Calendar.Component = .day
		matcher.timeUnit = timeUnit
		Given(mockSampleUtil, .aggregate(samples: .value(subQuerySamples), by: .value(timeUnit), for: .value(CommonSampleAttributes.startDate), willReturn: [subQuerySampleDate1: subQuerySamples]))
		Given(mockSampleUtil, .aggregate(samples: .value(subQuerySamples), by: .value(timeUnit), for: .value(CommonSampleAttributes.endDate), willReturn: [Date: [Sample]]()))
		Given(mockCalendarUtil, .start(of: .value(timeUnit), in: .value(querySampleDate1), willReturn: subQuerySampleDate1))
		Given(mockCalendarUtil, .start(of: .value(timeUnit), in: .value(querySampleDate2), willReturn: querySampleDate2))

		// when
		let matchingSamples = try matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 1, "Found \(matchingSamples.count) samples")
		if matchingSamples.count > 0 {
			XCTAssert(
				matchingSamples[0].equalTo(querySamples[0]),
				"Expected \(querySamples[0].debugDescription) but got \(matchingSamples[0].debugDescription)")
		}
	}

	func testGivenMostRecentOnlyIsTrueAndMultipleSubQuerySamplesAndMultipleQuerySamples_getSamples_returnsOnlyMatchingSamples() throws {
		// given
		let querySampleDate1 = Date() - 1.days
		let querySampleDate2 = Date()
		let subQuerySampleDate1 = querySampleDate1
		let subQuerySampleDate2 = Date() + 1.days
		let querySamples = SampleCreatorTestUtil.createSamples(withDates: [querySampleDate1, querySampleDate2])
		let subQuerySamples: [Sample] = SampleCreatorTestUtil.createSamples(withDates: [subQuerySampleDate1, subQuerySampleDate2])
		let timeUnit: Calendar.Component = .day
		matcher.timeUnit = timeUnit
		matcher.mostRecentOnly = true
		Given(mockSampleUtil, .sort(samples: .value(subQuerySamples), by: .value(.start), in: .value(.orderedDescending), willReturn: subQuerySamples))
		Given(mockSampleUtil, .aggregate(samples: .value([subQuerySamples[0]]), by: .value(timeUnit), for: .value(CommonSampleAttributes.startDate), willReturn: [subQuerySampleDate1: [subQuerySamples[0]]]))
		Given(mockSampleUtil, .aggregate(samples: .value([subQuerySamples[0]]), by: .value(timeUnit), for: .value(CommonSampleAttributes.endDate), willReturn: [Date: [Sample]]()))
		Given(mockCalendarUtil, .start(of: .value(timeUnit), in: .value(querySampleDate1), willReturn: subQuerySampleDate1))
		Given(mockCalendarUtil, .start(of: .value(timeUnit), in: .value(querySampleDate2), willReturn: querySampleDate2))

		// when
		let matchingSamples = try matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 1, "Found \(matchingSamples.count) samples")
		if matchingSamples.count > 0 {
			XCTAssert(
				matchingSamples[0].equalTo(querySamples[0]),
				"Expected \(querySamples[0].debugDescription) but got \(matchingSamples[0].debugDescription)")
		}
	}

	// MARK: - set(attribute: to:)

	func testGivenUnknownAttribute_set_throwsUnknownAttributeError() throws {
		// given
		let attribute = CommonSampleAttributes.endDate
		let value = 1

		// when
		XCTAssertThrowsError(try matcher.set(attribute: attribute, to: value)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenTimeUnitAttributeWithInvalidValue_set_throwsTypeMismatchError() throws {
		// given
		let attribute = InSameCalendarUnitSubQueryMatcher.timeUnit
		let value = "abc"

		// when
		XCTAssertThrowsError(try matcher.set(attribute: attribute, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenTimeUnitAttributeWithValidValue_set_correctlySetsValue() throws {
		// given
		let attribute = InSameCalendarUnitSubQueryMatcher.timeUnit
		let value = Calendar.Component.day

		// when
		try! matcher.set(attribute: attribute, to: value)

		// then
		XCTAssert(matcher.timeUnit == value)
	}

	func testGivenMostRecentOnlyAttributeWithInvalidValue_set_throwsTypeMismatchError() throws {
		// given
		let attribute = CommonSubQueryMatcherAttributes.mostRecentOnly
		let value = "abc"

		// when
		XCTAssertThrowsError(try matcher.set(attribute: attribute, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenMostRecentOnlyAttributeWithValidValue_set_correctlySetsValue() throws {
		// given
		let attribute = CommonSubQueryMatcherAttributes.mostRecentOnly
		let value = true

		// when
		try! matcher.set(attribute: attribute, to: value)

		// then
		XCTAssert(matcher.mostRecentOnly == value)
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() throws {
		// given
		let attribute = CommonSampleAttributes.endDate

		// when
		XCTAssertThrowsError(try matcher.value(of: attribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenTimeUnitAttribute_valueOf_returnsCorrectValue() throws {
		// given
		let attribute = InSameCalendarUnitSubQueryMatcher.timeUnit
		let expectedValue = Calendar.Component.day
		matcher.timeUnit = expectedValue

		// when
		let actualValue = try! matcher.value(of: attribute) as! Calendar.Component

		// then
		XCTAssert(actualValue == expectedValue)
	}

	func testGivenMostRecentOnlyAttribute_valueOf_returnsCorrectValue() throws {
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

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() throws {
		// when
		let equal = matcher == matcher

		// then
		XCTAssert(equal)
	}

	func testGivenSameMatcherTypeWithDifferentTimeUnits_equalToOperator_returnsFalse() throws {
		// given
		let other = InSameCalendarUnitSubQueryMatcher(timeUnit: Calendar.Component.hour)

		// when
		let equal = matcher == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithDifferentMostRecentOnly_equalToOperator_returnsFalse() throws {
		// given
		let other = InSameCalendarUnitSubQueryMatcher(mostRecentOnly: true)

		// when
		let equal = matcher == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToOperator_returnsTrue() throws {
		// given
		let other = InSameCalendarUnitSubQueryMatcher()

		// when
		let equal = matcher == other

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo(attributed:)

	func testGivenTwoMatchersOfDifferentTypes_equalToAttributed_returnsFalse() throws {
		// given
		let otherAttributed: Attributed = SameDatesSubQueryMatcher()

		// when
		let equal = matcher.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameObjectTwice_equalToAttributed_returnsTrue() throws {
		// when
		let equal = matcher.equalTo(matcher as Attributed)

		// then
		XCTAssert(equal)
	}

	func testGivenSameMatcherTypeWithDifferentTimeUnits_equalToAttributed_returnsFalse() throws {
		// given
		let otherAttributed: Attributed = InSameCalendarUnitSubQueryMatcher(timeUnit: Calendar.Component.hour)

		// when
		let equal = matcher.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithDifferentMostRecentOnly_equalToAttributed_returnsFalse() throws {
		// given
		let otherAttributed: Attributed = InSameCalendarUnitSubQueryMatcher(mostRecentOnly: true)

		// when
		let equal = matcher.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToAttributed_returnsTrue() throws {
		// given
		let otherAttributed: Attributed = InSameCalendarUnitSubQueryMatcher()

		// when
		let equal = matcher.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo(matcher:)

	func testGivenTwoMatchersOfDifferentTypes_equalToMatcher_returnsFalse() throws {
		// given
		let otherMatcher: SubQueryMatcher = SameDatesSubQueryMatcher()

		// when
		let equal = matcher.equalTo(otherMatcher)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameObjectTwice_equalToMatcher_returnsTrue() throws {
		// when
		let equal = matcher.equalTo(matcher as SubQueryMatcher)

		// then
		XCTAssert(equal)
	}

	func testGivenSameMatcherTypeWithDifferentTimeUnits_equalToMatcher_returnsFalse() throws {
		// given
		let otherMatcher: SubQueryMatcher = InSameCalendarUnitSubQueryMatcher(timeUnit: Calendar.Component.hour)

		// when
		let equal = matcher.equalTo(otherMatcher)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithDifferentMostRecentOnly_equalToMatcher_returnsFalse() throws {
		// given
		let otherMatcher: SubQueryMatcher = InSameCalendarUnitSubQueryMatcher(mostRecentOnly: true)

		// when
		let equal = matcher.equalTo(otherMatcher)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToMatcher_returnsTrue() throws {
		// given
		let otherMatcher: SubQueryMatcher = InSameCalendarUnitSubQueryMatcher()

		// when
		let equal = matcher.equalTo(otherMatcher)

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo()

	func testGivenSameObjectTwice_equalTo_returnsTrue() throws {
		// when
		let equal = matcher.equalTo(matcher)

		// then
		XCTAssert(equal)
	}

	func testGivenSameMatcherTypeWithDifferentTimeUnits_equalTo_returnsFalse() throws {
		// given
		let other = InSameCalendarUnitSubQueryMatcher(timeUnit: Calendar.Component.hour)

		// when
		let equal = matcher.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithDifferentMostRecentOnly_equalTo_returnsFalse() throws {
		// given
		let other = InSameCalendarUnitSubQueryMatcher(mostRecentOnly: true)

		// when
		let equal = matcher.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalTo_returnsTrue() throws {
		// given
		let other = InSameCalendarUnitSubQueryMatcher()

		// when
		let equal = matcher.equalTo(other)

		// then
		XCTAssert(equal)
	}
}
