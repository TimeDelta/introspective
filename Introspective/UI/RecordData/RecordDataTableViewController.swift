//
//  RecordDataTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Presentr
import UIKit

import Common
import DependencyInjection
import Settings

final class RecordDataTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
	// MARK: - Static Variables

	private typealias Me = RecordDataTableViewController

	public static let showErrorMessage = Notification.Name("showErrorOnRecordDataScreen")
	public static let showViewController = Notification.Name("showViewController")
	public static let pushToNavigationController = Notification.Name("pushToNavigationController")

	private static let moodId = "mood"
	private static let continuousMoodId = "continuousMood"
	private static let discreteMoodId = "discreteMood"

	private static let log = Log()

	// MARK: - Instance Variables

	private final var viewOrder = [
		Me.moodId,
		"medication",
		"activity",
	]
	private final var viewHeights: [String: CGFloat] = [
		Me.continuousMoodId: 145,
		Me.discreteMoodId: 145,
		"medication": 52,
		"activity": 52,
	]

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		observe(selector: #selector(showViewController), name: Me.showViewController)
		observe(selector: #selector(showErrorMessage), name: Me.showErrorMessage)
		observe(selector: #selector(showRecordActivitiesScreen), name: .showRecordActivitiesScreen)
		observe(selector: #selector(showRecordMedicationsScreen), name: .showRecordMedicationsScreen)
		observe(selector: #selector(useDiscreteMoodChanged), name: MoodUiUtilImpl.useDiscreteMoodChanged)
		observe(selector: #selector(pushToNavigationController), name: Me.pushToNavigationController)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Table view data source

	final override func numberOfSections(in _: UITableView) -> Int {
		1
	}

	final override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
		viewOrder.count
	}

	// MARK: - Table view delegate

	final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let id = getIdFor(indexPath)
		return tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
	}

	final override func tableView(_: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		viewOrder.swapAt(fromIndexPath.row, to.row)
	}

	final override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let id = getIdFor(indexPath)
		if let height = viewHeights[id] {
			return height
		}
		Me.log.error("Failed to retrieve height for id: %@", id)
		// return the largest possible size so that all content is shown
		return viewHeights.map { $0.value }.sorted()[0]
	}

	final override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 1 {
			navigationController?.pushViewController(viewController(named: "medicationsTable"), animated: false)
		} else if indexPath.row == 2 {
			navigationController?.pushViewController(viewController(named: "activitiesTable"), animated: false)
		}
	}

	// MARK: - Received Notifications

	@objc private final func showViewController(notification: Notification) {
		if let controller: UIViewController = value(for: .controller, from: notification) {
			let defaultPresenter = DependencyInjector.get(UiUtil.self).defaultPresenter
			let presenter: Presentr! = value(for: .presenter, from: notification) ?? defaultPresenter
			customPresentViewController(presenter, viewController: controller, animated: false)
		}
	}

	@objc private final func pushToNavigationController(notification: Notification) {
		guard let controller: UIViewController = value(for: .controller, from: notification) else { return }
		if let navigationController = navigationController {
			navigationController.pushViewController(controller, animated: false)
		} else {
			log.error("no navigation controller")
		}
	}

	@objc private final func showErrorMessage(notification: Notification) {
		if let title: String = value(for: .title, from: notification) {
			if let error: Error = value(for: .error, from: notification) {
				if let message: String = value(for: .message, from: notification) {
					showError(title: title, message: message, error: error)
				} else {
					showError(title: title, error: error)
				}
			}
			if let message: String = value(for: .message, from: notification) {
				showError(title: title, message: message)
			} else {
				showError(title: title)
			}
		}
	}

	@objc private final func showRecordActivitiesScreen(notification _: Notification) {
		let controller: RecordActivityTableViewController = viewController(named: "activitiesTable")
		if let navigationController = navigationController {
			navigationController.pushViewController(controller, animated: false)
		} else {
			Me.log.error("no navigation controller")
		}
	}

	@objc private final func showRecordMedicationsScreen(notification _: Notification) {
		let controller: RecordMedicationTableViewController = viewController(named: "medicationsTable")
		if let navigationController = navigationController {
			navigationController.pushViewController(controller, animated: false)
		} else {
			Me.log.error("no navigation controller")
		}
	}

	@objc private final func useDiscreteMoodChanged(notification _: Notification) {
		tableView.reloadData()
	}

	// MARK: - Helper Functions

	private final func getIdFor(_ indexPath: IndexPath) -> String {
		var id = viewOrder[indexPath.row]
		if id == Me.moodId {
			if DependencyInjector.get(Settings.self).discreteMoods {
				id = Me.discreteMoodId
			} else {
				id = Me.continuousMoodId
			}
		}
		return id
	}
}
