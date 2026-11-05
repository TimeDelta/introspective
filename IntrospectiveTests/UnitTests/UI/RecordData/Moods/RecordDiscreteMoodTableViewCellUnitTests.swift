//
//  RecordDiscreteMoodTableViewCellUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/20/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import UIKit
@testable import Introspective
@testable import Common
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
		Given(mockMoodUiUtil, .feedbackMessage(for: .any, min: .any, max: .any, willReturn: "not nil"))

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

final class DiscreteRatingCellRenderingTests: UnitTest {
	private var uiUtil: DiscreteRatingUiUtilSpy!

	override func setUp() {
		super.setUp()
		uiUtil = DiscreteRatingUiUtilSpy()
		Matcher.default.register(FatigueUiUtil.Protocol.self) { _, _ in true }
		Matcher.default.register(PainUiUtil.Protocol.self) { _, _ in true }
		Given(injectionProvider, .get(.value(MoodUiUtil.self), willReturn: uiUtil))
		Given(injectionProvider, .get(.value(FatigueUiUtil.self), willReturn: uiUtil))
		Given(injectionProvider, .get(.value(PainUiUtil.self), willReturn: uiUtil))
		for kind in DiscreteRatingKind.allCases { setRange(kind, min: 0, max: 7) }
	}

	func testOneHundredLayoutsKeepButtonsConstraintsColorsAndScrollPosition() {
		for kind in DiscreteRatingKind.allCases {
			setRange(kind, min: 0, max: 10)
			let controls = makeCell(kind, width: 180)
			defer { controls.observationCenter.removeObserver(controls.cell) }
			assertColors(min: 0, max: 10)
			assertGeometry(controls, kind: kind, min: 0, max: 10, selected: 5)
			let buttons = controls.buttons
			let constraints = controls.renderConstraints
			controls.scrollView.contentOffset = CGPoint(x: 80, y: 0)
			uiUtil.clearColors()

			for _ in 0 ..< 100 { controls.layout() }

			assertSameRendering(controls, buttons: buttons, constraints: constraints)
			assertGeometry(controls, kind: kind, min: 0, max: 10, selected: 5)
			XCTAssertEqual(controls.scrollView.contentOffset.x, 80, accuracy: 0.001)
			XCTAssertEqual(controls.scrollView.contentOffset.y, 0, accuracy: 0.001)
			XCTAssertTrue(uiUtil.colorRatings.isEmpty)
		}
	}

	func testResizingChangesExistingNormalAndSelectedWidthConstraints() {
		for kind in DiscreteRatingKind.allCases {
			let controls = makeCell(kind)
			defer { controls.observationCenter.removeObserver(controls.cell) }
			let buttons = controls.buttons
			let constraints = controls.renderConstraints
			uiUtil.clearColors()

			for width in [CGFloat(480), 120, 0, 320] {
				controls.layout(width: width)

				assertSameRendering(controls, buttons: buttons, constraints: constraints)
				assertGeometry(controls, kind: kind, min: 0, max: 7, selected: 3)
			}
			XCTAssertTrue(uiUtil.colorRatings.isEmpty)
		}
	}

	func testButtonActionsAndRetappingKeepConstraintsAndUpdateSelection() {
		for kind in DiscreteRatingKind.allCases {
			let controls = makeCell(kind)
			defer { controls.observationCenter.removeObserver(controls.cell) }
			let buttons = controls.buttons
			let constraints = controls.renderConstraints
			uiUtil.clearColors()

			for rating in [0, 7, 7, 3] {
				buttons.first { $0.title(for: .normal) == String(rating) }?.sendActions(for: .touchUpInside)
				controls.layout()

				assertGeometry(controls, kind: kind, min: 0, max: 7, selected: rating)
				assertSameRendering(controls, buttons: buttons, constraints: constraints)
			}
			XCTAssertTrue(uiUtil.colorRatings.isEmpty)
		}
	}

