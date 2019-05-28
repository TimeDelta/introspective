//
//  GroupDefinitionTableViewCellUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/27/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
@testable import Introspective

class GroupDefinitionTableViewCellUnitTests: UnitTest {

	private final var nameLabel: UILabel!
	private final var descriptionLabel: UILabel!

	private final var cell: GroupDefinitionTableViewCell!

	override func setUp() {
		super.setUp()

		nameLabel = UILabel()
		descriptionLabel = UILabel()

		cell = GroupDefinitionTableViewCell()
		cell.nameLabel = nameLabel
		cell.descriptionLabel = descriptionLabel
	}

	// MARK: - groupDefinitionDidSet()

	func test_groupDefinitionDidSet_correctlySetsNameLabelText() {
		// given
		let expectedName = "fdsjio"
		let groupDefinition = mockGroupDefinition(withName: expectedName)

		// when
		cell.groupDefinition = groupDefinition

		// then
		assertThat(nameLabel.text, equalTo(expectedName))
	}

	func test_groupDefinitionDidSet_correctlySetsDescriptionLabelText() {
		// given
		let expectedDescription = "fdsjio"
		let groupDefinition = mockGroupDefinition(withDescription: expectedDescription)

		// when
		cell.groupDefinition = groupDefinition

		// then
		assertThat(descriptionLabel.text, equalTo(expectedDescription))
	}

	func testGivenNilGroupDefinition_groupDefinitionDidSet_doesNotThrowError() {
		// given
		let groupDefinition: GroupDefinition? = nil

		// when
		cell.groupDefinition = groupDefinition

		// then - no error is thrown
	}

	// MARK: - Helper Functions

	private final func mockGroupDefinition(
		withName name: String = "",
		withDescription description: String = "")
	-> GroupDefinitionMock {
		let groupDefinition = GroupDefinitionMock()
		Given(groupDefinition, .name(getter: name))
		Given(groupDefinition, .description(getter: description))
		return groupDefinition
	}
}
