//
//  OrExpressionUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/26/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
@testable import Introspective
@testable import BooleanAlgebra

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

	// MARK: - copy()

	func test_copy_returnsCopy() {
		// given
		let expectedExpression1 = ExpressionStub("copy1")
		let expectedExpression2 = ExpressionStub("copy2")
		expression1.copyOf = expectedExpression1
		expression2.copyOf = expectedExpression2

		// when
		let copy = or.copy()

		// then
		guard let castedCopy = copy as? OrExpression else {
			XCTFail("Wrong type returned")
			return
		}
		assertThat(castedCopy.expression1, equals(expectedExpression1))
		assertThat(castedCopy.expression2, equals(expectedExpression2))
	}
}