	func testShiftedAndFractionalBoundsRebuildAndRecolorEvenWithEqualButtonCount() {
		for kind in DiscreteRatingKind.allCases {
			setRange(kind, min: 0, max: 7)
			let controls = makeCell(kind)
			defer { controls.observationCenter.removeObserver(controls.cell) }
			for (min, max, color) in [(2.0, 9.0, UIColor.orange), (2.25, 9.75, UIColor.green)] {
				let oldButtons = controls.buttons
				let oldConstraints = controls.renderConstraints
				setRange(kind, min: min, max: max)
				uiUtil.clearColors()
				uiUtil.buttonColor = color

				controls.layout()

				XCTAssertEqual(controls.buttons.count, oldButtons.count)
				XCTAssertTrue(Set(controls.buttons.map(ObjectIdentifier.init))
					.isDisjoint(with: oldButtons.map(ObjectIdentifier.init)))
				XCTAssertTrue(oldButtons.allSatisfy { $0.superview == nil })
				XCTAssertTrue(oldConstraints.allSatisfy { !$0.isActive })
				XCTAssertTrue(Set(controls.renderConstraints.map(ObjectIdentifier.init))
					.isDisjoint(with: oldConstraints.map(ObjectIdentifier.init)))
				assertColors(min: min, max: max)
				assertGeometry(controls, kind: kind, min: min, max: max, selected: 3)
				XCTAssertTrue(controls.buttons.allSatisfy { $0.backgroundColor == color })
				let newButtons = controls.buttons
				let newConstraints = controls.renderConstraints
				uiUtil.clearColors()

				// A detached control must not change the new scale's selection.
				oldButtons.first?.sendActions(for: .touchUpInside)
				controls.layout()

				assertSameRendering(controls, buttons: newButtons, constraints: newConstraints)
				assertGeometry(controls, kind: kind, min: min, max: max, selected: 3)
				XCTAssertTrue(uiUtil.colorRatings.isEmpty)
			}
		}
	}

	func testBothSettingsNotificationsResetMidpointNoteAndLocation() {
		Given(mockUiUtil, .value(for: .value(.text), from: .any, keyIsOptional: .any, willReturn: "Previous note"))
		for kind in DiscreteRatingKind.allCases {
			setRange(kind, min: 0, max: 7)
			let controls = makeCell(kind)
			defer { controls.observationCenter.removeObserver(controls.cell) }
			for (notification, min, max) in [(kind.minChanged, 2.0, 10.0), (kind.maxChanged, -2.0, 8.0)] {
				controls.observationCenter.post(name: kind.noteChanged, object: nil,
					userInfo: [UserInfoKey.text: "Previous note"])
				XCTAssertEqual(controls.noteButton.title(for: .normal), "Previous note")
				controls.location?.text = "Previous location"
				controls.buttons.first?.sendActions(for: .touchUpInside)
				let oldButtons = controls.buttons
				setRange(kind, min: min, max: max)
				uiUtil.clearColors()

				controls.observationCenter.post(name: notification, object: nil)
				controls.layout()

				assertGeometry(controls, kind: kind, min: min, max: max, selected: Int((max - min) / 2 + min))
				assertColors(min: min, max: max)
				XCTAssertTrue(oldButtons.allSatisfy { $0.superview == nil })
				XCTAssertEqual(controls.noteButton.title(for: .normal), "Add Note")
				if let location = controls.location { XCTAssertTrue(location.text?.isEmpty ?? true) }
				if let mood = controls.cell as? RecordDiscreteMoodTableViewCell { XCTAssertNil(mood.note) }
				if let fatigue = controls.cell as? RecordDiscreteFatigueTableViewCell { XCTAssertNil(fatigue.note) }
			}
			let buttons = controls.buttons
			let constraints = controls.renderConstraints
			controls.buttons.first?.sendActions(for: .touchUpInside)
			uiUtil.clearColors()

			controls.observationCenter.post(name: kind.maxChanged, object: nil)
			controls.layout()

			assertSameRendering(controls, buttons: buttons, constraints: constraints)
			assertGeometry(controls, kind: kind, min: -2, max: 8, selected: 3)
			XCTAssertTrue(uiUtil.colorRatings.isEmpty)
		}
	}

