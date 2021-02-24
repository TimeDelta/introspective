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
import Samples
import Settings

final class RecordDataTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
	// MARK: - Static Variables

	private typealias Me = RecordDataTableViewController

	public static let showErrorMessage = Notification.Name("showErrorOnRecordDataScreen")
	public static let showViewController = Notification.Name("showViewController")

	private static let moodId = "mood"
	private static let continuousMoodId = "continuousMood"
	private static let discreteMoodId = "discreteMood"

	private static let fatigueId = "fatigue"
	private static let continuousFatigueId = "continuousFatigue"
	private static let discreteFatigueId = "discreteFatigue"

	private static let medicationId = "medication"
	private static let activityId = "activity"

	private static let log = Log()

	// MARK: - Instance Variables

	private final var viewOrder = [
		Me.moodId,
		Me.fatigueId,
		Me.medicationId,
		Me.activityId,
	]
	private final var viewHeights: [String: CGFloat] = [
		Me.continuousMoodId: 145,
		Me.discreteMoodId: 145,
		Me.continuousFatigueId: 145,
		Me.discreteFatigueId: 145,
		Me.medicationId: 52,
		Me.activityId: 52,
	]

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		observe(selector: #selector(showViewController), name: Me.showViewController)
		observe(selector: #selector(showErrorMessage), name: Me.showErrorMessage)
		observe(selector: #selector(showRecordActivitiesScreen), name: .showRecordActivitiesScreen)
		observe(selector: #selector(showRecordMedicationsScreen), name: .showRecordMedicationsScreen)
		observe(selector: #selector(useDiscreteMoodChanged), name: MoodUiUtilImpl.useDiscreteMoodChanged)
		observe(selector: #selector(useDiscreteFatigueChanged), name: FatigueUiUtilImpl.useDiscreteFatigueChanged)
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
		if indexPath.row == viewOrder.firstIndex(of: Me.medicationId) {
			navigationController?.pushViewController(viewController(named: "medicationsTable"), animated: false)
		} else if indexPath.row == viewOrder.firstIndex(of: Me.activityId) {
			navigationController?.pushViewController(viewController(named: "activitiesTable"), animated: false)
		}
	}

	final override func tableView(
		_ tableView: UITableView,
		trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
	) -> UISwipeActionsConfiguration? {
		var actions: [UIContextualAction] = []
		let id = getIdFor(indexPath)
		if isMoodId(id) {
			if let _ = try? injected(MoodDAO.self).getMostRecentMood() {
				actions.append(getEditLastMoodAction())
			}
		}
		if isFatigueId(id) {
			if let _ = try? injected(FatigueDAO.self).getMostRecentFatigue() {
				actions.append(getEditLastFatigueAction())
			}
		}
		return UISwipeActionsConfiguration(actions: actions)
	}

	// MARK: - Received Notifications

	@objc private final func showViewController(notification: Notification) {
		if let controller: UIViewController = value(for: .controller, from: notification) {
			let presenter: Presentr! = value(for: .presenter, from: notification) ?? injected(UiUtil.self)
				.defaultPresenter
			customPresentViewController(presenter, viewController: controller, animated: false)
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

	@objc private final func useDiscreteFatigueChanged(notification _: Notification) {
		tableView.reloadData()
	}

	// MARK: - Helper Functions

	private final func getIdFor(_ indexPath: IndexPath) -> String {
		let id = viewOrder[indexPath.row]
		if id == Me.moodId {
			if injected(Settings.self).discreteMoods {
				return Me.discreteMoodId
			}
			return Me.continuousMoodId
		}
		if id == Me.fatigueId {
			if injected(Settings.self).discreteFatigue {
				return Me.discreteFatigueId
			}
			return Me.continuousFatigueId
		}
		return id
	}

	private final func isMoodId(_ id: String) -> Bool {
		id == Me.discreteMoodId || id == Me.continuousMoodId || id == Me.moodId
	}

	private final func isFatigueId(_ id: String) -> Bool {
		id == Me.discreteFatigueId || id == Me.continuousFatigueId || id == Me.fatigueId
	}

	private final func getEditLastMoodAction() -> UIContextualAction {
		let action = injected(UiUtil.self).contextualAction(
			style: .normal,
			title: "✎ Last"
		) { _, _, completion in
			do {
				guard let mood = try injected(MoodDAO.self).getMostRecentMood() else {
					Me.log.error("Edit last mood action triggered with no mood records")
					completion(false)
					return
				}
				let controller = self.viewController(
					named: "editMood",
					fromStoryboard: "Util"
				) as! EditMoodTableViewController
				controller.mood = mood
				self.pushToNavigationController(controller)
			} catch {
				self.showError(title: "Failed to retrieve most recent mood entry", error: error)
			}
		}
		action.backgroundColor = .orange
		return action
	}

	private final func getEditLastFatigueAction() -> UIContextualAction {
		let action = injected(UiUtil.self).contextualAction(
			style: .normal,
			title: "✎ Last"
		) { _, _, completion in
			do {
				guard let fatigue = try injected(FatigueDAO.self).getMostRecentFatigue() else {
					Me.log.error("Edit last fatigue action triggered with no fatigue records")
					completion(false)
					return
				}
				let controller = self.viewController(
					named: "editFatigue",
					fromStoryboard: "Util"
				) as! EditFatigueTableViewController
				controller.fatigue = fatigue
				self.pushToNavigationController(controller)
			} catch {
				self.showError(title: "Failed to retrieve most recent fatigue entry", error: error)
			}
		}
		action.backgroundColor = .orange
		return action
	}
}
