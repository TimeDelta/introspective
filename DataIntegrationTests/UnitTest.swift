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

	func createNumericSample(start: Date, end: Date, value: Double) -> DoubleValueSample {
		return DoubleValueSample(value, [.start : start, .end: end])
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

	func createNumericSamples(withValues values: [(start: Date, end: Date, value: Double)]) -> [DoubleValueSample] {
		var samples = [DoubleValueSample]()
		for (start, end, value) in values {
			samples.append(createNumericSample(start: start, end: end, value: value))
		}
		return samples
	}
}
