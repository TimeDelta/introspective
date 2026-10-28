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

	private static let painId = "pain"
	private static let continuousPainId = "continuousPain"
	private static let discretePainId = "discretePain"

	private static let medicationId = "medication"
	private static let activityId = "activity"

	private static let log = Log()

	// MARK: - Instance Variables

	private final var viewOrder = [
		Me.moodId,
		Me.painId,
		Me.fatigueId,
		Me.medicationId,
		Me.activityId,
	]
	private final var viewHeights: [String: CGFloat] = [
		Me.continuousMoodId: 145,
		Me.discreteMoodId: 145,
		Me.continuousFatigueId: 145,
		Me.discreteFatigueId: 145,
		Me.continuousPainId: 180,
		Me.discretePainId: 180,
		Me.medicationId: 52,
		Me.activityId: 52,
	]

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Mood History", style: .plain,
			target: self, action: #selector(showMoodHistory))
		observe(selector: #selector(showViewController), name: Me.showViewController)
		observe(selector: #selector(showErrorMessage), name: Me.showErrorMessage)
		observe(selector: #selector(showRecordActivitiesScreen), name: .showRecordActivitiesScreen)
		observe(selector: #selector(showRecordMedicationsScreen), name: .showRecordMedicationsScreen)
		observe(selector: #selector(reloadData), name: MoodUiUtilImpl.useDiscreteMoodChanged)
		observe(selector: #selector(reloadData), name: FatigueUiUtilImpl.useDiscreteFatigueChanged)
		observe(selector: #selector(reloadData), name: PainUiUtilImpl.useDiscretePainChanged)

		hideKeyboardOnTapNonTextInput()
	}

	@objc private func showMoodHistory() {
		pushToNavigationController(MoodHistoryViewController(style: .grouped))
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
		if isPainId(id) {
			if let _ = try? injected(PainDAO.self).getMostRecentPain() {
				actions.append(getEditLastPainAction())
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

	@objc private func reloadData(notification _: Notification) {
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
		if id == Me.painId {
			if injected(Settings.self).discretePain {
				return Me.discretePainId
			}
			return Me.continuousPainId
		}
		return id
	}

	private final func isMoodId(_ id: String) -> Bool {
		id == Me.discreteMoodId || id == Me.continuousMoodId || id == Me.moodId
	}

	private final func isFatigueId(_ id: String) -> Bool {
		id == Me.discreteFatigueId || id == Me.continuousFatigueId || id == Me.fatigueId
	}

	private func isPainId(_ id: String) -> Bool {
		id == Me.discretePainId || id == Me.continuousPainId || id == Me.painId
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

	private func getEditLastPainAction() -> UIContextualAction {
		let action = injected(UiUtil.self).contextualAction(
			style: .normal,
			title: "✎ Last"
		) { _, _, completion in
			do {
				guard let pain = try injected(PainDAO.self).getMostRecentPain() else {
					Me.log.error("Edit last pain action triggered with no pain records")
					completion(false)
					return
				}
				let controller = self.viewController(
					named: "editPain",
					fromStoryboard: "Util"
				) as! EditPainTableViewController
				controller.pain = pain
				self.pushToNavigationController(controller)
			} catch {
				self.showError(title: "Failed to retrieve most recent pain entry", error: error)
			}
		}
		action.backgroundColor = .orange
		return action
	}
}

/// A focused review flow alongside the existing quick recording controls.
private final class MoodHistoryViewController: UITableViewController, UISearchResultsUpdating {
	private let period = UISegmentedControl(items: ["Today", "7 Days", "30 Days"])
	private let search = UISearchController(searchResultsController: nil)
	private var moods: [Mood] = []
	private var displayed: [Mood] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Mood History"
		tableView.accessibilityIdentifier = "moodHistory"
		period.selectedSegmentIndex = 1
		period.addTarget(self, action: #selector(reloadMoods), for: .valueChanged)
		period.accessibilityLabel = "Mood history period"
		let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 52))
		period.translatesAutoresizingMaskIntoConstraints = false
		header.addSubview(period)
		NSLayoutConstraint.activate([
			period.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
			period.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16),
			period.centerYAnchor.constraint(equalTo: header.centerYAnchor),
		])
		tableView.tableHeaderView = header
		search.searchResultsUpdater = self
		search.obscuresBackgroundDuringPresentation = false
		search.searchBar.placeholder = "Search mood notes"
		navigationItem.searchController = search
		navigationItem.hidesSearchBarWhenScrolling = false
		definesPresentationContext = true
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
			target: self, action: #selector(addMood))
		navigationItem.rightBarButtonItem?.accessibilityLabel = "Add mood check-in"
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(reloadMoods), for: .valueChanged)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		reloadMoods()
	}

	@objc private func reloadMoods() {
		defer { refreshControl?.endRefreshing() }
		let days = [1, 7, 30][period.selectedSegmentIndex]
		let interval = MoodReviewSummary.dateInterval(forLastDays: days)
		do {
			moods = try injected(MoodDAO.self).getMoods(from: interval.start, to: interval.end)
				.filter { $0.date >= interval.start && $0.date < interval.end }
				.sorted { $0.date > $1.date }
			updateSearchResults(for: search)
		} catch { showError(title: "Could not load mood history", error: error) }
	}

	func updateSearchResults(for searchController: UISearchController) {
		let text = (searchController.searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
		displayed = text.isEmpty ? moods : moods.filter {
			($0.note ?? "").range(of: text, options: [.caseInsensitive, .diacriticInsensitive]) != nil
		}
		tableView.reloadData()
	}

	override func numberOfSections(in tableView: UITableView) -> Int { 2 }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		section == 0 ? 1 : displayed.count
	}
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		section == 0 ? "Summary" : "Check-ins"
	}
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		if section == 1 { return displayed.isEmpty ? "No matching check-ins. Tap + to record a mood, including a missed check-in." : nil }
		let summary = MoodReviewSummary(moods: displayed)
		var text = "Average across displayed check-ins, adjusted for each entry's original scale. 0% is the lowest rating; 100% is the highest."
		if summary.ratedCheckInCount < summary.checkInCount {
			text += " Entries with invalid or missing scales are excluded from the average."
		}
		return text
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
		cell.textLabel?.numberOfLines = 0
		cell.detailTextLabel?.numberOfLines = 0
		if indexPath.section == 0 {
			let summary = MoodReviewSummary(moods: displayed)
			cell.textLabel?.text = "\(summary.checkInCount) check-ins on \(summary.recordedDayCount) days"
			cell.detailTextLabel?.text = summary.averagePosition.map {
				"Average position: \(number($0 * 100))% of mood scale"
			} ?? "Average unavailable"
			cell.selectionStyle = .none
		} else {
			let mood = displayed[indexPath.row]
			let formatter = DateFormatter()
			formatter.dateStyle = .medium; formatter.timeStyle = .short
			cell.textLabel?.text = "\(formatter.string(from: mood.date)) · \(number(mood.rating)) (\(number(mood.minRating))–\(number(mood.maxRating)))"
			cell.detailTextLabel?.text = mood.note?.isEmpty == false ? mood.note : "No note"
			cell.accessoryType = .disclosureIndicator
		}
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		guard indexPath.section == 1 else { return }
		edit(displayed[indexPath.row])
	}
	@objc private func addMood() { edit(nil) }
	private func edit(_ mood: Mood?) {
		let controller = viewController(named: "editMood", fromStoryboard: "Util") as! EditMoodTableViewController
		controller.mood = mood
		pushToNavigationController(controller)
	}
	private func number(_ value: Double) -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 1
		return formatter.string(from: NSNumber(value: value)) ?? "—"
	}
}
