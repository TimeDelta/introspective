//
//  RecordMoodTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr

import Common
import DependencyInjection
import Persistence
import Samples
import Settings

final class RecordMoodTableViewCell: UITableViewCell {

	// MARK: - Static Variables

	private typealias Me = RecordMoodTableViewCell
	private static let notePresenter: Presentr = DependencyInjector.get(UiUtil.self).customPresenter(width: .custom(size: 300), height: .custom(size: 200), center: .topCenter)
	private static let ratingPresenter: Presentr = DependencyInjector.get(UiUtil.self).customPresenter(width: .custom(size: 300), height: .custom(size: 70), center: .topCenter)

	private static let ratingChanged = Notification.Name("moodRatingChanged")

	// MARK: - IBOutlets

	@IBOutlet weak final var ratingSlider: UISlider!
	@IBOutlet weak final var ratingRangeLabel: UILabel!
	@IBOutlet weak final var doneButton: UIButton!
	@IBOutlet weak final var addNoteButton: UIButton!
	@IBOutlet weak final var ratingButton: UIButton!
	@IBOutlet weak final var feedbackLabel: UILabel!

	// MARK: - Instance Variables

	/// This is not made private solely for testing purposes
	final var note: String? = nil
	private final var rating: Double = DependencyInjector.get(Settings.self).maxMood / 2 {
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
		observe(selector: #selector(updateUI), name: MoodUiUtilImpl.minRatingChanged)
		observe(selector: #selector(updateUI), name: MoodUiUtilImpl.maxRatingChanged)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Actions

	@IBAction final func ratingChanged(_ sender: Any) {
		let min = DependencyInjector.get(Settings.self).minMood
		let max = DependencyInjector.get(Settings.self).maxMood
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
			let mood = try DependencyInjector.get(MoodDAO.self).createMood(rating: rating, note: note)

			feedbackLabel.text = DependencyInjector.get(MoodUiUtil.self).feedbackMessage(
				for: rating,
				min: mood.minRating,
				max: mood.maxRating)
			feedbackLabel.isHidden = false
			Timer.scheduledTimer(
				timeInterval: 5,
				target: self,
				selector: #selector(hideFeedbackLabel),
				userInfo: nil,
				repeats: false)

			reset()
		} catch {
			log.error("Failed to create or save mood: %@", errorInfo(error))
			NotificationCenter.default.post(
				name: RecordDataTableViewController.showErrorMessage,
				object: self,
				userInfo: info([
					.title: "Failed to save mood rating",
					.error: error,
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
		let min = DependencyInjector.get(Settings.self).minMood
		let max = DependencyInjector.get(Settings.self).maxMood
		rating = (max - min) / 2 + min
	}

	@objc private final func hideFeedbackLabel() {
		feedbackLabel.isHidden = true
	}

	@objc private final func updateUI() {
		let min = DependencyInjector.get(Settings.self).minMood
		let max = DependencyInjector.get(Settings.self).maxMood
		ratingSlider.setValue(Float((rating - min) / (max - min)), animated: false)
		ratingSlider.thumbTintColor = DependencyInjector.get(MoodUiUtil.self).colorForMood(rating: rating, minRating: min, maxRating: max)
		ratingButton.setTitle(DependencyInjector.get(MoodUiUtil.self).valueToString(rating), for: .normal)
		ratingButton.accessibilityValue = DependencyInjector.get(MoodUiUtil.self).valueToString(rating)
		ratingRangeLabel.text = "(\(DependencyInjector.get(MoodUiUtil.self).valueToString(min))-\(DependencyInjector.get(MoodUiUtil.self).valueToString(max)))"
	}
}
