//
//  LabelsTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
import XCTest
import NaturalLanguage
@testable import DataIntegration

class LabelsTests: UnitTest {

	fileprivate var labels: Labels!

	override func setUp() {
		super.setUp()
		labels = Labels()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testGivenValidLabel_addLabel_storesLabelByIndex() {
		// given
		let label = createLabelFor(Tags.activityData)

		// when
		labels.addLabel(label)

		// then
		assert(labels.byIndex[0] == label)
	}

	func testGivenValidLabel_addLabel_storesLabelByTag() {
		// given
		let label = createLabelFor(Tags.activityData)

		// when
		labels.addLabel(label)

		// then
		assert(labels.byTag[label.tag] == [label])
	}

	func testGivenLabelWithSameTagJustAdded_addLabel_combinesNewLabelWithMostRecentOne() {
		// given
		let tag = Tags.activityData
		let token1 = "token1"
		let token2 = "token2"
		labels.addLabel(createLabelFor(tag, token1))

		// when
		labels.addLabel(createLabelFor(tag, token2))

		// then
		assert(labels.count == 1)
		assert(labels.byIndex[0].token == token1 + " " + token2)
	}

	func testGivenLabelWithNoneTagJustAdded_addLabel_doesNotCombineNewLabelWithMostRecentOne() {
		// given
		labels.addLabel(createLabelFor(Tags.none))

		// when
		labels.addLabel(createLabelFor(Tags.none))

		// then
		assert(labels.count == 2)
	}

	func testGivenNoLabelsPreviouslyAdded_hasLabels_returnsFalse() {
		// when
		let hasLabels = labels.hasLabels()

		// then
		XCTAssertFalse(hasLabels)
	}

	func testGivenLabelsPreviouslyAdded_hasLabels_returnsTrue() {
		// given
		let label = createLabelFor(Tags.activityData)
		labels.addLabel(label)

		// when
		let hasLabels = labels.hasLabels()

		// then
		assert(hasLabels)
	}

	func testGivenNoLabelsPreviouslyAdded_hasLabelFor_returnsFalse() {
		// when
		let hasLabelFor = labels.hasLabelFor(Tags.activityData)

		// then
		XCTAssertFalse(hasLabelFor)
	}

	func testGivenLabelWithSpecifiedTagPreviouslyAdded_hasLabelFor_returnsTrue() {
		// given
		let label = createLabelFor(Tags.activityData)
		labels.addLabel(label)

		// when
		let hasLabelFor = labels.hasLabelFor(label.tag)

		// then
		assert(hasLabelFor)
	}

	func testGivenLabelWithDifferentTagPreviouslyAdded_hasLabelFor_returnsFalse() {
		// given
		let label = createLabelFor(Tags.activityData)
		labels.addLabel(label)

		// when
		let hasLabelFor = labels.hasLabelFor(NLTag("SomethingDifferent"))

		// then
		XCTAssertFalse(hasLabelFor)
	}

	func testGivenNoLabelsPreviouslyAdded_labelsInAnyOrderFor_returnsEmptyArray() {
		// when
		let labelsFor = labels.labelsInAnyOrderFor(tags: [Tags.activityData])

		// then
		assert(labelsFor.isEmpty)
	}

	func testGivenOnlyLabelsWithRequestedTagsPreviouslyAdded_labelsInAnyOrderFor_returnsAllLabelsForGivenTags() {
		// given
		let tags = Set<NLTag>([Tags.attribute, Tags.comparison, Tags.quantity])
		// can't add same one twice consecutively because it consolidates consecutive tokens with identical tags
		for tag in tags {
			labels.addLabel(createLabelFor(tag))
		}
		for tag in tags {
			labels.addLabel(createLabelFor(tag))
		}

		// when
		let labelsFor = labels.labelsInAnyOrderFor(tags: tags)

		// then
		assert(2 * tags.count == labelsFor.count)
		for label in labelsFor {
			assert(tags.contains(label.tag))
		}
	}

	func testGivenLabelsWithRequestedTagsAndLabelsWithNonRequestedTagsPreviouslyAdded_labelsInAnyOrderFor_doesNotReturnLabelsWithNonRequestedTags() {
		// given
		let tags = Set<NLTag>([Tags.attribute, Tags.comparison, Tags.quantity])
		let otherTag = NLTag("otherTag")
		for tag in tags {
			labels.addLabel(createLabelFor(tag))
		}
		labels.addLabel(createLabelFor(otherTag))

		// when
		let labelsFor = labels.labelsInAnyOrderFor(tags: tags)

		// then
		for label in labelsFor {
			assert(label.tag != otherTag)
		}
	}

	func testGivenLabelsWithOnlyNonRequestedTagsPreviouslyAdded_labelsInAnyOrderFor_returnsEmptyArray() {
		// given
		let tags = Set<NLTag>([Tags.attribute, Tags.comparison, Tags.quantity])
		let otherTag = NLTag("otherTag")
		labels.addLabel(createLabelFor(otherTag))

		// when
		let labelsFor = labels.labelsInAnyOrderFor(tags: tags)

		// then
		assert(labelsFor.isEmpty)
	}

	func testGivenNoLabelsPreviouslyAdded_labelsFor_returnsEmptyArray() {
		// when
		let labelsFor = labels.labelsFor(tags: [Tags.activityData])

		// then
		assert(labelsFor.isEmpty)
	}

	func testGivenOnlyLabelsWithRequestedTagsPreviouslyAdded_labelsFor_returnsAllLabelsForGivenTags() {
		// given
		let tags = Set<NLTag>([Tags.attribute, Tags.comparison, Tags.quantity])
		// can't add same one twice consecutively because it consolidates consecutive tokens with identical tags
		for tag in tags {
			labels.addLabel(createLabelFor(tag))
		}
		for tag in tags {
			labels.addLabel(createLabelFor(tag))
		}

		// when
		let labelsFor = labels.labelsFor(tags: tags)

		// then
		assert(2 * tags.count == labelsFor.count)
		for label in labelsFor {
			assert(tags.contains(label.tag))
		}
	}

	func testGivenLabelsWithRequestedTagsAndLabelsWithNonRequestedTagsPreviouslyAdded_labelsFor_doesNotReturnLabelsWithNonRequestedTags() {
		// given
		let tags = Set<NLTag>([Tags.attribute, Tags.comparison, Tags.quantity])
		let otherTag = NLTag("otherTag")
		for tag in tags {
			labels.addLabel(createLabelFor(tag))
		}
		labels.addLabel(createLabelFor(otherTag))

		// when
		let labelsFor = labels.labelsFor(tags: tags)

		// then
		for label in labelsFor {
			assert(label.tag != otherTag)
		}
	}

	func testGivenLabelsWithOnlyNonRequestedTagsPreviouslyAdded_labelsFor_returnsEmptyArray() {
		// given
		let tags = Set<NLTag>([Tags.attribute, Tags.comparison, Tags.quantity])
		let otherTag = NLTag("otherTag")
		labels.addLabel(createLabelFor(otherTag))

		// when
		let labelsFor = labels.labelsFor(tags: tags)

		// then
		assert(labelsFor.isEmpty)
	}

	func testGivenLabelsWithRequestedTags_labelsFor_returnsLabelsInOrderTheyWereAdded() {
		// given
		let tags = [Tags.attribute, Tags.comparison, Tags.quantity]
		for tag in tags.reversed() {
			labels.addLabel(createLabelFor(tag))
		}

		// when
		let labelsFor = labels.labelsFor(tags: Set(tags))

		// then
		for i in 0 ..< tags.count {
			assert(labelsFor[labelsFor.count - i - 1].tag == tags[i])
		}
	}

	func testGivenOnlyOneLabelWithSpecifiedTag_splitBeforeTag_splitsBeforeThatTag() {
		// given
		let splitTag = Tags.questionWord
		let otherTag = Tags.none
		labels.addLabel(createLabelFor(otherTag))
		labels.addLabel(createLabelFor(splitTag))
		labels.addLabel(createLabelFor(otherTag))
		let expectedFirst = Labels()
		expectedFirst.addLabel(createLabelFor(otherTag))
		let expectedSecond = Labels()
		expectedSecond.addLabel(createLabelFor(splitTag))
		expectedSecond.addLabel(createLabelFor(otherTag))

		// when
		let split = labels.splitBefore(tag: splitTag)

		// then
		assert(split.count == 2)
		assert(split[0] == expectedFirst)
		assert(split[1] == expectedSecond)
	}

	func testGivenMultipleLabelsWithSpecifiedTag_splitBeforeTag_splitsBeforeEachLabelWithSpecifiedTag() {
		// given
		let splitTag = Tags.questionWord
		let otherTag = Tags.none
		labels.addLabel(createLabelFor(otherTag))
		labels.addLabel(createLabelFor(splitTag))
		labels.addLabel(createLabelFor(otherTag))
		labels.addLabel(createLabelFor(splitTag))
		labels.addLabel(createLabelFor(otherTag))
		let expectedFirst = Labels()
		expectedFirst.addLabel(createLabelFor(otherTag))
		let expectedSecond = Labels()
		expectedSecond.addLabel(createLabelFor(splitTag))
		expectedSecond.addLabel(createLabelFor(otherTag))
		let expectedThird = Labels()
		expectedThird.addLabel(createLabelFor(splitTag))
		expectedThird.addLabel(createLabelFor(otherTag))

		// when
		let split = labels.splitBefore(tag: splitTag)

		// then
		assert(split.count == 3)
		assert(split[0] == expectedFirst)
		assert(split[1] == expectedSecond)
		assert(split[2] == expectedThird)
	}

	func testGivenLabelWithSpecifiedTagAtBeggining_splitBeforeTag_doesNotIncludeEmptyLabelsObjectInReturnValue() {
		// given
		let splitTag = Tags.activityData
		labels.addLabel(createLabelFor(splitTag))

		// when
		let split = labels.splitBefore(tag: splitTag)

		// then
		assert(split.count == 1)
		XCTAssertFalse(split[0].isEmpty)
	}

	func testGivenOnlyOneLabelWithSpecifiedTag_splitAfterTag_splitsAfterThatTag() {
		// given
		let splitTag = Tags.questionWord
		let otherTag = Tags.none
		labels.addLabel(createLabelFor(otherTag))
		labels.addLabel(createLabelFor(splitTag))
		labels.addLabel(createLabelFor(otherTag))
		let expectedFirst = Labels()
		expectedFirst.addLabel(createLabelFor(otherTag))
		expectedFirst.addLabel(createLabelFor(splitTag))
		let expectedSecond = Labels()
		expectedSecond.addLabel(createLabelFor(otherTag))

		// when
		let split = labels.splitAfter(tag: splitTag)

		// then
		assert(split.count == 2)
		assert(split[0] == expectedFirst)
		assert(split[1] == expectedSecond)
	}

	func testGivenMultipleLabelsWithSpecifiedTag_splitAfterTag_splitsAfterEachLabelWithSpecifiedTag() {
		// given
		let splitTag = Tags.questionWord
		let otherTag = Tags.none
		labels.addLabel(createLabelFor(otherTag))
		labels.addLabel(createLabelFor(splitTag))
		labels.addLabel(createLabelFor(otherTag))
		labels.addLabel(createLabelFor(splitTag))
		labels.addLabel(createLabelFor(otherTag))
		let expectedFirst = Labels()
		expectedFirst.addLabel(createLabelFor(otherTag))
		expectedFirst.addLabel(createLabelFor(splitTag))
		let expectedSecond = Labels()
		expectedSecond.addLabel(createLabelFor(otherTag))
		expectedSecond.addLabel(createLabelFor(splitTag))
		let expectedThird = Labels()
		expectedThird.addLabel(createLabelFor(otherTag))

		// when
		let split = labels.splitAfter(tag: splitTag)

		// then
		assert(split.count == 3)
		assert(split[0] == expectedFirst)
		assert(split[1] == expectedSecond)
		assert(split[2] == expectedThird)
	}

	func testGivenLabelWithSpecifiedTagAtEnd_splitAfterTag_doesNotIncludeEmptyLabelsObjectInReturnValue() {
		// given
		let splitTag = Tags.activityData
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(splitTag))

		// when
		let split = labels.splitAfter(tag: splitTag)

		// then
		assert(split.count == 1)
		XCTAssertFalse(split[0].isEmpty)
	}

