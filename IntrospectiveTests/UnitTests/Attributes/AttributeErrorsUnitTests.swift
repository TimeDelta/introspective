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

final class AttributeErrorsUnitTests: UnitTest {

	// MARK: - TypeMismatchError

	func testGivenTypeMismatchErrorWithAttributedObject_localizedDescription_containsNameOfAttributedObject() {
		// given
		let attribute = TextAttribute(name: "name of the text attribute")
		let attributedObject = HeartRate(12, Date())
		let error = TypeMismatchError(attribute: attribute, of: attributedObject, wasA: HeartRate.self)

		// when
		let description = error.localizedDescription

		// then
		assertThat(description, containsString(attributedObject.attributedName))
	}

	func testGivenTypeMismatchErrorWithAttributedObject_localizedDescription_containsNameOfAttribute() {
		// given
		let attribute = TextAttribute(name: "name of the text attribute")
		let attributedObject = HeartRate(12, Date())
		let error = TypeMismatchError(attribute: attribute, of: attributedObject, wasA: HeartRate.self)

		// when
		let description = error.localizedDescription

		// then
		assertThat(description, containsString(attribute.name))
	}

	func testGivenTypeMismatchErrorWithAttributedObjectAndNonNilValue_localizedDescription_containsDescriptionOfValueType() {
		// given
		let attribute = TextAttribute(name: "name of the text attribute")
		let attributedObject = HeartRate(12, Date())
		let error = TypeMismatchError(attribute: attribute, of: attributedObject, wasA: HeartRate.self)

		// when
		let description = error.localizedDescription

		// then
		assertThat(description, containsString("HeartRate"))
	}

	func testGivenTypeMismatchErrorWithoutAttributedObject_localizedDescription_containsNameOfAttribute() {
		// given
		let attribute = TextAttribute(name: "name of the text attribute")
		let error = TypeMismatchError(attribute: attribute, wasA: HeartRate.self)

		// when
		let description = error.localizedDescription

		// then
		assertThat(description, containsString(attribute.name))
	}

	func testGivenTypeMismatchErrorWithoutAttributedObjectAndWithNonNilValue_localizedDescription_containsDescriptionOfValueType() {
		// given
		let attribute = TextAttribute(name: "name of the text attribute")
		let error = TypeMismatchError(attribute: attribute, wasA: HeartRate.self)

		// when
		let description = error.localizedDescription

		// then
		assertThat(description, containsString("HeartRate"))
	}

	// MARK: - UnsupportedValueError

	func testGivenUnsupportedValueErrorWithAttributedObject_localizedDescription_containsNameOfAttributedObject() {
		// given
		let attribute = TextAttribute(name: "name of the text attribute")
		let attributedObject = HeartRate(12, Date())
		let value: Any? = nil
		let error = UnsupportedValueError(attribute: attribute, of: attributedObject, is: value)

		// when
		let description = error.localizedDescription

		// then
		assertThat(description, containsString(attributedObject.attributedName))
	}

	func testGivenUnsupportedValueErrorWithAttributedObject_localizedDescription_containsNameOfAttribute() {
		// given
		let attribute = TextAttribute(name: "name of the text attribute")
		let attributedObject = HeartRate(12, Date())
		let value: Any? = nil
		let error = UnsupportedValueError(attribute: attribute, of: attributedObject, is: value)

		// when
		let description = error.localizedDescription

		// then
		assertThat(description, containsString(attribute.name))
	}

	func testGivenUnsupportedValueErrorWithAttributedObjectAndNonNilValue_localizedDescription_containsDescriptionOfValue() {
		// given
		let attribute = TextAttribute(name: "name of the text attribute")
		let attributedObject = HeartRate(12, Date())
		let value: Any = Dosage(12, "mg")
		let error = UnsupportedValueError(attribute: attribute, of: attributedObject, is: value)

		// when
		let description = error.localizedDescription

		// then
		assertThat(description, containsString(String(describing: value)))
	}

	func testGivenUnsupportedValueErrorWithAttributedObjectAndNilValue_localizedDescription_containsNil() {
		// given
		let attribute = TextAttribute(name: "name of the text attribute")
		let attributedObject = HeartRate(12, Date())
		let error = UnsupportedValueError(attribute: attribute, of: attributedObject, is: nil)

		// when
		let description = error.localizedDescription

		// then
		assertThat(description, containsString("nil"))
	}

	func testGivenUnsupportedValueErrorWithoutAttributedObject_localizedDescription_containsNameOfAttribute() {
		// given
		let attribute = TextAttribute(name: "name of the text attribute")
		let value: Any? = nil
		let error = UnsupportedValueError(attribute: attribute, is: value)

		// when
		let description = error.localizedDescription

		// then
		assertThat(description, containsString(attribute.name))
	}

	func testGivenUnsupportedValueErrorWithoutAttributedObjectAndWithNonNilValue_localizedDescription_containsDescriptionOfValue() {
		// given
		let attribute = TextAttribute(name: "name of the text attribute")
		let value: Any = Dosage(12, "mg")
		let error = UnsupportedValueError(attribute: attribute, is: value)

		// when
		let description = error.localizedDescription

		// then
		assertThat(description, containsString(String(describing: value)))
	}

	func testGivenUnsupportedValueErrorWithoutAttributedObjectAndWithNilValue_localizedDescription_containsNil() {
		// given
		let attribute = TextAttribute(name: "name of the text attribute")
		let error = UnsupportedValueError(attribute: attribute, is: nil)

		// when
		let description = error.localizedDescription

		// then
		assertThat(description, containsString("nil"))
	}

	// MARK: - UnknownAttributeError

	func testGivenUnknownAttributeError_localizedDescription_containsNameOfAttributedObject() {
		// given
		let attribute = TextAttribute(name: "name of the text attribute")
		let attributedObject = HeartRate(12, Date())
		let error = UnknownAttributeError(attribute: attribute, for: attributedObject)

		// when
		let description = error.localizedDescription

		// then
		assertThat(description, containsString(attributedObject.attributedName))
	}

	func testGivenUnknownAttributeError_localizedDescription_containsNameOfAttribute() {
		// given
		let attribute = TextAttribute(name: "name of the text attribute")
		let attributedObject = HeartRate(12, Date())
		let error = UnknownAttributeError(attribute: attribute, for: attributedObject)

		// when
		let description = error.localizedDescription

		// then
		assertThat(description, containsString(attribute.name))
	}
}
