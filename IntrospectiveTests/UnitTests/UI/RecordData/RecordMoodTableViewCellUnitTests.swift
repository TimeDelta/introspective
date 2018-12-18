//
//  RecordMoodTableViewCellUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import UIKit
@testable import Introspective

class RecordMoodTableViewCellUnitTests: UnitTest {

	fileprivate typealias Me = RecordMoodTableViewCellUnitTests
	private static let frame = CGRect(x: 0, y: 0, width: 100, height: 30)
	private static let ratingSlider = UISlider(frame: frame)
	private static let addNoteButton = UIButton(type: .system)
	private static let doneButton = UIButton(type: .system)
	private static let outOfMaxRatingLabel = UILabel(frame: frame)

	fileprivate var cell: RecordMoodTableViewCell!
	fileprivate var mockMood: MoodMock!

	override func setUp() {
		super.setUp()

		cell = RecordMoodTableViewCell()
		cell.ratingSlider = Me.ratingSlider
		cell.addNoteButton = Me.addNoteButton
		cell.doneButton = Me.doneButton
		cell.outOfMaxRatingLabel = Me.outOfMaxRatingLabel

		mockMood = MoodMock()
		Given(mockSampleFactory, .mood(willReturn: mockMood))

		Given(mockSettings, .maxMood(getter: 7.0))
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
