//
//  RecordDiscretePainTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 6/16/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import Presentr
import UIKit

import Common
import DependencyInjection
import Persistence
import Samples
import Settings

public final class RecordDiscretePainTableViewCell: UITableViewCell {
	// MARK: - Static Variables

	private typealias Me = RecordDiscretePainTableViewCell

	private static let notePresenter: Presentr = injected(UiUtil.self)
		.customPresenter(width: .custom(size: 300), height: .custom(size: 200), center: .topCenter)
	private static let ratingPresenter: Presentr = injected(UiUtil.self)
		.customPresenter(width: .custom(size: 300), height: .custom(size: 70), center: .topCenter)

	private static let ratingChanged = Notification.Name("recordPainRatingChanged")
	private static let noteChangedNotification = Notification.Name("recordPainNoteChanged")

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var doneButton: UIButton!
	@IBOutlet final var locationTextField: UITextField!
	@IBOutlet final var addNoteButton: UIButton!
	@IBOutlet final var scrollView: UIScrollView!
	@IBOutlet final var painContentView: UIView!
	@IBOutlet final var feedbackLabel: UILabel!

	// MARK: - Instance Variables

	private var note: String?
	private var rating: Int = Int(injected(Settings.self).maxPain)
	private struct RatingScale: Equatable {
		let min: Double
		let max: Double
	}

	private struct RatingButtonLayout {
		let button: UIButton
		let width: NSLayoutConstraint
		let top: NSLayoutConstraint
		let bottom: NSLayoutConstraint
	}

	private var renderedScale: RatingScale?
	private var ratingButtons = [RatingButtonLayout]()
	private var ratingConstraints = [NSLayoutConstraint]()
	private var selectedRating: Int?
	private var baseRatingButtonWidth: CGFloat?
	final var observationCenter: NotificationCenter = .default

	private final let spacingBetweenRatingButtons: CGFloat = 5

	// MARK: - UIView Overrides

