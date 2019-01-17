//
//  RecordMoodTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr

final class RecordMoodTableViewCell: UITableViewCell {

	// MARK: - Static Variables

	private typealias Me = RecordMoodTableViewCell
	private static let notePresenter: Presentr = DependencyInjector.util.ui.customPresenter(width: .custom(size: 300), height: .custom(size: 200), center: .topCenter)
	private static let ratingPresenter: Presentr = DependencyInjector.util.ui.customPresenter(width: .custom(size: 300), height: .custom(size: 70), center: .topCenter)

	private static let ratingChanged = Notification.Name("moodRatingChanged")

	// MARK: - IBOutlets

	@IBOutlet weak final var ratingSlider: UISlider!
	@IBOutlet weak final var ratingRangeLabel: UILabel!
	@IBOutlet weak final var doneButton: UIButton!
	@IBOutlet weak final var addNoteButton: UIButton!
	@IBOutlet weak final var ratingButton: UIButton!

	// MARK: - Instance Variables

	/// This is not made private solely for testing purposes
	final var note: String? = nil
	private final var rating: Double = DependencyInjector.settings.maxMood / 2 {
		didSet { updateUI() }
	}

	private final let log = Log()

	// MARK: - UIView Overrides

	public final override func awakeFromNib() {
		super.awakeFromNib()
		reset()
		updateUI()
		observe(selector: #selector(noteSaved), name: MoodNoteViewController.noteSavedNotification)
		observe(selector: #selector(ratingSaved), name: Me.ratingChanged)
		observe(selector: #selector(updateUI), name: MoodUiUtil.minRatingChanged)
		observe(selector: #selector(updateUI), name: MoodUiUtil.maxRatingChanged)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Actions

	@IBAction final func ratingChanged(_ sender: Any) {
		let min = DependencyInjector.settings.minMood
		let max = DependencyInjector.settings.maxMood
		rating = Double(ratingSlider.value) * (max - min) + min
	}

	@IBAction final func setRating(_ sender: Any) {
		let controller: RecordMoodRatingViewController = viewController(named: "moodRating", fromStoryboard: "RecordData")
		controller.rating = rating
		controller.notificationToSendOnAccept = Me.ratingChanged
		NotificationCenter.default.post(
			name: RecordDataTableViewController.showViewController,
			object: self,
			userInfo: info([
				.controller: controller,
				.presenter: Me.ratingPresenter,
			]))
	}

	@IBAction final func presentMoodNoteController(_ sender: Any) {
		let controller: MoodNoteViewController = viewController(named: "moodNote", fromStoryboard: "RecordData")
		controller.note = note ?? ""
		NotificationCenter.default.post(
			name: RecordDataTableViewController.showViewController,
			object: self,
			userInfo: info([
				.controller: controller,
				.presenter: Me.notePresenter,
			]))
	}

	@IBAction final func doneButtonPressed(_ sender: Any) {
		do {
			let transaction = DependencyInjector.db.transaction()
			let mood = try DependencyInjector.sample.mood(using: transaction)
			mood.timestamp = Date()
			mood.rating = rating
			mood.note = note
			mood.minRating = DependencyInjector.settings.minMood
			mood.maxRating = DependencyInjector.settings.maxMood
			mood.setSource(.introspective)
			try transaction.commit()

			reset()
		} catch {
			var title = "Failed to save mood rating"
			var message = "Sorry for the inconvenience"
			if let error = error as? DisplayableError {
				title = error.displayableTitle
				if let description = error.displayableDescription {
					message = description
				}
			}
			log.error("Failed to create or save mood: %@", errorInfo(error))
			NotificationCenter.default.post(
				name: RecordDataTableViewController.showErrorMessage,
				object: self,
				userInfo: info([
					.title: title,
					.message: message,
				]))
		}
	}

	// MARK: - Received Notifications

	@objc private final func noteSaved(notification: Notification) {
		if let note: String = value(for: .text, from: notification) {
			self.note = note
			addNoteButton.setTitle(note, for: .normal)
			addNoteButton.accessibilityValue = "Add Note"
		}
	}

	@objc private final func ratingSaved(notification: Notification) {
		guard let rating: Double = value(for: .number, from: notification) else { return }
		self.rating = rating
	}

	// MARK: - Helper Functions

	private final func reset() {
		note = nil
		addNoteButton.setTitle("Add Note", for: .normal)
		let min = DependencyInjector.settings.minMood
		let max = DependencyInjector.settings.maxMood
		rating = (max - min) / 2 + min
	}

	@objc private final func updateUI() {
		let min = DependencyInjector.settings.minMood
		let max = DependencyInjector.settings.maxMood
		ratingSlider.setValue(Float((rating - min) / (max - min)), animated: false)
		ratingSlider.thumbTintColor = MoodUiUtil.colorForMood(rating: rating, maxRating: max)
		ratingButton.setTitle(MoodUiUtil.valueToString(rating), for: .normal)
		ratingButton.accessibilityValue = MoodUiUtil.valueToString(rating)
		ratingRangeLabel.text = "(\(MoodUiUtil.valueToString(min))-\(MoodUiUtil.valueToString(max)))"
	}
}
