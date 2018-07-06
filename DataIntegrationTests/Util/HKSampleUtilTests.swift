//
//  HKSampleUtilTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 7/6/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import HealthKit
@testable import DataIntegration

class HKSampleUtilTests: UnitTest {

	fileprivate var util: HKSampleUtil!

    override func setUp() {
        super.setUp()
		util = HKSampleUtil()
    }

	func testGivenEmptyDayOfWeekSet_sampleOccursOnOneOf_returnsTrue() {
		// given
		let sample = createSample(5.0)

		// when
		let occurs = util.sample(sample, occursOnOneOf: Set<DayOfWeek>())

		// then
		XCTAssert(occurs)
	}

	// TODO - finish writing unit tests
}
