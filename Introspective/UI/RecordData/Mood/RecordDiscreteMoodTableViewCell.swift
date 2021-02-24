//
//  RecordDiscreteMoodTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 3/19/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Presentr
import UIKit

import Common
import DependencyInjection
import Persistence
import Samples
import Settings

public final class RecordDiscreteMoodTableViewCell: UITableViewCell {
	// MARK: - Static Variables

	private typealias Me = RecordDiscreteMoodTableViewCell

	private static let notePresenter: Presentr = injected(UiUtil.self)
		.customPresenter(width: .custom(size: 300), height: .custom(size: 200), center: .topCenter)
	private static let ratingPresenter: Presentr = injected(UiUtil.self)
		.customPresenter(width: .custom(size: 300), height: .custom(size: 70), center: .topCenter)

	private static let ratingChanged = Notification.Name("moodRatingChanged")
	private static let noteChangedNotification = Notification.Name("moodNoteChanged")

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var doneButton: UIButton!
	@IBOutlet final var addNoteButton: UIButton!
	@IBOutlet final var scrollView: UIScrollView!
	@IBOutlet final var moodContentView: UIView!
	@IBOutlet final var feedbackLabel: UILabel!

	// MARK: - Instance Variables

	/// This is not made private solely for testing purposes
	final var note: String?
	private final var rating: Int = Int(injected(Settings.self).maxMood)
	private final var ratingButtons = [UIButton]()

	private final let spacingBetweenRatingButtons: CGFloat = 5

	// MARK: - UIView Overrides

