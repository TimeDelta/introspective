//
//  GroupDefinitionUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import SwiftyMocky
@testable import Introspective
@testable import BooleanAlgebra
@testable import Common
@testable import SampleGroupers
@testable import Samples

class GroupDefinitionUnitTests: UnitTest {

	private final let sampleType = HeartRate.self

	private final var definition: GroupDefinitionImpl!
	private final var parser: BooleanExpressionParserMock!

	override func setUp() {
		super.setUp()
		definition = GroupDefinitionImpl(sampleType)
		parser = BooleanExpressionParserMock()
		Given(injectionProvider, .get(.value(BooleanExpressionParser.self), willReturn: parser))
	}

	// MARK: - description

	func testGivenExpressionPartsAreValid_description_returnsDescriptionOfParsedExpression() {
		// given
		let expectedDescription = "a OR b"
		let expression = ExpressionStub(expectedDescription)
		makeExpressionPartsParsable(expression)
		definition.expressionParts = [
			(type: .expression, expression: ExpressionStub("a")),
			(type: .or, expression: nil),
			(type: .expression, expression: ExpressionStub("b")),
		]

		// when
		let description = definition.description

		// then
		assertThat(description, equalTo(expectedDescription))
	}

	func testGivenExpressionPartsAreInvalid_description_returnsEmptyString() {
		// given
		makeExpressionPartsUnparsable()
		definition.expressionParts = [
			(type: .or, expression: nil),
		]

		// when
		let description = definition.description

		// then
		assertThat(description, equalTo(""))
	}

	// MARK: - sampleBelongsInGroup()

	func testGivenExpressionPartsUnparsable_sampleBelongsInGroup_throwsError() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample()
		makeExpressionPartsUnparsable()
		definition.expressionParts = [
			(type: .or, expression: nil),
		]

