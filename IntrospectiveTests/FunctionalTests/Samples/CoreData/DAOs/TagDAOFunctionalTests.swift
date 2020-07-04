//
//  TagDAOFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/4/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest

@testable import Samples

class TagDAOFunctionalTests: FunctionalTest {

	// MARK: - Test Setup

	private typealias Me = TagDAOFunctionalTests

	private static let tagInfo1 = TagInfo("tag 1")

	private var dao: TagDAOImpl!

	public override final func setUp() {
		super.setUp()
		dao = TagDAOImpl()
	}

	// MARK: - getTag()

	func testGivenExactlyOneMatchingTagExists_getTag_returnsCorrectTag() throws {
		// given
		let expectedTagName = "fheuwiohfui pvds"
		TagDataTestUtil.createTag(name: expectedTagName)
		TagDataTestUtil.createTag(name: "prefix " + expectedTagName)
		TagDataTestUtil.createTag(name: expectedTagName + " suffix")

		// when
		guard let tag = try dao.getTag(named: expectedTagName) else {
			XCTFail("return value was nil")
			return
		}

		// then
		assertThat(tag, hasName(expectedTagName))
	}

	func testGivenNoMatchingTagsExist_getTag_returnsNil() throws {
		// when
		let tag = try dao.getTag(named: "no tags exist")

		// then
		assertThat(tag, nilValue())
	}

	func testGivenMultipleMatchingTags_getTag_doesNotThrowError() throws {
		// given
		let tagName = "fewas"
		TagDataTestUtil.createTag(name: tagName)
		TagDataTestUtil.createTag(name: tagName)

		// when
		let _ = try dao.getTag(named: tagName)

		// then - no error thrown
	}

	// MARK: - getOrCreateTag()

	func testGivenNoExistingTagWithName_getOrCreateTag_createsNewTagWithCorrectName() throws {
		// when
		_ = try dao.getOrCreateTag(named: Me.tagInfo1.name)

		// then
		assertThat(Me.tagInfo1, exists(Tag.self))
	}

	func testGivenExistingTagWithName_getOrCreateTag_retrievesCorrectTag() throws {
		// given
		TagDataTestUtil.createTag(name: Me.tagInfo1.name)

		// when
		let tag = try dao.getOrCreateTag(named: Me.tagInfo1.name)

		// then
		assertThat(tag, hasName(Me.tagInfo1.name))
	}

	func testGivenExistingTagWithName_getOrCreateTag_doesNotCreateAdditionalTag() throws {
		// given
		TagDataTestUtil.createTag(name: Me.tagInfo1.name)

		// when
		_ = try dao.getOrCreateTag(named: Me.tagInfo1.name)

		// then
		assertThat(Tag.self, numberStoredInDatabase(1))
	}
}
