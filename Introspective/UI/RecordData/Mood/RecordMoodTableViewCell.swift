//
//  RecordMoodTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import os

final class RecordMoodTableViewCell: UITableViewCell {

	// MARK: - Static Variables

	private typealias Me = RecordMoodTableViewCell
	private static let notePresenter: Presentr = DependencyInjector.util.ui.customPresenter(width: .custom(size: 300), height: .custom(size: 200), center: .topCenter)
	private static let ratingPresenter: Presentr = DependencyInjector.util.ui.customPresenter(width: .custom(size: 300), height: .custom(size: 70), center: .topCenter)

	private static let ratingChanged = Notification.Name("moodRatingChanged")

	// MARK: - IBOutlets

	@IBOutlet weak final var ratingSlider: UISlider!
	@IBOutlet weak final var outOfMaxRatingLabel: UILabel!
	@IBOutlet weak final var doneButton: UIButton!
	@IBOutlet weak final var addNoteButton: UIButton!
	@IBOutlet weak final var ratingButton: UIButton!

	// MARK: - Instance Variables

	/// This is not made private solely for testing purposes
	final var note: String? = nil
	private final var rating: Double = DependencyInjector.settings.maxMood / 2 {
		didSet { updateUI() }
	}

	// MARK: - UIView Overrides

	public final override func awakeFromNib() {
		super.awakeFromNib()
		reset()
		updateUI()
		observe(selector: #selector(noteSaved), name: MoodNoteViewController.noteSavedNotification)
		observe(selector: #selector(ratingSaved), name: Me.ratingChanged)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Actions

	@IBAction final func ratingChanged(_ sender: Any) {
		let maxValue = DependencyInjector.settings.maxMood
		rating = Double(ratingSlider.value) * maxValue
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
			let mood = try DependencyInjector.sample.mood()
			mood.timestamp = Date()
			mood.rating = Double(ratingSlider.value) * DependencyInjector.settings.maxMood
			mood.note = note
			mood.maxRating = DependencyInjector.settings.maxMood
			mood.setSource(.introspective)
			DependencyInjector.db.save()

			reset()
		} catch {
			os_log("Failed to create mood: %@", type: .error, error.localizedDescription)
			NotificationCenter.default.post(
				name: RecordDataTableViewController.showErrorMessage,
				object: self,
				userInfo: info([
					.title: "Failed to save mood rating",
					.message: "Sorry for the inconvenience",
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
		rating = DependencyInjector.settings.maxMood / 2
	}

	private final func updateUI() {
		let maxRating = DependencyInjector.settings.maxMood
		ratingSlider.setValue(Float(rating / maxRating), animated: false)
		ratingSlider.thumbTintColor = MoodUiUtil.colorForMood(rating: rating, maxRating: maxRating)
		ratingButton.setTitle(MoodUiUtil.valueToString(rating), for: .normal)
		ratingButton.accessibilityValue = MoodUiUtil.valueToString(rating)
		outOfMaxRatingLabel.text = "/ " + MoodUiUtil.valueToString(maxRating)
	}
}
