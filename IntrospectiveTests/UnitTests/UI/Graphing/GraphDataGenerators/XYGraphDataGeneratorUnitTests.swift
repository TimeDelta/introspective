//
//  XYGraphDataGeneratorUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/2/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
import SwiftDate
@testable import Introspective
@testable import Common
@testable import Samples

final class XYGraphDataGeneratorUnitTests: UnitTest {

	public final var generator: XYGraphDataGenerator!

	override func setUp() {
		super.setUp()
		generator = XYGraphDataGenerator(log: Log())
	}

	// MARK: - areAllNumbers()

	func testGivenEmptyArray_areAllNumbers_returnsTrue() {
		// when
		let areAllNumbers = generator.areAllNumbers([])

		// then
		XCTAssert(areAllNumbers)
	}

	func testGivenAllNumbers_areAllNumbers_returnsTrue() {
		// given
		Given(mockStringUtil, .isNumber(.any, willReturn: true))

		// when
		let areAllNumbers = generator.areAllNumbers(["1"])

		// then
		XCTAssert(areAllNumbers)
	}

	func testGivenOnlySomeNumbers_areAllNumbers_returnsFalse() {
		// given
		Given(mockStringUtil, .isNumber(.any, willReturn: true, false, true))

		// when
		let areAllNumbers = generator.areAllNumbers(["1", "a", "3"])

		// then
		XCTAssertFalse(areAllNumbers)
	}

	// MARK: - areAllDates

	func testGivenEmptyArray_areAllDates_returnsTrue() {
		// when
		let areAllDates = generator.areAllDates([])

		// then
		XCTAssert(areAllDates)
	}

	func testsGivenAllDates_areAllDates_returnsTrue() {
		// given
		Given(mockCalendarUtil, .date(from: .any, format: .any, willReturn: Date()))

		// when
		let areAllDates = generator.areAllDates([""])

		// then
		XCTAssert(areAllDates)
	}

	func testsGivenOnlySomeDates_areAllDates_returnsFalse() {
		// given
		Given(mockCalendarUtil, .date(from: .any, format: .any, willReturn: Date(), nil, Date()))

		// when
		let areAllDates = generator.areAllDates(["date", "not a date", "date"])

		// then
		XCTAssertFalse(areAllDates)
	}

	// MARK: - areAllDaysOfWeek

	func testGivenEmptyArray_areAllDaysOfWeek_returnsTrue() {
		// when
		let areAllDaysOfWeek = generator.areAllDaysOfWeek([])

		// then
		XCTAssert(areAllDaysOfWeek)
	}

	func testsGivenAllDates_areAllDaysOfWeek_returnsTrue() {
		// given
		let values = [DayOfWeek.Sunday.fullDayName]
		Given(mockStringUtil, .isDayOfWeek(.any, willReturn: true))

		// when
		let areAllDaysOfWeek = generator.areAllDaysOfWeek(values)

		// then
		XCTAssert(areAllDaysOfWeek)
	}

	func testsGivenOnlySomeDates_areAllDaysOfWeek_returnsFalse() {
		// given
		let values = [DayOfWeek.Sunday.fullDayName, "not a day of week", DayOfWeek.Saturday.fullDayName]
		Given(mockStringUtil, .isDayOfWeek(.any, willReturn: true, false, true))

		// when
		let areAllDaysOfWeek = generator.areAllDaysOfWeek(values)

		// then
		XCTAssertFalse(areAllDaysOfWeek)
	}

	// MARK: - getSortedXValues()

	func testGivenEmptyArray_getSortedXVales_returnsEmptyArray() {
		// when
		let sortedValues = generator.getSortedXValues([])

		// then
		assertThat(sortedValues, hasCount(0))
	}

	func testGivenAllNumbers_getSortedXValues_returnsCorrectlySortedValues() {
		// given
		Given(mockStringUtil, .isNumber(.any, willReturn: true))
		let values: [(groupValue: Any, sampleValue: String)] = [
			(groupValue: "2g", sampleValue: "2"),
			(groupValue: "1g", sampleValue: "1"),
			(groupValue: "3g", sampleValue: "3"),
		]

		// when
		let sortedValues = generator.getSortedXValues(values)

		// then
		assertThat(sortedValues, contains(hasSampleValue(1.0), hasSampleValue(2.0), hasSampleValue(3.0)))
	}

