//
//  NumericSampleUtilUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import HealthKit
import SwiftyMocky
@testable import Introspective

class NumericSampleUtilUnitTests: UnitTest {

	fileprivate typealias Me = NumericSampleUtilUnitTests
	fileprivate static let attribute = HeartRate.heartRate

	fileprivate var util: NumericSampleUtilImpl!

	override func setUp() {
		super.setUp()
		util = NumericSampleUtilImpl()
	}

	func testGivenOneSample_average_returnsValueOfThatSample() {
		// given
		let expectedAverage = 5.0
		let samples = SampleCreatorTestUtil.createSamples(withValues: [expectedAverage], for: Me.attribute)

		// when
		let average = util.average(for: Me.attribute, over: samples)

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
		let samples = SampleCreatorTestUtil.createSamples(withValues: values, for: Me.attribute)

		// when
		let average = util.average(for: Me.attribute, over: samples)

		// then
		XCTAssert(average == expectedAverage)
	}

	func testGivenOnlyOneSampleWithNilAggregation_averagePer_returnsValueForThatSample() {
		// given
		let values = [5.0]
		let samples = SampleCreatorTestUtil.createSamples(withValues: values, for: Me.attribute)
		let expectedAverages: [(date: Date?, value: Double)] = [(date: nil, value: 5.0)]

		// when
		let averages = util.average(for: Me.attribute, over: samples, per: nil)

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
		let samples = SampleCreatorTestUtil.createSamples(withValues: values, for: Me.attribute)

		// when
		let averages = util.average(for: Me.attribute, over: samples, per: nil)

		// then
		XCTAssert(averages.count == 1)
		XCTAssert(averages[0].date == nil)
		XCTAssert(averages[0].value == expectedAverage)
	}

	func testGivenOnlyOneSampleInOneAggregationUnit_averagePer_returnsValueForThatSample() {
		// given
		let values = [5.0]
		let samples = SampleCreatorTestUtil.createSamples(withValues: values, for: Me.attribute)
		let aggregationUnit: Calendar.Component = .year
		let aggregationDate = Date()
		Given(mockSampleUtil, .sort(samples: .any([Sample].self), by: .value(aggregationUnit), willReturn: [(date: aggregationDate, samples: samples)]))

		// when
		let averages = util.average(for: Me.attribute, over: samples, per: aggregationUnit)

		// then
		XCTAssert(averages.count == 1)
		XCTAssert(averages[0].date == aggregationDate)
		XCTAssert(averages[0].value == 5.0)
	}

	func testGivenMultipleSamplesFromSameAggregationUnit_averagePer_returnsCorrectAverageForThatYear() {
		// given
		let date = Date("2018-01-01")!
		let entries = [
			(startDate: date, value: 5.0),
			(startDate: date, value: 2.0),
			(startDate: date, value: 1.0),
		]
		let samples = SampleCreatorTestUtil.createSamples(entries, for: Me.attribute)
		let aggregationUnit: Calendar.Component = .year
		let aggregationDate = Date()
		Given(mockSampleUtil, .sort(samples: .any([Sample].self), by: .value(aggregationUnit), willReturn: [(date: aggregationDate, samples: samples)]))
		var expectedAverage = 0.0
		for entry in entries {
			expectedAverage += entry.value
		}
		expectedAverage /= Double(entries.count)

		// when
		let averages = util.average(for: Me.attribute, over: samples, per: aggregationUnit)

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
			(startDate: date1, value: value1),
			(startDate: date2, value: value2),
			(startDate: date3, value: value3),
		]
		let samples = SampleCreatorTestUtil.createSamples(entries, for: Me.attribute)
		let aggregationUnit: Calendar.Component = .year
		Given(mockSampleUtil, .sort(samples: .any([Sample].self), by: .value(aggregationUnit), willReturn: generateAggregationSortReturnValue(for: samples)))
		let expectedAverages: [(date: Date?, value: Double)] = [
			(date: date1, value: value1),
			(date: date2, value: value2),
			(date: date3, value: value3),
		]

