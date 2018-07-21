//
//  WithinXCalendarUnitsSubQueryMatcherUnitTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 7/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
@testable import DataIntegration

class WithinXCalendarUnitsSubQueryMatcherUnitTests: UnitTest {

	fileprivate var matcher: WithinXCalendarUnitsSubQueryMatcher!

	override func setUp() {
		matcher = WithinXCalendarUnitsSubQueryMatcher()
	}

	func testGivenEmptyArrayOfQuerySamplesAndEmptyArrayOfSubQuerySamples_getSamples_returnsEmptyArray() {
		// given
		let querySamples = [AnySample]()
		let subQuerySamples = [AnySample]()

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 0)
	}

	func testGivenEmptyArrayOfQuerySamplesAndNonEmptyArrayOfSubQuerySamples_getSamples_returnsEmptyArray() {
		// given
		let querySamples = [AnySample]()
		let subQuerySamples = createSamples(withValues: [1.1, 2.2]) as! [AnySample]

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 0)
	}

	func testGivenEmptyArrayOfSubQuerySamplesAndNonEmptyArrayOfQuerySamples_getSamples_returnsEmptyArray() {
		// given
		let querySamples = createSamples(withValues: [8.0, 1.2]) as! [AnySample]
		let subQuerySamples = [AnySample]()

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 0)
	}
}
