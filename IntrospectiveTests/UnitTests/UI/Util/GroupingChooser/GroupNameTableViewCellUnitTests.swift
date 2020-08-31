//
//  GroupNameTableViewCellUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/27/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
@testable import Introspective
@testable import Common

class GroupNameTableViewCellUnitTests: UnitTest {

	private final var textField: UITextField!

	private final var cell: GroupNameTableViewCell!

	override func setUp() {
		super.setUp()

		textField = UITextField()

		cell = GroupNameTableViewCell()
		cell.textField = textField
	}

	// MARK: - groupNameDidSet()

	func testGivenGroupNameIsNotNil_groupNameDidSet_correctlySetsTextFieldText() {
		// given
		let groupName = "fds"

		// when
		cell.groupName = groupName

		// then
		assertThat(textField.text, equalTo(groupName))
	}

	func testGivenGroupNameIsNil_groupNameDidSet_doesNotThrowError() {
		// given
		let groupName: String? = nil

		// when
		cell.groupName = groupName

		// then - no error thrown
	}

	// MARK: - nameChanged()

	func test_nameChanged_postsGroupNameEditedNotificationWithTextFieldText() {
		// given
		let expectedText = "fejhslk"
		textField.text = expectedText

		// when
		cell.nameChanged(textField)

		// then
		let userInfoCaptor = ArgumentCaptor<[UserInfoKey: Any]?>()
		Verify(
			mockNotificationUtil,
			.post(.value(.groupNameEdited), object: .any, userInfo: .capturing(userInfoCaptor), qos: .any))
		guard let userInfo = userInfoCaptor.value else {
			XCTFail("No user info")
			return
		}
		assertThat(userInfo, userInfoHasKey(.text, withValue: expectedText))
	}
}
