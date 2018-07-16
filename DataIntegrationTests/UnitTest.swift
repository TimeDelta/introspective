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

	fileprivate typealias Me = NumericSampleUtilTests

	static let defaultUnit = HKUnit(from: "count/min")
	static let defaultType = HKQuantityType.quantityType(forIdentifier: .heartRate)!

    override func setUp() {
        super.setUp()
		DependencyInjector.setType(newType: .UnitTest)
    }

    override func tearDown() {
        DependencyInjector.setType(newType: .Production)
        UnitTestInjectionProvider.resetMocks()
        super.tearDown()
    }

	func createNumericSample(_ value: Double) -> DoubleValueSample {
		return DoubleValueSample(value)
	}

	func createNumericSample(_ value: Double, _ date: Date) -> DoubleValueSample {
		return DoubleValueSample(value, .start, date)
	}

	func createNumericSamples(withValues values: [Double]) -> [DoubleValueSample] {
		var samples = [DoubleValueSample]()
		for value in values {
			samples.append(createNumericSample(value))
		}
		return samples
	}

	func createNumericSamples(withValues values: [(date: Date, value: Double)]) -> [DoubleValueSample] {
		var samples = [DoubleValueSample]()
		for (date, value) in values {
			samples.append(createNumericSample(value, date))
		}
		return samples
	}
}