	func testUnnotifiedBoundsChangesClampSelectionToTheNewIntegerEndpoints() {
		for kind in DiscreteRatingKind.allCases {
			let controls = makeCell(kind)
			defer { controls.observationCenter.removeObserver(controls.cell) }
			controls.buttons.last?.sendActions(for: .touchUpInside)
			controls.layout()
			assertGeometry(controls, kind: kind, min: 0, max: 7, selected: 7)
			for (min, max, selected) in [(-4.0, 2.0, 2), (5.0, 9.0, 5)] {
				let oldButtons = controls.buttons
				let oldConstraints = controls.renderConstraints
				setRange(kind, min: min, max: max)
				uiUtil.clearColors()

				controls.layout()

				assertGeometry(controls, kind: kind, min: min, max: max, selected: selected)
				assertColors(min: min, max: max)
				XCTAssertTrue(oldButtons.allSatisfy { $0.superview == nil })
				XCTAssertTrue(oldConstraints.allSatisfy { !$0.isActive })
				XCTAssertTrue(Set(controls.buttons.map(ObjectIdentifier.init))
					.isDisjoint(with: oldButtons.map(ObjectIdentifier.init)))
				let buttons = controls.buttons
				let constraints = controls.renderConstraints

				oldButtons.last?.sendActions(for: .touchUpInside)
				controls.layout()

				assertSameRendering(controls, buttons: buttons, constraints: constraints)
				assertGeometry(controls, kind: kind, min: min, max: max, selected: selected)
				XCTAssertTrue(uiUtil.colorRatings.isEmpty)
			}
		}
	}

	func testSingleNegativeAndFractionalScalesUseActualIntegerButtonCount() {
		for kind in DiscreteRatingKind.allCases {
			for (min, max, width) in [(0.0, 0.0, CGFloat(120)), (-4.0, -1.0, 320),
				(-2.8, 2.4, 320), (2.25, 9.75, 480)] {
				setRange(kind, min: min, max: max)
				uiUtil.clearColors()
				let controls = makeCell(kind, width: width)
				defer { controls.observationCenter.removeObserver(controls.cell) }

				assertGeometry(controls, kind: kind, min: min, max: max, selected: Int((max - min) / 2 + min))
				assertColors(min: min, max: max)
			}
		}
	}

	func testSavingMoodPersistsTappedRatingAndResetsWithoutRebuilding() {
		let transaction = TransactionMock()
		let mood = MoodMock()
		Given(mockDatabase, .transaction(willReturn: transaction))
		Given(mockSampleFactory, .mood(using: .any, willReturn: mood))
		Given(mockUiUtil, .value(for: .value(.text), from: .any, keyIsOptional: .any, willReturn: "Saved note"))
		let controls = makeCell(.mood)
		defer { controls.observationCenter.removeObserver(controls.cell) }
		let buttons = controls.buttons
		let constraints = controls.renderConstraints
		controls.observationCenter.post(name: DiscreteRatingKind.mood.noteChanged, object: nil,
			userInfo: [UserInfoKey.text: "Saved note"])
		buttons.last?.sendActions(for: .touchUpInside)
		uiUtil.clearColors()
		let moodCell = controls.cell as! RecordDiscreteMoodTableViewCell

		moodCell.doneButtonPressed(self)
		controls.layout()

		XCTAssertEqual(mood.rating, 7)
		XCTAssertEqual(mood.minRating, 0)
		XCTAssertEqual(mood.maxRating, 7)
		XCTAssertEqual(mood.note, "Saved note")
		Verify(transaction, .exactly(1), .commit())
		Verify(mood, .exactly(1), .setSource(.value(.introspective)))
		XCTAssertNil(moodCell.note)
		XCTAssertEqual(controls.noteButton.title(for: .normal), "Add Note")
		XCTAssertEqual(controls.feedbackLabel.text, "Recorded")
		XCTAssertFalse(controls.feedbackLabel.isHidden)
		assertSameRendering(controls, buttons: buttons, constraints: constraints)
		assertGeometry(controls, kind: .mood, min: 0, max: 7, selected: 3)
		XCTAssertTrue(uiUtil.colorRatings.isEmpty)
	}

	private func assertSameRendering(_ controls: DiscreteRatingCellControls, buttons: [UIButton],
		constraints: [NSLayoutConstraint], file: StaticString = #file, line: UInt = #line) {
		XCTAssertEqual(controls.buttons.map(ObjectIdentifier.init), buttons.map(ObjectIdentifier.init), file: file, line: line)
		XCTAssertEqual(Set(controls.renderConstraints.map(ObjectIdentifier.init)),
			Set(constraints.map(ObjectIdentifier.init)), file: file, line: line)
		XCTAssertTrue(constraints.allSatisfy { $0.isActive }, file: file, line: line)
	}

