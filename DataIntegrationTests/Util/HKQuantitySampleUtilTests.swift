//
//  HKQuantitySampleUtilTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 7/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import HealthKit
import Cuckoo
@testable import DataIntegration

class HKQuantitySampleUtilTests: UnitTest {

	fileprivate typealias Me = HKQuantitySampleUtilTests

	fileprivate var util: HKQuantitySampleUtil!
	fileprivate var mockCalendarUtil: MockCalendarUtil!

	override func setUp() {
		super.setUp()
		util = HKQuantitySampleUtil()

		let mockCalUtil = MockCalendarUtil()
		mockCalendarUtil = mockCalUtil
		// TODO - fixing compilation error with following code should fix some of the failing tests here
		stub(UnitTestInjectionProvider.mockUtilFactory) { stub in
			when(stub.calendarUtil.get).thenReturn(mockCalUtil)
		}
	}

	func testGivenAverageOperationOverMultipleSamplesPerAggregationInMultipleAggregations_compute_returnsCorrectValues() throws {
		// given
		let date1 = Date("2018-01-01")!
		let date2 = Date("2019-01-01")!
		let date3 = Date("2020-01-01")!
		let entries = [
			(start: date1, end: date1, value: 5.0),
			(start: date1, end: date1, value: 7.0),
			(start: date2, end: date2, value: 1.0),
			(start: date2, end: date2, value: 2.0),
			(start: date2, end: date2, value: 3.0),
			(start: date3, end: date3, value: 1.0),
			(start: date3, end: date3, value: 2.0),
			(start: date3, end: date3, value: 3.0),
			(start: date3, end: date3, value: 4.0)
		]
		let samples = createSamples(withValues: entries)
		let aggregationUnit: Calendar.Component = .year
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.endDate))).thenReturn(sample.endDate)
			}
		}
		let queryOperation = try QueryOperation.from(tag: Tags.average)
		queryOperation.aggregationUnit = aggregationUnit

		// when
		let results = util.compute(operation: queryOperation, over: samples, withUnit: Me.defaultUnit)

		// then
		XCTAssert(results == [6.0, 2.0, 2.5])
	}

	func testGivenOneSample_average_returnsValueOfThatSample() {
		// given
		let expectedAverage = 5.0
		let samples = createSamples(withValues: [expectedAverage])

		// when
		let average = util.average(over: samples, withUnit: Me.defaultUnit)

		// then
		XCTAssert(average == expectedAverage)
	}

	func testGivenMultipleSamples_average_returnsCorrectValue() {
		// given
		let values = [1.23, 5.7, 19.2, 8.6]
		var expectedAverage = 0.0
		for value in values {
			expectedAverage += value
		}
		expectedAverage /= Double(values.count)
		let samples = createSamples(withValues: values)

		// when
		let average = util.average(over: samples, withUnit: Me.defaultUnit)

		// then
		XCTAssert(average == expectedAverage)
	}

	func testGivenOnlyOneSampleWithNilAggregation_averagePer_returnsValueForThatSample() {
		// given
		let values = [5.0]
		let samples = createSamples(withValues: values)

		// when
		let averages = util.average(over: samples, per: nil, withUnit: Me.defaultUnit)

		// then
		XCTAssert(averages == values)
	}

	func testGivenMultipleSamplesWithNilAggregation_averagePer_returnsCorrectValue() {
		// given
		let values = [1.23, 5.7, 19.2, 8.6]
		var expectedAverage = 0.0
		for value in values {
			expectedAverage += value
		}
		expectedAverage /= Double(values.count)
		let samples = createSamples(withValues: values)

		// when
		let average = util.average(over: samples, per: nil, withUnit: Me.defaultUnit)

		// then
		XCTAssert(average == [expectedAverage])
	}

	func testGivenOnlyOneSampleInOneAggregationUnit_averagePer_returnsValueForThatSample() {
		// given
		let values = [5.0]
		let samples = createSamples(withValues: values)
		let aggregationUnit: Calendar.Component = .year
		let aggregationDate = Date()
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.endDate))).thenReturn(aggregationDate)
			}
		}

		// when
		let averages = util.average(over: samples, per: aggregationUnit, withUnit: Me.defaultUnit)

		// then
		XCTAssert(averages == values)
	}

	func testGivenMultipleSamplesFromSameAggregationUnit_averagePer_returnsCorrectAverageForThatYear() {
		// given
		let date = Date("2018-01-01")!
		let entries = [
			(start: date, end: date, value: 5.0),
			(start: date, end: date, value: 2.0),
			(start: date, end: date, value: 1.0)
		]
		let samples = createSamples(withValues: entries)
		let aggregationUnit: Calendar.Component = .year
		let aggregationDate = Date()
		stub(mockCalendarUtil) { stub in
			when(stub.start(of: equal(to: aggregationUnit), in: any())).thenReturn(aggregationDate)
		}
		var expectedAverage = 0.0
		for entry in entries {
			expectedAverage += entry.value
		}
		expectedAverage /= Double(entries.count)

		// when
		let averages = util.average(over: samples, per: aggregationUnit, withUnit: Me.defaultUnit)

		// then
		XCTAssert(averages == [expectedAverage])
	}

	func testGivenThreeSamplesWithOneSamplePerAggregationUnit_averagePer_returnsCorrectValueForEachYear() {
		// given
		let date1 = Date("2018-01-01")!
		let date2 = Date("2019-01-01")!
		let date3 = Date("2020-01-01")!
		let entries = [
			(start: date1, end: date1, value: 5.0),
			(start: date2, end: date2, value: 2.0),
			(start: date3, end: date3, value: 1.0)
		]
		let samples = createSamples(withValues: entries)
		let aggregationUnit: Calendar.Component = .year
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.endDate))).thenReturn(sample.endDate)
			}
		}

		// when
		let averages = util.average(over: samples, per: aggregationUnit, withUnit: Me.defaultUnit)

		// then
		XCTAssert(averages == [entries[0].value, entries[1].value, entries[2].value])
	}

	func testGivenMultipleSamplesPerAggregationUnitOverMultipleAggregations_averagePer_returnsCorrectValueForEachYear() {
		// given
		let date1 = Date("2018-01-01")!
		let date2 = Date("2019-01-01")!
		let date3 = Date("2020-01-01")!
		let entries = [
			(start: date1, end: date1, value: 5.0),
			(start: date1, end: date1, value: 7.0),
			(start: date2, end: date2, value: 1.0),
			(start: date2, end: date2, value: 2.0),
			(start: date2, end: date2, value: 3.0),
			(start: date3, end: date3, value: 1.0),
			(start: date3, end: date3, value: 2.0),
			(start: date3, end: date3, value: 3.0),
			(start: date3, end: date3, value: 4.0)
		]
		let samples = createSamples(withValues: entries)
		let aggregationUnit: Calendar.Component = .year
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.endDate))).thenReturn(sample.endDate)
			}
		}

		// when
		let averages = util.average(over: samples, per: aggregationUnit, withUnit: Me.defaultUnit)

		// then
		XCTAssert(averages == [6.0, 2.0, 2.5])
	}

	// TODO - finish writing unit tests
}