	func testGivenEmptySet_splitBeforeTags_returnsArrayWithJustOriginalLabelsObject() {
		// given
		labels.addLabel(createLabelFor(Tags.activityData))
		labels.addLabel(createLabelFor(Tags.attribute))

		// when
		let split = labels.splitBefore(tags: Set<NLTag>())

		// then
		assert(split.count == 1)
		assert(split[0] == labels)
	}

	func testGivenEmptyLabelsObject_splitBeforeTags_returnsEmptyArray() {
		// given
		let splitTags = Set<NLTag>([Tags.activityData])

		// when
		let split = labels.splitBefore(tags: splitTags)

		// then
		assert(split.isEmpty)
	}

	func testGivenLabelWithSpecifiedTagAtBeggining_splitBeforeTags_doesNotIncludeEmptyLabelsObjectInReturnValue() {
		// given
		let splitTag = Tags.activityData
		labels.addLabel(createLabelFor(splitTag))

		// when
		let split = labels.splitBefore(tags: Set<NLTag>([splitTag]))

		// then
		assert(split.count == 1)
		XCTAssertFalse(split.isEmpty)
	}

	func testGivenMultipleLabelsWithSingleSpecifiedTag_splitBeforeTags_splitsBeforeEachLabelWithSpecifiedTag() {
		// given
		let splitTag = Tags.activityData
		let splitTags = Set<NLTag>([splitTag])
		let otherTag = Tags.attribute
		labels.addLabel(createLabelFor(otherTag))
		labels.addLabel(createLabelFor(splitTag))
		labels.addLabel(createLabelFor(otherTag))
		labels.addLabel(createLabelFor(splitTag))
		let expected0 = Labels()
		expected0.addLabel(createLabelFor(otherTag))
		let expected1 = Labels()
		expected1.addLabel(createLabelFor(splitTag))
		expected1.addLabel(createLabelFor(otherTag))
		let expected2 = Labels()
		expected2.addLabel(createLabelFor(splitTag))

		// when
		let split = labels.splitBefore(tags: splitTags)

		// then
		assert(split.count == 3)
		assert(split[0] == expected0)
		assert(split[1] == expected1)
		assert(split[2] == expected2)
	}

