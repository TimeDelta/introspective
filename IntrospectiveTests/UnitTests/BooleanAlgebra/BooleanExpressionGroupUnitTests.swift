//
//  BooleanExpressionGroupUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/26/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
@testable import Introspective

final class BooleanExpressionGroupUnitTests: UnitTest {

	private final var group: BooleanExpressionGroup!

	private final var subExpression: ExpressionStub!

	final override func setUp() {
		super.setUp()
		subExpression = ExpressionStub("a")
		group = BooleanExpressionGroup(subExpression)
	}

	// MARK: - evaluate

	func testGivenTrue_evaluate_returnsTrue() throws {
		// given
		subExpression.evaluation = true

		// when
		let evaluation = try group.evaluate()

		// then
		XCTAssert(evaluation)
	}

	func testGivenFalse_evaluate_returnsFalse() throws {
		// given
		subExpression.evaluation = false

		// when
		let evaluation = try group.evaluate()

		// then
		XCTAssertFalse(evaluation)
	}
}
