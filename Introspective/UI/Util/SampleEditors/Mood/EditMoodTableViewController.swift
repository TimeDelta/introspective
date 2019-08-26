//
//  EditMoodTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 12/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr

public protocol EditMoodTableViewController: UITableViewController {

	var notificationToSendOnAccept: Notification.Name! { get set }
	var userInfoKey: UserInfoKey { get set }
	var mood: Mood? { get set }
}

public final class EditMoodTableViewControllerImpl: UITableViewController, EditMoodTableViewController {

	// MARK: - Static Variables

	private typealias Me = EditMoodTableViewControllerImpl

	private static let timestampChanged = Notification.Name("moodTimestampChanged")
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
	public final var userInfoKey: UserInfoKey = .mood
	public final var mood: Mood? {
		didSet {
			guard let mood = mood else { return }
			timestamp = mood.date
			rating = mood.rating
			minRating = mood.minRating
			maxRating = mood.maxRating
			note = mood.note
		}
	}

	private final var timestamp: Date = Date()
	private final var rating: Double = 0
	private final var minRating: Double = DependencyInjector.settings.minMood
	private final var maxRating: Double = DependencyInjector.settings.maxMood
	private final var note: String? = nil

	private final let log = Log()

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Save",
			style: .done,
			target: self,
			action: #selector(saveButtonPressed))

		observe(selector: #selector(timestampChanged), name: Me.timestampChanged)
		observe(selector: #selector(ratingChanged), name: .moodRatingChanged)
		observe(selector: #selector(noteChanged), name: Me.noteChanged)
		observe(selector: #selector(useDiscreteMoodChanged), name: MoodUiUtil.useDiscreteMoodChanged)
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
			return getRatingCell(for: indexPath)
		} else if indexPath == Me.noteIndex {
			let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath) as! MoodNoteTableViewCell
			cell.note = note
			cell.notificationToSendOnChange = Me.noteChanged
			return cell
		}
		log.error("Missing cell customization case for edit mood")
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
			let controller = viewController(named: "datePicker", fromStoryboard: "Util") as! SelectDateViewController
			controller.initialDate = timestamp
			controller.notificationToSendOnAccept = Me.timestampChanged
			customPresentViewController(Me.datePresenter, viewController: controller, animated: false)
		}
	}

	// MARK: - Received Notifications

	@objc private final func timestampChanged(notification: Notification) {
		if let timestamp: Date = value(for: .date, from: notification) {
			self.timestamp = timestamp
			tableView.reloadData()
		}
	}

	@objc private final func ratingChanged(notification: Notification) {
		if let rating: Double = value(for: .number, from: notification) {
			self.rating = rating
		}
	}

	@objc private final func noteChanged(notification: Notification) {
		self.note = value(for: .text, from: notification)
	}

	@objc private final func useDiscreteMoodChanged(notification: Notification) {
		tableView.reloadData()
	}

	// MARK: - Actions

	@objc private final func saveButtonPressed(_ sender: Any) {
		do {
			let transaction = DependencyInjector.db.transaction()
			var mood: Mood! = self.mood
			if let localMood = mood {
				if let localMood = localMood as? MoodImpl {
					mood = try transaction.pull(savedObject: localMood)
				} else {// otherwise mood is a Mock and we're testing
					log.debug("Mood not pulled from transaction")
				}
			} else {
				mood = try transaction.new(MoodImpl.self)
				mood.setSource(.introspective)
			}
			mood.date = timestamp
			mood.rating = rating
			mood.note = note
			try retryOnFail({ try transaction.commit() }, maxRetries: 2)
			if let localMood = mood as? MoodImpl {
				mood = try DependencyInjector.db.pull(savedObject: localMood)
			} else { // otherwise mood is a Mock and we're testing
				log.debug("Mood not pulled from database")
			}
			DispatchQueue.main.async {
				NotificationCenter.default.post(
					name: self.notificationToSendOnAccept,
					object: self,
					userInfo: self.info([
						self.userInfoKey: mood as Any,
					]))
			}
			navigationController?.popViewController(animated: false)
		} catch {
			log.error("Failed to save create or save mood: %@", errorInfo(error))
			showError(title: "Failed to save mood", error: error)
		}
	}

	// MARK: - Helper Functions

	private final func getRatingCell(for indexPath: IndexPath) -> UITableViewCell {
		if DependencyInjector.settings.discreteMoods {
			let cell = tableView.dequeueReusableCell(withIdentifier: "integerRating", for: indexPath) as! DiscreteRatingTableViewCell
			cell.rating = Int(rating)
			cell.minRating = Int(minRating)
			cell.maxRating = Int(maxRating)
			return cell
		}
		let cell = tableView.dequeueReusableCell(withIdentifier: "rating", for: indexPath) as! MoodRatingTableViewCell
		cell.rating = rating
		cell.minRating = minRating
		cell.maxRating = maxRating
		return cell
	}
}