	private func assertColors(min: Double, max: Double, file: StaticString = #file, line: UInt = #line) {
		let ratings = (Int(min) ... Int(max)).map { Double($0) }
		XCTAssertEqual(uiUtil.colorRatings, ratings, file: file, line: line)
		XCTAssertEqual(uiUtil.colorMinimums, Array(repeating: min, count: ratings.count), file: file, line: line)
		XCTAssertEqual(uiUtil.colorMaximums, Array(repeating: max, count: ratings.count), file: file, line: line)
		uiUtil.clearColors()
	}

	private func assertGeometry(_ controls: DiscreteRatingCellControls, kind: DiscreteRatingKind,
		min: Double, max: Double, selected: Int, file: StaticString = #file, line: UInt = #line) {
		let ratings = Array(Int(min) ... Int(max))
		let buttons = controls.buttons
		XCTAssertEqual(buttons.map { $0.title(for: .normal) }, ratings.map { Optional(String($0)) }, file: file, line: line)
		XCTAssertEqual(controls.renderConstraints.count, 4 * ratings.count + 1, file: file, line: line)
		let baseWidth = Swift.max(30, (controls.scrollView.bounds.width - 5 * CGFloat(ratings.count)) / CGFloat(ratings.count))
		let pixelAccuracy = 1 / UIScreen.main.scale
		for (index, button) in buttons.enumerated() {
			guard index < ratings.count else { continue }
			let rating = ratings[index]
			let isSelected = rating == selected
			let expectedWidth = baseWidth + (isSelected ? 5 : 0)
			let inset: CGFloat = isSelected ? 0 : 5
			let widths = button.constraints.filter {
				$0.isActive && $0.identifier == "discreteRating" &&
				$0.firstAttribute == .width && $0.secondItem == nil
			}
			XCTAssertEqual(widths.count, 1, file: file, line: line)
			if let width = widths.first { XCTAssertEqual(width.constant, expectedWidth, accuracy: 0.001, file: file, line: line) }
			for (attribute, constant) in [(NSLayoutConstraint.Attribute.top, inset), (.bottom, -inset)] {
				let edges = controls.content.constraints.filter {
					$0.isActive && $0.identifier == "discreteRating" &&
					($0.firstItem as? UIView) === button && $0.firstAttribute == attribute &&
					($0.secondItem as? UIView) === controls.content && $0.secondAttribute == attribute
				}
				XCTAssertEqual(edges.count, 1, file: file, line: line)
				if let edge = edges.first { XCTAssertEqual(edge.constant, constant, accuracy: 0.001, file: file, line: line) }
			}
			XCTAssertEqual(button.frame.width, expectedWidth, accuracy: pixelAccuracy, file: file, line: line)
			XCTAssertEqual(button.frame.minY, inset, accuracy: 0.001, file: file, line: line)
			XCTAssertEqual(button.frame.maxY, controls.content.bounds.height - inset, accuracy: 0.001, file: file, line: line)
			let expectedLeading = index == 0 ? 0 : buttons[index - 1].frame.maxX + 5
			XCTAssertEqual(button.frame.minX, expectedLeading, accuracy: pixelAccuracy, file: file, line: line)
			let identifier = "set \(kind.rawValue) to \(rating) button"
			XCTAssertEqual(button.accessibilityIdentifier, identifier, file: file, line: line)
			XCTAssertEqual(button.accessibilityLabel, identifier, file: file, line: line)
			XCTAssertEqual(button.actions(forTarget: controls.cell, forControlEvent: .touchUpInside)?.count, 1, file: file, line: line)
		}
		let expectedContentWidth = CGFloat(ratings.count) * (baseWidth + 5)
		XCTAssertEqual(controls.content.bounds.width, expectedContentWidth, accuracy: 0.001, file: file, line: line)
		XCTAssertEqual(controls.scrollView.contentSize.width, expectedContentWidth, accuracy: 0.001, file: file, line: line)
	}

