//
//  EditPainTableViewController.swift
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

public protocol EditPainTableViewController: UITableViewController, EditViewController {
	var userInfoKey: UserInfoKey { get set }
	var pain: Pain? { get set }
}

public final class EditPainTableViewControllerImpl: UITableViewController, EditPainTableViewController {
	// MARK: - Static Variables

	private typealias Me = EditPainTableViewControllerImpl

	// MARK: Notification Names

	private static let timestampChanged = Notification.Name("editPainTimestampChanged")
	private static let locationChanged = Notification.Name("editPainLocationChanged")
	private static let noteChanged = Notification.Name("editPainNoteChanged")

	// MARK: IndexPaths

	private static let timestampIndex = IndexPath(row: 0, section: 0)
	private static let ratingIndex = IndexPath(row: 1, section: 0)
	private static let locationIndex = IndexPath(row: 2, section: 0)
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
	/// The user info key to use when sending back the edited pain record
	public final var userInfoKey: UserInfoKey = .pain
	public final var pain: Pain? {
		didSet {
			guard let pain = pain else { return }
			timestamp = pain.date
			rating = pain.rating
			minRating = pain.minRating
			maxRating = pain.maxRating
			location = pain.location
			note = pain.note
		}
	}

	private var timestamp: Date = Date()
	private var rating: Double = 0
	private var minRating: Double = injected(Settings.self).minPain
	private var maxRating: Double = injected(Settings.self).maxPain
	private var location: String?
	private var note: String?

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
		observe(selector: #selector(ratingChanged), name: .painRatingChanged)
		observe(selector: #selector(locationChanged), name: Me.locationChanged)
		observe(selector: #selector(noteChanged), name: Me.noteChanged)
		observe(selector: #selector(useDiscretePainChanged), name: PainUiUtilImpl.useDiscretePainChanged)

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
			return 3
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
			return getTimestampCell(for: indexPath)
		} else if indexPath == Me.ratingIndex {
			return getRatingCell(for: indexPath)
		} else if indexPath == Me.locationIndex {
			return getLocationCell(for: indexPath)
		} else if indexPath == Me.noteIndex {
			return getNoteCell(for: indexPath)
		}
		Me.log.error("Missing cell customization case for edit pain")
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

	@objc private final func locationChanged(notification: Notification) {
		if let location: String? = value(for: .text, from: notification) {
			self.location = location
		}
	}

	@objc private final func noteChanged(notification: Notification) {
		note = value(for: .text, from: notification)
	}

	@objc private final func useDiscretePainChanged(notification _: Notification) {
		tableView.reloadData()
	}

	// MARK: - Actions

	@objc private final func saveButtonPressed(_: Any) {
		do {
			let transaction = injected(Database.self).transaction()
			var pain: Pain! = self.pain
			if let localPain = pain {
				if let localPain = localPain as? PainImpl {
					pain = try transaction.pull(savedObject: localPain)
				} else { // otherwise pain is a Mock and we're testing
					Me.log.debug("Pain not pulled from transaction")
				}
			} else {
				pain = try transaction.new(PainImpl.self)
			}
			pain.date = timestamp
			pain.rating = rating
			pain.note = note
			try retryOnFail({ try transaction.commit() }, maxRetries: 2)
			if let localPain = pain as? PainImpl {
				pain = try injected(Database.self).pull(savedObject: localPain)
			} else { // otherwise pain is a Mock and we're testing
				Me.log.debug("Pain not pulled from database")
			}
			if let notificationToSendOnAccept = notificationToSendOnAccept {
				post(
					notificationToSendOnAccept,
					userInfo: [
						userInfoKey: pain as Any,
					]
				)
			}
			popFromNavigationController()
		} catch {
			Me.log.error("Failed to save create or save pain: %@", errorInfo(error))
			showError(title: "Failed to save pain", error: error)
		}
	}

	// MARK: - Helper Functions

	private func getTimestampCell(for indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "timestamp", for: indexPath)
		cell.detailTextLabel?.text = injected(CalendarUtil.self)
			.string(for: timestamp, dateStyle: .medium, timeStyle: .medium)
		return cell
	}

	private func getRatingCell(for indexPath: IndexPath) -> UITableViewCell {
		if injected(Settings.self).discretePain {
			let cell = tableView.dequeueReusableCell(
				withIdentifier: "integerRating",
				for: indexPath
			) as! DiscretePainRatingTableViewCell
			cell.rating = Int(rating)
			cell.minRating = Int(minRating)
			cell.maxRating = Int(maxRating)
			return cell
		}
		let cell = tableView.dequeueReusableCell(
			withIdentifier: "rating",
			for: indexPath
		) as! ContinuousPainRatingTableViewCell
		cell.rating = rating
		cell.minRating = minRating
		cell.maxRating = maxRating
		return cell
	}

	private func getLocationCell(for indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(
			withIdentifier: "location",
			for: indexPath
		) as! PainLocationTableViewCell
		cell.location = location
		cell.notificationToSendOnChange = Me.locationChanged
		return cell
	}

	private func getNoteCell(for indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(
			withIdentifier: "note",
			for: indexPath
		) as! PainNoteTableViewCell
		cell.note = note
		cell.notificationToSendOnChange = Me.noteChanged
		return cell
	}
}