		// when
		let averages = util.average(for: Me.attribute, over: samples, per: aggregationUnit)

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
			(startDate: date1, value: 5.0),
			(startDate: date1, value: 7.0),
			(startDate: date2, value: 1.0),
			(startDate: date2, value: 2.0),
			(startDate: date2, value: 3.0),
			(startDate: date3, value: 1.0),
			(startDate: date3, value: 2.0),
			(startDate: date3, value: 3.0),
			(startDate: date3, value: 4.0),
		]
		let samples = SampleCreatorTestUtil.createSamples(entries, for: Me.attribute)
		let aggregationUnit: Calendar.Component = .year
		Given(mockSampleUtil, .sort(samples: .any([Sample].self), by: .value(aggregationUnit), willReturn: generateAggregationSortReturnValue(for: samples)))
		let expectedAverages: [(date: Date?, value: Double)] = [
			(date: date1, value: 6.0),
			(date: date2, value: 2.0),
			(date: date3, value: 2.5),
		]

		// when
		let averages = util.average(for: Me.attribute, over: samples, per: aggregationUnit)

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
			(startDate: date3, value: 2.0),
			(startDate: date2, value: 1.0),
			(startDate: date2, value: 3.0),
			(startDate: date3, value: 4.0),
			(startDate: date3, value: 1.0),
			(startDate: date1, value: 7.0),
			(startDate: date2, value: 2.0),
			(startDate: date3, value: 3.0),
			(startDate: date1, value: 5.0),
		]
		let samples = SampleCreatorTestUtil.createSamples(entries, for: Me.attribute)
		let aggregationUnit: Calendar.Component = .year
		Given(mockSampleUtil, .sort(samples: .any([Sample].self), by: .value(aggregationUnit), willReturn: generateAggregationSortReturnValue(for: samples)))
		let expectedAverages: [(date: Date?, value: Double)] = [
			(date: date1, value: 6.0),
			(date: date2, value: 2.0),
			(date: date3, value: 2.5),
		]

		// when
		let averages = util.average(for: Me.attribute, over: samples, per: aggregationUnit)

		// then
		XCTAssert(averages.count == expectedAverages.count)
		for index in 0 ..< averages.count {
			XCTAssert(averages[index].date == expectedAverages[index].date)
			XCTAssert(averages[index].value == expectedAverages[index].value)
		}
	}

	func testGivenSampleArrayWithOnlyOneSampleAndNilAggregation_countPer_returnsOne() {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 1)

		// when
		let counts = util.count(over: samples, per: nil)

		// then
		XCTAssert(counts.count == 1)
		XCTAssert(counts[0].date == nil)
		XCTAssert(counts[0].value == 1)
	}

	func testGivenSampleArrayWithMultipleSamplesAndNilAggregation_countPer_returnsCorrectValue() {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 3)

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
		let samples = [SampleCreatorTestUtil.createSample()]
		let aggregationDate = Date()
		Given(mockSampleUtil, .sort(samples: .any([Sample].self), by: .value(aggregationUnit), willReturn: [(date: aggregationDate, samples: samples)]))

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
		let samples = SampleCreatorTestUtil.createSamples(withDates: [date1, date2, date3])
		Given(mockSampleUtil, .sort(samples: .any([Sample].self), by: .value(aggregationUnit), willReturn: generateAggregationSortReturnValue(for: samples)))
		let expectedCounts: [(date: Date?, value: Int)] = [
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
		let samples = SampleCreatorTestUtil.createSamples(withDates: [date1, date1, date2, date2, date2, date3, date3, date3, date3])
		Given(mockSampleUtil, .sort(samples: .any([Sample].self), by: .value(aggregationUnit), willReturn: generateAggregationSortReturnValue(for: samples)))
		let expectedCounts: [(date: Date?, value: Int)] = [
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
		let samples = SampleCreatorTestUtil.createSamples(withDates: [date1, date2, date3, date2, date3, date1, date3, date2, date3])
		Given(mockSampleUtil, .sort(samples: .any([Sample].self), by: .value(aggregationUnit), willReturn: generateAggregationSortReturnValue(for: samples)))
		let expectedCounts: [(date: Date?, value: Int)] = [
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
		let samples = SampleCreatorTestUtil.createSamples(withValues: [value], for: Me.attribute)

		// when
		let max: Double = util.max(for: Me.attribute, over: samples)

		// then
		XCTAssert(max == value)
	}

	func testGivenSampleArrayWithMultipleValues_max_returnsMaximumValue() {
		// given
		let expectedMax = 3.4
		let samples = SampleCreatorTestUtil.createSamples(withValues: [expectedMax - 1, expectedMax, expectedMax - 2], for: Me.attribute)

		// when
		let max: Double = util.max(for: Me.attribute, over: samples)

		// then
		XCTAssert(max == expectedMax)
	}

	func testGivenSampleArrayWithOnlyOneSampleAndNilAggregation_maxPer_returnsValueForThatSample() {
		// given
		let value = 5.2
		let samples = SampleCreatorTestUtil.createSamples(withValues: [value], for: Me.attribute)

		// when
		let maxs: [(date: Date?, value: Double)] = util.max(for: Me.attribute, over: samples, per: nil)

		// then
		XCTAssert(maxs.count == 1)
		XCTAssert(maxs[0].date == nil)
		XCTAssert(maxs[0].value == value)
	}

	func testGivenSampleArrayWithMultipleSamplesAndNilAggregation_maxPer_returnsCorrectValue() {
		// given
		let maxValue = 2.0
		let samples = SampleCreatorTestUtil.createSamples(withValues: [maxValue - 1, maxValue - 2, maxValue], for: Me.attribute)

		// when
		let maxs: [(date: Date?, value: Double)] = util.max(for: Me.attribute, over: samples, per: nil)

		// then
		XCTAssert(maxs.count == 1)
		XCTAssert(maxs[0].date == nil)
		XCTAssert(maxs[0].value == maxValue)
	}

	func testGivenSampleArrayWithOnlyOneSample_maxPer_returnsValueOfThatSample() {
		// given
		let aggregationUnit: Calendar.Component = .year
		let value = 5.4
		let samples = SampleCreatorTestUtil.createSamples(withValues: [value], for: Me.attribute)
		let aggregationDate = Date()
		Given(mockSampleUtil, .sort(samples: .any([Sample].self), by: .value(aggregationUnit), willReturn: [(date: aggregationDate, samples: samples)]))

		// when
		let maxs: [(date: Date?, value: Double)] = util.max(for: Me.attribute, over: samples, per: aggregationUnit)

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
		let samples = SampleCreatorTestUtil.createSamples([
			(startDate: date1, value: value1),
			(startDate: date2, value: value2),
			(startDate: date3, value: value3),
		], for: Me.attribute)
		Given(mockSampleUtil, .sort(samples: .any([Sample].self), by: .value(aggregationUnit), willReturn: generateAggregationSortReturnValue(for: samples)))
		let expectedMaxs: [(date: Date?, value: Double)] = [
			(date: date1, value: value1),
			(date: date2, value: value2),
			(date: date3, value: value3),
		]

		// when
		let maxs: [(date: Date?, value: Double)] = util.max(for: Me.attribute, over: samples, per: aggregationUnit)

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
		let samples = SampleCreatorTestUtil.createSamples([
			(startDate: date1, value: value1),
			(startDate: date1, value: value1 - 1),
			(startDate: date2, value: value2 - 2),
			(startDate: date2, value: value2 - 1),
			(startDate: date2, value: value2),
			(startDate: date3, value: value3),
			(startDate: date3, value: value3 - 2),
			(startDate: date3, value: value3 - 1),
			(startDate: date3, value: value3 - 3)
		], for: Me.attribute)
		Given(mockSampleUtil, .sort(samples: .any([Sample].self), by: .value(aggregationUnit), willReturn: generateAggregationSortReturnValue(for: samples)))
		let expectedMaxs: [(date: Date?, value: Double)] = [
			(date: date1, value: value1),
			(date: date2, value: value2),
			(date: date3, value: value3),
		]

		// when
		let maxs: [(date: Date?, value: Double)] = util.max(for: Me.attribute, over: samples, per: aggregationUnit)

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
		let samples = SampleCreatorTestUtil.createSamples([
			(startDate: date1, value: value1),
			(startDate: date3, value: value3 - 3),
			(startDate: date2, value: value2 - 1),
			(startDate: date3, value: value3),
			(startDate: date1, value: value1 - 1),
			(startDate: date2, value: value2),
			(startDate: date3, value: value3 - 1),
			(startDate: date3, value: value3 - 2),
			(startDate: date2, value: value2 - 2),
		], for: Me.attribute)
		Given(mockSampleUtil, .sort(samples: .any([Sample].self), by: .value(aggregationUnit), willReturn: generateAggregationSortReturnValue(for: samples)))
		let expectedMaxs: [(date: Date?, value: Double)] = [
			(date: date1, value: value1),
			(date: date2, value: value2),
			(date: date3, value: value3),
		]

		// when
		let maxs: [(date: Date?, value: Double)] = util.max(for: Me.attribute, over: samples, per: aggregationUnit)

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
		let samples = SampleCreatorTestUtil.createSamples(withValues: [value], for: Me.attribute)

		// when
		let min: Double = util.min(for: Me.attribute, over: samples)

		// then
		XCTAssert(min == value)
	}

	func testGivenSampleArrayWithMultipleValues_min_returnsMinimumValue() {
		// given
		let expectedMin = 3.4
		let samples = SampleCreatorTestUtil.createSamples(withValues: [expectedMin + 1, expectedMin, expectedMin + 2], for: Me.attribute)

		// when
		let min: Double = util.min(for: Me.attribute, over: samples)

		// then
		XCTAssert(min == expectedMin)
	}

	func testGivenSampleArrayWithOnlyOneSampleAndNilAggregation_minPer_returnsValueForThatSample() {
		// given
		let value = 4.3
		let samples = SampleCreatorTestUtil.createSamples(withValues: [value], for: Me.attribute)

		// when
		let mins: [(date: Date?, value: Double)] = util.min(for: Me.attribute, over: samples, per: nil)

		// then
		XCTAssert(mins.count == 1)
		XCTAssert(mins[0].date == nil)
		XCTAssert(mins[0].value == value)
	}

	func testGivenSampleArrayWithMultipleSamplesAndNilAggregation_minPer_returnsCorrectValue() {
		// given
		let minValue = 4.2432
		let samples = SampleCreatorTestUtil.createSamples(withValues: [minValue + 1, minValue, minValue + 2], for: Me.attribute)

		// when
		let mins: [(date: Date?, value: Double)] = util.min(for: Me.attribute, over: samples, per: nil)

		// then
		XCTAssert(mins.count == 1)
		XCTAssert(mins[0].date == nil)
		XCTAssert(mins[0].value == minValue)
	}

	func testGivenSampleArrayWithOnlyOneSample_minPer_returnsValueOfThatSample() {
		// given
		let aggregationUnit: Calendar.Component = .year
		let value = 23.5
		let samples = SampleCreatorTestUtil.createSamples(withValues: [value], for: Me.attribute)
		let aggregationDate = Date()
		Given(mockSampleUtil, .sort(samples: .any([Sample].self), by: .value(aggregationUnit), willReturn: [(date: aggregationDate, samples: samples)]))

		// when
		let mins: [(date: Date?, value: Double)] = util.min(for: Me.attribute, over: samples, per: aggregationUnit)

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
		let samples = SampleCreatorTestUtil.createSamples([
			(startDate: date1, value: value1),
			(startDate: date2, value: value2),
			(startDate: date3, value: value3),
		], for: Me.attribute)
		Given(mockSampleUtil, .sort(samples: .any([Sample].self), by: .value(aggregationUnit), willReturn: generateAggregationSortReturnValue(for: samples)))
		let expectedMins: [(date: Date?, value: Double)] = [
			(date: date1, value: value1),
			(date: date2, value: value2),
			(date: date3, value: value3),
		]

		// when
		let mins: [(date: Date?, value: Double)] = util.min(for: Me.attribute, over: samples, per: aggregationUnit)

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
		let samples = SampleCreatorTestUtil.createSamples([
			(startDate: date1, value: value1 + 1),
			(startDate: date1, value: value1),
			(startDate: date2, value: value2),
			(startDate: date2, value: value2 + 1),
			(startDate: date2, value: value2 + 2),
			(startDate: date3, value: value3 + 3),
			(startDate: date3, value: value3 + 1),
			(startDate: date3, value: value3 + 2),
			(startDate: date3, value: value3),
		], for: Me.attribute)
		Given(mockSampleUtil, .sort(samples: .any([Sample].self), by: .value(aggregationUnit), willReturn: generateAggregationSortReturnValue(for: samples)))
		let expectedMins: [(date: Date?, value: Double)] = [
			(date: date1, value: value1),
			(date: date2, value: value2),
			(date: date3, value: value3),
		]

		// when
		let mins: [(date: Date?, value: Double)] = util.min(for: Me.attribute, over: samples, per: aggregationUnit)

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
		let samples = SampleCreatorTestUtil.createSamples([
			(startDate: date1, value: value1 + 1),
			(startDate: date3, value: value3),
			(startDate: date2, value: value2 + 1),
			(startDate: date3, value: value3 + 3),
			(startDate: date3, value: value3 + 2),
			(startDate: date3, value: value3 + 1),
			(startDate: date1, value: value1),
			(startDate: date2, value: value2 + 2),
			(startDate: date2, value: value2),
		], for: Me.attribute)
		Given(mockSampleUtil, .sort(samples: .any([Sample].self), by: .value(aggregationUnit), willReturn: generateAggregationSortReturnValue(for: samples)))
		let expectedMins: [(date: Date?, value: Double)] = [
			(date: date1, value: value1),
			(date: date2, value: value2),
			(date: date3, value: value3),
		]

		// when
		let mins: [(date: Date?, value: Double)] = util.min(for: Me.attribute, over: samples, per: aggregationUnit)

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
		let samples = SampleCreatorTestUtil.createSamples(withValues: [value], for: Me.attribute)

		// when
		let sum: Double = util.sum(for: Me.attribute, over: samples)

		// then
		XCTAssert(sum == value)
	}

	func testGivenSampleArrayWithMultipleValues_sum_returnsCorrectValue() {
		// given
		let value1 = 1.0
		let value2 = 4.3
		let value3 = 87.2
		let samples = SampleCreatorTestUtil.createSamples(withValues: [value1, value2, value3], for: Me.attribute)
		let expectedSum = value1 + value2 + value3

		// when
		let sum: Double = util.sum(for: Me.attribute, over: samples)

		// then
		XCTAssert(sum == expectedSum)
	}

	func testGivenSampleArrayWithOnlyOneSampleAndNilAggregation_sumPer_returnsValueForThatSample() {
		// given
		let value = 23.3
		let samples = SampleCreatorTestUtil.createSamples(withValues: [value], for: Me.attribute)

		// when
		let sums: [(date: Date?, value: Double)] = util.sum(for: Me.attribute, over: samples, per: nil)

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
		let samples = SampleCreatorTestUtil.createSamples(withValues: [value1, value2, value3], for: Me.attribute)
		let expectedSum = value1 + value2 + value3

		// when
		let sums: [(date: Date?, value: Double)] = util.sum(for: Me.attribute, over: samples, per: nil)

		// then
		XCTAssert(sums.count == 1)
		XCTAssert(sums[0].date == nil)
		XCTAssert(sums[0].value == expectedSum)
	}

	func testGivenSampleArrayWithOnlyOneSample_sumPer_returnsValueOfThatSample() {
		// given
		let aggregationUnit: Calendar.Component = .year
		let value = 4.2
		let samples = SampleCreatorTestUtil.createSamples(withValues: [value], for: Me.attribute)
		let aggregationDate = Date()
		Given(mockSampleUtil, .sort(samples: .any([Sample].self), by: .value(aggregationUnit), willReturn: [(date: aggregationDate, samples: samples)]))

		// when
		let sums: [(date: Date?, value: Double)] = util.sum(for: Me.attribute, over: samples, per: aggregationUnit)

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
		let samples = SampleCreatorTestUtil.createSamples([
			(startDate: date1, value: value1),
			(startDate: date2, value: value2),
			(startDate: date3, value: value3)
		], for: Me.attribute)
		Given(mockSampleUtil, .sort(samples: .any([Sample].self), by: .value(aggregationUnit), willReturn: generateAggregationSortReturnValue(for: samples)))
		let expectedSums: [(date: Date?, value: Double)] = [
			(date: date1, value: value1),
			(date: date2, value: value2),
			(date: date3, value: value3),
		]

		// when
		let sums: [(date: Date?, value: Double)] = util.sum(for: Me.attribute, over: samples, per: aggregationUnit)

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
		let samples = SampleCreatorTestUtil.createSamples([
			(startDate: date1, value: value1),
			(startDate: date1, value: value1 + 1),
			(startDate: date2, value: value2),
			(startDate: date2, value: value2 + 2),
			(startDate: date2, value: value2 + 1),
			(startDate: date3, value: value3 + 2),
			(startDate: date3, value: value3),
			(startDate: date3, value: value3 + 1),
			(startDate: date3, value: value3 + 3),
		], for: Me.attribute)
		Given(mockSampleUtil, .sort(samples: .any([Sample].self), by: .value(aggregationUnit), willReturn: generateAggregationSortReturnValue(for: samples)))
		let expectedSums: [(date: Date?, value: Double)] = [
			(date: date1, value: 2 * value1 + 1),
			(date: date2, value: 3 * value2 + 3),
			(date: date3, value: 4 * value3 + 6),
		]

		// when
		let sums: [(date: Date?, value: Double)] = util.sum(for: Me.attribute, over: samples, per: aggregationUnit)

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
		let samples = SampleCreatorTestUtil.createSamples([
			(startDate: date2, value: value2),
			(startDate: date2, value: value2 + 2),
			(startDate: date3, value: value3 + 3),
			(startDate: date3, value: value3),
			(startDate: date1, value: value1 + 1),
			(startDate: date2, value: value2 + 1),
			(startDate: date3, value: value3 + 1),
			(startDate: date1, value: value1),
			(startDate: date3, value: value3 + 2),
		], for: Me.attribute)
		Given(mockSampleUtil, .sort(samples: .any([Sample].self), by: .value(aggregationUnit), willReturn: generateAggregationSortReturnValue(for: samples)))
		let expectedSums: [(date: Date?, value: Double)] = [
			(date: date1, value: 2 * value1 + 1),
			(date: date2, value: 3 * value2 + 3),
			(date: date3, value: 4 * value3 + 6),
		]

		// when
		let sums: [(date: Date?, value: Double)] = util.sum(for: Me.attribute, over: samples, per: aggregationUnit)

		// then
		XCTAssert(sums.count == expectedSums.count)
		for index in 0 ..< sums.count {
			XCTAssert(sums[index].date == expectedSums[index].date)
			XCTAssert(sums[index].value == expectedSums[index].value)
		}
	}

	// TODO - write unit tests for sortSamplesByAggregation

	fileprivate func generateAggregationSortReturnValue(for samples: [Sample]) -> [(date: Date, samples: [Sample])] {
		var samplesByDate = [Date: [Sample]]()
		for sample in samples {
			let date = sample.dates()[.start]!
			var samplesForDate = samplesByDate[date]
			if samplesForDate == nil {
				samplesForDate = [Sample]()
			}
			samplesForDate!.append(sample)
			samplesByDate[date] = samplesForDate
		}
		let sortedSamples = samplesByDate.sorted { (entry1: (key: Date, value: [Sample]), entry2: (key: Date, value: [Sample])) -> Bool in
			return entry1.key.compare(entry2.key) == ComparisonResult.orderedAscending
		}
		return sortedSamples.map { (key: Date, value: [Sample]) in return (date: key, samples: value) }
	}
}
