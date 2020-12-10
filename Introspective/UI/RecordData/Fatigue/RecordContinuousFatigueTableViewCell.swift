//
//  RecordContinuousFatigueTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 12/8/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Presentr
import UIKit

import Common
import DependencyInjection
import Persistence
import Samples
import Settings

final class RecordContinuousFatigueTableViewCell: UITableViewCell {
	// MARK: - Static Variables

	private typealias Me = RecordContinuousFatigueTableViewCell

	private static let notePresenter: Presentr = injected(UiUtil.self)
		.customPresenter(width: .custom(size: 300), height: .custom(size: 200), center: .topCenter)
	private static let ratingPresenter: Presentr = injected(UiUtil.self)
		.customPresenter(width: .custom(size: 300), height: .custom(size: 70), center: .topCenter)

	private static let ratingChanged = Notification.Name("fatigueRatingChanged")
	private static let noteChangedNotification = Notification.Name("fatigueNoteChanged")

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var ratingSlider: UISlider!
	@IBOutlet final var ratingRangeLabel: UILabel!
	@IBOutlet final var doneButton: UIButton!
	@IBOutlet final var addNoteButton: UIButton!
	@IBOutlet final var ratingButton: UIButton!
	@IBOutlet final var feedbackLabel: UILabel!

	// MARK: - Instance Variables

	/// This is not made private solely for testing purposes
	final var note: String?
	private final var rating: Double = injected(Settings.self).maxFatigue / 2 {
		didSet { updateUI() }
	}

	// MARK: - UIView Overrides

	public final override func awakeFromNib() {
		super.awakeFromNib()
		reset()
		updateUI()
		observe(selector: #selector(noteSaved), name: Me.noteChangedNotification)
		observe(selector: #selector(ratingSaved), name: Me.ratingChanged)
		observe(selector: #selector(updateUI), name: FatigueUiUtilImpl.minRatingChanged)
		observe(selector: #selector(updateUI), name: FatigueUiUtilImpl.maxRatingChanged)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Actions

	@IBAction final func ratingChanged(_: Any) {
		let min = injected(Settings.self).minFatigue
		let max = injected(Settings.self).maxFatigue
		rating = Double(ratingSlider.value) * (max - min) + min
	}

	@IBAction final func setRating(_: Any) {
		let controller: RecordNumberViewController = viewController(
			named: "recordNumber",
			fromStoryboard: "RecordData"
		)
		controller.min = injected(Settings.self).minFatigue
		controller.max = injected(Settings.self).maxFatigue
		controller.number = rating
		controller.notificationToSendOnAccept = Me.ratingChanged
		NotificationCenter.default.post(
			name: RecordDataTableViewController.showViewController,
			object: self,
			userInfo: info([
				.controller: controller,
				.presenter: Me.ratingPresenter,
			])
		)
	}

	@IBAction final func presentFatigueNoteController(_: Any) {
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

	@IBAction final func doneButtonPressed(_: Any) {
		do {
			let fatigue = try injected(FatigueDAO.self).createFatigue(rating: rating, note: note)

			feedbackLabel.text = injected(FatigueUiUtil.self).feedbackMessage(
				for: rating,
				min: fatigue.minRating,
				max: fatigue.maxRating
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
		} catch {
			Me.log.error("Failed to create or save fatigue: %@", errorInfo(error))
			NotificationCenter.default.post(
				name: RecordDataTableViewController.showErrorMessage,
				object: self,
				userInfo: info([
					.title: "Failed to save fatigue rating",
					.error: error,
				])
			)
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
		let min = injected(Settings.self).minFatigue
		let max = injected(Settings.self).maxFatigue
		rating = (max - min) / 2 + min
	}

	@objc private final func hideFeedbackLabel() {
		feedbackLabel.isHidden = true
	}

	@objc private final func updateUI() {
		let min = injected(Settings.self).minFatigue
		let max = injected(Settings.self).maxFatigue
		ratingSlider.setValue(Float((rating - min) / (max - min)), animated: false)
		ratingSlider.thumbTintColor = injected(FatigueUiUtil.self)
			.colorForFatigue(rating: rating, minRating: min, maxRating: max)
		ratingButton.setTitle(injected(FatigueUiUtil.self).valueToString(rating), for: .normal)
		ratingButton.accessibilityValue = injected(FatigueUiUtil.self).valueToString(rating)
		ratingRangeLabel
			.text =
			"(\(injected(FatigueUiUtil.self).valueToString(min))-\(injected(FatigueUiUtil.self).valueToString(max)))"
	}
}