	func testGivenAllDates_getSortedXValues_returnsCorrectlySortedValues() {
		// given
		let date1 = Date() - 2.days
		let date2 = Date() - 1.days
		let date3 = Date()
		let date1String = "date1"
		let date2String = "date2"
		let date3String = "date3"
		let values: [(groupValue: Any, sampleValue: String)] = [
			(groupValue: "3", sampleValue: date3String),
			(groupValue: "1", sampleValue: date1String),
			(groupValue: "2", sampleValue: date2String),
		]
		Given(mockCalendarUtil, .date(from: .value(date1String), format: .any, willReturn: date1))
		Given(mockCalendarUtil, .date(from: .value(date2String), format: .any, willReturn: date2))
		Given(mockCalendarUtil, .date(from: .value(date3String), format: .any, willReturn: date3))
		Given(mockStringUtil, .isNumber(.any, willReturn: false))

		// when
		let sortedValues = generator.getSortedXValues(values)

		// then
		assertThat(
			sortedValues,
			contains(
				hasSampleValue(date1String),
				hasSampleValue(date2String),
				hasSampleValue(date3String)))
	}

	func testGivenAllDaysOfWeek_getSortedXValues_returnsCorrectlySortedValues() {
		// given
		let day1 = DayOfWeek.Sunday
		let day2 = DayOfWeek.Monday
		let day3 = DayOfWeek.Tuesday
		let values: [(groupValue: Any, sampleValue: String)] = [
			(groupValue: "3", sampleValue: day3.fullDayName),
			(groupValue: "1", sampleValue: day1.fullDayName),
			(groupValue: "2", sampleValue: day2.fullDayName),
		]
		Given(mockStringUtil, .isNumber(.any, willReturn: false))
		Given(mockCalendarUtil, .date(from: .any, format: .any, willReturn: nil))
		Given(mockStringUtil, .isDayOfWeek(.any, willReturn: true))

		// when
		let sortedValues = generator.getSortedXValues(values)

		// then
		assertThat(
			sortedValues,
			contains(
				hasSampleValue(day1.fullDayName),
				hasSampleValue(day2.fullDayName),
				hasSampleValue(day3.fullDayName)))
	}

	func testGivenNonSortableType_getSortedXValues_returnsSameAsInput() {
		// given
		let values: [(groupValue: Any, sampleValue: String)] = [
			(groupValue: "1", sampleValue: "a"),
			(groupValue: "2", sampleValue: "b"),
			(groupValue: "3", sampleValue: "c"),
		]
		Given(mockStringUtil, .isNumber(.any, willReturn: false))
		Given(mockCalendarUtil, .date(from: .any, format: .any, willReturn: nil))
		Given(mockStringUtil, .isDayOfWeek(.any, willReturn: false))

		// when
		let sortedValues = generator.getSortedXValues(values)

		// then
		assertThat(
			sortedValues,
			contains(
				hasSampleValue(values[0].sampleValue),
				hasSampleValue(values[1].sampleValue),
				hasSampleValue(values[2].sampleValue)))
	}

	// MARK: - getSeriesDataForYInformation()

	func testGivenNoYInformation_getSeriesDataForYInformation_returnsEmptyGraphData() throws {
		// when
		let graphData = try generator.getSeriesDataForYInformation(
			[],
			fromGroups: [],
			groupedBy: SampleGrouperMock(attributes: []),
			withGroupName: nil,
			sortedXValues: [])

		// then
		assertThat(graphData, hasCount(0))
	}

	func testGivenNoXValues_getSeriesDataForYInformation_returnsSeriesWithNoData() throws {
		// given
		let yInformation = mockInformation()
		Given(yInformation, .computeGraphable(forSamples: .any, willReturn: "0"))
		let grouper = SampleGrouperMock(attributes: [])
		let groups: [(Any, [Sample])] = [("", [SampleCreatorTestUtil.createSample()])]

		// when
		let graphData = try generator.getSeriesDataForYInformation(
			[yInformation],
			fromGroups: groups,
			groupedBy: grouper,
			withGroupName: nil,
			sortedXValues: [])

		// then
		assertThat(graphData, hasSeriesWithData([] as [[Double]]))
	}

	func testGivenGroupValuesDoNotMatchUp_getSeriesDataForYInformation_returnsSeriesWithNoData() throws {
		// given
		let yInformation = mockInformation()
		Given(yInformation, .computeGraphable(forSamples: .any, willReturn: "0"))
		let grouper = SampleGrouperMock(attributes: [])
		Given(grouper, .groupValuesAreEqual(.any, .any, willReturn: false))
		let groups: [(Any, [Sample])] = [("no match in x", [SampleCreatorTestUtil.createSample()])]
		let xValues: [(groupValue: Any, sampleValue: Any)] = [
			(groupValue: "1", sampleValue: "1"),
		]

		// when
		let graphData = try generator.getSeriesDataForYInformation(
			[yInformation],
			fromGroups: groups,
			groupedBy: grouper,
			withGroupName: nil,
			sortedXValues: xValues)

		// then
		assertThat(graphData, hasSeriesWithData([] as [[Double]]))
	}

