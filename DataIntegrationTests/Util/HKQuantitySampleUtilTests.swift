//
//  HKQuantitySampleUtilTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 7/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import HealthKit
@testable import DataIntegration

class HKQuantitySampleUtilTests: UnitTest {

	fileprivate typealias Me = HKQuantitySampleUtilTests

	fileprivate static let defaultUnit = HKUnit(from: "count/min")
	fileprivate static let defaultType = HKQuantityType.quantityType(forIdentifier: .heartRate)!

	fileprivate var util: HKQuantitySampleUtil!

    override func setUp() {
        super.setUp()
		util = HKQuantitySampleUtil()
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
		var sum = 0.0
		for value in values {
			sum += value
		}
		let expectedAverage = sum / Double(values.count)
		let samples = createSamples(withValues: values)

		// when
		let average = util.average(over: samples, withUnit: Me.defaultUnit)

		// then
		XCTAssert(average == expectedAverage)
	}

	func testGivenOnlyOneSampleWithYearlyAggregation_averagePer_returnsValueForThatSample() {
		// given
		let values = [5.0]
		let samples = createSamples(withValues: values)

		// when
		let averages = util.average(over: samples, per: .year, withUnit: Me.defaultUnit)

		// then
		XCTAssert(averages == values)
	}

    fileprivate func createSamples(withValues values: [Double]) -> [HKQuantitySample] {
		var samples = [HKQuantitySample]()
		for value in values {
			samples.append(HKQuantitySample(type: Me.defaultType, quantity: HKQuantity(unit: Me.defaultUnit, doubleValue: value), start: Date(), end: Date()))
		}
		return samples
	}

	fileprivate func createSamples(withValues values: [(start: Date, end: Date, value: Double)]) -> [HKQuantitySample] {
		var samples = [HKQuantitySample]()
		for (start, end, value) in values {
			samples.append(HKQuantitySample(type: Me.defaultType, quantity: HKQuantity(unit: Me.defaultUnit, doubleValue: value), start: start, end: end))
		}
		return samples
	}
}
