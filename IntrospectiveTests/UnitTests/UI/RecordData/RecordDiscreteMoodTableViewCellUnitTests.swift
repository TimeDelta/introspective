//
//  RecordDiscreteMoodTableViewCellUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/20/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
@testable import Introspective

class RecordDiscreteMoodTableViewCellUnitTests: UnitTest {

	private typealias Me = RecordDiscreteMoodTableViewCellUnitTests
	private static let frame = CGRect(x: 0, y: 0, width: 100, height: 30)
	private static let scrollView = UIScrollView(frame: frame)
	private static let moodContentView = UIView(frame: frame)
	private static let addNoteButton = UIButton(type: .system)
	private static let doneButton = UIButton(type: .system)

	private var cell: RecordDiscreteMoodTableViewCell!
	private var mockMood: MoodMock!
	private var mockTransaction: TransactionMock!

	override func setUp() {
		super.setUp()

		mockTransaction = TransactionMock()
		Given(mockDatabase, .transaction(willReturn: mockTransaction))

		mockMood = MoodMock()
		Given(mockSampleFactory, .mood(using: .any, willReturn: mockMood))

		Given(mockSettings, .minMood(getter: 0.0))
		Given(mockSettings, .maxMood(getter: 7.0))

		cell = RecordDiscreteMoodTableViewCell()
		cell.scrollView = Me.scrollView
		cell.moodContentView = Me.moodContentView
		cell.addNoteButton = Me.addNoteButton
		cell.doneButton = Me.doneButton
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

	func testTransactionIsCommitedOnSave() {
		// when
		cell.doneButtonPressed(self)

		// then
		Verify(mockTransaction, .commit())
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
