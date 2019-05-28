//
//  BooleanExpressionGroupUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/26/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
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

	// MARK: - copy()

	func test_copy_returnsCopy() {
		// given
		let expectedSubExpression = ExpressionStub("copy")
		subExpression.copyOf = expectedSubExpression

		// when
		let copy = group.copy()

		// then
		guard let castedCopy = copy as? BooleanExpressionGroup else {
			XCTFail("Wrong type returned")
			return
		}
		assertThat(castedCopy.subExpression, equals(expectedSubExpression))
	}
}