	private func setRange(_ kind: DiscreteRatingKind, min: Double, max: Double) {
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

	private func makeCell(_ kind: DiscreteRatingKind, width: CGFloat = 320) -> DiscreteRatingCellControls {
		uiUtil.clearColors()
		let center = NotificationCenter()
		let scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: width, height: 60))
		scroll.contentInsetAdjustmentBehavior = .never
		let content = UIView()
		let note = UIButton()
		let done = UIButton()
		let feedback = UILabel()
		let cell: UITableViewCell
		var location: UITextField?
		switch kind {
		case .mood:
			let mood = RecordDiscreteMoodTableViewCell()
			mood.observationCenter = center
			mood.scrollView = scroll
			mood.moodContentView = content
			mood.addNoteButton = note
			mood.doneButton = done
			mood.feedbackLabel = feedback
			cell = mood
		case .fatigue:
			let fatigue = RecordDiscreteFatigueTableViewCell()
			fatigue.observationCenter = center
			fatigue.scrollView = scroll
			fatigue.fatigueContentView = content
			fatigue.addNoteButton = note
			fatigue.doneButton = done
			fatigue.feedbackLabel = feedback
			cell = fatigue
		case .pain:
			let pain = RecordDiscretePainTableViewCell()
			pain.observationCenter = center
			pain.scrollView = scroll
			pain.painContentView = content
			pain.addNoteButton = note
			pain.doneButton = done
			pain.feedbackLabel = feedback
			let field = UITextField()
			pain.locationTextField = field
			location = field
			cell = pain
		}
		cell.frame = CGRect(x: 0, y: 0, width: width, height: 70)
		cell.contentView.addSubview(scroll)
		let otherViews: [UIView] = [note, done, feedback]
		for view in otherViews { cell.contentView.addSubview(view) }
		if let location = location { cell.contentView.addSubview(location) }
		scroll.addSubview(content)
		content.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			content.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor),
			content.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor),
			content.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
			content.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor),
			content.heightAnchor.constraint(equalTo: scroll.frameLayoutGuide.heightAnchor),
		])
		let controls = DiscreteRatingCellControls(observationCenter: center, cell: cell, scrollView: scroll,
			content: content, noteButton: note, doneButton: done, feedbackLabel: feedback, location: location)
		cell.awakeFromNib()
		controls.layout()
		return controls
	}
}

private enum DiscreteRatingKind: String, CaseIterable {
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

	var noteChanged: Notification.Name { Notification.Name("record\(rawValue.capitalized)NoteChanged") }
}

private struct DiscreteRatingCellControls {
	let observationCenter: NotificationCenter
	let cell: UITableViewCell
	let scrollView: UIScrollView
	let content: UIView
	let noteButton: UIButton
	let doneButton: UIButton
	let feedbackLabel: UILabel
	let location: UITextField?

	var buttons: [UIButton] { content.subviews.compactMap { $0 as? UIButton } }
	var renderConstraints: [NSLayoutConstraint] {
		(content.constraints + buttons.flatMap { $0.constraints }).filter {
			$0.isActive && $0.identifier == "discreteRating"
		}
	}

	func layout(width: CGFloat? = nil) {
		if let width = width {
			cell.frame.size.width = width
			scrollView.frame.size.width = width
		}
		cell.setNeedsLayout()
		cell.layoutIfNeeded()
		scrollView.layoutIfNeeded()
		content.layoutIfNeeded()
	}
}

private final class DiscreteRatingUiUtilSpy: MoodUiUtil, FatigueUiUtil, PainUiUtil {
	var buttonColor: UIColor = .purple
	var colorRatings: [Double] = []
	var colorMinimums: [Double] = []
	var colorMaximums: [Double] = []

	func valueToString(_ value: Double) -> String { String(value) }
	func feedbackMessage(for rating: Double, min: Double, max: Double) -> String { "Recorded" }
	func colorForMood(rating: Double, minRating: Double, maxRating: Double) -> UIColor {
		color(rating: rating, min: minRating, max: maxRating)
	}
	func colorForFatigue(rating: Double, minRating: Double, maxRating: Double) -> UIColor {
		color(rating: rating, min: minRating, max: maxRating)
	}
	func colorForPain(rating: Double, minRating: Double, maxRating: Double) -> UIColor {
		color(rating: rating, min: minRating, max: maxRating)
	}

	func clearColors() {
		colorRatings = []
		colorMinimums = []
		colorMaximums = []
	}

	private func color(rating: Double, min: Double, max: Double) -> UIColor {
		colorRatings.append(rating)
		colorMinimums.append(min)
		colorMaximums.append(max)
		return buttonColor
	}
}