	func testGivenMultipleTagsWithMultipleMatchingLabels_splitBeforeTags_splitsBeforeEachLabelWithMatchingTag() {
		// given
		let splitTag1 = Tags.activityData
		let splitTag2 = Tags.attribute
		let nonSplitTag = Tags.none
		labels.addLabel(createLabelFor(splitTag1))
		labels.addLabel(createLabelFor(nonSplitTag))
		labels.addLabel(createLabelFor(splitTag2))
		let expected0 = Labels()
		expected0.addLabel(createLabelFor(splitTag1))
		expected0.addLabel(createLabelFor(nonSplitTag))
		let expected1 = Labels()
		expected1.addLabel(createLabelFor(splitTag2))

		// when
		let split = labels.splitBefore(tags: Set<NLTag>([splitTag1, splitTag2]))

		// then
		assert(split.count == 2)
		assert(split[0] == expected0)
		assert(split[1] == expected1)
	}

	func testGivenNoLabelsHaveAnyOfTheSpecifiedTags_splitBeforeTags_returnsArrayWithJustTheOriginalLabelsObject() {
		// given
		labels.addLabel(createLabelFor(Tags.activityData))
		labels.addLabel(createLabelFor(Tags.attribute))

		// when
		let split = labels.splitBefore(tags: Set<NLTag>([Tags.none, Tags.frequency]))

		// then
		assert(split.count == 1)
		assert(split[0] == labels)
	}

