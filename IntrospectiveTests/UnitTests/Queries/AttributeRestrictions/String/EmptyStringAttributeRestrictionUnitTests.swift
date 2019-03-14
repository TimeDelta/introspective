//
//  EmptyStringAttributeRestrictionUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/13/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
@testable import Introspective

class EmptyStringAttributeRestrictionUnitTests: UnitTest {

	private final let attribute = TextAttribute(name: "attribute name")
	private final var restriction: EmptyStringAttributeRestriction!

	override func setUp() {
		restriction = EmptyStringAttributeRestriction(restrictedAttribute: attribute)
	}

	func testGivenNilSampleValue_samplePasses_returnsTrue() throws {
		// given
		let sampleValue: String? = nil
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleValue, for: attribute)

		// when
		let samplePasses = try restriction.samplePasses(sample)

		// then
		XCTAssertTrue(samplePasses)
	}

	func testGivenEmptySampleValue_samplePasses_returnsTrue() throws {
		// given
		let sampleValue = ""
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleValue, for: attribute)

		// when
		let samplePasses = try restriction.samplePasses(sample)

		// then
		XCTAssertTrue(samplePasses)
	}

	func testGivenNonEmptySampleValue_samplePasses_returnsFalse() throws {
		// given
		let sampleValue = "not empty"
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleValue, for: attribute)

		// when
		let samplePasses = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(samplePasses)
	}
}
