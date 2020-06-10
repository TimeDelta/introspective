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
@testable import Samples

class RecordDiscreteMoodTableViewCellUnitTests: UnitTest {

	private var scrollView: UIScrollView!
	private var moodContentView: UIView!
	private var addNoteButton: UIButton!
	private var doneButton: UIButton!
	private var feedbackLabel: UILabel!

	private var cell: RecordDiscreteMoodTableViewCell!
	private var mockMood: MoodMock!
	private var mockTransaction: TransactionMock!

	override func setUp() {
		super.setUp()

		Given(mockMoodUiUtil, .colorForMood(rating: .any, minRating: .any, maxRating: .any, willReturn: UIColor.white))

		mockTransaction = TransactionMock()
		Given(mockDatabase, .transaction(willReturn: mockTransaction))

		mockMood = MoodMock()
		Given(mockSampleFactory, .mood(using: .any, willReturn: mockMood))

		Given(mockSettings, .minMood(getter: 0.0))
		Given(mockSettings, .maxMood(getter: 7.0))

		scrollView = UIScrollView()
		moodContentView = UIView()
		addNoteButton = UIButton()
		doneButton = UIButton()
		feedbackLabel = UILabel()

		cell = RecordDiscreteMoodTableViewCell()
		cell.scrollView = scrollView
		cell.moodContentView = moodContentView
		cell.addNoteButton = addNoteButton
		cell.doneButton = doneButton
		cell.feedbackLabel = feedbackLabel
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
