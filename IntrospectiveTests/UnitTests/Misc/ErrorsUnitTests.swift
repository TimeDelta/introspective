//
//  ErrorsUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
@testable import Introspective

final class ErrorsUnitTests: UnitTest {

	// MARK: - GenericDisplayableError

	func testGivenGenericDisplayableErrorWithOnlyTitle_localizedDescription_returnsTitle() {
		// given
		let title = "error title"
		let error = GenericDisplayableError(title: title)

		// when
		let description = error.localizedDescription

		// then
		XCTAssertEqual(description, title)
	}

	func testGivenGenericDisplayableErrorWithTitleAndDescription_localizedDescription_containsTitle() {
		// given
		let title = "error title"
		let description = "error description"
		let error = GenericDisplayableError(title: title, description: description)

		// when
		let localizedDescription = error.localizedDescription

		// then
		assertThat(localizedDescription, containsString(title))
	}

	func testGivenGenericDisplayableErrorWithTitleAndDescription_localizedDescription_containsDescription() {
		// given
		let title = "error title"
		let description = "error description"
		let error = GenericDisplayableError(title: title, description: description)

		// when
		let localizedDescription = error.localizedDescription

		// then
		assertThat(localizedDescription, containsString(description))
	}

	// MARK: - NotOverriddenError

	func testGivenNotOverriddenError_localizedDescription_containsNameOfFunctionThatIsNotOverridden() {
		// given
		let functionName = "name of function not overridden"
		let error = NotOverriddenError(functionName: functionName)

		// when
		let description = error.localizedDescription

		// then
		assertThat(description, containsString(functionName))
	}

	// MARK: - UnknownSampleTypeError

	func testGivenUnknownSampleTypeError_localizedDescription_containsNameOfUnknownSampleType() {
		// given
		let sampleType: Sample.Type = HeartRate.self
		let error = UnknownSampleTypeError(sampleType)

		// when
		let description = error.localizedDescription

		// then
		assertThat(description, containsString(sampleType.name))
	}

	// MARK: - GenericError

	func testGivenGenericError_localizedDescription_returnsPassedMessage() {
		// given
		let message = "this is a generic error message"
		let error = GenericError(message)

		// when
		let description = error.localizedDescription

		// then
		XCTAssertEqual(description, message)
	}
}
