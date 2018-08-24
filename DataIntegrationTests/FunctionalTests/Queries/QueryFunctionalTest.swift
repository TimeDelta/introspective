//
//  QueryFunctionalTest.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/23/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
@testable import DataIntegration

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

	func expected(_ expected: Sample, butGot actual: Sample) -> String {
		return "EXPECTED: " + expected.debugDescription + "; ACTUAL: " + actual.debugDescription
	}
}
