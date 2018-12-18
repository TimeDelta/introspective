//
//  EditMoodTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 12/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import os

public final class EditMoodTableViewController: UITableViewController {

	// MARK: - Static Variables

	private typealias Me = EditMoodTableViewController

	private static let timestampChanged = Notification.Name("moodTimestampChanged")
	private static let ratingChanged = Notification.Name("moodRatingChanged")
	private static let noteChanged = Notification.Name("moodNoteChanged")

	private static let timestampIndex = IndexPath(row: 0, section: 0)
	private static let ratingIndex = IndexPath(row: 1, section: 0)
	private static let noteIndex = IndexPath(row: 0, section: 1)

	private static let datePresenter = DependencyInjector.util.ui.customPresenter(
		width: .full,
		height: .fluid(percentage: 0.4),
		center: .bottomCenter)

	// MARK: - Instance Variables

	public final var notificationToSendOnAccept: Notification.Name!
	public final var mood: Mood? {
		didSet {
			guard let mood = mood else { return }
			timestamp = mood.timestamp
			rating = mood.rating
			maxRating = mood.maxRating
			note = mood.note
		}
	}

	private final var timestamp: Date = Date()
	private final var rating: Double = 0
	private final var maxRating: Double = DependencyInjector.settings.maxMood
	private final var note: String? = nil

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Save",
			style: .done,
			target: self,
			action: #selector(saveButtonPressed))

		NotificationCenter.default.addObserver(self, selector: #selector(timestampChanged), name: Me.timestampChanged, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(ratingChanged), name: Me.ratingChanged, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(noteChanged), name: Me.noteChanged, object: nil)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Table view data source

	public final override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	public final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 2
		}
		return 1
	}

	public final override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 1 {
			return "Note"
		}
		return nil
	}

	public final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath == Me.timestampIndex {
			let cell = tableView.dequeueReusableCell(withIdentifier: "timestamp", for: indexPath)
			cell.detailTextLabel?.text = DependencyInjector.util.calendar.string(for: timestamp, dateStyle: .medium, timeStyle: .medium)
			return cell
		} else if indexPath == Me.ratingIndex {
			let cell = tableView.dequeueReusableCell(withIdentifier: "rating", for: indexPath) as! MoodRatingTableViewCell
			cell.rating = rating
			cell.maxRating = maxRating
			cell.notificationToSendOnChange = Me.ratingChanged
			return cell
		} else if indexPath == Me.noteIndex {
			let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath) as! MoodNoteTableViewCell
			cell.note = note
			cell.notificationToSendOnChange = Me.noteChanged
			return cell
		}
		os_log("Missing cell customization case for edit mood", type: .error)
		return UITableViewCell()
	}

	public final override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath == Me.noteIndex {
			return 131
		}
		return 44
	}

	// MARK: - Table view delegate

	public final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath == Me.timestampIndex {
			let controller = UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "datePicker") as! SelectDateViewController
			controller.initialDate = timestamp
			controller.notificationToSendOnAccept = Me.timestampChanged
			customPresentViewController(Me.datePresenter, viewController: controller, animated: false)
		}
	}

	// MARK: - Received Notifications

	@objc private final func timestampChanged(notification: Notification) {
		if let timestamp = notification.object as? Date {
			self.timestamp = timestamp
			tableView.reloadData()
		} else {
			os_log("Wrong object type for mood timestamp changed notification", type: .error)
		}
	}

	@objc private final func ratingChanged(notification: Notification) {
		if let rating = notification.object as? Double {
			self.rating = rating
		} else {
			os_log("Wrong object type for mood rating changed notification", type: .error)
		}
	}

	@objc private final func noteChanged(notification: Notification) {
		if let note = notification.object as? String? {
			self.note = note
		} else {
			os_log("Wrong object type for mood note change notification", type: .error)
		}
	}

	// MARK: - Actions

	@objc private final func saveButtonPressed(_ sender: Any) {
		do {
			if mood == nil {
				mood = try DependencyInjector.sample.mood()
			}
			mood?.timestamp = timestamp
			mood?.rating = rating
			mood?.note = note
			DependencyInjector.db.save()
			DispatchQueue.main.async {
				NotificationCenter.default.post(name: self.notificationToSendOnAccept, object: self.mood!)
			}
			navigationController?.popViewController(animated: true)
		} catch {
			os_log("Failed to save create mood: %@", type: .error, error.localizedDescription)
			showError(title: "Failed to save mood", message: "Sorry for the inconvenience")
		}
	}
}
