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
@testable import Common
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

	func testSavingChangedRatingResetsVisibleControlsWithOneRender() {
		Given(mockSettings, .minMood(getter: 2))
		Given(mockSettings, .maxMood(getter: 10))
		Given(mockMoodUiUtil, .valueToString(.value(2), willReturn: "2"))
		Given(mockMoodUiUtil, .valueToString(.value(6), willReturn: "6"))
		Given(mockMoodUiUtil, .valueToString(.value(10), willReturn: "10"))
		cell.awakeFromNib()
		defer { NotificationCenter.default.removeObserver(cell!) }
		ratingSlider.value = 0.25
		cell.ratingChanged(self)
		cell.note = "Keep this note on the saved mood"
		mockMoodUiUtil.resetMock(.invocation)

		cell.doneButtonPressed(self)

		Verify(mockMoodDAO, .exactly(1), .createMood(timestamp: .any, rating: .value(4),
			min: .any, max: .any, note: .value("Keep this note on the saved mood")))
		XCTAssertEqual(ratingSlider.value, 0.5, accuracy: 0.000001)
		XCTAssertEqual(ratingButton.title(for: .normal), "6")
		XCTAssertEqual(ratingButton.accessibilityValue, "6")
		XCTAssertEqual(ratingRangeLabel.text, "(2-10)")
		XCTAssertEqual(addNoteButton.title(for: .normal), "Add Note")
		XCTAssertNil(cell.note)
		Verify(mockMoodUiUtil, .exactly(3), .valueToString(.any))
		Verify(mockMoodUiUtil, .exactly(1), .colorForMood(rating: .value(6), minRating: .value(2), maxRating: .value(10)))
	}
}

final class ContinuousRatingCellRenderingTests: UnitTest {
	private var uiUtil: ContinuousRatingUiUtilSpy!

	override func setUp() {
		super.setUp()
		uiUtil = ContinuousRatingUiUtilSpy()
		Matcher.default.register(FatigueUiUtil.Protocol.self) { _, _ in true }
		Matcher.default.register(PainUiUtil.Protocol.self) { _, _ in true }
		Given(injectionProvider, .get(.value(MoodUiUtil.self), willReturn: uiUtil))
		Given(injectionProvider, .get(.value(FatigueUiUtil.self), willReturn: uiUtil))
		Given(injectionProvider, .get(.value(PainUiUtil.self), willReturn: uiUtil))
		for kind in RatingKind.allCases { setRange(for: kind, min: 2, max: 10) }
	}

	func testMoodAwakeRendersMidpointAndScaleOnce() { assertAwake(.mood) }
	func testFatigueAwakeRendersMidpointAndScaleOnce() { assertAwake(.fatigue) }
	func testPainAwakeRendersMidpointAndScaleOnce() { assertAwake(.pain) }

	func testMoodSliderUpdatesVisibleAndAccessibleRating() { assertSliderChanges(.mood) }
	func testFatigueSliderUpdatesVisibleAndAccessibleRating() { assertSliderChanges(.fatigue) }
	func testPainSliderUpdatesVisibleAndAccessibleRating() { assertSliderChanges(.pain) }

	func testMoodSettingsNotificationsRefreshScaleWithoutChangingRating() { assertSettingsChanges(.mood) }
	func testFatigueSettingsNotificationsRefreshScaleWithoutChangingRating() { assertSettingsChanges(.fatigue) }
	func testPainSettingsNotificationsRefreshScaleWithoutChangingRating() { assertSettingsChanges(.pain) }

	private func assertAwake(_ kind: RatingKind, file: StaticString = #file, line: UInt = #line) {
		let controls = makeCell(kind)
		defer { controls.observationCenter.removeObserver(controls.cell) }
		clearInvocations()

		controls.cell.awakeFromNib()

		assertRendered(controls, kind: kind, rating: 6, min: 2, max: 10, file: file, line: line)
		XCTAssertEqual(controls.noteButton.title(for: .normal), "Add Note", file: file, line: line)
		if let location = controls.location { XCTAssertTrue(location.text?.isEmpty ?? true, file: file, line: line) }
	}

	private func assertSliderChanges(_ kind: RatingKind, file: StaticString = #file, line: UInt = #line) {
		let controls = makeCell(kind)
		defer { controls.observationCenter.removeObserver(controls.cell) }
		controls.cell.awakeFromNib()
		for (fraction, rating) in [(Float(0.25), 4.0), (Float(0.75), 8.0)] {
			clearInvocations()
			controls.slider.value = fraction

			controls.changeRating()

			assertRendered(controls, kind: kind, rating: rating, min: 2, max: 10, file: file, line: line)
		}
	}

	private func assertSettingsChanges(_ kind: RatingKind, file: StaticString = #file, line: UInt = #line) {
		let controls = makeCell(kind)
		defer { controls.observationCenter.removeObserver(controls.cell) }
		controls.cell.awakeFromNib()
		for (notification, maximum) in [(kind.minChanged, 18.0), (kind.maxChanged, 14.0)] {
			setRange(for: kind, min: -2, max: maximum)
			clearInvocations()

			controls.observationCenter.post(name: notification, object: nil)

			assertRendered(controls, kind: kind, rating: 6, min: -2, max: maximum, file: file, line: line)
		}
	}

