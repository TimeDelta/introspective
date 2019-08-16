//
//  GlobalFunctionsUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 1/17/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
@testable import Introspective

final class GlobalFunctionsUnitTests: UnitTest {

	private enum Errors: Error {
		case error1
		case error2
	}

	// MARK: - isOptional()

	func testGivenOptionalTypeWithNonNilValue_isOptional_returnsTrue() {
		// given
		let value: String? = nil

		// when
		let optional = isOptional(value)

		// then
		XCTAssert(optional)
	}

	func testGivenOptionalTypeWithNilValue_isOptional_returnsTrue() {
		// given
		let value: String? = "not nil"

		// when
		let optional = isOptional(value)

		// then
		XCTAssert(optional)
	}

	func testGivenNonOptionalType_isOptional_returnsFalse() {
		// given
		let value = "not optional"

		// when
		let optional = isOptional(value)

		// then
		XCTAssertFalse(optional)
	}

	func testGivenOptionalNilValueHiddenBehindAnyType_isOptional_returnsTrue() {
		// given
		let hiddenValue: String? = nil
		let value: Any = hiddenValue as Any

		// when
		let optional = isOptional(value)

		// then
		XCTAssert(optional)
	}

	func testGivenOptionalNonNilValueHiddenBehindAnyType_isOptional_returnsTrue() {
		// given
		let hiddenValue: String? = "not nil"
		let value: Any = hiddenValue as Any

		// when
		let optional = isOptional(value)

		// then
		XCTAssert(optional)
	}

	// MARK: - retryOnFail() -> Type

	func testGivenThrowingFunctionWithRetries_retryOnFailWithReturn_runsCodeMaxRetriesPlusOneTimes() {
		// given
		var numberOfTimesRan = 0
		let maxRetries = 2

		// when
		do {
			let _: Bool = try retryOnFail({
				numberOfTimesRan += 1
				throw NSError()
			}, maxRetries: maxRetries)
		} catch { /* do nothing - it's supposed to throw */ }

		// then
		XCTAssertEqual(numberOfTimesRan, maxRetries + 1)
	}

	func testGivenThrowingFunctionWithRetries_retryOnFailWithReturn_throwsOriginalError() {
		// given
		let maxRetries = 1
		var index = -1

		// when
		XCTAssertThrowsError(
			try callRetryOnFailWithReturn({
				index += 1
				if index == 0 {
					throw Errors.error1
				}
				throw Errors.error2
			},
			maxRetries: maxRetries)
		) { error in
			// then
			XCTAssertEqual(error as? Errors, Errors.error1)
		}
	}

	func testGivenFunctionThatThrowsFirstTimeOnlyAndNoMaximumRetries_retryOnFailWithReturn_executesAndReturnsCorrectValue() throws {
		// given
		var index = -1
		let expectedValue = 1432

		// when
		let returned: Int = try retryOnFail({
			index += 1
			if index == 0 {
				throw Errors.error1
			}
			return expectedValue
		})

		// then
		XCTAssertEqual(returned, expectedValue)
	}

	// MARK: - retryOnFail()

	func testGivenThrowingFunctionWithRetries_retryOnFail_runsCodeMaxRetriesPlusOneTimes() {
		// given
		var numberOfTimesRan = 0
		let maxRetries = 2

		// when
		do {
			try retryOnFail({
				numberOfTimesRan += 1
				throw NSError()
			}, maxRetries: maxRetries)
		} catch { /* do nothing - it's supposed to throw */ }

		// then
		XCTAssertEqual(numberOfTimesRan, maxRetries + 1)
	}

	func testGivenThrowingFunctionWithRetries_retryOnFail_throwsOriginalError() {
		// given
		let maxRetries = 1
		var index = -1

		// when
		XCTAssertThrowsError(
			try retryOnFail({
				index += 1
				if index == 0 {
					throw Errors.error1
				}
				throw Errors.error2
			},
			maxRetries: maxRetries)
		) { error in
			// then
			XCTAssertEqual(error as? Errors, Errors.error1)
		}
	}

	func testGivenFunctionThatThrowsFirstTimeOnlyAndNoMaximumRetries_retryOnFail_executesAndReturns() throws {
		// given
		var index = -1
		let returned = expectation(description: "returned")

		// when
		try retryOnFail({
			index += 1
			if index == 0 {
				throw Errors.error1
			}
			returned.fulfill()
		})

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			XCTAssert(waitError == nil, waitError?.localizedDescription ?? "Timed out")
		}
	}

	// MARK - copyArray()

	func test_copyArray_returnsArrayThatModifyingDoesNotAffectOriginal() {
		// given
		let original = [1, 2, 3]

		// when
		var copy = copyArray(original)
		copy[0] = 8

		// then
		assertThat(original, contains(1, 2, 3))
	}

	// MARK: - Helper Functions

	private final func callRetryOnFailWithReturn(_ code: () throws -> Bool, maxRetries: Int) throws {
		let _: Bool = try retryOnFail(code, maxRetries: maxRetries)
	}
}
