//
//  TagFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
@testable import Introspective
@testable import Samples

final class TagFunctionalTests: FunctionalTest {

	private typealias Me = TagFunctionalTests
	private static let name = "tag name"

	private final var tag: Tag!

	final override func setUp() {
		super.setUp()
		tag = TagDataTestUtil.createTag(name: Me.name)
	}

	// MARK: - description

	func testGivenNonEmptyTagName_description_includesTagName() {
		// when
		let description = tag.description

		// then
		assertThat(description, containsString(tag.name))
	}

	// MARK: - ==

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() {
		// when
		let areEqual = tag == tag

		// then
		XCTAssert(areEqual)
	}

	// https://stackoverflow.com/questions/42283715/overload-for-custom-class-is-not-always-called
	// https://stackoverflow.com/questions/6883848/why-am-i-not-able-to-override-isequal-in-my-nsmanagedobject-subclass
	func testGivenTwotagsWithSameValuesButDifferentMemoryAddresses_equalToOperator_returnsFalse() {
		// given
		let othertag = TagDataTestUtil.createTag(name: tag.name)

		// when
		let areEqual = tag == othertag

		// then
		XCTAssertFalse(areEqual)
	}

	// MARK: - equalTo

	func testGivenSameObjectTwice_equalTo_returnsTrue() {
		// when
		let areEqual = tag.equalTo(tag)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTagWithSameName_equalTo_returnsTrue() {
		// given
		let otherTag = TagDataTestUtil.createTag(name: tag.name)

		// when
		let areEqual = tag.equalTo(otherTag)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTagWithDifferentName_equalTo_returnsFalse() {
		// given
		let otherTag = TagDataTestUtil.createTag(name: tag.name + "other stuff")

		// when
		let areEqual = tag.equalTo(otherTag)

		// then
		XCTAssertFalse(areEqual)
	}
}