	func testGivenEmptySet_splitAfterTags_returnsArrayWithJustOriginalLabelsObject() {
		// given
		labels.addLabel(createLabelFor(Tags.activityData))
		labels.addLabel(createLabelFor(Tags.attribute))

		// when
		let split = labels.splitAfter(tags: Set<NLTag>())

		// then
		assert(split.count == 1)
		assert(split[0] == labels)
	}

	func testGivenEmptyLabelsObject_splitAfterTags_returnsEmptyArray() {
		// given
		let splitTags = Set<NLTag>([Tags.activityData])

		// when
		let split = labels.splitAfter(tags: splitTags)

		// then
		assert(split.isEmpty)
	}

	func testGivenLabelWithSpecifiedTagAtEnd_splitAfterTags_doesNotIncludeEmptyLabelsObjectInReturnValue() {
		// given
		let splitTag = Tags.activityData
		let nonSplitTag = Tags.none
		labels.addLabel(createLabelFor(nonSplitTag))
		labels.addLabel(createLabelFor(splitTag))

		// when
		let split = labels.splitAfter(tags: Set<NLTag>([splitTag]))

		// then
		assert(split.count == 1)
		XCTAssertFalse(split.isEmpty)
	}

	func testGivenMultipleLabelsWithSingleSpecifiedTag_splitAfterTags_splitsAfterEachLabelWithSpecifiedTag() {
		// given
		let splitTag = Tags.activityData
		let splitTags = Set<NLTag>([splitTag])
		let otherTag = Tags.attribute
		labels.addLabel(createLabelFor(otherTag))
		labels.addLabel(createLabelFor(splitTag))
		labels.addLabel(createLabelFor(otherTag))
		labels.addLabel(createLabelFor(splitTag))
		let expected0 = Labels()
		expected0.addLabel(createLabelFor(otherTag))
		expected0.addLabel(createLabelFor(splitTag))
		let expected1 = Labels()
		expected1.addLabel(createLabelFor(otherTag))
		expected1.addLabel(createLabelFor(splitTag))

		// when
		let split = labels.splitAfter(tags: splitTags)

		// then
		assert(split.count == 2)
		assert(split[0] == expected0)
		assert(split[1] == expected1)
	}

	func testGivenMultipleTagsWithMultipleMatchingLabels_splitAfterTags_splitsAfterEachLabelWithMatchingTag() {
		// given
		let splitTag1 = Tags.activityData
		let splitTag2 = Tags.attribute
		let nonSplitTag = Tags.none
		labels.addLabel(createLabelFor(splitTag1))
		labels.addLabel(createLabelFor(nonSplitTag))
		labels.addLabel(createLabelFor(splitTag2))
		let expected0 = Labels()
		expected0.addLabel(createLabelFor(splitTag1))
		let expected1 = Labels()
		expected1.addLabel(createLabelFor(nonSplitTag))
		expected1.addLabel(createLabelFor(splitTag2))

		// when
		let split = labels.splitAfter(tags: Set<NLTag>([splitTag1, splitTag2]))

		// then
		assert(split.count == 2)
		assert(split[0] == expected0)
		assert(split[1] == expected1)
	}