	public final override func awakeFromNib() {
		super.awakeFromNib()
		reset()
		observe(selector: #selector(noteSaved), name: Me.noteChangedNotification)
		observe(selector: #selector(resetAndUpdateUI), name: MoodUiUtilImpl.minRatingChanged)
		observe(selector: #selector(resetAndUpdateUI), name: MoodUiUtilImpl.maxRatingChanged)
	}

	public final override func layoutSubviews() {
		super.layoutSubviews()
		updateUI()
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Received Notifications

	@objc private final func noteSaved(notification: Notification) {
		if let note: String = value(for: .text, from: notification) {
			self.note = note
			if !note.isEmpty {
				addNoteButton.setTitle(note, for: .normal)
				addNoteButton.accessibilityValue = "Change note"
			} else {
				addNoteButton.setTitle("Add Note", for: .normal)
				addNoteButton.accessibilityValue = "Add Note"
			}
		} else {
			addNoteButton.accessibilityValue = "Add Note"
		}
	}

	// MARK: - Actions

	@IBAction final func doneButtonPressed(_: Any) {
		do {
			let transaction = injected(Database.self).transaction()
			var mood = try injected(SampleFactory.self).mood(using: transaction)
			mood.date = Date()
			mood.rating = Double(rating)
			mood.note = note
			mood.minRating = injected(Settings.self).minMood
			mood.maxRating = injected(Settings.self).maxMood
			mood.setSource(.introspective)
			try transaction.commit()

			feedbackLabel.text = injected(MoodUiUtil.self).feedbackMessage(
				for: Double(rating),
				min: mood.minRating,
				max: mood.maxRating
			)
			feedbackLabel.isHidden = false
			Timer.scheduledTimer(
				timeInterval: 5,
				target: self,
				selector: #selector(hideFeedbackLabel),
				userInfo: nil,
				repeats: false
			)

			reset()
			updateUI()
		} catch {
			Me.log.error("Failed to create or save mood: %@", errorInfo(error))
			NotificationCenter.default.post(
				name: RecordDataTableViewController.showErrorMessage,
				object: self,
				userInfo: info([
					.title: "Failed to save mood rating",
					.error: error,
				])
			)
		}
	}

	@IBAction final func presentMoodNoteController(_: Any) {
		let controller: NoteViewController = viewController(named: "recordNote", fromStoryboard: "RecordData")
		controller.note = note ?? ""
		controller.noteSavedNotification = Me.noteChangedNotification
		NotificationCenter.default.post(
			name: RecordDataTableViewController.showViewController,
			object: self,
			userInfo: info([
				.controller: controller,
				.presenter: Me.notePresenter,
			])
		)
	}

	@objc private final func moodRatingButtonPressed(_ button: UIButton) {
		if let title = button.currentTitle {
			if let rating = Int(title) {
				let oldRatingButton = getRatingButton(forRating: self.rating)
				let newRatingButton = getRatingButton(forRating: rating)

				deselectRatingButton(oldRatingButton)
				selectRatingButton(newRatingButton)

				self.rating = rating
			} else {
				Me.log.error("Unable to get rating from button title")
			}
		} else {
			Me.log.error("Missing title for mood rating button")
		}
	}

	// MARK: - Helper Functions

	@objc private final func resetAndUpdateUI() {
		reset()
		updateUI()
	}

	private final func reset() {
		note = nil
		addNoteButton.setTitle("Add Note", for: .normal)
		let min = injected(Settings.self).minMood
		let max = injected(Settings.self).maxMood
		rating = Int((max - min) / 2 + min)
	}

	@objc private final func hideFeedbackLabel() {
		feedbackLabel.isHidden = true
	}

	private final func updateUI() {
		removeExistingMoodButtons()

		let min = injected(Settings.self).minMood
		let max = injected(Settings.self).maxMood
		var lastView: UIView?
		for i in Int(min) ... Int(max) {
			let ratingButton = createButtonForRating(i)
			ratingButtons.append(ratingButton)
			moodContentView.addSubview(ratingButton)
			addConstraintsForRatingButton(ratingButton, lastView)
			lastView = ratingButton
		}
		if let lastView = lastView {
			moodContentView.trailingAnchor.constraint(equalTo: lastView.trailingAnchor).isActive = true
		}
		let ratingButton = getRatingButton(forRating: rating)
		selectRatingButton(ratingButton)
	}

	private final func removeExistingMoodButtons() {
		ratingButtons = [UIButton]()
		for subView in moodContentView.subviews {
			moodContentView.willRemoveSubview(subView)
			subView.removeFromSuperview()
		}
	}

	private final func createButtonForRating(_ rating: Int) -> UIButton {
		let min = injected(Settings.self).minMood
		let max = injected(Settings.self).maxMood
		let button = UIButton(type: .custom)
		button.addTarget(self, action: #selector(moodRatingButtonPressed), for: .touchUpInside)
		button.backgroundColor = injected(MoodUiUtil.self)
			.colorForMood(rating: Double(rating), minRating: min, maxRating: max)
		let titleColor = button.backgroundColor?.highContrast()
		button.setTitleColor(titleColor, for: .normal)
		button.setTitle("\(rating)", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.accessibilityIdentifier = "set mood to \(rating) button"
		button.accessibilityLabel = "set mood to \(rating) button"
		return button
	}

	private final func addConstraintsForRatingButton(_ ratingButton: UIButton, _ lastView: UIView?) {
		if let lastView = lastView {
			ratingButton.leadingAnchor.constraint(
				equalTo: lastView.trailingAnchor,
				constant: spacingBetweenRatingButtons
			).isActive = true
		} else {
			ratingButton.leadingAnchor.constraint(equalTo: moodContentView.leadingAnchor).isActive = true
		}
		widthConstraint(for: ratingButton, width: getBaseWidth()).isActive = true
		ratingButton.topAnchor.constraint(equalTo: moodContentView.topAnchor, constant: 5).isActive = true
		ratingButton.bottomAnchor.constraint(equalTo: moodContentView.bottomAnchor, constant: -5).isActive = true
	}

	private final func getRatingButton(forRating rating: Int) -> UIButton {
		let buttonIndex = rating - Int(injected(Settings.self).minMood)
		return ratingButtons[buttonIndex]
	}

	private final func selectRatingButton(_ ratingButton: UIButton) {
		removeTopBottomAndWidthConstraintsFor(ratingButton)
		widthConstraint(for: ratingButton, width: getBaseWidth() + spacingBetweenRatingButtons).isActive = true
		ratingButton.topAnchor.constraint(equalTo: moodContentView.topAnchor).isActive = true
		ratingButton.bottomAnchor.constraint(equalTo: moodContentView.bottomAnchor).isActive = true
	}

	private final func deselectRatingButton(_ ratingButton: UIButton) {
		removeTopBottomAndWidthConstraintsFor(ratingButton)
		widthConstraint(for: ratingButton, width: getBaseWidth()).isActive = true
		ratingButton.topAnchor.constraint(equalTo: moodContentView.topAnchor, constant: 5).isActive = true
		ratingButton.bottomAnchor.constraint(equalTo: moodContentView.bottomAnchor, constant: -5).isActive = true
	}

	private final func removeTopBottomAndWidthConstraintsFor(_ ratingButton: UIButton) {
		for constraint in moodContentView.constraints {
			let involvesRatingButton = thisConstraint(constraint, involves: ratingButton)
			if involvesRatingButton && [.top, .bottom].contains(constraint.secondAttribute) {
				constraint.isActive = false
			}
		}
		for constraint in ratingButton.constraints {
			if [.width, .top, .bottom].contains(constraint.firstAttribute) {
				constraint.isActive = false
			}
		}
	}

	private final func thisConstraint(_ constraint: NSLayoutConstraint, involves item: UIView) -> Bool {
		constraint.firstItem?.accessibilityIdentifier == item.accessibilityIdentifier ||
			constraint.secondItem?.accessibilityIdentifier == item.accessibilityIdentifier
	}

	private final func widthConstraint(for view: UIView, width: CGFloat) -> NSLayoutConstraint {
		let widthConstraint = view.widthAnchor.constraint(equalToConstant: width)
		widthConstraint.priority = .required
		return widthConstraint
	}

	private final func getBaseWidth() -> CGFloat {
		let minWidth: CGFloat = 30
		let numberOfMoods = CGFloat(
			injected(Settings.self).maxMood - DependencyInjector
				.get(Settings.self).minMood + 1
		)
		// not -1 because need to account for one mood always being selected, which adds 1 spacing
		let totalSpacingRequired = spacingBetweenRatingButtons * numberOfMoods
		let proportionalWidth = (scrollView.frame.width - totalSpacingRequired) / numberOfMoods
		if proportionalWidth > minWidth {
			return proportionalWidth
		}
		return minWidth
	}
}
