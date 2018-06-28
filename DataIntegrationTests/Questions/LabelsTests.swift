//
//  LabelsTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

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

// TODO - fix compiler issue with this test
//    func testGivenValidLabel_addLabel_storesLabelByIndex() {
//		// given
//		let token = "token"
//		let label = Labels.Label(tag: Tags.activityData, token: token, tokenRange: createTokenRange(token))
//
//		// when
//		labels.addLabel(label)
//
//		// then
//		XCTAssertTrue(labels.byIndex[0] == label)
//    }

// TODO - fix compiler issue with this test
//    func testGValidLabel_addLabel_storesLabelByTag() {
//		// given
//		let token = "token"
//		let label = Labels.Label(tag: Tags.activityData, token: token, tokenRange: createTokenRange(token))
//
//		// when
//		labels.addLabel(label)
//
//		// then
//		XCTAssertTrue(labels.byTag[label.tag] == [label])
//    }

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
		XCTAssertTrue(hasLabels)
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
		XCTAssertTrue(hasLabelFor)
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
		XCTAssertEqual(2 * tags.count, labelsFor.count)
		for label in labelsFor {
			XCTAssertTrue(tags.contains(label.tag))
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
		XCTAssertEqual(2 * tags.count, labelsFor.count)
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
		XCTAssertTrue(labelsFor.isEmpty)
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
		XCTAssertFalse(split.isEmpty)
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

	func testGivenLabelWithSpecifiedTagAtBeggining_splitAfterTag_doesNotIncludeEmptyLabelsObjectInReturnValue() {
		// given
		let splitTag = Tags.activityData
		labels.addLabel(createLabelFor(splitTag))

        // when
		let split = labels.splitAfter(tag: splitTag)

        // then
		XCTAssert(split.count == 1)
		XCTAssertFalse(split.isEmpty)
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
