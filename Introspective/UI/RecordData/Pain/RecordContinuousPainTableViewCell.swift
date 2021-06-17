//
//  RecordContinuousPainTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 6/16/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import UIKit

import Presentr
import UIKit

import Common
import DependencyInjection
import Persistence
import Samples
import Settings

final class RecordContinuousPainTableViewCell: UITableViewCell {
	// MARK: - Static Variables

	private typealias Me = RecordContinuousPainTableViewCell

	private static let notePresenter: Presentr = injected(UiUtil.self)
		.customPresenter(width: .custom(size: 300), height: .custom(size: 200), center: .topCenter)
	private static let ratingPresenter: Presentr = injected(UiUtil.self)
		.customPresenter(width: .custom(size: 300), height: .custom(size: 70), center: .topCenter)

	private static let ratingChangedNotification = Notification.Name("recordPainRatingChanged")
	private static let noteChangedNotification = Notification.Name("recordPainNoteChanged")

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var ratingSlider: UISlider!
	@IBOutlet final var ratingRangeLabel: UILabel!
	@IBOutlet final var doneButton: UIButton!
	@IBOutlet final var locationTextField: UITextField!
	@IBOutlet final var addNoteButton: UIButton!
	@IBOutlet final var ratingButton: UIButton!
	@IBOutlet final var feedbackLabel: UILabel!

	// MARK: - Instance Variables

	private var note: String?
	private var rating: Double = injected(Settings.self).maxPain / 2 {
		didSet { updateUI() }
	}

	// MARK: - UIView Overrides

	public final override func awakeFromNib() {
		super.awakeFromNib()
		reset()
		updateUI()
		observe(selector: #selector(noteSaved), name: Me.noteChangedNotification)
		observe(selector: #selector(ratingSaved), name: Me.ratingChangedNotification)
		observe(selector: #selector(updateUI), name: PainUiUtilImpl.minRatingChanged)
		observe(selector: #selector(updateUI), name: PainUiUtilImpl.maxRatingChanged)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Actions

	@IBAction final func ratingChanged(_: Any) {
		let min = injected(Settings.self).minPain
		let max = injected(Settings.self).maxPain
		rating = Double(ratingSlider.value) * (max - min) + min
	}

	@IBAction final func setRating(_: Any) {
		let controller: RecordNumberViewController = viewController(
			named: "recordNumber",
			fromStoryboard: "RecordData"
		)
		controller.min = injected(Settings.self).minPain
		controller.max = injected(Settings.self).maxPain
		controller.number = rating
		controller.notificationToSendOnAccept = Me.ratingChangedNotification
		NotificationCenter.default.post(
			name: RecordDataTableViewController.showViewController,
			object: self,
			userInfo: info([
				.controller: controller,
				.presenter: Me.ratingPresenter,
			])
		)
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

	@IBAction final func doneButtonPressed(_: Any) {
		do {
			let pain = try injected(PainDAO.self).createPain(
				rating: rating,
				location: locationTextField.text,
				note: note
			)

			feedbackLabel.text = injected(PainUiUtil.self).feedbackMessage(
				for: rating,
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
		} catch {
			Me.log.error("Failed to create or save Pain: %@", errorInfo(error))
			DispatchQueue.main.async {
				injected(NotificationUtil.self).post(
					RecordDataTableViewController.showErrorMessage,
					object: self,
					userInfo: [
						.title: "Failed to save Pain rating",
						.error: error,
					]
				)
			}
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
		locationTextField.text = nil
		addNoteButton.setTitle("Add Note", for: .normal)
		let min = injected(Settings.self).minPain
		let max = injected(Settings.self).maxPain
		rating = (max - min) / 2 + min
	}

	@objc private final func hideFeedbackLabel() {
		feedbackLabel.isHidden = true
	}

	@objc private final func updateUI() {
		let min = injected(Settings.self).minPain
		let max = injected(Settings.self).maxPain
		ratingSlider.setValue(Float((rating - min) / (max - min)), animated: false)
		ratingSlider.thumbTintColor = injected(PainUiUtil.self)
			.colorForPain(rating: rating, minRating: min, maxRating: max)
		ratingButton.setTitle(injected(PainUiUtil.self).valueToString(rating), for: .normal)
		ratingButton.accessibilityValue = injected(PainUiUtil.self).valueToString(rating)
		ratingRangeLabel
			.text =
			"(\(injected(PainUiUtil.self).valueToString(min))-\(injected(PainUiUtil.self).valueToString(max)))"
	}
}