		// when / then
		XCTAssertThrowsError(try definition.sampleBelongsInGroup(sample))
	}

	func testGivenSampleBelongsInGroup_sampleBelongsInGroup_returnsTrue() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample()
		let expression = ExpressionStub("")
		expression.evaluation = true
		makeExpressionPartsParsable(expression)
		definition.expressionParts = [
			(type: .expression, expression: expression),
		]

		// when
		let belongsInGroup = try definition.sampleBelongsInGroup(sample)

		// then
		XCTAssert(belongsInGroup)
	}

	func testGivenSampleDoesNotBelongInGroup_sampleBelongsInGroup_returnsFalse() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample()
		let expression = ExpressionStub("")
		expression.evaluation = false
		makeExpressionPartsParsable(expression)
		definition.expressionParts = [
			(type: .or, expression: nil),
		]

		// when
		let belongsInGroup = try definition.sampleBelongsInGroup(sample)

		// then
		XCTAssertFalse(belongsInGroup)
	}

	// MARK: - isValid()

	func testGivenEmptyName_isValid_returnsFalse() {
		// given
		definition.name = ""

		// when
		let isValid = definition.isValid()

		// then
		XCTAssertFalse(isValid)
	}

	func testGivenNoExpressionParts_isValid_returnsFalse() {
		// given
		definition.name = "s"
		definition.expressionParts = []

		// when
		let isValid = definition.isValid()

		// then
		XCTAssertFalse(isValid)
	}

	func testGivenParsingOfBooleanExpressionFails_isValid_returnsFalse() {
		// given
		definition.name = "s"
		definition.expressionParts = [
			(type: .or, expression: nil),
		]
		makeExpressionPartsUnparsable()

		// when
		let isValid = definition.isValid()

		// then
		XCTAssertFalse(isValid)
	}

	func testGivenNonEmptyNameWithAtLeastOneExpressionPartThatCorrectlyParses_isValid_returnsTrue() {
		// given
		let expression = ExpressionStub("")
		definition.name = "s"
		definition.expressionParts = [
			(type: .expression, expression: expression),
		]
		makeExpressionPartsParsable(expression)

		// when
		let isValid = definition.isValid()

		// then
		XCTAssert(isValid)
	}

	// MARK: - copy()

	func test_copy_setsSameNameOnReturnedCopy() {
		// given
		let expectedName = "fds"
		definition.name = expectedName

		// when
		let copy = definition.copy()

		// then
		assertThat(copy.name, equalTo(expectedName))
	}

	func test_copy_setsCopyOfExpressionPartSequenceOnReturnedCopy() {
		// given
		let expression1 = ExpressionStub("1")
		let expression1Copy = ExpressionStub("1 copy")
		expression1.copyOf = expression1Copy
		let expression2 = ExpressionStub("2")
		let expression2Copy = ExpressionStub("2 copy")
		expression2.copyOf = expression2Copy
		let expectedPart1: BooleanExpressionPart = (type: .expression, expression: expression1Copy)
		let expectedPart2: BooleanExpressionPart = (type: .expression, expression: expression2Copy)
		definition.expressionParts = [
			(type: .expression, expression: expression1),
			(type: .expression, expression: expression2),
		]

		// when
		let copy = definition.copy()

		// then
		assertThat(copy.expressionParts, hasItems(equals(expectedPart1), equals(expectedPart2)))
	}

	// MARK: - equalTo()

	func testGivenExpressionPartsParseAndAreEqual_equalTo_returnsTrue() {
		// given
		let expression = ExpressionStub("a")
		makeExpressionPartsParsable(expression)
		let other = GroupDefinitionImpl(sampleType)

		// when
		let areEqual = definition.equalTo(other)

		// then
		XCTAssert(areEqual)
	}

	func testGivenExpressionPartsParseAndAreNotEqual_equalTo_returnsFalse() {
		// given
		let expression1 = ExpressionStub("a")
		definition.expressionParts = [
			(type: .or, expression: nil),
		]
		makeExpressionPartsParsable(parts: definition.expressionParts, expression1)
		let expression2 = ExpressionStub("b")
		let other = GroupDefinitionImpl(sampleType)
		other.expressionParts = [
			(type: .and, expression: nil),
		]
		makeExpressionPartsParsable(parts: other.expressionParts, expression2)

		// when
		let areEqual = definition.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	// if parts are equal, both will either parse or not
	func testGivenExpressionPartsDoNotParseAndAreEqual_equalTo_returnsTrue() {
		// given
		definition.expressionParts = [
			(type: .or, expression: nil),
		]
		let other = GroupDefinitionImpl(sampleType)
		other.expressionParts = definition.expressionParts
		makeExpressionPartsUnparsable(definition.expressionParts)

		// when
		let areEqual = definition.equalTo(other)

		// then
		XCTAssert(areEqual)
	}

	func testGivenExpressionPartsForSelfDoNotParseAndHaveDifferentTypes_equalTo_returnsFalse() {
		// given
		definition.expressionParts = [
			(type: .or, expression: nil),
		]
		let other = GroupDefinitionImpl(sampleType)
		other.expressionParts = [
			(type: .and, expression: nil),
		]
		makeExpressionPartsUnparsable(definition.expressionParts)

		// when
		let areEqual = definition.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenExpressionPartsForSelfDoNotParseAndHaveDifferentExpressions_equalTo_returnsFalse() {
		// given
		let expression1 = ExpressionStub("1")
		definition.expressionParts = [
			(type: .expression, expression: expression1),
		]
		let expression2 = ExpressionStub("2")
		let other = GroupDefinitionImpl(sampleType)
		other.expressionParts = [
			(type: .expression, expression: expression2),
		]
		makeExpressionPartsUnparsable(definition.expressionParts)

		// when
		let areEqual = definition.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenExpressionPartsForOtherDoNotParseAndHaveDifferentTypes_equalTo_returnsFalse() {
		// given
		definition.expressionParts = [
			(type: .or, expression: nil),
		]
		let other = GroupDefinitionImpl(sampleType)
		other.expressionParts = [
			(type: .and, expression: nil),
		]
		makeExpressionPartsParsable(parts: definition.expressionParts, ExpressionStub("parsed"))
		makeExpressionPartsUnparsable(other.expressionParts)

		// when
		let areEqual = definition.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenExpressionPartsForOtherDoNotParseAndHaveDifferentExpressions_equalTo_returnsFalse() {
		// given
		let expression1 = ExpressionStub("1")
		definition.expressionParts = [
			(type: .expression, expression: expression1),
		]
		let expression2 = ExpressionStub("2")
		let other = GroupDefinitionImpl(sampleType)
		other.expressionParts = [
			(type: .expression, expression: expression2),
		]
		makeExpressionPartsParsable(parts: definition.expressionParts, expression1)
		makeExpressionPartsUnparsable(other.expressionParts)

		// when
		let areEqual = definition.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenDifferentNames_equalTo_returnsFalse() {
		// given
		definition.expressionParts = [
			(type: .or, expression: nil),
		]
		let other = GroupDefinitionImpl(sampleType)
		other.expressionParts = definition.expressionParts
		other.name = definition.name + "other stuff"
		makeExpressionPartsUnparsable(definition.expressionParts)

		// when
		let areEqual = definition.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenDifferentSampleType_equalTo_returnsFalse() {
		// given
		definition.expressionParts = [
			(type: .or, expression: nil),
		]
		let other = GroupDefinitionImpl(BloodPressure.self)
		other.expressionParts = definition.expressionParts
		makeExpressionPartsUnparsable(definition.expressionParts)

		// when
		let areEqual = definition.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalTo_returnsTrue() {
		// given
		definition.expressionParts = [
			(type: .or, expression: nil),
		]
		makeExpressionPartsUnparsable()

		// when
		let areEqual = definition.equalTo(definition)

		// then
		XCTAssertTrue(areEqual)
	}

	func testGivenExpressionPartsHaveSameTypeButOneExpressionIsNilAndOtherIsNot_equalTo_returnsFalse() {
		// given
		definition.expressionParts = [
			(type: .or, expression: nil),
		]
		let other = GroupDefinitionImpl(BloodPressure.self)
		other.expressionParts = [
			(type: .or, expression: ExpressionStub("1")),
		]
		makeExpressionPartsUnparsable()

		// when
		let areEqual = definition.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	// MARK: - Helper Functions

	private final func makeExpressionPartsUnparsable(_ parts: [BooleanExpressionPart]? = nil) {
		if let parts = parts {
			Given(parser, .parse(.value(parts), willThrow: GenericError("")))
		} else {
			Given(parser, .parse(.any, willThrow: GenericError("")))
		}
	}

	private final func makeExpressionPartsParsable(
		parts: [BooleanExpressionPart]? = nil,
		_ expression: BooleanExpression)
	{
		if let parts = parts {
			Given(parser, .parse(.value(parts), willReturn: expression))
		} else {
			Given(parser, .parse(.any, willReturn: expression))
		}
	}
}
