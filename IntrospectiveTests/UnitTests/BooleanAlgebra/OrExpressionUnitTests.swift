//
//  OrExpressionUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/26/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
@testable import Introspective

final class OrExpressionUnitTests: UnitTest {

	private final var or: OrExpression!

	private final var expression1: ExpressionStub!
	private final var expression2: ExpressionStub!

	final override func setUp() {
		super.setUp()
		expression1 = ExpressionStub("a")
		expression2 = ExpressionStub("b")
		or = OrExpression(expression1, expression2)
	}

	// MARK: - evaluate

	func testGivenTrueOrTrue_evaluate_returnsTrue() throws {
		// given
		expression1.evaluation = true
		expression2.evaluation = true

		// when
		let evaluation = try or.evaluate()

		// then
		XCTAssert(evaluation)
	}

	func testGivenTrueOrFalse_evaluate_returnsTrue() throws {
		// given
		expression1.evaluation = true
		expression2.evaluation = false

		// when
		let evaluation = try or.evaluate()

		// then
		XCTAssert(evaluation)
	}

	func testGivenFalseOrTrue_evaluate_returnsTrue() throws {
		// given
		expression1.evaluation = false
		expression2.evaluation = true

		// when
		let evaluation = try or.evaluate()

		// then
		XCTAssert(evaluation)
	}

	func testGivenFalseOrFalse_evaluate_returnsFalse() throws {
		// given
		expression1.evaluation = false
		expression2.evaluation = false

		// when
		let evaluation = try or.evaluate()

		// then
		XCTAssertFalse(evaluation)
	}
}
