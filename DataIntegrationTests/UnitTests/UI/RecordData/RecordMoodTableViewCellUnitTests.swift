//
//  RecordMoodTableViewCellUnitTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import UIKit
@testable import DataIntegration

class RecordMoodTableViewCellUnitTests: UnitTest {

	fileprivate var cell: RecordMoodTableViewCell!
	fileprivate var mockMood: MoodMock!

	override func setUp() {
		super.setUp()

		let frame = CGRect(x: 0, y: 0, width: 100, height: 30)

		cell = RecordMoodTableViewCell()
		cell.ratingSlider = UISlider(frame: frame)
		cell.addNoteButton = UIButton(type: .system)
		cell.doneButon = UIButton(type: .system)
		cell.outOfMaxRatingLabel = UILabel(frame: frame)

		mockMood = MoodMock()
		Given(mockDataTypeFactory, .mood(willReturn: mockMood))
	}

	func testNoteGetsClearedOnSave() {
		// given
		cell.note = "this note is not nil"

		// when
		cell.doneButtonPressed(self)

		// then
		XCTAssert(cell.note == nil)
	}

	func testNoteGetsSetOnMoodOnSave() {
		// given
		let expectedNote = "this is a note"
		cell.note = expectedNote

		// when
		cell.doneButtonPressed(self)

		// then
		XCTAssert(mockMood.note == expectedNote)
	}

	func testDatabaseSaveIsCalledOnSave() {
		// when
		cell.doneButtonPressed(self)

		// then
		Verify(mockDatabase, .save())
	}

	func testAddNoteButtonTitleSetToAddNoteOnSave() {
		// given
		let expectedTitle = "Add Note"
		cell.addNoteButton.setTitle(expectedTitle + "some other stuff", for: .normal)

		// when
		cell.doneButtonPressed(self)

		// then
		XCTAssert(cell.addNoteButton.title(for: .normal) == expectedTitle)
	}
}
