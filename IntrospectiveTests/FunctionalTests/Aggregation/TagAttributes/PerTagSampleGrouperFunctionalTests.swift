//
//  PerTagSampleGrouperFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/28/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
@testable import Introspective
@testable import Attributes
@testable import DependencyInjection
@testable import SampleGroupers
@testable import Samples

final class PerTagSampleGrouperFunctionalTests: FunctionalTest {

	private final let tagAttribute = TagAttribute(name: "fdjkl")

	private final var grouper: PerTagSampleGrouper!

	override func setUp() {
		super.setUp()
		grouper = PerTagSampleGrouper(attributes: [tagAttribute])
	}

	// MARK: - group()

	func testGivenTagAttribute_group_correctlyGroupsSamplesByTag() throws {
		// given
		let tag1 = TagDataTestUtil.createTag(name: "1")
		let tag2 = TagDataTestUtil.createTag(name: "2")
		let samples = SampleCreatorTestUtil.createSamples(
			withValues: [
				tag1,
				tag2,
				tag1,
			],
			for: tagAttribute)

		// when
		let groups = try grouper.group(samples: samples)

		// then
		assertThat(groups, hasGroup(forValue: tag1.name, withSamples: [samples[0], samples[2]]))
		assertThat(groups, hasGroup(forValue: tag2.name, withSamples: [samples[1]]))
	}

	func testGivenTagsAttribute_group_correctlyGroupsSamplesByTag() throws {
		// given
		let tag1 = TagDataTestUtil.createTag(name: "1")
		let tag2 = TagDataTestUtil.createTag(name: "2")
		let tag3 = TagDataTestUtil.createTag(name: "3")
		let tagsAttribute = TagsAttribute(name: "fd")
		grouper = PerTagSampleGrouper(attributes: [tagsAttribute])
		let samples = SampleCreatorTestUtil.createSamples(
			withValues: [
				[tag1, tag3],
				[tag2, tag3],
				[tag1, tag2],
			],
			for: tagsAttribute)

		// when
		let groups = try grouper.group(samples: samples)

		// then
		assertThat(groups, hasGroup(forValue: tag1.name, withSamples: [samples[0], samples[2]]))
		assertThat(groups, hasGroup(forValue: tag2.name, withSamples: [samples[1], samples[2]]))
		assertThat(groups, hasGroup(forValue: tag3.name, withSamples: [samples[0], samples[1]]))
	}

	func testGivenTagAttributeWithNonTagValueForSample_group_throwsTypeMismatchError() throws {
		// given
		grouper.groupByAttribute = tagAttribute
		let samples = SampleCreatorTestUtil.createSamples(withValues: [0], for: tagAttribute)

		// when
		XCTAssertThrowsError(try grouper.group(samples: samples)) { error in
			// then
			assertThat(error, isA(TypeMismatchError.self))
		}
	}

	func testGivenTagsAttributeWithNonTagValueForSample_group_throwsTypeMismatchError() throws {
		// given
		let tagsAttribute = TagsAttribute(name: "fg")
		grouper = PerTagSampleGrouper(attributes: [tagsAttribute])
		grouper.groupByAttribute = tagsAttribute
		let samples = SampleCreatorTestUtil.createSamples(withValues: [0], for: tagsAttribute)

		// when
		XCTAssertThrowsError(try grouper.group(samples: samples)) { error in
			// then
			assertThat(error, isA(TypeMismatchError.self))
		}
	}

	// MARK: - groupNameFor(value:)

	func testGivenGroupByTagAttributeWithTagValue_groupNameForValue_returnsAttributeNameEqualsValue() throws {
		// given
		grouper.groupByAttribute = tagAttribute
		let tag = TagDataTestUtil.createTag(name: "fnerwo")

		// when
		let groupName = try grouper.groupNameFor(value: tag)

		// then
		assertThat(groupName, equalTo("\(tagAttribute.name) = \(tag.name)"))
	}

	func testGivenGroupByTagsAttributeWithTagValue_groupNameForValue_returnsAttributeNameHasValue() throws {
		// given
		let tagsAttribute = TagsAttribute(name: "fsd")
		grouper = PerTagSampleGrouper(attributes: [tagsAttribute])
		grouper.groupByAttribute = tagsAttribute
		let tag = TagDataTestUtil.createTag(name: "fnerwo")

		// when
		let groupName = try grouper.groupNameFor(value: tag)

		// then
		assertThat(groupName, equalTo("\(tagsAttribute.name) has \(tag.name)"))
	}

	// MARK: - groupValuesAreEqual()

	func testGivenEqualTagValues_groupValuesAreEqual_returnsTrue() throws {
		// given
		let tag = TagDataTestUtil.createTag(name: "f")

		// when
		let areEqual = try grouper.groupValuesAreEqual(tag, tag)

		// then
		XCTAssert(areEqual)
	}

	func testGivenNotEqualTagValues_groupValuesAreEqual_returnsFalse() throws {
		// given
		let tag1 = TagDataTestUtil.createTag(name: "f")
		let tag2 = TagDataTestUtil.createTag(name: tag1.name + "other stuff")

		// when
		let areEqual = try grouper.groupValuesAreEqual(tag1, tag2)

		// then
		XCTAssertFalse(areEqual)
	}
}
