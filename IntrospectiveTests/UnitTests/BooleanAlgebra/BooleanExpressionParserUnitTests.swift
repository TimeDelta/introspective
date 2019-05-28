//
//  BooleanExpressionParserUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
@testable import Introspective

final class BooleanExpressionParserUnitTests: UnitTest {

	private final var parser: BooleanExpressionParser!

	final override func setUp() {
		super.setUp()
		parser = BooleanExpressionParserImpl()
	}

	func testGivenHangingOr_parse_throwsError() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .expression, expression: ExpressionStub("a")),
			(type: .or, expression: nil),
		]

		// when / then
		XCTAssertThrowsError(try parser.parse(parts))
	}

	func testGivenHangingAnd_parse_throwsError() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .expression, expression: ExpressionStub("a")),
			(type: .and, expression: nil),
		]

		// when / then
		XCTAssertThrowsError(try parser.parse(parts))
	}

	func testGivenOnlyGroupStart_parse_throwsError() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .groupStart, expression: nil),
		]

		// when / then
		XCTAssertThrowsError(try parser.parse(parts))
	}

	func testGivenOnlyGroupEnd_parse_throwsError() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .groupEnd, expression: nil),
		]

		// when / then
		XCTAssertThrowsError(try parser.parse(parts))
	}

	func testGivenOnlyEmptyGroup_parse_throwsError() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .groupStart, expression: nil),
			(type: .groupEnd, expression: nil),
		]

		// when / then
		XCTAssertThrowsError(try parser.parse(parts))
	}

	func testGivenOnlyOr_parse_throwsError() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .or, expression: nil),
		]

		// when / then
		XCTAssertThrowsError(try parser.parse(parts))
	}

	func testGivenDoubleOr_parse_throwsError() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .expression, expression: ExpressionStub("a")),
			(type: .or, expression: nil),
			(type: .or, expression: nil),
		]

		// when / then
		XCTAssertThrowsError(try parser.parse(parts))
	}

	func testGivenOnlyAnd_parse_throwsError() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .and, expression: nil),
		]

		// when / then
		XCTAssertThrowsError(try parser.parse(parts))
	}

	func testGivenDoubleAnd_parse_throwsError() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .expression, expression: ExpressionStub("a")),
			(type: .and, expression: nil),
			(type: .and, expression: nil),
		]

		// when / then
		XCTAssertThrowsError(try parser.parse(parts))
	}

	func testGivenOnlyExpression_parse_correctlyParsesExpression() throws {
		// given
		let expectedExpression = ExpressionStub("a")
		let parts: [BooleanExpressionPart] = [
			(type: .expression, expression: expectedExpression),
		]

		// when
		let actualExpression = try parser.parse(parts)

		// then
		XCTAssert(actualExpression.equalTo(expectedExpression))
	}

	func testGivenGroupStartOrGroupEnd_parse_throwsError() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .groupStart, expression: nil),
			(type: .or, expression: nil),
			(type: .groupEnd, expression: nil),
		]

		// when / then
		XCTAssertThrowsError(try parser.parse(parts))
	}

	func testGivenGroupStartAndGroupEnd_parse_throwsError() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .groupStart, expression: nil),
			(type: .and, expression: nil),
			(type: .groupEnd, expression: nil),
		]

		// when / then
		XCTAssertThrowsError(try parser.parse(parts))
	}

	func testGivenOnlyTwoAttributeRestrictions_parse_throwsError() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .expression, expression: ExpressionStub("a")),
			(type: .expression, expression: ExpressionStub("b")),
		]

		// when / then
		XCTAssertThrowsError(try parser.parse(parts))
	}

	// ((a&b|c))|d
	func testGivenValidData1_parse_correctlyParsesExpression() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .groupStart, expression: nil),
			(type: .groupStart, expression: nil),
			(type: .expression, expression: ExpressionStub("a")),
			(type: .and, expression: nil),
			(type: .expression, expression: ExpressionStub("b")),
			(type: .or, expression: nil),
			(type: .expression, expression: ExpressionStub("c")),
			(type: .groupEnd, expression: nil),
			(type: .groupEnd, expression: nil),
			(type: .or, expression: nil),
			(type: .expression, expression: ExpressionStub("d")),
		]
		let expectedExpression = OrExpression(
			BooleanExpressionGroup(
				BooleanExpressionGroup(
					OrExpression(
						AndExpression(ExpressionStub("a"), ExpressionStub("b")),
						ExpressionStub("c")
					)
				)
			),
			ExpressionStub("d")
		)

		// when
		let actualExpression = try parser.parse(parts)

		// then
		XCTAssert(actualExpression.equalTo(expectedExpression))
	}

	// (a&(b|c))
	func testGivenValidData2_parse_correctlyParsesExpression() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .groupStart, expression: nil),
			(type: .expression, expression: ExpressionStub("a")),
			(type: .and, expression: nil),
			(type: .groupStart, expression: nil),
			(type: .expression, expression: ExpressionStub("b")),
			(type: .or, expression: nil),
			(type: .expression, expression: ExpressionStub("c")),
			(type: .groupEnd, expression: nil),
			(type: .groupEnd, expression: nil),
		]
		let expectedExpression = BooleanExpressionGroup(
			AndExpression(
				ExpressionStub("a"),
				BooleanExpressionGroup(
					OrExpression(
						ExpressionStub("b"),
						ExpressionStub("c")
					)
				)
			)
		)

		// when
		let actualExpression = try parser.parse(parts)

		// then
		XCTAssert(actualExpression.equalTo(expectedExpression))
	}

	// (a&(b|c))|(b&(c|d))
	func testGivenValidData3_parse_correctlyParsesExpression() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .groupStart, expression: nil),
			(type: .expression, expression: ExpressionStub("a")),
			(type: .and, expression: nil),
			(type: .groupStart, expression: nil),
			(type: .expression, expression: ExpressionStub("b")),
			(type: .or, expression: nil),
			(type: .expression, expression: ExpressionStub("c")),
			(type: .groupEnd, expression: nil),
			(type: .groupEnd, expression: nil),
			(type: .or, expression: nil),
			(type: .groupStart, expression: nil),
			(type: .expression, expression: ExpressionStub("b")),
			(type: .and, expression: nil),
			(type: .groupStart, expression: nil),
			(type: .expression, expression: ExpressionStub("c")),
			(type: .or, expression: nil),
			(type: .expression, expression: ExpressionStub("d")),
			(type: .groupEnd, expression: nil),
			(type: .groupEnd, expression: nil),
		]
		let expectedExpression = OrExpression(
			BooleanExpressionGroup(
				AndExpression(
					ExpressionStub("a"),
					BooleanExpressionGroup(
						OrExpression(ExpressionStub("b"), ExpressionStub("c"))
					)
				)
			),
			BooleanExpressionGroup(
				AndExpression(
					ExpressionStub("b"),
					BooleanExpressionGroup(
						OrExpression(ExpressionStub("c"), ExpressionStub("d"))
					)
				)
			)
		)

		// when
		let actualExpression = try parser.parse(parts)

		// then
		XCTAssert(actualExpression.equalTo(expectedExpression))
	}

	// a&b|((c|d|e)&a)|f
	func testGivenValidData4_parse_correctlyParsesExpression() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .expression, expression: ExpressionStub("a")),
			(type: .and, expression: nil),
			(type: .expression, expression: ExpressionStub("b")),
			(type: .or, expression: nil),
			(type: .groupStart, expression: nil),
			(type: .groupStart, expression: nil),
			(type: .expression, expression: ExpressionStub("c")),
			(type: .or, expression: nil),
			(type: .expression, expression: ExpressionStub("d")),
			(type: .or, expression: nil),
			(type: .expression, expression: ExpressionStub("e")),
			(type: .groupEnd, expression: nil),
			(type: .and, expression: nil),
			(type: .expression, expression: ExpressionStub("a")),
			(type: .groupEnd, expression: nil),
			(type: .or, expression: nil),
			(type: .expression, expression: ExpressionStub("f")),
		]
		let expectedExpression = OrExpression(
			AndExpression(ExpressionStub("a"), ExpressionStub("b")),
			OrExpression(
				BooleanExpressionGroup(
					AndExpression(
						BooleanExpressionGroup(
							OrExpression(
								OrExpression(ExpressionStub("c"), ExpressionStub("d")),
								ExpressionStub("e")
							)
						),
						ExpressionStub("a")
					)
				),
				ExpressionStub("f")
			)
		)

		// when
		let actualExpression = try parser.parse(parts)

		// then
		XCTAssert(actualExpression.equalTo(expectedExpression))
	}
}
