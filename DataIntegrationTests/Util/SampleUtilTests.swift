//
//  SampleUtilTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 7/6/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import HealthKit
@testable import DataIntegration

class SampleUtilTests: UnitTest {

	fileprivate var util: SampleUtil!

    override func setUp() {
        super.setUp()
		util = SampleUtil()
    }

	func testGivenEmptyDayOfWeekSet_sampleOccursOnOneOf_returnsTrue() {
		// given
		let sample = createNumericSample(5.0)

		// when
		let occurs = util.sample(sample, occursOnOneOf: Set<DayOfWeek>())

		// then
		XCTAssert(occurs)
	}

	// TODO - finish writing unit tests
}
