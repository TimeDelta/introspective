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
@testable import Samples

final class RecordMoodTableViewCellUnitTests: UnitTest {

	private var ratingSlider: UISlider!
	private var addNoteButton: UIButton!
	private var doneButton: UIButton!
	private var ratingRangeLabel: UILabel!
	private var ratingButton: UIButton!
	private var feedbackLabel: UILabel!

	private var cell: RecordMoodTableViewCell!
	private var mockMood: MoodMock!
	private var mockTransaction: TransactionMock!

	override func setUp() {
		super.setUp()

		Given(mockMoodUiUtil, .colorForMood(rating: .any, minRating: .any, maxRating: .any, willReturn: UIColor.white))
		Given(mockMoodUiUtil, .valueToString(.any, willReturn: ""))

		mockTransaction = TransactionMock()
		Given(mockDatabase, .transaction(willReturn: mockTransaction))

		mockMood = MoodMock()
		Given(mockSampleFactory, .mood(using: .any, willReturn: mockMood))

		Given(mockSettings, .minMood(getter: 0.0))
		Given(mockSettings, .maxMood(getter: 7.0))

		ratingSlider = UISlider()
		addNoteButton = UIButton()
		doneButton = UIButton()
		ratingRangeLabel = UILabel()
		ratingButton = UIButton()
		feedbackLabel = UILabel()

		cell = RecordMoodTableViewCell()
		cell.ratingSlider = ratingSlider
		cell.addNoteButton = addNoteButton
		cell.doneButton = doneButton
		cell.ratingRangeLabel = ratingRangeLabel
		cell.ratingButton = ratingButton
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