	private func assertRendered(_ controls: RatingCellControls, kind: RatingKind, rating: Double,
		min: Double, max: Double, file: StaticString, line: UInt) {
		XCTAssertEqual(controls.slider.value, Float((rating - min) / (max - min)), accuracy: 0.000001, file: file, line: line)
		XCTAssertEqual(controls.slider.thumbTintColor, UIColor.purple, file: file, line: line)
		XCTAssertEqual(controls.ratingButton.title(for: .normal), String(rating), file: file, line: line)
		XCTAssertEqual(controls.ratingButton.accessibilityValue, String(rating), file: file, line: line)
		XCTAssertEqual(controls.rangeLabel.text, "(\(min)-\(max))", file: file, line: line)
		// One formatting call for the rating shared by title/accessibility, plus the two bounds.
		XCTAssertEqual(uiUtil.formattedValues, [rating, min, max], file: file, line: line)
		XCTAssertEqual(uiUtil.colorRatings, [rating], file: file, line: line)
		XCTAssertEqual(uiUtil.colorMinimums, [min], file: file, line: line)
		XCTAssertEqual(uiUtil.colorMaximums, [max], file: file, line: line)
		switch kind {
		case .mood: Verify(injectionProvider, .exactly(1), .get(.value(MoodUiUtil.self)), file: file, line: line)
		case .fatigue: Verify(injectionProvider, .exactly(1), .get(.value(FatigueUiUtil.self)), file: file, line: line)
		case .pain: Verify(injectionProvider, .exactly(1), .get(.value(PainUiUtil.self)), file: file, line: line)
		}
	}

	private func clearInvocations() {
		uiUtil.formattedValues = []
		uiUtil.colorRatings = []
		uiUtil.colorMinimums = []
		uiUtil.colorMaximums = []
		injectionProvider.resetMock(.invocation)
	}

	private func setRange(for kind: RatingKind, min: Double, max: Double) {
		switch kind {
		case .mood:
			Given(mockSettings, .minMood(getter: min))
			Given(mockSettings, .maxMood(getter: max))
		case .fatigue:
			Given(mockSettings, .minFatigue(getter: min))
			Given(mockSettings, .maxFatigue(getter: max))
		case .pain:
			Given(mockSettings, .minPain(getter: min))
			Given(mockSettings, .maxPain(getter: max))
		}
	}

	private func makeCell(_ kind: RatingKind) -> RatingCellControls {
		let observationCenter = NotificationCenter()
		let slider = UISlider()
		let range = UILabel()
		let rating = UIButton()
		let note = UIButton()
		let cell: UITableViewCell
		let changeRating: () -> Void
		var location: UITextField?
		switch kind {
		case .mood:
			let mood = RecordContinuousMoodTableViewCell()
			mood.observationCenter = observationCenter
			mood.ratingSlider = slider
			mood.ratingRangeLabel = range
			mood.ratingButton = rating
			mood.addNoteButton = note
			cell = mood
			changeRating = { mood.ratingChanged(mood) }
		case .fatigue:
			let fatigue = RecordContinuousFatigueTableViewCell()
			fatigue.observationCenter = observationCenter
			fatigue.ratingSlider = slider
			fatigue.ratingRangeLabel = range
			fatigue.ratingButton = rating
			fatigue.addNoteButton = note
			cell = fatigue
			changeRating = { fatigue.ratingChanged(fatigue) }
		case .pain:
			let pain = RecordContinuousPainTableViewCell()
			pain.observationCenter = observationCenter
			pain.ratingSlider = slider
			pain.ratingRangeLabel = range
			pain.ratingButton = rating
			pain.addNoteButton = note
			let field = UITextField()
			field.text = "Previous location"
			pain.locationTextField = field
			location = field
			cell = pain
			changeRating = { pain.ratingChanged(pain) }
		}
		return RatingCellControls(observationCenter: observationCenter, cell: cell, slider: slider, rangeLabel: range,
			ratingButton: rating, noteButton: note, location: location, changeRating: changeRating)
	}
}

private enum RatingKind: CaseIterable {
	case mood, fatigue, pain

	var minChanged: Notification.Name {
		switch self {
		case .mood: return MoodUiUtilImpl.minRatingChanged
		case .fatigue: return FatigueUiUtilImpl.minRatingChanged
		case .pain: return PainUiUtilImpl.minRatingChanged
		}
	}

	var maxChanged: Notification.Name {
		switch self {
		case .mood: return MoodUiUtilImpl.maxRatingChanged
		case .fatigue: return FatigueUiUtilImpl.maxRatingChanged
		case .pain: return PainUiUtilImpl.maxRatingChanged
		}
	}
}

private struct RatingCellControls {
	let observationCenter: NotificationCenter
	let cell: UITableViewCell
	let slider: UISlider
	let rangeLabel: UILabel
	let ratingButton: UIButton
	let noteButton: UIButton
	let location: UITextField?
	let changeRating: () -> Void
}

private final class ContinuousRatingUiUtilSpy: MoodUiUtil, FatigueUiUtil, PainUiUtil {
	var formattedValues: [Double] = []
	var colorRatings: [Double] = []
	var colorMinimums: [Double] = []
	var colorMaximums: [Double] = []

	func valueToString(_ value: Double) -> String {
		formattedValues.append(value)
		return String(value)
	}

	func colorForMood(rating: Double, minRating: Double, maxRating: Double) -> UIColor {
		color(rating: rating, min: minRating, max: maxRating)
	}

	func colorForFatigue(rating: Double, minRating: Double, maxRating: Double) -> UIColor {
		color(rating: rating, min: minRating, max: maxRating)
	}

	func colorForPain(rating: Double, minRating: Double, maxRating: Double) -> UIColor {
		color(rating: rating, min: minRating, max: maxRating)
	}

	func feedbackMessage(for rating: Double, min: Double, max: Double) -> String { "Recorded" }

	private func color(rating: Double, min: Double, max: Double) -> UIColor {
		colorRatings.append(rating)
		colorMinimums.append(min)
		colorMaximums.append(max)
		return .purple
	}
}