	func testGivenNoLabelsHaveAnyOfTheSpecifiedTags_splitAfterTags_returnsArrayWithJustTheOriginalLabelsObject() {
		// given
		labels.addLabel(createLabelFor(Tags.activityData))
		labels.addLabel(createLabelFor(Tags.attribute))

		// when
		let split = labels.splitAfter(tags: Set<NLTag>([Tags.none, Tags.frequency]))

		// then
		assert(split.count == 1)
		assert(split[0] == labels)
	}

	func testGivenIndexLessThanZero_findNearestLabelWithTagTo_throwsIndexOutOfRange() throws {
		// when
		XCTAssertThrowsError(try labels.findNearestLabelWith(tag: Tags.activityData, to: -1)) { (error) -> Void in
			// then
			XCTAssertEqual(error as? Labels.ErrorTypes, Labels.ErrorTypes.IndexOutOfRange)
		}
	}

	func testGivenEmptyLabelsObject_findNearestLabelWithTagTo_throwsIndexOutOfRange() throws {
		// when
		XCTAssertThrowsError(try labels.findNearestLabelWith(tag: Tags.activityData, to: 0)) { (error) -> Void in
			// then
			XCTAssertEqual(error as? Labels.ErrorTypes, Labels.ErrorTypes.IndexOutOfRange)
		}
	}

	func testGivenNonZeroGreaterThanHighestIndex_findNearestLabelWithTagTo_throwsIndexOutOfRange() throws {
		// given
		labels.addLabel(createLabelFor(Tags.attribute))

		// when
		XCTAssertThrowsError(try labels.findNearestLabelWith(tag: Tags.activityData, to: 1)) { (error) -> Void in
			// then
			XCTAssertEqual(error as? Labels.ErrorTypes, Labels.ErrorTypes.IndexOutOfRange)
		}
	}

	func testGivenNonEmptyLabelsObjectThatDoesNotContainLabelWithSpecifiedTag_findNearestLabelWithTagTo_returnsNil() throws {
		// given
		let tag = Tags.activityData
		labels.addLabel(createLabelFor(tag))

		// when
		let result = try labels.findNearestLabelWith(tag: NLTag("DoesNotExist"), to: 0)

		// then
		assert(result == nil)
	}

	func testGivenLabelWithSpecifiedTagAtSpecifiedIndex_findNearestLabelWithTagTo_returnsArrayWithOnlyLabelAtGivenIndex() throws {
		// given
		let findTag = Tags.attribute
		let correctToken = "correctToken"
		let incorrectToken = "incorrectToken"
		labels.addLabel(createLabelFor(findTag, incorrectToken))
		labels.addLabel(createLabelFor(NLTag("not the find tag")))
		labels.addLabel(createLabelFor(findTag, correctToken))

		// when
		let result = try labels.findNearestLabelWith(tag: findTag, to: 2)

		// then
		assert(result?.count == 1)
		assert(result?[0].token == correctToken)
	}

	func testGivenOnlyOneLabelWithSpecifiedTag_findNearestLabelWithTagTo_returnsArrayWithOnlyThatLabel() throws {
		// given
		let findTag = Tags.activityData
		labels.addLabel(createLabelFor(findTag))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(Tags.comparison))

		// when
		let result = try labels.findNearestLabelWith(tag: findTag, to: labels.count - 1)

