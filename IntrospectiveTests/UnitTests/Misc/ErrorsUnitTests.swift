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

	func testGivenGenericDisplayableErrorWithOnlyTitle_description_containsTitle() {
		// given
		let title = "error title"
		let error = GenericDisplayableError(title: title)

		// when
		let actualDescription = error.description

		// then
		assertThat(actualDescription, containsString(title))
	}

	func testGivenGenericDisplayableErrorWithTitleAndDescription_description_containsTitle() {
		// given
		let title = "error title"
		let description = "error description"
		let error = GenericDisplayableError(title: title, description: description)

		// when
		let actualDescription = error.description

		// then
		assertThat(actualDescription, containsString(title))
	}

	func testGivenGenericDisplayableErrorWithTitleAndDescription_description_containsDescription() {
		// given
		let title = "error title"
		let description = "error description"
		let error = GenericDisplayableError(title: title, description: description)

		// when
		let actualDescription = error.description

		// then
		assertThat(actualDescription, containsString(description))
	}

	// MARK: - NotOverriddenError

	func testGivenNotOverriddenError_description_containsNameOfFunctionThatIsNotOverridden() {
		// given
		let functionName = "name of function not overridden"
		let error = NotOverriddenError(functionName: functionName)

		// when
		let actualDescription = error.description

		// then
		assertThat(actualDescription, containsString(functionName))
	}

	// MARK: - UnknownSampleTypeError

	func testGivenUnknownSampleTypeError_description_containsNameOfUnknownSampleType() {
		// given
		let sampleType: Sample.Type = HeartRate.self
		let error = UnknownSampleTypeError(sampleType)

		// when
		let actualDescription = error.description

		// then
		assertThat(actualDescription, containsString(sampleType.name))
	}

	// MARK: - GenericError

	func testGivenGenericError_description_containsPassedMessage() {
		// given
		let message = "this is a generic error message"
		let error = GenericError(message)

		// when
		let actualDescription = error.description

		// then
		assertThat(actualDescription, containsString(message))
	}
}
