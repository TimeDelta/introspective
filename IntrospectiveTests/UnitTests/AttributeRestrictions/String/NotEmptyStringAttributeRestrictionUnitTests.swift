//
//  NotEmptyStringAttributeRestrictionUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/13/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
@testable import Introspective

final class NotEmptyStringAttributeRestrictionUnitTests: UnitTest {

	private final let attribute = TextAttribute(name: "attribute name")
	private final var restriction: NotEmptyStringAttributeRestriction!

	override func setUp() {
		restriction = NotEmptyStringAttributeRestriction(restrictedAttribute: attribute)
	}

	// MARK: - samplePasses

	func testGivenNilSampleValue_samplePasses_returnsFalse() throws {
		// given
		let sampleValue: String? = nil
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleValue, for: attribute)

		// when
		let samplePasses = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(samplePasses)
	}

	func testGivenEmptySampleValue_samplePasses_returnsFalse() throws {
		// given
		let sampleValue = ""
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleValue, for: attribute)

		// when
		let samplePasses = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(samplePasses)
	}

	func testGivenNonEmptySampleValue_samplePasses_returnsTrue() throws {
		// given
		let sampleValue = "not empty"
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleValue, for: attribute)

		// when
		let samplePasses = try restriction.samplePasses(sample)

		// then
		XCTAssertTrue(samplePasses)
	}

	func testGivenNonStringValueForSpecifiedAttribute_samplePasses_throwsTypeMismatchError() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: 23, for: attribute)

		// when
		XCTAssertThrowsError(try restriction.samplePasses(sample)) { error in
			// then
			assertThat(error, instanceOf(TypeMismatchError.self))
		}
	}

	// MARK: - copy()

	func test_copy_returnsCopy() {
		// when
		let copy = restriction.copy()

		// then
		guard let castedCopy = copy as? NotEmptyStringAttributeRestriction else {
			XCTFail("Wrong type returned")
			return
		}
		assertThat(castedCopy, equals(restriction))
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = TextAttribute(name: "unknown")

		// when
		XCTAssertThrowsError(try restriction.value(of: unknownAttribute)) { error in
			// then
			assertThat(error, instanceOf(UnknownAttributeError.self))
		}
	}

	// MARK: - set(attribute: to:)

	func testGivenUnknownAttribute_set_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = TextAttribute(name: "unknown")

		// when
		XCTAssertThrowsError(try restriction.set(attribute: unknownAttribute, to: "" as Any)) { error in
			// then
			assertThat(error, instanceOf(UnknownAttributeError.self))
		}
	}
}
