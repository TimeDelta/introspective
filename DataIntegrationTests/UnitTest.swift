//
//  UnitTest.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
import XCTest
import HealthKit
@testable import DataIntegration

class UnitTest: XCTestCase {

	fileprivate typealias Me = HKQuantitySampleUtilTests

	static let defaultUnit = HKUnit(from: "count/min")
	static let defaultType = HKQuantityType.quantityType(forIdentifier: .heartRate)!

    override func setUp() {
        super.setUp()
		DependencyInjector.setType(newType: .UnitTest)
    }

    override func tearDown() {
        DependencyInjector.setType(newType: .Production)
    }

	func createSample(_ value: Double) -> HKQuantitySample {
		return HKQuantitySample(type: Me.defaultType, quantity: HKQuantity(unit: Me.defaultUnit, doubleValue: value), start: Date(), end: Date())
	}

	func createSample(_ value: Double, start: Date, end: Date) -> HKQuantitySample {
		return HKQuantitySample(type: Me.defaultType, quantity: HKQuantity(unit: Me.defaultUnit, doubleValue: value), start: start, end: end)
	}

	func createSamples(withValues values: [Double]) -> [HKQuantitySample] {
		var samples = [HKQuantitySample]()
		for value in values {
			samples.append(createSample(value))
		}
		return samples
	}

	func createSamples(withValues values: [(start: Date, end: Date, value: Double)]) -> [HKQuantitySample] {
		var samples = [HKQuantitySample]()
		for (start, end, value) in values {
			samples.append(createSample(value, start: start, end: end))
		}
		return samples
	}
}
