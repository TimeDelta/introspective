//
//  ActivityDefinitionFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/22/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
@testable import Introspective
@testable import Common
@testable import Samples

final class ActivityDefinitionFunctionalTests: FunctionalTest {

	private typealias Me = ActivityDefinitionFunctionalTests
	private static let name = "activity name"
	private static let description = "activity description"

	private final var tags: [Tag]!
	private final var definition: ActivityDefinition!

	final override func setUp() {
		super.setUp()
		tags = [TagDataTestUtil.createTag(name: "tag")]
		definition = ActivityDataTestUtil.createActivityDefinition(name: Me.name, description: Me.description, tags: tags)
	}

	func testActivityEditorConfiguresNameNotificationsBeforeLoadingTheNameCell() {
		let storyboard = UIStoryboard(name: "RecordData", bundle: nil)
		let editor = storyboard.instantiateViewController(withIdentifier: "editActivityDefinition") as! EditActivityDefinitionTableViewController
		editor.loadViewIfNeeded()
		let cell = editor.tableView(editor.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! ActivityDefinitionNameTableViewCell
		cell.nameTextField.text = "Complete initialized name"; cell.nameChanged(cell)
		XCTAssertTrue(editor.navigationItem.rightBarButtonItem?.isEnabled == true)
	}

	func testNameEditingPublishesTheFinalValueBeforeSaveCanRun() {
		let cell = ActivityDefinitionNameTableViewCell(style: .default, reuseIdentifier: nil)
		cell.nameLabel = UILabel(); cell.nameTextField = UITextField()
		let changed = Notification.Name("NameEdited-" + UUID().uuidString)
		let invalid = Notification.Name("NameInvalid-" + UUID().uuidString)
		cell.notificationToSendOnNameChange = changed; cell.notificationToSendOnInvalidName = invalid
		var received: String?; var invalidCount = 0
		let changedToken = NotificationCenter.default.addObserver(forName: changed, object: cell, queue: nil) {
			received = $0.userInfo?[UserInfoKey.text] as? String
		}
		let invalidToken = NotificationCenter.default.addObserver(forName: invalid, object: cell, queue: nil) { _ in invalidCount += 1 }
		defer { NotificationCenter.default.removeObserver(changedToken); NotificationCenter.default.removeObserver(invalidToken) }
		cell.nameTextField.text = "First complete name"; cell.nameChanged(cell)
		XCTAssertEqual(received, "First complete name")
		cell.nameTextField.text = ""; cell.nameChanged(cell)
		XCTAssertEqual(invalidCount, 1)
		cell.nameTextField.text = "Final complete name"; cell.nameChanged(cell)
		XCTAssertEqual(received, "Final complete name")
	}

	// MARK: - setSource()

	func testGivenNewSourceValue_setSource_correctlySetsSource() {
		// given
		let newSource = definition.source + 1

		// when
		definition.setSource(Sources.ActivitySourceNum.init(rawValue: newSource)!)

		// then
		XCTAssertEqual(definition.source, newSource)
	}

	// MARK: - setTags()

	func testGivenDefinitionAlreadyHasTags_setTags_replacesExistingTagsWithSpecifiedOnes() throws {
		// given
		let expectedTag1 = TagDataTestUtil.createTag(name: "expected 1")
		let expectedTag2 = TagDataTestUtil.createTag(name: "expected 2")

		// when
		try definition.setTags([expectedTag1, expectedTag2])

		// then
		let actualIDs = Set(definition.tagsArray().map { $0.objectID })
		XCTAssertEqual(actualIDs, Set([expectedTag1.objectID, expectedTag2.objectID]))
		for tag in tags {
			XCTAssertFalse(actualIDs.contains(tag.objectID))
		}
	}

	// MARK: - ==

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() {
		// when
		let areEqual = definition == definition

		// then
		XCTAssert(areEqual)
	}

	// https://stackoverflow.com/questions/42283715/overload-for-custom-class-is-not-always-called
	// https://stackoverflow.com/questions/6883848/why-am-i-not-able-to-override-isequal-in-my-nsmanagedobject-subclass
	func testGivenTwoActivitiesWithSameValuesButDifferentMemoryAddresses_equalToOperator_returnsFalse() {
		// given
		let otherDefinition = ActivityDataTestUtil.createActivityDefinition(
			name: definition.name,
			description: definition.activityDescription,
			tags: definition.tagsArray())

		// when
		let areEqual = definition == otherDefinition

		// then
		XCTAssertFalse(areEqual)
	}

	// MARK: - equalTo()

	func testGivenSameObjectTwice_equalTo_returnsTrue() {
		// when
		let areEqual = definition.equalTo(definition)

		// then
		XCTAssert(areEqual)
	}

	func testGivenNameMismatch_equalTo_returnsFalse() {
		// given
		let otherName = definition.name + "other stuff"
		let other = ActivityDataTestUtil.createActivityDefinition(
			name: otherName,
			description: definition.activityDescription,
			tags: definition.tagsArray())

		// when
		let areEqual = definition.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenDescriptionMismatch_equalTo_returnsFalse() {
		// given
		let otherDescription = (definition.activityDescription ?? "") + "other stuff"
		let other = ActivityDataTestUtil.createActivityDefinition(
			name: definition.name,
			description: otherDescription,
			tags: definition.tagsArray())

		// when
		let areEqual = definition.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTagsMismatch_equalTo_returnsFalse() {
		// given
		let otherTag = TagDataTestUtil.createTag(name: "other tag")
		let other = ActivityDataTestUtil.createActivityDefinition(
			name: definition.name,
			description: definition.activityDescription,
			tags: [otherTag])

		// when
		let areEqual = definition.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTwoActivitiesWithSameValues_equalTo_returnsTrue() {
		// given
		let otherDefinition = ActivityDataTestUtil.createActivityDefinition(
			name: definition.name,
			description: definition.activityDescription,
			tags: definition.tagsArray())

		// when
		let areEqual = definition.equalTo(otherDefinition)

		// then
		XCTAssert(areEqual)
	}
}
