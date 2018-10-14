//
//  QueryFunctionalTest.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/23/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
@testable import Introspective

class QueryFunctionalTest: FunctionalTest {

	var queryCompletedExpectation: XCTestExpectation!
	var result: QueryResult?
	var error: Error?

	var samples: [Sample] {
		return result!.samples
	}

	override func setUp() {
		super.setUp()
		queryCompletedExpectation = expectation(description: "queryCompleted")
	}

	func queryComplete(_ r: QueryResult?, _ e: Error?) {
		result = r
		error = e
		queryCompletedExpectation.fulfill()
	}

	func assertNoErrors(_ waitError: Error?) -> Bool {
		if waitError != nil {
			XCTFail(waitError!.localizedDescription)
		}
		if error != nil {
			XCTFail(error!.localizedDescription)
		}
		XCTAssert(result != nil)
		return waitError == nil && error == nil && result != nil
	}

	func assertOnlyExpectedSamples(expectedSamples: [Sample]) {
		let unexpectedSamples = self.samples.filter({ sample in
			return !expectedSamples.contains(where: { sample.equalTo($0) })
		})
		XCTAssert(unexpectedSamples.count == 0, "Found \(unexpectedSamples.count) unexpected samples: \(unexpectedSamples.debugDescription)")
		let missingSamples = expectedSamples.filter({ sample in
			return !self.samples.contains(where: { sample.equalTo($0) })
		})
		XCTAssert(missingSamples.count == 0, "Missing \(missingSamples.count) expected samples: \(missingSamples.debugDescription)")
	}

	func expected(_ expected: Sample, butGot actual: Sample) -> String {
		return "EXPECTED: " + expected.debugDescription + "; ACTUAL: " + actual.debugDescription
	}
}
