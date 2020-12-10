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

	private var cell: RecordContinuousMoodTableViewCell!
	private var mockMood: MoodMock!

	override func setUp() {
		super.setUp()

		Given(mockMoodUiUtil, .colorForMood(rating: .any, minRating: .any, maxRating: .any, willReturn: UIColor.white))
		Given(mockMoodUiUtil, .valueToString(.any, willReturn: ""))
		Given(mockMoodUiUtil, .feedbackMessage(for: .any, min: .any, max: .any, willReturn: "not nil"))

		mockMood = MoodMock()
		Given(mockMoodDAO, .createMood(timestamp: .any, rating: .any, min: .any, max: .any, note: .any, willReturn: mockMood))
		Given(mockSampleFactory, .mood(using: .any, willReturn: mockMood))
		Given(mockMood, .minRating(getter: 0))
		Given(mockMood, .maxRating(getter: 7))

		Given(mockSettings, .minMood(getter: 0.0))
		Given(mockSettings, .maxMood(getter: 7.0))

		ratingSlider = UISlider()
		addNoteButton = UIButton()
		doneButton = UIButton()
		ratingRangeLabel = UILabel()
		ratingButton = UIButton()
		feedbackLabel = UILabel()

		cell = RecordContinuousMoodTableViewCell()
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
		Verify(mockMoodDAO, .createMood(timestamp: .any, rating: .any, min: .any, max: .any, note: .value(expectedNote)))
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
