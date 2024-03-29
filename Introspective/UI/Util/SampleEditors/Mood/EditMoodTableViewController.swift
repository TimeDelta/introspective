//
//  EditMoodTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 12/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Presentr
import UIKit

import Common
import DependencyInjection
import Persistence
import Samples
import Settings

public protocol EditMoodTableViewController: UITableViewController, EditViewController {
	var userInfoKey: UserInfoKey { get set }
	var mood: Mood? { get set }
}

public final class EditMoodTableViewControllerImpl: UITableViewController, EditMoodTableViewController {
	// MARK: - Static Variables

	private typealias Me = EditMoodTableViewControllerImpl

	// MARK: Notification Names

	private static let timestampChanged = Notification.Name("moodTimestampChanged")
	private static let noteChanged = Notification.Name("moodNoteChanged")

	// MARK: IndexPaths

	private static let timestampIndex = IndexPath(row: 0, section: 0)
	private static let ratingIndex = IndexPath(row: 1, section: 0)
	private static let noteIndex = IndexPath(row: 0, section: 1)

	// MARK: Presenters

	private static let datePresenter = injected(UiUtil.self).customPresenter(
		width: .full,
		height: .fluid(percentage: 0.4),
		center: .bottomCenter
	)

	// MARK: Logging

	private static let log = Log()

	// MARK: - Instance Variables

	public final var notificationToSendOnAccept: Notification.Name?
	public final var indexPath: IndexPath?
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
	private final var minRating: Double = injected(Settings.self).minMood
	private final var maxRating: Double = injected(Settings.self).maxMood
	private final var note: String?

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Save",
			style: .done,
			target: self,
			action: #selector(saveButtonPressed)
		)

		observe(selector: #selector(timestampChanged), name: Me.timestampChanged)
		observe(selector: #selector(ratingChanged), name: .moodRatingChanged)
		observe(selector: #selector(noteChanged), name: Me.noteChanged)
		observe(selector: #selector(useDiscreteMoodChanged), name: MoodUiUtilImpl.useDiscreteMoodChanged)

		hideKeyboardOnTapNonTextInput()
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Table view data source

	public final override func numberOfSections(in _: UITableView) -> Int {
		2
	}

	public final override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 2
		}
		return 1
	}

	public final override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 1 {
			return "Note"
		}
		return nil
	}

	public final override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		if indexPath == Me.timestampIndex {
			let cell = tableView.dequeueReusableCell(withIdentifier: "timestamp", for: indexPath)
			cell.detailTextLabel?.text = injected(CalendarUtil.self)
				.string(for: timestamp, dateStyle: .medium, timeStyle: .medium)
			return cell
		} else if indexPath == Me.ratingIndex {
			return getRatingCell(for: indexPath)
		} else if indexPath == Me.noteIndex {
			let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath) as! MoodNoteTableViewCell
			cell.note = note
			cell.notificationToSendOnChange = Me.noteChanged
			return cell
		}
		Me.log.error("Missing cell customization case for edit mood")
		return UITableViewCell()
	}

	public final override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath == Me.noteIndex {
			return 131
		}
		return 44
	}

	// MARK: - Table view delegate

	public final override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
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
		note = value(for: .text, from: notification)
	}

	@objc private final func useDiscreteMoodChanged(notification _: Notification) {
		tableView.reloadData()
	}

	// MARK: - Actions

	@objc private final func saveButtonPressed(_: Any) {
		do {
			let transaction = injected(Database.self).transaction()
			var mood: Mood! = self.mood
			if let localMood = mood {
				if let localMood = localMood as? MoodImpl {
					mood = try transaction.pull(savedObject: localMood)
				} else { // otherwise mood is a Mock and we're testing
					Me.log.debug("Mood not pulled from transaction")
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
				mood = try injected(Database.self).pull(savedObject: localMood)
			} else { // otherwise mood is a Mock and we're testing
				Me.log.debug("Mood not pulled from database")
			}
			if let notificationToSendOnAccept = notificationToSendOnAccept {
				post(
					notificationToSendOnAccept,
					userInfo: [
						userInfoKey: mood as Any,
					]
				)
			}
			popFromNavigationController()
		} catch {
			Me.log.error("Failed to save create or save mood: %@", errorInfo(error))
			showError(title: "Failed to save mood", error: error)
		}
	}

	// MARK: - Helper Functions

	private final func getRatingCell(for indexPath: IndexPath) -> UITableViewCell {
		if injected(Settings.self).discreteMoods {
			let cell = tableView.dequeueReusableCell(
				withIdentifier: "integerRating",
				for: indexPath
			) as! DiscreteMoodRatingTableViewCell
			cell.rating = Int(rating)
			cell.minRating = Int(minRating)
			cell.maxRating = Int(maxRating)
			return cell
		}
		let cell = tableView.dequeueReusableCell(
			withIdentifier: "rating",
			for: indexPath
		) as! ContinuousMoodRatingTableViewCell
		cell.rating = rating
		cell.minRating = minRating
		cell.maxRating = maxRating
		return cell
	}
}
