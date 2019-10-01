//
//  QueryFunctionalTest.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/23/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
@testable import Introspective
@testable import AttributeRestrictions
@testable import BooleanAlgebra
@testable import Queries
@testable import Samples

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
		XCTAssertNotNil(result)
		return waitError == nil && error == nil && result != nil
	}

	func expected(_ expected: Sample, butGot actual: Sample) -> String {
		return "EXPECTED: " + expected.debugDescription + "; ACTUAL: " + actual.debugDescription
	}

	func andExpression(_ restrictions: AttributeRestriction...) -> BooleanExpression {
		precondition(restrictions.count > 1)
		var mutableRestrictions = restrictions
		var expression = AndExpression(restrictions[0], restrictions[1])
		mutableRestrictions.removeFirst(2)
		while mutableRestrictions.count > 0 {
			expression = AndExpression(expression, mutableRestrictions.removeFirst())
		}
		return expression
	}
}
