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

class NumericSampleUtilTests: UnitTest {

	fileprivate typealias Me = NumericSampleUtilTests

	fileprivate var util: NumericSampleUtil!
	fileprivate var mockCalendarUtil: MockCalendarUtil!

	override func setUp() {
		super.setUp()
		util = NumericSampleUtil()

		let mockCalUtil = MockCalendarUtil()
		mockCalendarUtil = mockCalUtil
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
			(date: date3, value: 2.0),
			(date: date2, value: 1.0),
			(date: date2, value: 3.0),
			(date: date3, value: 4.0),
			(date: date3, value: 1.0),
			(date: date1, value: 7.0),
			(date: date2, value: 2.0),
			(date: date3, value: 3.0),
			(date: date1, value: 5.0),
		]
		let samples = createNumericSamples(withValues: entries)
		let aggregationUnit: Calendar.Component = .year
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(sample.dates[.start]!)
			}
		}
		let expectedAverages: [(date: Date?, value: Double)] = [
			(date: date1, value: 6.0),
			(date: date2, value: 2.0),
			(date: date3, value: 2.5),
		]
		let queryOperation = try QueryOperation.from(tag: Tags.average)
		queryOperation.aggregationUnit = aggregationUnit

		// when
		let averages = util.compute(operation: queryOperation, over: samples)

		// then
		XCTAssert(averages.count == expectedAverages.count)
		for index in 0 ..< averages.count {
			XCTAssert(averages[index].date == expectedAverages[index].date)
			XCTAssert(averages[index].value == expectedAverages[index].value)
		}
	}

	func testGivenCountOperationOverMultipleSamplesPerAggregationInMultipleAggregations_compute_returnsCorrectValues() throws {
		// given
		let aggregationUnit: Calendar.Component = .day
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-01-02")!
		let date3 = Date("2018-01-03")!
		let samples = createNumericSamples(withValues: [
			(date: date1, value: 0.0),
			(date: date2, value: 0.0),
			(date: date3, value: 0.0),
			(date: date2, value: 0.0),
			(date: date3, value: 0.0),
			(date: date1, value: 0.0),
			(date: date3, value: 0.0),
			(date: date2, value: 0.0),
			(date: date3, value: 0.0),
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(sample.dates[.start]!)
			}
		}
		let expectedCounts: [(date: Date?, value: Double)] = [
			(date: date1, value: 2),
			(date: date2, value: 3),
			(date: date3, value: 4),
		]
		let queryOperation = try QueryOperation.from(tag: Tags.count)
		queryOperation.aggregationUnit = aggregationUnit

		// when
		let counts = util.compute(operation: queryOperation, over: samples)

		// then
		XCTAssert(counts.count == expectedCounts.count)
		for index in 0 ..< counts.count {
			XCTAssert(counts[index].date == expectedCounts[index].date)
			XCTAssert(counts[index].value == expectedCounts[index].value)
		}
	}

	func testGivenMaxOperationOverMultipleSamplesPerAggregationInMultipleAggregations_compute_returnsCorrectValues() throws {
		// given
		let aggregationUnit: Calendar.Component = .day
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-01-02")!
		let date3 = Date("2018-01-03")!
		let value1 = 4.3
		let value2 = 54.2
		let value3 = 43.2
		let samples = createNumericSamples(withValues: [
			(date: date1, value: value1),
			(date: date3, value: value3 - 3),
			(date: date2, value: value2 - 1),
			(date: date3, value: value3),
			(date: date1, value: value1 - 1),
			(date: date2, value: value2),
			(date: date3, value: value3 - 1),
			(date: date3, value: value3 - 2),
			(date: date2, value: value2 - 2),
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(sample.dates[.start]!)
			}
		}
		let expectedMaxs: [(date: Date?, value: Double)] = [
			(date: date1, value: value1),
			(date: date2, value: value2),
			(date: date3, value: value3),
		]
		let queryOperation = try QueryOperation.from(tag: Tags.max)
		queryOperation.aggregationUnit = aggregationUnit

		// when
		let maxs = util.compute(operation: queryOperation, over: samples)

		// then
		XCTAssert(maxs.count == expectedMaxs.count)
		for index in 0 ..< maxs.count {
			XCTAssert(maxs[index].date == expectedMaxs[index].date)
			XCTAssert(maxs[index].value == expectedMaxs[index].value)
		}
	}

	func testGivenMinOperationOverMultipleSamplesPerAggregationInMultipleAggregations_compute_returnsCorrectValues() throws {
		// given
		let aggregationUnit: Calendar.Component = .day
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-01-02")!
		let date3 = Date("2018-01-03")!
		let value1 = 3.2
		let value2 = 534.2
		let value3 = 32.2
		let samples = createNumericSamples(withValues: [
			(date: date1, value: value1 + 1),
			(date: date3, value: value3),
			(date: date2, value: value2 + 1),
			(date: date3, value: value3 + 3),
			(date: date3, value: value3 + 2),
			(date: date3, value: value3 + 1),
			(date: date1, value: value1),
			(date: date2, value: value2 + 2),
			(date: date2, value: value2),
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(sample.dates[.start]!)
			}
		}
		let expectedMins: [(date: Date?, value: Double)] = [
			(date: date1, value: value1),
			(date: date2, value: value2),
			(date: date3, value: value3),
		]
		let queryOperation = try QueryOperation.from(tag: Tags.min)
		queryOperation.aggregationUnit = aggregationUnit

		// when
		let mins = util.compute(operation: queryOperation, over: samples)

		// then
		XCTAssert(mins.count == expectedMins.count)
		for index in 0 ..< mins.count {
			XCTAssert(mins[index].date == expectedMins[index].date)
			XCTAssert(mins[index].value == expectedMins[index].value)
		}
	}

	func testGivenSumOperationOverMultipleSamplesPerAggregationInMultipleAggregations_compute_returnsCorrectValues() throws {
		// given
		let aggregationUnit: Calendar.Component = .day
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-01-02")!
		let date3 = Date("2018-01-03")!
		let value1 = 3.2
		let value2 = 534.2
		let value3 = 32.2
		let samples = createNumericSamples(withValues: [
			(date: date2, value: value2),
			(date: date2, value: value2 + 2),
			(date: date3, value: value3 + 3),
			(date: date3, value: value3),
			(date: date1, value: value1 + 1),
			(date: date2, value: value2 + 1),
			(date: date3, value: value3 + 1),
			(date: date1, value: value1),
			(date: date3, value: value3 + 2),
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(sample.dates[.start]!)
			}
		}
		let expectedSums: [(date: Date?, value: Double)] = [
			(date: date1, value: 2 * value1 + 1),
			(date: date2, value: 3 * value2 + 3),
			(date: date3, value: 4 * value3 + 6),
		]
		let queryOperation = try QueryOperation.from(tag: Tags.sum)
		queryOperation.aggregationUnit = aggregationUnit

		// when
		let sums = util.compute(operation: queryOperation, over: samples)

		// then
		XCTAssert(sums.count == expectedSums.count)
		for index in 0 ..< sums.count {
			XCTAssert(sums[index].date == expectedSums[index].date)
			XCTAssert(sums[index].value == expectedSums[index].value)
		}
	}

	func testGivenOneSample_average_returnsValueOfThatSample() {
		// given
		let expectedAverage = 5.0
		let samples = createNumericSamples(withValues: [expectedAverage])

		// when
		let average = util.average(over: samples)

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
		let samples = createNumericSamples(withValues: values)

		// when
		let average = util.average(over: samples)

		// then
		XCTAssert(average == expectedAverage)
	}

	func testGivenOnlyOneSampleWithNilAggregation_averagePer_returnsValueForThatSample() {
		// given
		let values = [5.0]
		let samples = createNumericSamples(withValues: values)
		let expectedAverages: [(date: Date?, value: Double)] = [(date: nil, value: 5.0)]

		// when
		let averages = util.average(over: samples, per: nil)

		// then
		XCTAssert(averages.count == expectedAverages.count)
		for index in 0 ..< averages.count {
			XCTAssert(averages[index].date == expectedAverages[index].date)
			XCTAssert(averages[index].value == expectedAverages[index].value)
		}
	}

	func testGivenMultipleSamplesWithNilAggregation_averagePer_returnsCorrectValue() {
		// given
		let values = [1.23, 5.7, 19.2, 8.6]
		var expectedAverage = 0.0
		for value in values {
			expectedAverage += value
		}
		expectedAverage /= Double(values.count)
		let samples = createNumericSamples(withValues: values)

		// when
		let averages = util.average(over: samples, per: nil)

		// then
		XCTAssert(averages.count == 1)
		XCTAssert(averages[0].date == nil)
		XCTAssert(averages[0].value == expectedAverage)
	}

	func testGivenOnlyOneSampleInOneAggregationUnit_averagePer_returnsValueForThatSample() {
		// given
		let values = [5.0]
		let samples = createNumericSamples(withValues: values)
		let aggregationUnit: Calendar.Component = .year
		let aggregationDate = Date()
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(aggregationDate)
			}
		}

		// when
		let averages = util.average(over: samples, per: aggregationUnit)

		// then
		XCTAssert(averages.count == 1)
		XCTAssert(averages[0].date == aggregationDate)
		XCTAssert(averages[0].value == 5.0)
	}

	func testGivenMultipleSamplesFromSameAggregationUnit_averagePer_returnsCorrectAverageForThatYear() {
		// given
		let date = Date("2018-01-01")!
		let entries = [
			(date: date, value: 5.0),
			(date: date, value: 2.0),
			(date: date, value: 1.0),
		]
		let samples = createNumericSamples(withValues: entries)
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
		let averages = util.average(over: samples, per: aggregationUnit)

		// then
		XCTAssert(averages.count == 1)
		XCTAssert(averages[0].date == aggregationDate)
		XCTAssert(averages[0].value == expectedAverage)
	}

	func testGivenThreeSamplesWithOneSamplePerAggregationUnit_averagePer_returnsCorrectValueForEachYear() {
		// given
		let date1 = Date("2018-01-01")!
		let date2 = Date("2019-01-01")!
		let date3 = Date("2020-01-01")!
		let value1 = 5.0
		let value2 = 43.3
		let value3 = 53.3
		let entries = [
			(date: date1, value: value1),
			(date: date2, value: value2),
			(date: date3, value: value3),
		]
		let samples = createNumericSamples(withValues: entries)
		let aggregationUnit: Calendar.Component = .year
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(sample.dates[.start]!)
			}
		}
		let expectedAverages: [(date: Date?, value: Double)] = [
			(date: date1, value: value1),
			(date: date2, value: value2),
			(date: date3, value: value3),
		]

		// when
		let averages = util.average(over: samples, per: aggregationUnit)

		// then
		XCTAssert(averages.count == expectedAverages.count)
		for index in 0 ..< averages.count {
			XCTAssert(averages[index].date == expectedAverages[index].date)
			XCTAssert(averages[index].value == expectedAverages[index].value)
		}
	}

	func testGivenMultipleSamplesPerAggregationUnitOverMultipleAggregations_averagePer_returnsCorrectValueForEachYear() {
		// given
		let date1 = Date("2018-01-01")!
		let date2 = Date("2019-01-01")!
		let date3 = Date("2020-01-01")!
		let entries = [
			(date: date1, value: 5.0),
			(date: date1, value: 7.0),
			(date: date2, value: 1.0),
			(date: date2, value: 2.0),
			(date: date2, value: 3.0),
			(date: date3, value: 1.0),
			(date: date3, value: 2.0),
			(date: date3, value: 3.0),
			(date: date3, value: 4.0),
		]
		let samples = createNumericSamples(withValues: entries)
		let aggregationUnit: Calendar.Component = .year
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(sample.dates[.start]!)
			}
		}
		let expectedAverages: [(date: Date?, value: Double)] = [
			(date: date1, value: 6.0),
			(date: date2, value: 2.0),
			(date: date3, value: 2.5),
		]

		// when
		let averages = util.average(over: samples, per: aggregationUnit)

		// then
		XCTAssert(averages.count == expectedAverages.count)
		for index in 0 ..< averages.count {
			XCTAssert(averages[index].date == expectedAverages[index].date)
			XCTAssert(averages[index].value == expectedAverages[index].value)
		}
	}

	func testGivenMultipleSamplesOutOfOrderPerAggregationUnitOverMultipleAggregations_averagePer_returnsCorrectValueForEachYear() {
		// given
		let date1 = Date("2018-01-01")!
		let date2 = Date("2019-01-01")!
		let date3 = Date("2020-01-01")!
		let entries = [
			(date: date3, value: 2.0),
			(date: date2, value: 1.0),
			(date: date2, value: 3.0),
			(date: date3, value: 4.0),
			(date: date3, value: 1.0),
			(date: date1, value: 7.0),
			(date: date2, value: 2.0),
			(date: date3, value: 3.0),
			(date: date1, value: 5.0),
		]
		let samples = createNumericSamples(withValues: entries)
		let aggregationUnit: Calendar.Component = .year
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(sample.dates[.start]!)
			}
		}
		let expectedAverages: [(date: Date?, value: Double)] = [
			(date: date1, value: 6.0),
			(date: date2, value: 2.0),
			(date: date3, value: 2.5),
		]

		// when
		let averages = util.average(over: samples, per: aggregationUnit)

		// then
		XCTAssert(averages.count == expectedAverages.count)
		for index in 0 ..< averages.count {
			XCTAssert(averages[index].date == expectedAverages[index].date)
			XCTAssert(averages[index].value == expectedAverages[index].value)
		}
	}

	func testGivenSampleArrayWithOnlyOneSampleAndNilAggregation_countPer_returnsOne() {
		// given
		let samples = createNumericSamples(withValues: [0.0])

		// when
		let counts = util.count(over: samples, per: nil)

		// then
		XCTAssert(counts.count == 1)
		XCTAssert(counts[0].date == nil)
		XCTAssert(counts[0].value == 1)
	}

	func testGivenSampleArrayWithMultipleSamplesAndNilAggregation_countPer_returnsCorrectValue() {
		// given
		let samples = createNumericSamples(withValues: [0.0, 1.0, 2.0])

		// when
		let counts = util.count(over: samples, per: nil)

		// then
		XCTAssert(counts.count == 1)
		XCTAssert(counts[0].date == nil)
		XCTAssert(counts[0].value == 3)
	}

	func testGivenSampleArrayWithOnlyOneSample_countPer_returnsOne() {
		// given
		let aggregationUnit: Calendar.Component = .year
		let samples = [createNumericSample(0.0)]
		let aggregationDate = Date()
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(aggregationDate)
			}
		}

		// when
		let counts = util.count(over: samples, per: aggregationUnit)

		// then
		XCTAssert(counts.count == 1)
		XCTAssert(counts[0].date == aggregationDate)
		XCTAssert(counts[0].value == 1)
	}

	func testGivenSampleArrayWithOneSamplePerAggregationAndMultipleAggregations_countPer_returnsOneForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .month
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-02-01")!
		let date3 = Date("2018-03-01")!
		let samples = createNumericSamples(withValues: [
			(date: date1, value: 0.0),
			(date: date2, value: 0.0),
			(date: date3, value: 0.0),
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(sample.dates[.start]!)
			}
		}
		let expectedCounts: [(date: Date?, value: Double)] = [
			(date: date1, value: 1),
			(date: date2, value: 1),
			(date: date3, value: 1),
		]

		// when
		let counts = util.count(over: samples, per: aggregationUnit)

		// then
		XCTAssert(counts.count == expectedCounts.count)
		for index in 0 ..< counts.count {
			XCTAssert(counts[index].date == expectedCounts[index].date)
			XCTAssert(counts[index].value == expectedCounts[index].value)
		}
	}

	func testGivenSampleArrayWithMultipleSamplesPerAggregationAndMultipleAggregations_countPer_returnsCorrectValueForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .day
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-01-02")!
		let date3 = Date("2018-01-03")!
		let samples = createNumericSamples(withValues: [
			(date: date1, value: 0.0),
			(date: date1, value: 0.0),
			(date: date2, value: 0.0),
			(date: date2, value: 0.0),
			(date: date2, value: 0.0),
			(date: date3, value: 0.0),
			(date: date3, value: 0.0),
			(date: date3, value: 0.0),
			(date: date3, value: 0.0),
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(sample.dates[.start]!)
			}
		}
		let expectedCounts: [(date: Date?, value: Double)] = [
			(date: date1, value: 2),
			(date: date2, value: 3),
			(date: date3, value: 4),
		]

		// when
		let counts = util.count(over: samples, per: aggregationUnit)

		// then
		XCTAssert(counts.count == expectedCounts.count)
		for index in 0 ..< counts.count {
			XCTAssert(counts[index].date == expectedCounts[index].date)
			XCTAssert(counts[index].value == expectedCounts[index].value)
		}
	}

	func testGivenSampleArrayWithMultipleSamplesOutOfOrderPerAggregationAndMultipleAggregations_countPer_returnsCorrectValueForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .day
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-01-02")!
		let date3 = Date("2018-01-03")!
		let samples = createNumericSamples(withValues: [
			(date: date1, value: 0.0),
			(date: date2, value: 0.0),
			(date: date3, value: 0.0),
			(date: date2, value: 0.0),
			(date: date3, value: 0.0),
			(date: date1, value: 0.0),
			(date: date3, value: 0.0),
			(date: date2, value: 0.0),
			(date: date3, value: 0.0),
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(sample.dates[.start]!)
			}
		}
		let expectedCounts: [(date: Date?, value: Double)] = [
			(date: date1, value: 2),
			(date: date2, value: 3),
			(date: date3, value: 4),
		]

		// when
		let counts = util.count(over: samples, per: aggregationUnit)

		// then
		XCTAssert(counts.count == expectedCounts.count)
		for index in 0 ..< counts.count {
			XCTAssert(counts[index].date == expectedCounts[index].date)
			XCTAssert(counts[index].value == expectedCounts[index].value)
		}
	}

	func testGivenSampleArrayWithOnlyOneValue_max_returnsThatValue() {
		// given
		let value = 3.4
		let samples = [createNumericSample(value)]

		// when
		let max = util.max(over: samples)

		// then
		XCTAssert(max == value)
	}

	func testGivenSampleArrayWithMultipleValues_max_returnsMaximumValue() {
		// given
		let expectedMax = 3.4
		let samples = createNumericSamples(withValues: [expectedMax - 1, expectedMax, expectedMax - 2])

		// when
		let max = util.max(over: samples)

		// then
		XCTAssert(max == expectedMax)
	}

	func testGivenSampleArrayWithOnlyOneSampleAndNilAggregation_maxPer_returnsValueForThatSample() {
		// given
		let value = 5.2
		let samples = createNumericSamples(withValues: [value])

		// when
		let maxs = util.max(over: samples, per: nil)

		// then
		XCTAssert(maxs.count == 1)
		XCTAssert(maxs[0].date == nil)
		XCTAssert(maxs[0].value == value)
	}

	func testGivenSampleArrayWithMultipleSamplesAndNilAggregation_maxPer_returnsCorrectValue() {
		// given
		let maxValue = 2.0
		let samples = createNumericSamples(withValues: [maxValue - 1, maxValue - 2, maxValue])

		// when
		let maxs = util.max(over: samples, per: nil)

		// then
		XCTAssert(maxs.count == 1)
		XCTAssert(maxs[0].date == nil)
		XCTAssert(maxs[0].value == maxValue)
	}

	func testGivenSampleArrayWithOnlyOneSample_maxPer_returnsValueOfThatSample() {
		// given
		let aggregationUnit: Calendar.Component = .year
		let value = 5.4
		let samples = [createNumericSample(value)]
		let aggregationDate = Date()
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(aggregationDate)
			}
		}

		// when
		let maxs = util.max(over: samples, per: aggregationUnit)

		// then
		XCTAssert(maxs.count == 1)
		XCTAssert(maxs[0].date == aggregationDate)
		XCTAssert(maxs[0].value == value)
	}

	func testGivenSampleArrayWithOneSamplePerAggregationAndMultipleAggregations_maxPer_returnsCorrectValueForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .month
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-02-01")!
		let date3 = Date("2018-03-01")!
		let value1 = 4.3
		let value2 = 5.3
		let value3 = 43.4
		let samples = createNumericSamples(withValues: [
			(date: date1, value: value1),
			(date: date2, value: value2),
			(date: date3, value: value3),
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(sample.dates[.start]!)
			}
		}
		let expectedMaxs: [(date: Date?, value: Double)] = [
			(date: date1, value: value1),
			(date: date2, value: value2),
			(date: date3, value: value3),
		]

		// when
		let maxs = util.max(over: samples, per: aggregationUnit)

		// then
		XCTAssert(maxs.count == expectedMaxs.count)
		for index in 0 ..< maxs.count {
			XCTAssert(maxs[index].date == expectedMaxs[index].date)
			XCTAssert(maxs[index].value == expectedMaxs[index].value)
		}
	}

	func testGivenSampleArrayWithMultipleSamplesPerAggregationAndMultipleAggregations_maxPer_returnsCorrectValueForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .day
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-01-02")!
		let date3 = Date("2018-01-03")!
		let value1 = 4.3
		let value2 = 54.2
		let value3 = 43.2
		let samples = createNumericSamples(withValues: [
			(date: date1, value: value1),
			(date: date1, value: value1 - 1),
			(date: date2, value: value2 - 2),
			(date: date2, value: value2 - 1),
			(date: date2, value: value2),
			(date: date3, value: value3),
			(date: date3, value: value3 - 2),
			(date: date3, value: value3 - 1),
			(date: date3, value: value3 - 3)
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(sample.dates[.start]!)
			}
		}
		let expectedMaxs: [(date: Date?, value: Double)] = [
			(date: date1, value: value1),
			(date: date2, value: value2),
			(date: date3, value: value3),
		]

		// when
		let maxs = util.max(over: samples, per: aggregationUnit)

		// then
		XCTAssert(maxs.count == expectedMaxs.count)
		for index in 0 ..< maxs.count {
			XCTAssert(maxs[index].date == expectedMaxs[index].date)
			XCTAssert(maxs[index].value == expectedMaxs[index].value)
		}
	}

	func testGivenSampleArrayWithMultipleSamplesOutOfOrderPerAggregationAndMultipleAggregations_maxPer_returnsCorrectValueForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .day
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-01-02")!
		let date3 = Date("2018-01-03")!
		let value1 = 4.3
		let value2 = 54.2
		let value3 = 43.2
		let samples = createNumericSamples(withValues: [
			(date: date1, value: value1),
			(date: date3, value: value3 - 3),
			(date: date2, value: value2 - 1),
			(date: date3, value: value3),
			(date: date1, value: value1 - 1),
			(date: date2, value: value2),
			(date: date3, value: value3 - 1),
			(date: date3, value: value3 - 2),
			(date: date2, value: value2 - 2),
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(sample.dates[.start]!)
			}
		}
		let expectedMaxs: [(date: Date?, value: Double)] = [
			(date: date1, value: value1),
			(date: date2, value: value2),
			(date: date3, value: value3),
		]

		// when
		let maxs = util.max(over: samples, per: aggregationUnit)

		// then
		XCTAssert(maxs.count == expectedMaxs.count)
		for index in 0 ..< maxs.count {
			XCTAssert(maxs[index].date == expectedMaxs[index].date)
			XCTAssert(maxs[index].value == expectedMaxs[index].value)
		}
	}

	func testGivenSampleArrayWithOnlyOneValue_min_returnsThatValue() {
		// given
		let value = 3.4
		let samples = [createNumericSample(value)]

		// when
		let min = util.min(over: samples)

		// then
		XCTAssert(min == value)
	}

	func testGivenSampleArrayWithMultipleValues_min_returnsMinimumValue() {
		// given
		let expectedMin = 3.4
		let samples = createNumericSamples(withValues: [expectedMin + 1, expectedMin, expectedMin + 2])

		// when
		let min = util.min(over: samples)

		// then
		XCTAssert(min == expectedMin)
	}

	func testGivenSampleArrayWithOnlyOneSampleAndNilAggregation_minPer_returnsValueForThatSample() {
		// given
		let value = 4.3
		let samples = createNumericSamples(withValues: [value])

		// when
		let mins = util.min(over: samples, per: nil)

		// then
		XCTAssert(mins.count == 1)
		XCTAssert(mins[0].date == nil)
		XCTAssert(mins[0].value == value)
	}

	func testGivenSampleArrayWithMultipleSamplesAndNilAggregation_minPer_returnsCorrectValue() {
		// given
		let minValue = 4.2432
		let samples = createNumericSamples(withValues: [minValue + 1, minValue, minValue + 2])

		// when
		let mins = util.min(over: samples, per: nil)

		// then
		XCTAssert(mins.count == 1)
		XCTAssert(mins[0].date == nil)
		XCTAssert(mins[0].value == minValue)
	}

	func testGivenSampleArrayWithOnlyOneSample_minPer_returnsValueOfThatSample() {
		// given
		let aggregationUnit: Calendar.Component = .year
		let value = 23.5
		let samples = [createNumericSample(value)]
		let aggregationDate = Date()
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(aggregationDate)
			}
		}

		// when
		let mins = util.min(over: samples, per: aggregationUnit)

		// then
		XCTAssert(mins.count == 1)
		XCTAssert(mins[0].date == aggregationDate)
		XCTAssert(mins[0].value == value)
	}

	func testGivenSampleArrayWithOneSamplePerAggregationAndMultipleAggregations_minPer_returnsCorrectValueForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .month
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-02-01")!
		let date3 = Date("2018-03-01")!
		let value1 = 3.2
		let value2 = 534.2
		let value3 = 32.2
		let samples = createNumericSamples(withValues: [
			(date: date1, value: value1),
			(date: date2, value: value2),
			(date: date3, value: value3),
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(sample.dates[.start]!)
			}
		}
		let expectedMins: [(date: Date?, value: Double)] = [
			(date: date1, value: value1),
			(date: date2, value: value2),
			(date: date3, value: value3),
		]

		// when
		let mins = util.min(over: samples, per: aggregationUnit)

		// then
		XCTAssert(mins.count == expectedMins.count)
		for index in 0 ..< mins.count {
			XCTAssert(mins[index].date == expectedMins[index].date)
			XCTAssert(mins[index].value == expectedMins[index].value)
		}
	}

	func testGivenSampleArrayWithMultipleSamplesPerAggregationAndMultipleAggregations_minPer_returnsCorrectValueForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .day
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-01-02")!
		let date3 = Date("2018-01-03")!
		let value1 = 3.2
		let value2 = 534.2
		let value3 = 32.2
		let samples = createNumericSamples(withValues: [
			(date: date1, value: value1 + 1),
			(date: date1, value: value1),
			(date: date2, value: value2),
			(date: date2, value: value2 + 1),
			(date: date2, value: value2 + 2),
			(date: date3, value: value3 + 3),
			(date: date3, value: value3 + 1),
			(date: date3, value: value3 + 2),
			(date: date3, value: value3),
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(sample.dates[.start]!)
			}
		}
		let expectedMins: [(date: Date?, value: Double)] = [
			(date: date1, value: value1),
			(date: date2, value: value2),
			(date: date3, value: value3),
		]

		// when
		let mins = util.min(over: samples, per: aggregationUnit)

		// then
		XCTAssert(mins.count == expectedMins.count)
		for index in 0 ..< mins.count {
			XCTAssert(mins[index].date == expectedMins[index].date)
			XCTAssert(mins[index].value == expectedMins[index].value)
		}
	}

	func testGivenSampleArrayWithMultipleSamplesOutOfOrderPerAggregationAndMultipleAggregations_minPer_returnsCorrectValueForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .day
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-01-02")!
		let date3 = Date("2018-01-03")!
		let value1 = 3.2
		let value2 = 534.2
		let value3 = 32.2
		let samples = createNumericSamples(withValues: [
			(date: date1, value: value1 + 1),
			(date: date3, value: value3),
			(date: date2, value: value2 + 1),
			(date: date3, value: value3 + 3),
			(date: date3, value: value3 + 2),
			(date: date3, value: value3 + 1),
			(date: date1, value: value1),
			(date: date2, value: value2 + 2),
			(date: date2, value: value2),
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(sample.dates[.start]!)
			}
		}
		let expectedMins: [(date: Date?, value: Double)] = [
			(date: date1, value: value1),
			(date: date2, value: value2),
			(date: date3, value: value3),
		]

		// when
		let mins = util.min(over: samples, per: aggregationUnit)

		// then
		XCTAssert(mins.count == expectedMins.count)
		for index in 0 ..< mins.count {
			XCTAssert(mins[index].date == expectedMins[index].date)
			XCTAssert(mins[index].value == expectedMins[index].value)
		}
	}

	func testGivenSampleArrayWithOnlyOneValue_sum_returnsThatValue() {
		// given
		let value = 3.4
		let samples = [createNumericSample(value)]

		// when
		let sum = util.sum(over: samples)

		// then
		XCTAssert(sum == value)
	}

	func testGivenSampleArrayWithMultipleValues_sum_returnsCorrectValue() {
		// given
		let value1 = 1.0
		let value2 = 4.3
		let value3 = 87.2
		let samples = createNumericSamples(withValues: [value1, value2, value3])
		let expectedSum = value1 + value2 + value3

		// when
		let sum = util.sum(over: samples)

		// then
		XCTAssert(sum == expectedSum)
	}

	func testGivenSampleArrayWithOnlyOneSampleAndNilAggregation_sumPer_returnsValueForThatSample() {
		// given
		let value = 23.3
		let samples = createNumericSamples(withValues: [value])

		// when
		let sums = util.sum(over: samples, per: nil)

		// then
		XCTAssert(sums.count == 1)
		XCTAssert(sums[0].date == nil)
		XCTAssert(sums[0].value == value)
	}

	func testGivenSampleArrayWithMultipleSamplesAndNilAggregation_sumPer_returnsCorrectValue() {
		// given
		let value1 = 6.4
		let value2 = 1005.4
		let value3 = 23.45
		let samples = createNumericSamples(withValues: [value1, value2, value3])
		let expectedSum = value1 + value2 + value3

		// when
		let sums = util.sum(over: samples, per: nil)

		// then
		XCTAssert(sums.count == 1)
		XCTAssert(sums[0].date == nil)
		XCTAssert(sums[0].value == expectedSum)
	}

	func testGivenSampleArrayWithOnlyOneSample_sumPer_returnsValueOfThatSample() {
		// given
		let aggregationUnit: Calendar.Component = .year
		let value = 4.2
		let samples = [createNumericSample(value)]
		let aggregationDate = Date()
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(aggregationDate)
			}
		}

		// when
		let sums = util.sum(over: samples, per: aggregationUnit)

		// then
		XCTAssert(sums.count == 1)
		XCTAssert(sums[0].date == aggregationDate)
		XCTAssert(sums[0].value == value)
	}

	func testGivenSampleArrayWithOneSamplePerAggregationAndMultipleAggregations_sumPer_returnsCorrectValueForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .month
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-02-01")!
		let date3 = Date("2018-03-01")!
		let value1 = 3.2
		let value2 = 534.2
		let value3 = 32.2
		let samples = createNumericSamples(withValues: [
			(date: date1, value: value1),
			(date: date2, value: value2),
			(date: date3, value: value3)
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(sample.dates[.start]!)
			}
		}
		let expectedSums: [(date: Date?, value: Double)] = [
			(date: date1, value: value1),
			(date: date2, value: value2),
			(date: date3, value: value3),
		]

		// when
		let sums = util.sum(over: samples, per: aggregationUnit)

		// then
		XCTAssert(sums.count == expectedSums.count)
		for index in 0 ..< sums.count {
			XCTAssert(sums[index].date == expectedSums[index].date)
			XCTAssert(sums[index].value == expectedSums[index].value)
		}
	}

	func testGivenSampleArrayWithMultipleSamplesPerAggregationAndMultipleAggregations_sumPer_returnsCorrectValueForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .day
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-01-02")!
		let date3 = Date("2018-01-03")!
		let value1 = 3.2
		let value2 = 534.2
		let value3 = 32.2
		let samples = createNumericSamples(withValues: [
			(date: date1, value: value1),
			(date: date1, value: value1 + 1),
			(date: date2, value: value2),
			(date: date2, value: value2 + 2),
			(date: date2, value: value2 + 1),
			(date: date3, value: value3 + 2),
			(date: date3, value: value3),
			(date: date3, value: value3 + 1),
			(date: date3, value: value3 + 3),
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(sample.dates[.start]!)
			}
		}
		let expectedSums: [(date: Date?, value: Double)] = [
			(date: date1, value: 2 * value1 + 1),
			(date: date2, value: 3 * value2 + 3),
			(date: date3, value: 4 * value3 + 6),
		]

		// when
		let sums = util.sum(over: samples, per: aggregationUnit)

		// then
		XCTAssert(sums.count == expectedSums.count)
		for index in 0 ..< sums.count {
			XCTAssert(sums[index].date == expectedSums[index].date)
			XCTAssert(sums[index].value == expectedSums[index].value)
		}
	}

	func testGivenSampleArrayWithMultipleSamplesOutOfOrderPerAggregationAndMultipleAggregations_sumPer_returnsCorrectValueForEachAggregation() {
		// given
		let aggregationUnit: Calendar.Component = .day
		let date1 = Date("2018-01-01")!
		let date2 = Date("2018-01-02")!
		let date3 = Date("2018-01-03")!
		let value1 = 3.2
		let value2 = 534.2
		let value3 = 32.2
		let samples = createNumericSamples(withValues: [
			(date: date2, value: value2),
			(date: date2, value: value2 + 2),
			(date: date3, value: value3 + 3),
			(date: date3, value: value3),
			(date: date1, value: value1 + 1),
			(date: date2, value: value2 + 1),
			(date: date3, value: value3 + 1),
			(date: date1, value: value1),
			(date: date3, value: value3 + 2),
		])
		stub(mockCalendarUtil) { stub in
			for sample in samples {
				when(stub.start(of: equal(to: aggregationUnit), in: equal(to: sample.dates[.start]!))).thenReturn(sample.dates[.start]!)
			}
		}
		let expectedSums: [(date: Date?, value: Double)] = [
			(date: date1, value: 2 * value1 + 1),
			(date: date2, value: 3 * value2 + 3),
			(date: date3, value: 4 * value3 + 6),
		]

		// when
		let sums = util.sum(over: samples, per: aggregationUnit)

		// then
		XCTAssert(sums.count == expectedSums.count)
		for index in 0 ..< sums.count {
			XCTAssert(sums[index].date == expectedSums[index].date)
			XCTAssert(sums[index].value == expectedSums[index].value)
		}
	}

	// TODO - write unit tests for sortSamplesByAggregation
}