	public final override func awakeFromNib() {
		super.awakeFromNib()
		reset()
		observationCenter.addObserver(self, selector: #selector(noteSaved), name: Me.noteChangedNotification, object: nil)
		observationCenter.addObserver(self, selector: #selector(resetAndUpdateUI), name: PainUiUtilImpl.minRatingChanged, object: nil)
		observationCenter.addObserver(self, selector: #selector(resetAndUpdateUI), name: PainUiUtilImpl.maxRatingChanged, object: nil)
	}

	public final override func layoutSubviews() {
		super.layoutSubviews()
		updateUI()
	}

	deinit {
		observationCenter.removeObserver(self)
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
			let pain = try injected(PainDAO.self).createPain(
				rating: Double(rating),
				location: locationTextField.text,
				note: note
			)

			feedbackLabel.text = injected(PainUiUtil.self).feedbackMessage(
				for: Double(rating),
				min: pain.minRating,
				max: pain.maxRating
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
			Me.log.error("Failed to create or save pain: %@", errorInfo(error))
			NotificationCenter.default.post(
				name: RecordDataTableViewController.showErrorMessage,
				object: self,
				userInfo: info([
					.title: "Failed to save pain rating",
					.error: error,
				])
			)
		}
	}

	@IBAction final func presentPainNoteController(_: Any) {
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

	@objc private final func painRatingButtonPressed(_ button: UIButton) {
		if let title = button.currentTitle {
			if let rating = Int(title) {
				guard let layout = getRatingButton(forRating: rating), layout.button === button else { return }
				self.rating = rating
				updateSelectedRating()
			} else {
				Me.log.error("Unable to get rating from button title")
			}
		} else {
			Me.log.error("Missing title for pain rating button")
		}
	}

	// MARK: - Helper Functions

	@objc private final func resetAndUpdateUI() {
		reset()
		updateUI()
	}

	private final func reset() {
		note = nil
		locationTextField.text = nil
		addNoteButton.setTitle("Add Note", for: .normal)
		let settings = injected(Settings.self)
		let min = settings.minPain
		let max = settings.maxPain
		rating = Int((max - min) / 2 + min)
	}

	@objc private final func hideFeedbackLabel() {
		feedbackLabel.isHidden = true
	}

	private final func updateUI() {
		let settings = injected(Settings.self)
		let scale = RatingScale(min: settings.minPain, max: settings.maxPain)
		if renderedScale != scale {
			rebuildRatingButtons(for: scale)
		}
		updateButtonWidths()
		updateSelectedRating()
	}

	private final func rebuildRatingButtons(for scale: RatingScale) {
		NSLayoutConstraint.deactivate(ratingConstraints)
		for layout in ratingButtons {
			layout.button.removeFromSuperview()
		}
		ratingButtons.removeAll()
		ratingConstraints.removeAll()
		renderedScale = scale
		selectedRating = nil
		baseRatingButtonWidth = nil

		let ratings = Int(scale.min) ... Int(scale.max)
		// Settings can change before their notification resets the rating to the midpoint.
		rating = Swift.min(ratings.upperBound, Swift.max(ratings.lowerBound, rating))
		let uiUtil = injected(PainUiUtil.self)
		var lastView: UIView?
		for value in ratings {
			let button = createButtonForRating(value, scale: scale, uiUtil: uiUtil)
			painContentView.addSubview(button)
			ratingButtons.append(addConstraintsForRatingButton(button, lastView))
			lastView = button
		}
		if let lastView = lastView {
			ratingConstraints.append(painContentView.trailingAnchor.constraint(equalTo: lastView.trailingAnchor))
		}
		NSLayoutConstraint.activate(ratingConstraints)
	}

	private final func createButtonForRating(_ rating: Int, scale: RatingScale, uiUtil: PainUiUtil) -> UIButton {
		let button = UIButton(type: .custom)
		button.addTarget(self, action: #selector(painRatingButtonPressed), for: .touchUpInside)
		button.backgroundColor = uiUtil.colorForPain(rating: Double(rating), minRating: scale.min, maxRating: scale.max)
		let titleColor = button.backgroundColor?.highContrast()
		button.setTitleColor(titleColor, for: .normal)
		button.setTitle("\(rating)", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.accessibilityIdentifier = "set pain to \(rating) button"
		button.accessibilityLabel = "set pain to \(rating) button"
		return button
	}

	private final func addConstraintsForRatingButton(_ button: UIButton, _ lastView: UIView?) -> RatingButtonLayout {
		let leading: NSLayoutConstraint
		if let lastView = lastView {
			leading = button.leadingAnchor.constraint(
				equalTo: lastView.trailingAnchor,
				constant: spacingBetweenRatingButtons
			)
		} else {
			leading = button.leadingAnchor.constraint(equalTo: painContentView.leadingAnchor)
		}
		let width = button.widthAnchor.constraint(equalToConstant: 30)
		let top = button.topAnchor.constraint(equalTo: painContentView.topAnchor, constant: 5)
		let bottom = button.bottomAnchor.constraint(equalTo: painContentView.bottomAnchor, constant: -5)
		ratingConstraints.append(contentsOf: [leading, width, top, bottom])
		return RatingButtonLayout(button: button, width: width, top: top, bottom: bottom)
	}

	private final func getRatingButton(forRating rating: Int) -> RatingButtonLayout? {
		guard let scale = renderedScale else { return nil }
		let min = Int(scale.min)
		guard rating >= min, rating <= Int(scale.max) else { return nil }
		let index = rating - min
		guard ratingButtons.indices.contains(index) else { return nil }
		return ratingButtons[index]
	}

	private final func updateButtonWidths() {
		guard !ratingButtons.isEmpty else { return }
		let count = CGFloat(ratingButtons.count)
		// The selected button adds one spacing, in addition to the gaps between buttons.
		let width = Swift.max(30, (scrollView.bounds.width - spacingBetweenRatingButtons * count) / count)
		guard width != baseRatingButtonWidth else { return }
		baseRatingButtonWidth = width
		let selectedButton = selectedRating.flatMap { getRatingButton(forRating: $0)?.button }
		for layout in ratingButtons {
			let extraWidth = layout.button === selectedButton ? spacingBetweenRatingButtons : 0
			updateConstraint(layout.width, constant: width + extraWidth)
		}
	}

	private final func updateSelectedRating() {
		guard selectedRating != rating, let layout = getRatingButton(forRating: rating) else { return }
		if let oldRating = selectedRating, let oldLayout = getRatingButton(forRating: oldRating) {
			updateRatingButton(oldLayout, selected: false)
		}
		updateRatingButton(layout, selected: true)
		selectedRating = rating
	}

	private final func updateRatingButton(_ layout: RatingButtonLayout, selected: Bool) {
		guard let baseWidth = baseRatingButtonWidth else { return }
		updateConstraint(layout.width, constant: baseWidth + (selected ? spacingBetweenRatingButtons : 0))
		updateConstraint(layout.top, constant: selected ? 0 : 5)
		updateConstraint(layout.bottom, constant: selected ? 0 : -5)
	}

	private final func updateConstraint(_ constraint: NSLayoutConstraint, constant: CGFloat) {
		if constraint.constant != constant {
			constraint.constant = constant
		}
	}
}
