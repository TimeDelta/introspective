//
//  UnitTest.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

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

	func createSample(_ value: Double) -> Sample {
		return HeartRate(value)
	}

	func createSample(_ value: Double, _ date: Date) -> Sample {
		return HeartRate(value, .start, date)
	}

	func createSample(start: Date, end: Date, value: Double) -> Sample {
		return HeartRate(value, [.start : start, .end: end])
	}

	func createSamples(withValues values: [Double]) -> [Sample] {
		var samples = [Sample]()
		for value in values {
			samples.append(createSample(value))
		}
		return samples
	}

	func createSamples(withValues values: [(date: Date, value: Double)]) -> [Sample] {
		var samples = [Sample]()
		for (date, value) in values {
			samples.append(createSample(value, date))
		}
		return samples
	}

	func createSamples(withValues values: [(start: Date, end: Date, value: Double)]) -> [Sample] {
		var samples = [Sample]()
		for (start, end, value) in values {
			samples.append(createSample(start: start, end: end, value: value))
		}
		return samples
	}
}
