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
	}

	func testGivenTwoLabelsObjectsWithDifferentCounts_equalsOperator_returnsFalse() {
		// given
		let otherLabels = Labels()
		labels.addLabel(createLabelFor(Tags.none))
		otherLabels.addLabel(createLabelFor(Tags.none))
		otherLabels.addLabel(createLabelFor(Tags.none))

		// when
		let equal = labels == otherLabels

		// then
		XCTAssert(!equal)
	}

	func testGivenTwoLabelsObjectsWithSameCountsButDifferentLabels_equalsOperator_returnsFalse() {
		// given
		let otherLabels = Labels()
		labels.addLabel(createLabelFor(Tags.none))
		otherLabels.addLabel(createLabelFor(NLTag("some other tag")))

		// when
		let equal = labels == otherLabels

		// then
		XCTAssert(!equal)
	}

	func testGivenTwoLabelsObjectsWithSameCountsAndEqualLabelsInSameOrder_equalsOperator_returnsTrue() {
		// given
		let tag = Tags.activityData
		let otherLabels = Labels()
		labels.addLabel(createLabelFor(tag))
		labels.addLabel(createLabelFor(Tags.none))
		otherLabels.addLabel(createLabelFor(tag))
		otherLabels.addLabel(createLabelFor(Tags.none))

		// when
		let equal = labels == otherLabels

		// then
		XCTAssert(equal)
	}

	func testGivenTwoLabelsObjectsWithSameCountsAndEqualLabelsInDifferentOrder_equalsOperator_returnsFalse() {
		// given
		let tag = Tags.activityData
		let otherLabels = Labels()
		labels.addLabel(createLabelFor(tag))
		labels.addLabel(createLabelFor(Tags.none))
		otherLabels.addLabel(createLabelFor(Tags.none))
		otherLabels.addLabel(createLabelFor(tag))

		// when
		let equal = labels == otherLabels

		// then
		XCTAssert(!equal)
	}

	func testGivenValidLabel_addLabel_storesLabelByIndex() {
		// given
		let label = createLabelFor(Tags.activityData)

		// when
		labels.addLabel(label)

		// then
		XCTAssert(labels.byIndex[0] == label)
	}

	func testGivenValidLabel_addLabel_storesLabelByTag() {
		// given
		let label = createLabelFor(Tags.activityData)

		// when
		labels.addLabel(label)

		// then
		XCTAssert(labels.byTag[label.tag] == [label])
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
		XCTAssert(labels.count == 1)
		XCTAssert(labels.byIndex[0].token == token1 + " " + token2)
	}

	func testGivenLabelWithNoneTagJustAdded_addLabel_doesNotCombineNewLabelWithMostRecentOne() {
		// given
		labels.addLabel(createLabelFor(Tags.none))

		// when
		labels.addLabel(createLabelFor(Tags.none))

		// then
		XCTAssert(labels.count == 2)
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
		XCTAssert(hasLabels)
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
		XCTAssert(hasLabelFor)
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

	func testGivenNoLabelsAdded_indexOfLabel_returnsNegativeOne() {
		// when
		let index = labels.indexOf(label: createLabelFor(Tags.activityData))

		// then
		XCTAssert(index == -1)
	}

	func testGivenLabelWithSameTagAndTokenButDifferentRange_indexOfLabel_returnsNegativeOne() {
		// given
		let token = "token"
		let range = createTokenRange(token + "some other stuff")
		let tag = Tags.activityData
		let targetLabel = createLabelFor(tag, token, range)
		labels.addLabel(createLabelFor(tag, token))

		// when
		let index = labels.indexOf(label: targetLabel)

		// then
		XCTAssert(index == -1)
	}

	func testGivenLabelWithSameTagAndRangeButDifferentToken_indexOfLabel_returnsNegativeOne() {
		// given
		let token = "token"
		let targetToken = token + "some other stuff"
		let tag = Tags.activityData
		let range = createTokenRange(targetToken)
		let targetLabel = createLabelFor(tag, targetToken, range)
		labels.addLabel(createLabelFor(tag, token, range))

		// when
		let index = labels.indexOf(label: targetLabel)

		// then
		XCTAssert(index == -1)
	}

	func testGivenLabelWithSameTokenAndRangeButDifferentTag_indexOfLabel_returnsNegativeOne() {
		// given
		let token = "token"
		let tag = Tags.activityData
		let targetTag = NLTag("definitely not the same tag")
		let targetLabel = createLabelFor(targetTag, token)
		labels.addLabel(createLabelFor(tag, token))

		// when
		let index = labels.indexOf(label: targetLabel)

		// then
		XCTAssert(index == -1)
	}

	func testGivenLabelWithSameTokenSameRangeAndSameTag_indexOfLabel_returnsCorrectIndex() {
		// given
		let label = createLabelFor(Tags.activityData)
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(label)
		labels.addLabel(createLabelFor(Tags.none))

		// when
		let index = labels.indexOf(label: label)

		// then
		XCTAssert(index == 2)
	}

	func testGivenNoLabelsPreviouslyAdded_labelsInAnyOrderFor_returnsEmptyArray() {
		// when
		let labelsFor = labels.labelsInAnyOrderFor(tags: [Tags.activityData])

		// then
		XCTAssert(labelsFor.isEmpty)
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
		XCTAssert(2 * tags.count == labelsFor.count)
		for label in labelsFor {
			XCTAssert(tags.contains(label.tag))
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
			XCTAssert(label.tag != otherTag)
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
		XCTAssert(labelsFor.isEmpty)
	}

	func testGivenNoLabelsPreviouslyAdded_labelsFor_returnsEmptyArray() {
		// when
		let labelsFor = labels.labelsFor(tags: [Tags.activityData])

		// then
		XCTAssert(labelsFor.isEmpty)
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
		XCTAssert(2 * tags.count == labelsFor.count)
		for label in labelsFor {
			XCTAssert(tags.contains(label.tag))
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
			XCTAssert(label.tag != otherTag)
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
		XCTAssert(labelsFor.isEmpty)
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
			XCTAssert(labelsFor[labelsFor.count - i - 1].tag == tags[i])
		}
	}

	func testGivenNoLabelsAdded_splitBeforeTag_returnsArrayWithJustOriginalLabelsObject() {
		// when
		let split = labels.splitBefore(tag: Tags.none)

		// then
		XCTAssert(split.count == 1)
		XCTAssert(split[0] == labels)
	}

	func testGivenNoLabelsWithSpecifiedTag_splitBeforeTag_returnsArrayWithJustOriginalLabelsObject() {
		// given
		let tag = Tags.activityData
		labels.addLabel(createLabelFor(NLTag("definitely not the specified tag")))

		// when
		let split = labels.splitBefore(tag: tag)

		// then
		XCTAssert(split.count == 1)
		XCTAssert(split[0] == labels)
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
		XCTAssert(split.count == 2)
		XCTAssert(split[0] == expectedFirst)
		XCTAssert(split[1] == expectedSecond)
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
		XCTAssert(split.count == 3)
		XCTAssert(split[0] == expectedFirst)
		XCTAssert(split[1] == expectedSecond)
		XCTAssert(split[2] == expectedThird)
	}

	func testGivenLabelWithSpecifiedTagAtBeggining_splitBeforeTag_doesNotIncludeEmptyLabelsObjectInReturnValue() {
		// given
		let splitTag = Tags.activityData
		labels.addLabel(createLabelFor(splitTag))

		// when
		let split = labels.splitBefore(tag: splitTag)

		// then
		XCTAssert(split.count == 1)
		XCTAssertFalse(split[0].isEmpty)
	}

	func testGivenNoLabelsAdded_splitAfterTag_returnsArrayWithJustOriginalLabelsObject() {
		// when
		let split = labels.splitAfter(tag: Tags.none)

		// then
		XCTAssert(split.count == 1)
		XCTAssert(split[0] == labels)
	}

	func testGivenNoLabelsWithSpecifiedTag_splitAfterTag_returnsArrayWithJustOriginalLabelsObject() {
		// given
		let tag = Tags.activityData
		labels.addLabel(createLabelFor(NLTag("definitely not the specified tag")))

		// when
		let split = labels.splitAfter(tag: tag)

		// then
		XCTAssert(split.count == 1)
		XCTAssert(split[0] == labels)
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
		XCTAssert(split.count == 2)
		XCTAssert(split[0] == expectedFirst)
		XCTAssert(split[1] == expectedSecond)
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
		XCTAssert(split.count == 3)
		XCTAssert(split[0] == expectedFirst)
		XCTAssert(split[1] == expectedSecond)
		XCTAssert(split[2] == expectedThird)
	}

	func testGivenLabelWithSpecifiedTagAtEnd_splitAfterTag_doesNotIncludeEmptyLabelsObjectInReturnValue() {
		// given
		let splitTag = Tags.activityData
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(splitTag))

		// when
		let split = labels.splitAfter(tag: splitTag)

		// then
		XCTAssert(split.count == 1)
		XCTAssertFalse(split[0].isEmpty)
	}

	func testGivenEmptySet_splitBeforeTags_returnsArrayWithJustOriginalLabelsObject() {
		// given
		labels.addLabel(createLabelFor(Tags.activityData))
		labels.addLabel(createLabelFor(Tags.attribute))

		// when
		let split = labels.splitBefore(tags: Set<NLTag>())

		// then
		XCTAssert(split.count == 1)
		XCTAssert(split[0] == labels)
	}

	func testGivenEmptyLabelsObject_splitBeforeTags_returnsEmptyArray() {
		// given
		let splitTags = Set<NLTag>([Tags.activityData])

		// when
		let split = labels.splitBefore(tags: splitTags)

		// then
		XCTAssert(split.isEmpty)
	}

	func testGivenLabelWithSpecifiedTagAtBeggining_splitBeforeTags_doesNotIncludeEmptyLabelsObjectInReturnValue() {
		// given
		let splitTag = Tags.activityData
		labels.addLabel(createLabelFor(splitTag))

		// when
		let split = labels.splitBefore(tags: Set<NLTag>([splitTag]))

		// then
		XCTAssert(split.count == 1)
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
		XCTAssert(split.count == 3)
		XCTAssert(split[0] == expected0)
		XCTAssert(split[1] == expected1)
		XCTAssert(split[2] == expected2)
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
		XCTAssert(split.count == 2)
		XCTAssert(split[0] == expected0)
		XCTAssert(split[1] == expected1)
	}

	func testGivenNoLabelsHaveAnyOfTheSpecifiedTags_splitBeforeTags_returnsArrayWithJustTheOriginalLabelsObject() {
		// given
		labels.addLabel(createLabelFor(Tags.activityData))
		labels.addLabel(createLabelFor(Tags.attribute))

		// when
		let split = labels.splitBefore(tags: Set<NLTag>([Tags.none, Tags.frequency]))

		// then
		XCTAssert(split.count == 1)
		XCTAssert(split[0] == labels)
	}

	func testGivenEmptySet_splitAfterTags_returnsArrayWithJustOriginalLabelsObject() {
		// given
		labels.addLabel(createLabelFor(Tags.activityData))
		labels.addLabel(createLabelFor(Tags.attribute))

		// when
		let split = labels.splitAfter(tags: Set<NLTag>())

		// then
		XCTAssert(split.count == 1)
		XCTAssert(split[0] == labels)
	}

	func testGivenEmptyLabelsObject_splitAfterTags_returnsEmptyArray() {
		// given
		let splitTags = Set<NLTag>([Tags.activityData])

		// when
		let split = labels.splitAfter(tags: splitTags)

		// then
		XCTAssert(split.isEmpty)
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
		XCTAssert(split.count == 1)
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
		XCTAssert(split.count == 2)
		XCTAssert(split[0] == expected0)
		XCTAssert(split[1] == expected1)
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
		XCTAssert(split.count == 2)
		XCTAssert(split[0] == expected0)
		XCTAssert(split[1] == expected1)
	}

	func testGivenNoLabelsHaveAnyOfTheSpecifiedTags_splitAfterTags_returnsArrayWithJustTheOriginalLabelsObject() {
		// given
		labels.addLabel(createLabelFor(Tags.activityData))
		labels.addLabel(createLabelFor(Tags.attribute))

		// when
		let split = labels.splitAfter(tags: Set<NLTag>([Tags.none, Tags.frequency]))

		// then
		XCTAssert(split.count == 1)
		XCTAssert(split[0] == labels)
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
		XCTAssert(result == nil)
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
		XCTAssert(result?.count == 1)
		XCTAssert(result?[0].token == correctToken)
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
		XCTAssert(result?.count == 1)
		XCTAssert(result?[0] == createLabelFor(findTag))
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
		XCTAssert(result?.count == 1)
		XCTAssert(result?[0].token == correctToken)
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
		XCTAssert(result?.count == 2)
		XCTAssert(
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
		XCTAssert(result == nil)
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
		XCTAssert(result?.token == correctToken)
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
		XCTAssert(result == createLabelFor(findTag))
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
		XCTAssert(result?.token == correctToken)
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
		XCTAssert(result == nil)
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
		XCTAssert(result?.token == correctToken)
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
		XCTAssert(result == nil)
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
		XCTAssert(result?.token == correctToken)
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
		XCTAssert(result == createLabelFor(findTag))
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
		XCTAssert(result?.token == correctToken)
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
		XCTAssert(result == nil)
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
		XCTAssert(result?.token == correctToken)
	}

	func testGivenNoLabelsAdded_ifNotTaggedTagLabelAtRangeAsTag_doesNothing() {
		// given
		let targetToken = "target token"
		let targetRange = createTokenRange(targetToken)
		let newTag = NLTag("new tag")

		// when
		labels.ifNotTaggedTagLabelAt(range: targetRange, asTag: newTag)

		// then
		XCTAssert(labels.count == 0)
	}

	func testGivenNoLabelWithTargetRange_ifNotTaggedTagLabelAtRangeAsTag_doesNotReTagLabel() {
		// given
		let targetToken = "target token"
		let targetRange = createTokenRange(targetToken)
		let newTag = NLTag("new tag")
		labels.addLabel(createLabelFor(Tags.none, "not the target token")) // specifying a different token will create a different range for the Label

		// when
		labels.ifNotTaggedTagLabelAt(range: targetRange, asTag: newTag)

		// then
		XCTAssert(labels.byIndex[0].tag != newTag)
	}

	func testGivenLabelWithTargetRangeAlreadyTagged_ifNotTaggedTagLabelAtRangeAsTag_doesNotReTagLabel() {
		// given
		let targetToken = "target token"
		let targetRange = createTokenRange(targetToken)
		let newTag = NLTag("new tag")
		labels.addLabel(createLabelFor(Tags.activityData, targetToken)) // specifying same token will create same range for the Label

		// when
		labels.ifNotTaggedTagLabelAt(range: targetRange, asTag: newTag)

		// then
		XCTAssert(labels.byIndex[0].tag != newTag)
	}

	func testGivenUntaggedLabelWithTargetRange_ifNotTaggedTagLabelAtRangeAsTag_reTagsLabelWithNewTag() {
		// given
		let targetToken = "target token"
		let targetRange = createTokenRange(targetToken)
		let newTag = NLTag("new tag")
		labels.addLabel(createLabelFor(Tags.none, targetToken)) // specifying same token will create same range for the Label

		// when
		labels.ifNotTaggedTagLabelAt(range: targetRange, asTag: newTag)

		// then
		XCTAssert(labels.byIndex[0].tag == newTag)
	}

	func testGivenNoLabelsAdded_shortestDistance_returnsMaxInt() {
		// when
		let distance = labels.shortestDistance(between: Tags.none, and: Tags.activityData)

		// then
		XCTAssert(distance == Int.max)
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
		XCTAssert(distance == Int.max)
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
		XCTAssert(distance == Int.max)
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
		XCTAssert(distance == Int.max)
	}

	func testGivenOnlyOneLabelAdded_shortestDistance_returnsMaxInt() {
		// given
		let tag1 = Tags.activityData
		let tag2 = Tags.average
		labels.addLabel(createLabelFor(tag1))

		// when
		let distance = labels.shortestDistance(between: tag1, and: tag2)

		// then
		XCTAssert(distance == Int.max)
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
		XCTAssert(distance == 2)
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
		XCTAssert(distance == 1)
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
		XCTAssert(distance == 2)
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
		XCTAssert(distance == 2)
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
		XCTAssert(distance == 3)
	}

	func testGivenNoLabelsAdded_shortestDistanceFromLabelToLabelWithTag_returnsNil() {
		// given
		let tag = Tags.activityData
		let label = createLabelFor(Tags.activityData)

		// when
		let distance = labels.shortestDistance(from: label, toLabelWith: tag)

		// then
		XCTAssert(distance == nil)
	}

	func testGivenSpecifiedLabelNotAdded_shortestDistanceFromLabelToLabelWithTag_returnsNil() {
		// given
		let tag = Tags.activityData
		let label = createLabelFor(tag)
		labels.addLabel(createLabelFor(Tags.none))

		// when
		let distance = labels.shortestDistance(from: label, toLabelWith: tag)

		// then
		XCTAssert(distance == nil)
	}

	func testGivenNoLabelsWithSpecifiedTag_shortestDistanceFromLabelToLabelWithTag_returnsNegativeOne() {
		// given
		let tag = Tags.activityData
		let label = createLabelFor(Tags.none)
		labels.addLabel(label)

		// when
		let distance = labels.shortestDistance(from: label, toLabelWith: tag)

		// then
		XCTAssert(distance == -1)
	}

	func testGivenMultipleLabelsWithSpecifiedTag_shortestDistanceFromLabelToLabelWithTag_returnsDistanceToClosestMatchingLabel() {
		// given
		let tag = Tags.activityData
		let label = createLabelFor(Tags.which)
		labels.addLabel(createLabelFor(tag))
		labels.addLabel(createLabelFor(tag))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(label)
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(tag))

		// when
		let distance = labels.shortestDistance(from: label, toLabelWith: tag)

		// then
		XCTAssert(distance == 2)
	}

	func testGivenShortestDistanceIsBeforeSpecifiedLabel_shortestDistanceFromLabelToLabelWithTag_returnsCorrectDistance() {
		// given
		let tag = Tags.activityData
		let label = createLabelFor(Tags.which)
		labels.addLabel(createLabelFor(tag))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(label)
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(tag))

		// when
		let distance = labels.shortestDistance(from: label, toLabelWith: tag)

		// then
		XCTAssert(distance == 2)
	}

	func testGivenShortestDistanceIsAfterSpecifiedLabel_shortestDistanceFromLabelToLabelWithTag_returnsCorrectDistance() {
		// given
		let tag = Tags.activityData
		let label = createLabelFor(Tags.which)
		labels.addLabel(createLabelFor(tag))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(label)
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(tag))

		// when
		let distance = labels.shortestDistance(from: label, toLabelWith: tag)

		// then
		XCTAssert(distance == 2)
	}

	func testGivenOnlyLabelWithSpecifiedTagIsSpecifiedLabel_shortestDistanceFromLabelToLabelWithTag_returnsNegativeOne() {
		// given
		let tag = Tags.activityData
		let label = createLabelFor(tag)
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(label)
		labels.addLabel(createLabelFor(Tags.none))
		labels.addLabel(createLabelFor(Tags.none))

		// when
		let distance = labels.shortestDistance(from: label, toLabelWith: tag)

		// then
		XCTAssert(distance == -1)
	}

	fileprivate func createLabelFor(_ tag: NLTag) -> Labels.Label {
		return createLabelFor(tag, "token")
	}

	fileprivate func createLabelFor(_ tag: NLTag, _ token: String) -> Labels.Label {
		return Labels.Label(tag: tag, token: token, tokenRange: createTokenRange(token))
	}

	fileprivate func createLabelFor(_ tag: NLTag, _ token: String, _ range: Range<String.Index>) -> Labels.Label {
		return Labels.Label(tag: tag, token: token, tokenRange: range)
	}

	fileprivate func createTokenRange(_ token: String) -> Range<String.Index> {
		return Range(NSMakeRange(0, token.count), in: token)!
	}
}
