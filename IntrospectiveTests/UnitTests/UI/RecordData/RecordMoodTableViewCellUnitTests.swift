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

final class RecordMoodTableViewCellUnitTests: UnitTest {

	private typealias Me = RecordMoodTableViewCellUnitTests
	private static let frame = CGRect(x: 0, y: 0, width: 100, height: 30)
	private static let ratingSlider = UISlider(frame: frame)
	private static let addNoteButton = UIButton(type: .system)
	private static let doneButton = UIButton(type: .system)
	private static let ratingRangeLabel = UILabel(frame: frame)
	private static let ratingButton = UIButton()

	private var cell: RecordMoodTableViewCell!
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

		cell = RecordMoodTableViewCell()
		cell.ratingSlider = Me.ratingSlider
		cell.addNoteButton = Me.addNoteButton
		cell.doneButton = Me.doneButton
		cell.ratingRangeLabel = Me.ratingRangeLabel
		cell.ratingButton = Me.ratingButton
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