	func testGivenXGroupValuesMapToYGroupValues_getSeriesDataForYInformation_returnsSeriesWithCorrectData() throws {
		// given
		let yInformation = mockInformation()
		let xValue = 0.0
		let yValue = 1.0
		let groupValue = "group"
		Given(yInformation, .computeGraphable(forSamples: .any, willReturn: String(yValue)))
		let grouper = SampleGrouperMock(attributes: [])
		Given(grouper, .groupValuesAreEqual(.any, .any, willReturn: true))
		let groups: [(Any, [Sample])] = [(groupValue, [SampleCreatorTestUtil.createSample()])]
		let xValues: [(groupValue: Any, sampleValue: Any)] = [
			(groupValue: groupValue, sampleValue: xValue),
		]

		// when
		let graphData = try generator.getSeriesDataForYInformation(
			[yInformation],
			fromGroups: groups,
			groupedBy: grouper,
			withGroupName: nil,
			sortedXValues: xValues)

		// then
		assertThat(graphData, hasSeriesWithData([[xValue, yValue]]))
	}

	func testGivenGroupName_getSeriesDataForYInformation_includesGroupNameInSeriesName() throws {
		// given
		let informationDescription = "information"
		let yInformation = mockInformation(description: informationDescription)
		let xValue = 0.0
		let yValue = 1.0
		let groupValue = "group"
		Given(yInformation, .computeGraphable(forSamples: .any, willReturn: String(yValue)))
		let grouper = SampleGrouperMock(attributes: [])
		Given(grouper, .groupValuesAreEqual(.any, .any, willReturn: true))
		let groups: [(Any, [Sample])] = [(groupValue, [SampleCreatorTestUtil.createSample()])]
		let xValues: [(groupValue: Any, sampleValue: Any)] = [
			(groupValue: groupValue, sampleValue: xValue),
		]
		let groupName = "group name"

		// when
		let graphData = try generator.getSeriesDataForYInformation(
			[yInformation],
			fromGroups: groups,
			groupedBy: grouper,
			withGroupName: groupName,
			sortedXValues: xValues)

		// then
		assertThat(graphData, hasSeriesWithName("\(groupName): \(informationDescription.localizedCapitalized)"))
	}

	// MARK: - formatNumber()

	func testGivenMoreThanTwoDecimalPoints_formatNumber_returnsOnlyTwoPlacesAfterDecimalPoint() {
		// given
		let input = "000.1234"

		// when
		let output = generator.formatNumber(input)

		// then
		assertThat(output, equalTo("000.12"))
	}

	// MARK: - transform()

	func testGivenEmptyGroupsArray_transform_returnsEmptyArray() throws {
		// given
		let information = SampleGroupInformationMock()

		// when
		let transformedValues = try generator.transform(sampleGroups: [], information: information)

		// then
		assertThat(transformedValues, hasCount(0))
	}

	func testGivenMultipleGroups_transform_returnsCorrectlyTransformedArray() throws {
		// given
		let information = SampleGroupInformationMock()
		let group1Samples = [SampleCreatorTestUtil.createSample()]
		let group2Samples = [SampleCreatorTestUtil.createSample()]
		let group1Value = "1"
		let group2Value = "2"
		let group1SampleValue = 1.2
		let group2SampleValue = 2.3
		Given(information, .computeGraphable(forSamples: .value(group1Samples), willReturn: String(group1SampleValue)))
		Given(information, .computeGraphable(forSamples: .value(group2Samples), willReturn: String(group2SampleValue)))
		let groups: [(Any, [Sample])] = [
			(group1Value, group1Samples),
			(group2Value, group2Samples),
		]

		// when
		let transformedValues = try generator.transform(sampleGroups: groups, information: information)

		// then
		XCTFail("uncomment this when swift compiler error is fixed")
		#warning("uncomment this when swift compiler error is fixed")
//		assertThat(
//			transformedValues,
//			contains(
//				has(groupValue: group1Value, sampleValue: group1SampleValue),
//				has(groupValue: group2Value, sampleValue: group2SampleValue)))
	}

	// MARK: - index()

