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
		cell.outOfMaxRatingLabel = UILabel(frame: frame)

		mockMood = MoodMock()
		Given(mockDataTypeFactory, .mood(willReturn: mockMood))
	}

	func testNoteGetsClearedAfterSaving() {
		// given
		cell.note = "this note is not nil"

		// when
		cell.doneButtonPressed(self)

		// then
		XCTAssert(cell.note == nil)
	}
}
