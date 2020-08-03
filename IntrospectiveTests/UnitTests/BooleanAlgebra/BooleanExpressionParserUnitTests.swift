//
//  BooleanExpressionParserUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest

@testable import Introspective
@testable import BooleanAlgebra

final class BooleanExpressionParserUnitTests: UnitTest {

	private final var parser: BooleanExpressionParser!

	final override func setUp() {
		super.setUp()
		parser = BooleanExpressionParserImpl()
	}

	// MARK: - parse() - invalid expressions

	func testGivenEmptyArray_parse_throwsError() throws {
		// given
		let parts = [BooleanExpressionPart]()

		// when / then
		XCTAssertThrowsError(try parser.parse(parts))
	}

	// MARK: Dangling Conjunction (missing second subexpression)

	func testGivenDanglingOr_parse_throwsError() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .expression, expression: ExpressionStub("a")),
			(type: .or, expression: nil),
		]

		// when / then
		XCTAssertThrowsError(try parser.parse(parts))
	}

	func testGivenDanglingAnd_parse_throwsError() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .expression, expression: ExpressionStub("a")),
			(type: .and, expression: nil),
		]

		// when / then
		XCTAssertThrowsError(try parser.parse(parts))
	}

	// MARK: Groups

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

	// MARK: Not

	func testGivenOnlyNot_parse_throwsError() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .not, expression: nil),
		]

		// when / then
		XCTAssertThrowsError(try parser.parse(parts))
	}

	func testGivenExpressionFollowedByNot_parse_throwsError() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .expression, expression: ExpressionStub("a")),
			(type: .not, expression: nil),
			// want to make sure the error thrown is not because of missing sub expression for not
			(type: .expression, expression: ExpressionStub("b")),
		]

		// when / then
		XCTAssertThrowsError(try parser.parse(parts))
	}

	// MARK: Or

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

	// MARK: And

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

	// MARK: Combos

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

	func testGivenGroupEndFollowedByPlainExpression_parse_throwsError() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .groupStart, expression: nil),
			(type: .expression, expression: ExpressionStub("a")),
			(type: .groupEnd, expression: nil),
			(type: .expression, expression: ExpressionStub("b")),
		]

		// when / then
		XCTAssertThrowsError(try parser.parse(parts))
	}

	func testGivenGroupEndFollowedByNot_parse_throwsError() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .groupStart, expression: nil),
			(type: .expression, expression: ExpressionStub("a")),
			(type: .groupEnd, expression: nil),
			(type: .not, expression: nil),
			// want to make sure the error thrown is not because of missing sub expression for not
			(type: .expression, expression: ExpressionStub("b")),
		]

		// when / then
		XCTAssertThrowsError(try parser.parse(parts))
	}

	// MARK: - parse() - valid expressions

	// MARK: a

	func testGivenOnlyExpression_parse_correctlyParsesExpression() throws {
		// given
		let expectedExpression = ExpressionStub("a")
		let parts: [BooleanExpressionPart] = [
			(type: .expression, expression: expectedExpression),
		]

		// when
		let actualExpression = try parser.parse(parts)

		// then
		assertThat(actualExpression, equals(expectedExpression))
	}

	// MARK: (a)

	func testGivenOnlyGroupedExpression_parse_correctlyParsesExpression() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .groupStart, expression: nil),
			(type: .expression, expression: ExpressionStub("a")),
			(type: .groupEnd, expression: nil),
		]
		let expectedExpression = BooleanExpressionGroup(ExpressionStub("a"))

		// when
		let actualExpression = try parser.parse(parts)

		// then
		assertThat(actualExpression, equals(expectedExpression))
	}

	// MARK: !a

	func testGivenSimpleNotExpression_parse_correctlyParsesExpression() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .not, expression: nil),
			(type: .expression, expression: ExpressionStub("a")),
		]
		let expectedExpression = NotExpression(ExpressionStub("a"))

		// when
		let actualExpression = try parser.parse(parts)

		// then
		assertThat(actualExpression, equals(expectedExpression))
	}

	// MARK: !a|b

	func testGivenNotAOrB_parse_correctlyParsesExpression() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .not, expression: nil),
			(type: .expression, expression: ExpressionStub("a")),
			(type: .or, expression: nil),
			(type: .expression, expression: ExpressionStub("b")),
		]
		let expectedExpression = OrExpression(
			NotExpression(ExpressionStub("a")),
			ExpressionStub("b")
		)

		// when
		let actualExpression = try parser.parse(parts)

		// then
		assertThat(actualExpression, equals(expectedExpression))
	}

	// MARK: !(a|b)

	func testGivenNotGroupedAOrB_parse_correctlyParsesExpression() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .not, expression: nil),
			(type: .groupStart, expression: nil),
			(type: .expression, expression: ExpressionStub("a")),
			(type: .or, expression: nil),
			(type: .expression, expression: ExpressionStub("b")),
			(type: .groupEnd, expression: nil),
		]
		let expectedExpression = NotExpression(
			BooleanExpressionGroup(
				OrExpression(
					ExpressionStub("a"),
					ExpressionStub("b")
				)
			)
		)

		// when
		let actualExpression = try parser.parse(parts)

		// then
		assertThat(actualExpression, equals(expectedExpression))
	}

	// MARK: (!!a)

	func testGivenValidData5_parse_correctlyParsesExpression() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .groupStart, expression: nil),
			(type: .not, expression: nil),
			(type: .not, expression: nil),
			(type: .expression, expression: ExpressionStub("a")),
			(type: .groupEnd, expression: nil),
		]
		let expectedExpression = BooleanExpressionGroup(
			NotExpression(NotExpression(ExpressionStub("a")))
		)

		// when
		let actualExpression = try parser.parse(parts)

		// then
		assertThat(actualExpression, equals(expectedExpression))
	}

	// MARK: a&!(b|c)

	func testGivenAAndNotGroupedBOrC_parse_correctlyParsesExpression() throws {
		// given
		let parts: [BooleanExpressionPart] = [
			(type: .expression, expression: ExpressionStub("a")),
			(type: .and, expression: nil),
			(type: .not, expression: nil),
			(type: .groupStart, expression: nil),
			(type: .expression, expression: ExpressionStub("b")),
			(type: .or, expression: nil),
			(type: .expression, expression: ExpressionStub("c")),
			(type: .groupEnd, expression: nil),
		]
		let expectedExpression = AndExpression(
			ExpressionStub("a"),
			NotExpression(
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
		assertThat(actualExpression, equals(expectedExpression))
	}

	// MARK: ((a&b|c))|d

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
		assertThat(actualExpression, equals(expectedExpression))
	}

	// MARK: (a&(b|c))

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
		assertThat(actualExpression, equals(expectedExpression))
	}

	// MARK: (a&(b|c))|(b&(c|d))

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
		assertThat(actualExpression, equals(expectedExpression))
	}

	// MARK: a&b|((c|d|e)&a)|f

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
		assertThat(actualExpression, equals(expectedExpression))
	}
}