	func testGivenEmptyGroupsArray_index_returnsNil() {
		// given
		let grouper = SampleGrouperMock(attributes: [])

		// when
		let index = generator.index(ofValue: "", in: [], groupedBy: grouper)

		// then
		assertThat(index, nilValue())
	}

	func testGivenGroupValueDoesNotAppear_index_returnsNil() {
		// given
		let value = ""
		let groups: [(groupValue: Any, sampleValue: String)] = [
			(groupValue: value + "1", sampleValue: ""),
			(groupValue: value + "2", sampleValue: ""),
		]
		let grouper = SampleGrouperMock(attributes: [])
		Given(grouper, .groupValuesAreEqual(.any, .any, willReturn: false))

		// when
		let index = generator.index(ofValue: value, in: groups, groupedBy: grouper)

		// then
		assertThat(index, nilValue())
	}

	func testGivenGroupValueAppears_index_returnsCorrectIndex() {
		// given
		let value = ""
		let groups: [(groupValue: Any, sampleValue: String)] = [
			(groupValue: value + "1", sampleValue: ""),
			(groupValue: value, sampleValue: ""),
			(groupValue: value + "2", sampleValue: ""),
		]
		let grouper = SampleGrouperMock(attributes: [])
		Given(grouper, .groupValuesAreEqual(.any, .any, willReturn: false, true, false))

		// when
		let index = generator.index(ofValue: value, in: groups, groupedBy: grouper)

		// then
		assertThat(index, equalTo(1))
	}

	func testGivenGrouperThrowsErrorWhileDeterminingGroupValueEqualityForAllValues_index_returnsNil() {
		// given
		let value = ""
		let groups: [(groupValue: Any, sampleValue: String)] = [
			(groupValue: value + "1", sampleValue: ""),
			(groupValue: value + "2", sampleValue: ""),
		]
		let grouper = SampleGrouperMock(attributes: [])
		Given(grouper, .groupValuesAreEqual(.any, .any, willThrow: GenericError("")))

		// when
		let index = generator.index(ofValue: value, in: groups, groupedBy: grouper)

		// then
		assertThat(index, nilValue())
	}

	// MARK: - Helper Functions

	// MARK: Matchers

	// there is an error in the swift compiler that causes a segmentation fault when trying to compile the following method
	private final func has<GroupType: Equatable, SampleType: Equatable>(
		groupValue: GroupType,
		sampleValue: SampleType)
	-> Hamcrest.Matcher<(groupValue: Any, sampleValue: Any)> {
		return has(
			groupValue: groupValue,
			sampleValue: sampleValue,
			groupValuesEqual: { $0 == $1 },
			sampleValuesEqual: { $0 == $1 })
	}

	private final func has<GroupType, SampleType>(
		groupValue: GroupType,
		sampleValue: SampleType,
		groupValuesEqual: @escaping (GroupType, GroupType) -> Bool,
		sampleValuesEqual: @escaping (SampleType, SampleType) -> Bool)
	-> Hamcrest.Matcher<(groupValue: Any, sampleValue: Any)> {
		return Hamcrest.Matcher("") { group -> MatchResult in
			guard let actualGroupValue = group.groupValue as? GroupType else {
				return .mismatch("Wrong type of group value")
			}
			guard let actualSampleValue = group.sampleValue as? SampleType else {
				return .mismatch("Wrong type of sample value")
			}
			if !groupValuesEqual(groupValue, actualGroupValue) {
				return .mismatch("Group values do not match")
			}
			if !sampleValuesEqual(sampleValue, actualSampleValue) {
				return .mismatch("Sample values do not match")
			}
			return .match
		}
	}

	private final func hasSampleValue<Type: Equatable>(_ expectedValue: Type)
	-> Hamcrest.Matcher<(groupValue: Any, sampleValue: Any)> {
		return hasSampleValue(expectedValue, areEqual: { $0 == $1 })
	}

	private final func hasSampleValue<Type>(_ expectedValue: Type, areEqual: @escaping (Type, Type) -> Bool)
	-> Hamcrest.Matcher<(groupValue: Any, sampleValue: Any)> {
		return Hamcrest.Matcher("Sample value of \(String(describing: expectedValue))") { (group) -> MatchResult in
			guard let sampleValue = group.sampleValue as? Type else {
				return .mismatch("Wrong type")
			}
			if areEqual(sampleValue, expectedValue) {
				return .match
			}
			return .mismatch("Was \(String(describing: sampleValue))")
		}
	}

	// MARK: Other

	private final func mockInformation(description: String = "information") -> SampleGroupInformationMock {
		let information = SampleGroupInformationMock(AttributeMock())
		Given(information, .description(getter: description))
		return information
	}
}
