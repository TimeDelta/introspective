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

	func testGivenMultipleSamplesOutOfOrderPerAggregationUnitOverMultipleAggregations_averagePer_returnsCorrectValueForEachYear() {
		// given
		let date1 = Date("2018-01-01")!
		let date2 = Date("2019-01-01")!
		let date3 = Date("2020-01-01")!
		let entries = [
			(start: date3, end: date3, value: 2.0),
			(start: date2, end: date2, value: 1.0),
			(start: date2, end: date2, value: 3.0),
			(start: date3, end: date3, value: 4.0),
			(start: date3, end: date3, value: 1.0),
			(start: date1, end: date1, value: 7.0),
			(start: date2, end: date2, value: 2.0),
			(start: date3, end: date3, value: 3.0),
			(start: date1, end: date1, value: 5.0)
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

	func testGivenSampleArrayWithOnlyOneSampleAndNilAggregation_countPer_returnsOne() {
		// given
		let samples = createSamples(withValues: [0.0])

		// when
		let counts = util.count(over: samples, per: nil, withUnit: Me.defaultUnit)

		// then
		XCTAssert(counts == [1])
	}

	func testGivenSampleArrayWithMultipleSamplesAndNilAggregation_countPer_returnsCorrectValue() {
		// given
		let samples = createSamples(withValues: [0.0, 1.0, 2.0])

		// when
		let counts = util.count(over: samples, per: nil, withUnit: Me.defaultUnit)

		// then
		XCTAssert(counts == [3])
	}

	func testGivenSampleArrayWithOnlyOneSample_countPer_returnsOne() {
		// given
		let aggregationUnit: Calendar.Component = .year
		let samples = [createSample(0.0)]
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.endDate))).thenReturn(sample.endDate)
			}
		}

		// when
		let counts = util.count(over: samples, per: aggregationUnit, withUnit: Me.defaultUnit)

		// then
		XCTAssert(counts == [1])
	}

	func testGivenSampleArrayWithOneSamplePerAggregationAndMultipleAggregations_countPer_returnsOneForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .month
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-02-01")!
		let date3 = Date("2018-03-01")!
		let samples = createSamples(withValues: [
			(start: date1, end: date1, value: 0.0),
			(start: date2, end: date2, value: 0.0),
			(start: date3, end: date3, value: 0.0)
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.endDate))).thenReturn(sample.endDate)
			}
		}

		// when
		let counts = util.count(over: samples, per: aggregationUnit, withUnit: Me.defaultUnit)

		// then
		XCTAssert(counts == [1, 1, 1])
	}

	func testGivenSampleArrayWithMultipleSamplesPerAggregationAndMultipleAggregations_countPer_returnsCorrectValueForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .day
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-01-02")!
		let date3 = Date("2018-01-03")!
		let samples = createSamples(withValues: [
			(start: date1, end: date1, value: 0.0),
			(start: date1, end: date1, value: 0.0),
			(start: date2, end: date2, value: 0.0),
			(start: date2, end: date2, value: 0.0),
			(start: date2, end: date2, value: 0.0),
			(start: date3, end: date3, value: 0.0),
			(start: date3, end: date3, value: 0.0),
			(start: date3, end: date3, value: 0.0),
			(start: date3, end: date3, value: 0.0)
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.endDate))).thenReturn(sample.endDate)
			}
		}

		// when
		let counts = util.count(over: samples, per: aggregationUnit, withUnit: Me.defaultUnit)

		// then
		XCTAssert(counts == [2, 3, 4])
	}

	func testGivenSampleArrayWithMultipleSamplesOutOfOrderPerAggregationAndMultipleAggregations_countPer_returnsCorrectValueForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .day
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-01-02")!
		let date3 = Date("2018-01-03")!
		let samples = createSamples(withValues: [
			(start: date1, end: date1, value: 0.0),
			(start: date2, end: date2, value: 0.0),
			(start: date3, end: date3, value: 0.0),
			(start: date2, end: date2, value: 0.0),
			(start: date3, end: date3, value: 0.0),
			(start: date1, end: date1, value: 0.0),
			(start: date3, end: date3, value: 0.0),
			(start: date2, end: date2, value: 0.0),
			(start: date3, end: date3, value: 0.0)
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.endDate))).thenReturn(sample.endDate)
			}
		}

		// when
		let counts = util.count(over: samples, per: aggregationUnit, withUnit: Me.defaultUnit)

		// then
		XCTAssert(counts == [2, 3, 4])
	}

	func testGivenSampleArrayWithOnlyOneValue_max_returnsThatValue() {
		// given
		let value = 3.4
		let samples = [createSample(value)]

		// when
		let max = util.max(over: samples, withUnit: Me.defaultUnit)

		// then
		XCTAssert(max == value)
	}

	func testGivenSampleArrayWithMultipleValues_max_returnsMaximumValue() {
		// given
		let expectedMax = 3.4
		let samples = createSamples(withValues: [expectedMax - 1, expectedMax, expectedMax - 2])

		// when
		let max = util.max(over: samples, withUnit: Me.defaultUnit)

		// then
		XCTAssert(max == expectedMax)
	}

	func testGivenSampleArrayWithOnlyOneSampleAndNilAggregation_maxPer_returnsValueForThatSample() {
		// given
		let samples = createSamples(withValues: [0.0])

		// when
		let maxs = util.max(over: samples, per: nil, withUnit: Me.defaultUnit)

		// then
		XCTAssert(maxs == [0.0])
	}

	func testGivenSampleArrayWithMultipleSamplesAndNilAggregation_maxPer_returnsCorrectValue() {
		// given
		let samples = createSamples(withValues: [1.0, 0.0, 2.0])

		// when
		let maxs = util.max(over: samples, per: nil, withUnit: Me.defaultUnit)

		// then
		XCTAssert(maxs == [2.0])
	}

	func testGivenSampleArrayWithOnlyOneSample_maxPer_returnsValueOfThatSample() {
		// given
		let aggregationUnit: Calendar.Component = .year
		let samples = [createSample(0.0)]
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.endDate))).thenReturn(sample.endDate)
			}
		}

		// when
		let maxs = util.max(over: samples, per: aggregationUnit, withUnit: Me.defaultUnit)

		// then
		XCTAssert(maxs == [0.0])
	}

	func testGivenSampleArrayWithOneSamplePerAggregationAndMultipleAggregations_maxPer_returnsCorrectValueForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .month
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-02-01")!
		let date3 = Date("2018-03-01")!
		let samples = createSamples(withValues: [
			(start: date1, end: date1, value: 0.0),
			(start: date2, end: date2, value: 1.0),
			(start: date3, end: date3, value: 2.0)
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.endDate))).thenReturn(sample.endDate)
			}
		}

		// when
		let maxs = util.max(over: samples, per: aggregationUnit, withUnit: Me.defaultUnit)

		// then
		XCTAssert(maxs == [0.0, 1.0, 2.0])
	}

	func testGivenSampleArrayWithMultipleSamplesPerAggregationAndMultipleAggregations_maxPer_returnsCorrectValueForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .day
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-01-02")!
		let date3 = Date("2018-01-03")!
		let samples = createSamples(withValues: [
			(start: date1, end: date1, value: 4.0),
			(start: date1, end: date1, value: 3.0),
			(start: date2, end: date2, value: 2.0),
			(start: date2, end: date2, value: 3.0),
			(start: date2, end: date2, value: 4.0),
			(start: date3, end: date3, value: 3.0),
			(start: date3, end: date3, value: 1.0),
			(start: date3, end: date3, value: 2.0),
			(start: date3, end: date3, value: 0.0)
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.endDate))).thenReturn(sample.endDate)
			}
		}

		// when
		let maxs = util.max(over: samples, per: aggregationUnit, withUnit: Me.defaultUnit)

		// then
		XCTAssert(maxs == [4.0, 4.0, 3.0])
	}

	func testGivenSampleArrayWithMultipleSamplesOutOfOrderPerAggregationAndMultipleAggregations_maxPer_returnsCorrectValueForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .day
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-01-02")!
		let date3 = Date("2018-01-03")!
		let samples = createSamples(withValues: [
			(start: date3, end: date3, value: 2.0),
			(start: date2, end: date2, value: 3.0),
			(start: date1, end: date1, value: 3.0),
			(start: date3, end: date3, value: 0.0),
			(start: date3, end: date3, value: 1.0),
			(start: date2, end: date2, value: 4.0),
			(start: date1, end: date1, value: 4.0),
			(start: date3, end: date3, value: 3.0),
			(start: date2, end: date2, value: 2.0)
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.endDate))).thenReturn(sample.endDate)
			}
		}

		// when
		let maxs = util.max(over: samples, per: aggregationUnit, withUnit: Me.defaultUnit)

		// then
		XCTAssert(maxs == [4.0, 4.0, 3.0])
	}

	func testGivenSampleArrayWithOnlyOneValue_min_returnsThatValue() {
		// given
		let value = 3.4
		let samples = [createSample(value)]

		// when
		let min = util.min(over: samples, withUnit: Me.defaultUnit)

		// then
		XCTAssert(min == value)
	}

	func testGivenSampleArrayWithMultipleValues_min_returnsMinimumValue() {
		// given
		let expectedMin = 3.4
		let samples = createSamples(withValues: [expectedMin + 1, expectedMin, expectedMin + 2])

		// when
		let min = util.min(over: samples, withUnit: Me.defaultUnit)

		// then
		XCTAssert(min == expectedMin)
	}

	func testGivenSampleArrayWithOnlyOneSampleAndNilAggregation_minPer_returnsValueForThatSample() {
		// given
		let samples = createSamples(withValues: [0.0])

		// when
		let mins = util.min(over: samples, per: nil, withUnit: Me.defaultUnit)

		// then
		XCTAssert(mins == [0.0])
	}

	func testGivenSampleArrayWithMultipleSamplesAndNilAggregation_minPer_returnsCorrectValue() {
		// given
		let samples = createSamples(withValues: [1.0, 0.0, 2.0])

		// when
		let mins = util.min(over: samples, per: nil, withUnit: Me.defaultUnit)

		// then
		XCTAssert(mins == [0.0])
	}

	func testGivenSampleArrayWithOnlyOneSample_minPer_returnsValueOfThatSample() {
		// given
		let aggregationUnit: Calendar.Component = .year
		let samples = [createSample(0.0)]
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.endDate))).thenReturn(sample.endDate)
			}
		}

		// when
		let mins = util.min(over: samples, per: aggregationUnit, withUnit: Me.defaultUnit)

		// then
		XCTAssert(mins == [0.0])
	}

	func testGivenSampleArrayWithOneSamplePerAggregationAndMultipleAggregations_minPer_returnsCorrectValueForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .month
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-02-01")!
		let date3 = Date("2018-03-01")!
		let samples = createSamples(withValues: [
			(start: date1, end: date1, value: 0.0),
			(start: date2, end: date2, value: 1.0),
			(start: date3, end: date3, value: 2.0)
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.endDate))).thenReturn(sample.endDate)
			}
		}

		// when
		let mins = util.min(over: samples, per: aggregationUnit, withUnit: Me.defaultUnit)

		// then
		XCTAssert(mins == [0.0, 1.0, 2.0])
	}

	func testGivenSampleArrayWithMultipleSamplesPerAggregationAndMultipleAggregations_minPer_returnsCorrectValueForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .day
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-01-02")!
		let date3 = Date("2018-01-03")!
		let samples = createSamples(withValues: [
			(start: date1, end: date1, value: 4.0),
			(start: date1, end: date1, value: 3.0),
			(start: date2, end: date2, value: 2.0),
			(start: date2, end: date2, value: 3.0),
			(start: date2, end: date2, value: 4.0),
			(start: date3, end: date3, value: 3.0),
			(start: date3, end: date3, value: 1.0),
			(start: date3, end: date3, value: 2.0),
			(start: date3, end: date3, value: 0.0)
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.endDate))).thenReturn(sample.endDate)
			}
		}

		// when
		let mins = util.min(over: samples, per: aggregationUnit, withUnit: Me.defaultUnit)

		// then
		XCTAssert(mins == [3.0, 2.0, 0.0])
	}

	func testGivenSampleArrayWithMultipleSamplesOutOfOrderPerAggregationAndMultipleAggregations_minPer_returnsCorrectValueForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .day
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-01-02")!
		let date3 = Date("2018-01-03")!
		let samples = createSamples(withValues: [
			(start: date3, end: date3, value: 1.0),
			(start: date1, end: date1, value: 3.0),
			(start: date3, end: date3, value: 2.0),
			(start: date3, end: date3, value: 3.0),
			(start: date2, end: date2, value: 3.0),
			(start: date2, end: date2, value: 2.0),
			(start: date3, end: date3, value: 0.0),
			(start: date1, end: date1, value: 4.0),
			(start: date2, end: date2, value: 4.0)
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.endDate))).thenReturn(sample.endDate)
			}
		}

		// when
		let mins = util.min(over: samples, per: aggregationUnit, withUnit: Me.defaultUnit)

		// then
		XCTAssert(mins == [3.0, 2.0, 0.0])
	}

	func testGivenSampleArrayWithOnlyOneValue_sum_returnsThatValue() {
		// given
		let value = 3.4
		let samples = [createSample(value)]

		// when
		let sum = util.sum(over: samples, withUnit: Me.defaultUnit)

		// then
		XCTAssert(sum == value)
	}

	func testGivenSampleArrayWithMultipleValues_sum_returnsCorrectValue() {
		// given
		let value1 = 1.0
		let value2 = 4.3
		let value3 = 87.2
		let samples = createSamples(withValues: [value1, value2, value3])
		let expectedSum = value1 + value2 + value3

		// when
		let sum = util.sum(over: samples, withUnit: Me.defaultUnit)

		// then
		XCTAssert(sum == expectedSum)
	}

	func testGivenSampleArrayWithOnlyOneSampleAndNilAggregation_sumPer_returnsValueForThatSample() {
		// given
		let samples = createSamples(withValues: [0.0])

		// when
		let sums = util.sum(over: samples, per: nil, withUnit: Me.defaultUnit)

		// then
		XCTAssert(sums == [0.0])
	}

	func testGivenSampleArrayWithMultipleSamplesAndNilAggregation_sumPer_returnsCorrectValue() {
		// given
		let value1 = 6.4
		let value2 = 1005.4
		let value3 = 23.45
		let samples = createSamples(withValues: [value1, value2, value3])
		let expectedSum = value1 + value2 + value3

		// when
		let sums = util.sum(over: samples, per: nil, withUnit: Me.defaultUnit)

		// then
		XCTAssert(sums == [expectedSum])
	}

	func testGivenSampleArrayWithOnlyOneSample_sumPer_returnsValueOfThatSample() {
		// given
		let aggregationUnit: Calendar.Component = .year
		let samples = [createSample(0.0)]
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.endDate))).thenReturn(sample.endDate)
			}
		}

		// when
		let sums = util.sum(over: samples, per: aggregationUnit, withUnit: Me.defaultUnit)

		// then
		XCTAssert(sums == [0.0])
	}

	func testGivenSampleArrayWithOneSamplePerAggregationAndMultipleAggregations_sumPer_returnsCorrectValueForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .month
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-02-01")!
		let date3 = Date("2018-03-01")!
		let samples = createSamples(withValues: [
			(start: date1, end: date1, value: 0.0),
			(start: date2, end: date2, value: 1.0),
			(start: date3, end: date3, value: 2.0)
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.endDate))).thenReturn(sample.endDate)
			}
		}

		// when
		let sums = util.sum(over: samples, per: aggregationUnit, withUnit: Me.defaultUnit)

		// then
		XCTAssert(sums == [0.0, 1.0, 2.0])
	}

	func testGivenSampleArrayWithMultipleSamplesPerAggregationAndMultipleAggregations_sumPer_returnsCorrectValueForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .day
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-01-02")!
		let date3 = Date("2018-01-03")!
		let samples = createSamples(withValues: [
			(start: date1, end: date1, value: 4.0),
			(start: date1, end: date1, value: 3.0),
			(start: date2, end: date2, value: 2.0),
			(start: date2, end: date2, value: 3.0),
			(start: date2, end: date2, value: 4.0),
			(start: date3, end: date3, value: 3.0),
			(start: date3, end: date3, value: 1.0),
			(start: date3, end: date3, value: 2.0),
			(start: date3, end: date3, value: 0.0)
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.endDate))).thenReturn(sample.endDate)
			}
		}

		// when
		let sums = util.sum(over: samples, per: aggregationUnit, withUnit: Me.defaultUnit)

		// then
		XCTAssert(sums == [7.0, 9.0, 6.0])
	}

	func testGivenSampleArrayWithMultipleSamplesOutOfOrderPerAggregationAndMultipleAggregations_sumPer_returnsCorrectValueForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .day
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-01-02")!
		let date3 = Date("2018-01-03")!
		let samples = createSamples(withValues: [
			(start: date3, end: date3, value: 2.0),
			(start: date2, end: date2, value: 2.0),
			(start: date1, end: date1, value: 4.0),
			(start: date2, end: date2, value: 4.0),
			(start: date3, end: date3, value: 1.0),
			(start: date3, end: date3, value: 3.0),
			(start: date2, end: date2, value: 3.0),
			(start: date1, end: date1, value: 3.0),
			(start: date3, end: date3, value: 0.0)
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.endDate))).thenReturn(sample.endDate)
			}
		}

		// when
		let sums = util.sum(over: samples, per: aggregationUnit, withUnit: Me.defaultUnit)

		// then
		XCTAssert(sums == [7.0, 9.0, 6.0])
	}

	// TODO - write unit tests for sortSamplesByAggregation
}