		// then
		assert(result?.count == 1)
		assert(result?[0] == createLabelFor(findTag))
	}

	func testGivenMultipleLabelsAtDifferentDistancesWithSpecifiedTag_findNearestLabelWithTagTo_returnsArrayWithOnlyClosestLabel() throws {
		// given
		let correctToken = "correctToken"
		let incorrectToken = "incorrectToken"
		let findTag = Tags.activityData
		let startIndex = 2
		labels.addLabel(createLabelFor(findTag, correctToken))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(Tags.attribute))
		labels.addLabel(createLabelFor(Tags.comparison))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(findTag, incorrectToken))

		// when
		let result = try labels.findNearestLabelWith(tag: findTag, to: startIndex)

		// then
		assert(result?.count == 1)
		assert(result?[0].token == correctToken)
	}

	func testGivenMultipleLabelsWithSpecifiedTagAtSameDistanceFromStartIndex_findNBearestLabelWithTagTo_returnsArrayWithBothMatchingLabels() throws {
		// given
		let findTag = Tags.activityData
		let token1 = "token1"
		let token2 = "token2"
		let startIndex = 1
		labels.addLabel(createLabelFor(findTag, token1))
		labels.addLabel(createLabelFor(Tags.comparison))
		labels.addLabel(createLabelFor(findTag, token2))

		// when
		let result = try labels.findNearestLabelWith(tag: findTag, to: startIndex)

		// then
		assert(result?.count == 2)
		assert(
			(result?[0].token == token1 && result?[1].token == token2) ||
			(result?[0].token == token2 && result?[1].token == token1))
	}

	func testGivenIndexLessThanZero_findNearestLabelWithTagBefore_throwsIndexOutOfRange() {
		// when
		XCTAssertThrowsError(try labels.findNearestLabelWith(tag: Tags.activityData, before: -1)) { (error) -> Void in
			// then
			XCTAssertEqual(error as? Labels.ErrorTypes, Labels.ErrorTypes.IndexOutOfRange)
		}
	}

	func testGivenEmptyLabelsObject_findNearestLabelWithTagBefore_throwsIndexOutOfRange() throws {
		// when
		XCTAssertThrowsError(try labels.findNearestLabelWith(tag: Tags.activityData, before: 0)) { (error) -> Void in
			// then
			XCTAssertEqual(error as? Labels.ErrorTypes, Labels.ErrorTypes.IndexOutOfRange)
		}
	}

	func testGivenNonZeroGreaterThanHighestIndex_findNearestLabelWithTagBefore_throwsIndexOutOfRange() throws {
		// given
		labels.addLabel(createLabelFor(Tags.attribute))

		// when
		XCTAssertThrowsError(try labels.findNearestLabelWith(tag: Tags.activityData, before: 1)) { (error) -> Void in
			// then
			XCTAssertEqual(error as? Labels.ErrorTypes, Labels.ErrorTypes.IndexOutOfRange)
		}
	}

	func testGivenNonEmptyLabelsObjectThatDoesNotContainLabelWithSpecifiedTag_findNearestLabelWithTagBefore_returnsNil() throws {
		// given
		let tag = Tags.activityData
		labels.addLabel(createLabelFor(tag))

		// when
		let result = try labels.findNearestLabelWith(tag: NLTag("DoesNotExist"), before: 0)

		// then
		assert(result == nil)
	}

	func testGivenLabelWithSpecifiedTagAtSpecifiedIndex_findNearestLabelWithTagBefore_returnsLabelAtGivenIndex() throws {
		// given
		let findTag = Tags.attribute
		let correctToken = "correctToken"
		let incorrectToken = "incorrectToken"
		labels.addLabel(createLabelFor(findTag, correctToken))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(findTag, incorrectToken))

		// when
		let result = try labels.findNearestLabelWith(tag: findTag, before: 1)

		// then
		assert(result?.token == correctToken)
	}

	func testGivenOnlyOneLabelWithSpecifiedTag_findNearestLabelWithTagBefore_returnsThatLabel() throws {
		// given
		let findTag = Tags.activityData
		labels.addLabel(createLabelFor(findTag))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(Tags.comparison))

		// when
		let result = try labels.findNearestLabelWith(tag: findTag, before: labels.count - 1)

		// then
		assert(result == createLabelFor(findTag))
	}

	func testGivenMultipleLabelsAtDifferentDistancesWithSpecifiedTag_findNearestLabelWithTagBefore_returnsClosestLabel() throws {
		// given
		let correctToken = "correctToken"
		let incorrectToken = "incorrectToken"
		let findTag = Tags.activityData
		labels.addLabel(createLabelFor(findTag, incorrectToken))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(findTag, correctToken))
		labels.addLabel(createLabelFor(Tags.attribute))
		labels.addLabel(createLabelFor(Tags.comparison))
		labels.addLabel(createLabelFor(Tags.none))
		let startIndex = labels.count - 1

		// when
		let result = try labels.findNearestLabelWith(tag: findTag, before: startIndex)

		// then
		assert(result?.token == correctToken)
	}

	func testGivenOnlyLabelWithSpecifiedTagIsAfterSpecifiedIndex_findNearestLabelWithTagBefore_returnsNil() throws {
		// given
		let findTag = Tags.activityData
		labels.addLabel(createLabelFor(NLTag("Not the find tag")))
		labels.addLabel(createLabelFor(NLTag("Also not the find tag")))
		labels.addLabel(createLabelFor(findTag))

		// when
		let result = try labels.findNearestLabelWith(tag: findTag, before: 1)

		// then
		assert(result == nil)
	}

	func testGivenClosestLabelWithSpecifiedTagIsAfterSpecifiedIndex_findNearestLabelWithTagBefore_returnsLabelBeforeSpecifiedIndex() throws {
		// given
		let findTag = Tags.activityData
		let correctToken = "correctToken"
		let incorrectToken = "incorrectToken"
		labels.addLabel(createLabelFor(findTag, correctToken))
		labels.addLabel(createLabelFor(NLTag("Not the find tag")))
		labels.addLabel(createLabelFor(NLTag("Also not the find tag")))
		labels.addLabel(createLabelFor(findTag, incorrectToken))

		// when
		let result = try labels.findNearestLabelWith(tag: findTag, before: 2)

		// then
		assert(result?.token == correctToken)
	}

	func testGivenIndexLessThanZero_findNearestLabelWithTagAfter_throwsIndexOutOfRange() throws {
		// when
		XCTAssertThrowsError(try labels.findNearestLabelWith(tag: Tags.activityData, after: -1)) { (error) -> Void in
			// then
			XCTAssertEqual(error as? Labels.ErrorTypes, Labels.ErrorTypes.IndexOutOfRange)
		}
	}

	func testGivenEmptyLabelsObject_findNearestLabelWithTagAfter_throwsIndexOutOfRange() throws {
		// when
		XCTAssertThrowsError(try labels.findNearestLabelWith(tag: Tags.activityData, after: 0)) { (error) -> Void in
			// then
			XCTAssertEqual(error as? Labels.ErrorTypes, Labels.ErrorTypes.IndexOutOfRange)
		}
	}

	func testGivenNonZeroGreaterThanHighestIndex_findNearestLabelWithTagAfter_throwsIndexOutOfRange() throws {
		// given
		labels.addLabel(createLabelFor(Tags.attribute))

		// when
		XCTAssertThrowsError(try labels.findNearestLabelWith(tag: Tags.activityData, after: 1)) { (error) -> Void in
			// then
			XCTAssertEqual(error as? Labels.ErrorTypes, Labels.ErrorTypes.IndexOutOfRange)
		}
	}

	func testGivenNonEmptyLabelsObjectThatDoesNotContainLabelWithSpecifiedTag_findNearestLabelWithTagAfter_returnsNil() throws {
		// given
		let tag = Tags.activityData
		labels.addLabel(createLabelFor(tag))

		// when
		let result = try labels.findNearestLabelWith(tag: NLTag("DoesNotExist"), after: 0)

		// then
		assert(result == nil)
	}

	func testGivenLabelWithSpecifiedTagAtSpecifiedIndex_findNearestLabelWithTagAfter_returnsLabelAtGivenIndex() throws {
		// given
		let findTag = Tags.attribute
		let correctToken = "correctToken"
		let incorrectToken = "incorrectToken"
		labels.addLabel(createLabelFor(findTag, incorrectToken))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(findTag, correctToken))

		// when
		let result = try labels.findNearestLabelWith(tag: findTag, after: 1)

		// then
		assert(result?.token == correctToken)
	}

	func testGivenOnlyOneLabelWithSpecifiedTag_findNearestLabelWithTagAfter_returnsThatLabel() throws {
		// given
		let findTag = Tags.activityData
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(Tags.comparison))
		labels.addLabel(createLabelFor(findTag))

		// when
		let result = try labels.findNearestLabelWith(tag: findTag, after: 0)

		// then
		assert(result == createLabelFor(findTag))
	}

	func testGivenMultipleLabelsAtDifferentDistancesWithSpecifiedTag_findNearestLabelWithTagAfter_returnsClosestLabel() throws {
		// given
		let correctToken = "correctToken"
		let incorrectToken = "incorrectToken"
		let findTag = Tags.activityData
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(Tags.attribute))
		labels.addLabel(createLabelFor(Tags.comparison))
		labels.addLabel(createLabelFor(findTag, correctToken))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(findTag, incorrectToken))
		let startIndex = 0

		// when
		let result = try labels.findNearestLabelWith(tag: findTag, after: startIndex)

		// then
		assert(result?.token == correctToken)
	}

	func testGivenOnlyLabelWithSpecifiedTagIsBeforeSpecifiedIndex_findNearestLabelWithTagAfter_returnsNil() throws {
		// given
		let findTag = Tags.activityData
		labels.addLabel(createLabelFor(findTag))
		labels.addLabel(createLabelFor(NLTag("Not the find tag")))
		labels.addLabel(createLabelFor(NLTag("Also not the find tag")))

		// when
		let result = try labels.findNearestLabelWith(tag: findTag, after: 1)

		// then
		assert(result == nil)
	}

	func testGivenClosestLabelWithSpecifiedTagIsBeforeSpecifiedIndex_findNearestLabelWithTagAfter_returnsLabelBeforeSpecifiedIndex() throws {
		// given
		let findTag = Tags.activityData
		let correctToken = "correctToken"
		let incorrectToken = "incorrectToken"
		labels.addLabel(createLabelFor(findTag, incorrectToken))
		labels.addLabel(createLabelFor(NLTag("Not the find tag")))
		labels.addLabel(createLabelFor(NLTag("Also not the find tag")))
		labels.addLabel(createLabelFor(findTag, correctToken))

		// when
		let result = try labels.findNearestLabelWith(tag: findTag, after: 1)

		// then
		assert(result?.token == correctToken)
	}

	func testGivenNoLabelsAdded_shortestDistance_returnsMaxInt() {
		// when
		let distance = labels.shortestDistance(between: Tags.none, and: Tags.activityData)

		// then
		assert(distance == Int.max)
	}

	func testGivenNoLabelWithTag1_shortestDistance_returnsMaxInt() {
		// given
		let tag1 = Tags.activityData
		let tag2 = Tags.attribute
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(tag2))

		// when
		let distance = labels.shortestDistance(between: tag1, and: tag2)

		// then
		assert(distance == Int.max)
	}

	func testGivenNoLabelWithTag2_shortestDistance_returnsMaxInt() {
		// given
		let tag1 = Tags.activityData
		let tag2 = Tags.attribute
		labels.addLabel(createLabelFor(tag1))
		labels.addLabel(createLabelFor(Tags.none))

		// when
		let distance = labels.shortestDistance(between: tag1, and: tag2)

		// then
		assert(distance == Int.max)
	}

	func testGivenNoLabelWithEitherTag_shortestDistance_returnsMaxInt() {
		// given
		let tag1 = Tags.activityData
		let tag2 = Tags.attribute
		labels.addLabel(createLabelFor(NLTag("different tag")))
		labels.addLabel(createLabelFor(NLTag("other different tag")))

		// when
		let distance = labels.shortestDistance(between: tag1, and: tag2)

		// then
		assert(distance == Int.max)
	}

	func testGivenOnlyOneLabelAdded_shortestDistance_returnsMaxInt() {
		// given
		let tag1 = Tags.activityData
		let tag2 = Tags.average
		labels.addLabel(createLabelFor(tag1))

		// when
		let distance = labels.shortestDistance(between: tag1, and: tag2)

		// then
		assert(distance == Int.max)
	}

	func testGivenSpecifiedTagsAreEqual_shortestDistance_returnsCorrectDistance() {
		// given
		let tag = Tags.activityData
		labels.addLabel(createLabelFor(tag))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(tag))

		// when
		let distance = labels.shortestDistance(between: tag, and: tag)

		// assert
		assert(distance == 2)
	}

	func testGivenLabelsWithSpecifiedTagsExistAndTagsAreNotEqual_shortestDistance_returnsCorrectDistance() {
		// given
		let tag1 = Tags.activityData
		let tag2 = Tags.attribute
		labels.addLabel(createLabelFor(tag1))
		labels.addLabel(createLabelFor(tag2))

		// when
		let distance = labels.shortestDistance(between: tag1, and: tag2)

		// then
		assert(distance == 1)
	}

	func testGivenMultipleLabelPairsWithSpecifiedTagsAndTagsAreNotEqual_shortestDistance_returnsShortestDistanceBetweenViableLabels() {
		// given
		let tag1 = Tags.activityData
		let tag2 = Tags.attribute
		labels.addLabel(createLabelFor(tag1))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(tag2))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(tag1))

		// when
		let distance = labels.shortestDistance(between: tag1, and: tag2)

		// then
		assert(distance == 2)
	}

	func testGivenMultipleLabelPairsWithSpecifiedTagsAndTagsAreEqual_shortestDistance_returnsShortestDistanceBetweenViableLabels() {
		// given
		let tag = Tags.activityData
		labels.addLabel(createLabelFor(tag))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(tag))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(tag))

		// when
		let distance = labels.shortestDistance(between: tag, and: tag)

		// then
		assert(distance == 2)
	}

	func testGivenSpecifiedTagsAreNotEqualAndTwoLabelsWithSameTagAreCloserThanCorrectDistance_shortestDistance_returnsCorrectDistance() {
		// given
		let tag1 = Tags.activityData
		let tag2 = Tags.attribute
		labels.addLabel(createLabelFor(tag1))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(tag1))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(tag2))

		// when
		let distance = labels.shortestDistance(between: tag1, and: tag2)

		// then
		assert(distance == 3)
	}

	fileprivate func createLabelFor(_ tag: NLTag) -> Labels.Label {
		return createLabelFor(tag, "token")
	}

	fileprivate func createLabelFor(_ tag: NLTag, _ token: String) -> Labels.Label {
		return Labels.Label(tag: tag, token: token, tokenRange: createTokenRange(token))
	}

	fileprivate func createTokenRange(_ token: String) -> Range<String.Index> {
		return Range(NSMakeRange(0, token.count), in: token)!
	}
}
