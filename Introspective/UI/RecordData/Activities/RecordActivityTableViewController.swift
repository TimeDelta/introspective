//
//  RecordActivityTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 11/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import CoreData
import os

public final class RecordActivityTableViewController: UITableViewController {

	// MARK: - Static Variables

	private typealias Me = RecordActivityTableViewController
	private static let activityDefinitionCreated = Notification.Name("activityDefinitionCreated")
	private static let activityEditedOrCreated = Notification.Name("activityEdited")
	private static let activityDefinitionEdited = Notification.Name("activityDefinitionEdited")

	// MARK: - Instance Variables

	private final let searchController = UISearchController(searchResultsController: nil)
	private final var finishedLoading = false {
		didSet {
			searchController.searchBar.isUserInteractionEnabled = finishedLoading
			tableView.reloadData()
		}
	}
	private final var definitionEditIndex: IndexPath?
	private final var fetchedResultsController: NSFetchedResultsController<ActivityDefinition>!

	private final let signpost = Signpost(log: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Activity Display"))

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(addButtonPressed))

		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search Activities"
		searchController.hidesNavigationBarDuringPresentation = false
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		definesPresentationContext = true

		loadActivitiyDefinitions()

		observe(selector: #selector(activityDefinitionCreated), name: Me.activityDefinitionCreated, object: nil)
		observe(selector: #selector(activityEditedOrCreated), name: Me.activityEditedOrCreated, object: nil)
		observe(selector: #selector(activityDefinitionEdited), name: Me.activityDefinitionEdited, object: nil)

		reorderOnLongPress()
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - TableView Data Source

	public final override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	public final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if !finishedLoading {
			return 1
		}
		if let fetchedObjects = fetchedResultsController.fetchedObjects {
			return fetchedObjects.count
		}
		os_log("Unable to determine number of expected rows because fetched objects was nil", type: .error)
		return 0
	}

	// MARK: - TableView Delegate

	public final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if !finishedLoading {
			return tableView.dequeueReusableCell(withIdentifier: "waiting", for: indexPath)
		}

		let cell = tableView.dequeueReusableCell(withIdentifier: "activity", for: indexPath) as! RecordActivityDefinitionTableViewCell
		cell.activityDefinition = fetchedResultsController.object(at: indexPath)
		return cell
	}

	public final override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 57
	}

	public final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let activityDefinition = fetchedResultsController.object(at: indexPath)
		guard let cell = tableView.visibleCells[indexPath.row] as? RecordActivityDefinitionTableViewCell else {
			return
		}
		if cell.running {
			if let activity = getMostRecentlyStartedIncompleteActivity(for: activityDefinition) {
				let now = Date()
				if DependencyInjector.settings.autoIgnoreEnabled {
					let minSeconds = DependencyInjector.settings.autoIgnoreSeconds
					if Duration(start: activity.startDate, end: now).inUnit(.second) < Double(minSeconds) {
						DependencyInjector.db.delete(activity)
						cell.updateUiElements()
						return
					}
				}
				activity.endDate = now
				DependencyInjector.db.save()
				cell.updateUiElements()
				if activityDefinition.autoNote {
					showEditScreenForActivity(activity, autoFocusNote: true)
				}
			} else {
				os_log("Could not find activity to stop.", type: .error)
				showError(title: "Could not stop activity", message: "Sorry for the inconvenience.")
			}
		} else {
			var activity: Activity? = nil
			do {
				activity = try DependencyInjector.db.new(Activity.self)
				activity!.setSource(.introspective)
				let definition = try DependencyInjector.db.pull(savedObject: activityDefinition, fromSameContextAs: activity!)
				activity!.definition = definition
				activity!.startDate = Date()
				definition.addToActivities(activity!)
				DependencyInjector.db.save()
				// just calling updateUiElements here doesn't display the progress indicator for some reason
				cell.activityDefinition = definition
			} catch {
				if let activityToDelete = activity {
					DependencyInjector.db.delete(activityToDelete)
				}
				showError(title: "Could not start activity", message: "Sorry for the inconvenience.")
				os_log("Failed to start activity: %@", type: .error, error.localizedDescription)
			}
		}
		tableView.deselectRow(at: indexPath, animated: false)
	}

	// MARK: - TableView Reordering

	public final override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		let definitionsFromIndex = Int(fetchedResultsController.object(at: fromIndexPath).recordScreenIndex)
		let definitionsToIndex = Int(fetchedResultsController.object(at: to).recordScreenIndex)
		let searchText = getSearchText()
		searchController.searchBar.text = ""
		resetFetchedResultsController()
		if definitionsFromIndex < definitionsToIndex {
			for i in definitionsFromIndex + 1 ... definitionsToIndex {
				fetchedResultsController.fetchedObjects?[i].recordScreenIndex -= 1
			}
		} else {
			for i in definitionsToIndex ..< definitionsFromIndex {
				fetchedResultsController.fetchedObjects?[i].recordScreenIndex += 1
			}
		}
		fetchedResultsController.fetchedObjects?[definitionsFromIndex].recordScreenIndex = Int16(definitionsToIndex)
		DependencyInjector.db.save()
		searchController.searchBar.text = searchText
		loadActivitiyDefinitions()
	}

	// MARK: - Swipe Actions

	public final override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let activityDefinition = fetchedResultsController.object(at: indexPath)

		var actions = [UIContextualAction]()
		actions.append(getDeleteActivityDefinitionActionFor(activityDefinition, at: indexPath))
		actions.append(getEditActivityDefinitionActionFor(activityDefinition, at: indexPath))
		return UISwipeActionsConfiguration(actions: actions)
	}

	public final override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let activityDefinition = fetchedResultsController.object(at: indexPath)

		var actions = [UIContextualAction]()
		if let activity = self.getMostRecentActivity(activityDefinition) {
			actions.append(getDeleteActivityActionFor(activity))
			actions.append(getEditLastActionFor(activity))
		}
		actions.append(getAddNewActionFor(activityDefinition))

		return UISwipeActionsConfiguration(actions: actions)
	}

	private final func getDeleteActivityActionFor(_ activity: Activity) -> UIContextualAction {
		let deleteAction = UIContextualAction(style: .destructive, title: "🗑️ Last") { _, _, completionHandler in
			let timeText = self.getTimeTextFor(activity)
			let alert = UIAlertController(
				title: "Are you sure you want to delete '\(activity.definition.name)'?",
				message: "This will only delete the most recent instance \(timeText).",
				preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
				DispatchQueue.global(qos: .background).async {
					DependencyInjector.db.delete(activity)
				}
				self.tableView.reloadData()
			})
			alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
			self.present(alert, animated: false, completion: nil)
		}
		deleteAction.accessibilityLabel = "delete most recent \(activity.definition.name)"
		return deleteAction
	}

	private final func getEditLastActionFor(_ activity: Activity) -> UIContextualAction {
		let editLast = UIContextualAction(style: .normal, title: "✎ Last") { _, _, completionHandler in
			self.showEditScreenForActivity(activity)
		}
		editLast.backgroundColor = .orange
		return editLast
	}

	private final func getAddNewActionFor(_ activityDefinition: ActivityDefinition) -> UIContextualAction {
		let addNew = UIContextualAction(style: .normal, title: "+") { _, _, completionHandler in
			let controller = self.storyboard!.instantiateViewController(withIdentifier: "editActivity") as! EditActivityTableViewController
			controller.definition = activityDefinition
			controller.notificationToSendOnAccept = Me.activityEditedOrCreated

			self.navigationController?.pushViewController(controller, animated: false)
		}
		addNew.backgroundColor = .blue
		return addNew
	}

	private final func getDeleteActivityDefinitionActionFor(_ activityDefinition: ActivityDefinition, at indexPath: IndexPath) -> UIContextualAction {
		return UIContextualAction(style: .destructive, title: "🗑️ All") { _, _, completionHandler in
			let alert = UIAlertController(
				title: "Are you sure you want to delete \(activityDefinition.name)?",
				message: "This will delete all history for this activity.",
				preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
				DependencyInjector.db.delete(activityDefinition)
				self.loadActivitiyDefinitions()
			})
			alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
			self.present(alert, animated: false, completion: nil)
		}
	}

	private final func getEditActivityDefinitionActionFor(_ activityDefinition: ActivityDefinition, at indexPath: IndexPath) -> UIContextualAction {
		let editDefinitionAction = UIContextualAction(style: .normal, title: "✎ All") { _, _, completionHandler in
			self.definitionEditIndex = indexPath
			let controller = self.storyboard!.instantiateViewController(withIdentifier: "editActivityDefinition") as! EditActivityDefinitionTableViewController
			controller.activityDefinition = activityDefinition
			controller.notificationToSendOnAccept = Me.activityDefinitionEdited

			self.navigationController?.pushViewController(controller, animated: false)
		}
		editDefinitionAction.backgroundColor = .orange
		editDefinitionAction.accessibilityLabel = "edit \(activityDefinition.name)"
		return editDefinitionAction
	}

	// MARK: - Received Notifications

	@objc private final func activityDefinitionCreated(notification: Notification) {
		if let activityDefinition = notification.object as? ActivityDefinition {
			activityDefinition.recordScreenIndex = Int16(fetchedResultsController.fetchedObjects?.count ?? 0)
			DependencyInjector.db.save()
			loadActivitiyDefinitions()
		} else {
			os_log("Wrong object type for activity definition created notification", type: .error)
		}
	}

	@objc private final func activityEditedOrCreated(notification: Notification) {
		tableView.reloadData()
	}

	@objc private final func activityDefinitionEdited(notification: Notification) {
		if let indexPath = definitionEditIndex {
			tableView.reloadRows(at: [indexPath], with: .automatic)
		} else {
			os_log("Failed to find activity definition in original set. Resorting to reload of activity definitions.", type: .error)
			loadActivitiyDefinitions()
		}
	}

	// MARK: - Actions

	@IBAction private final func addButtonPressed(_ sender: Any, forEvent event: UIEvent) {
		if let touch = event.allTouches?.first {
			if touch.tapCount == 1 { // tap
				showActivityDefinitionCreationScreen()
			} else if touch.tapCount == 0 { // long press
				quickCreateAndStart()
			}
		} else {
			showActivityDefinitionCreationScreen()
		}
	}

	// MARK: - Helper Functions

	private final func loadActivitiyDefinitions() {
		self.resetFetchedResultsController()
		DispatchQueue.main.async {
			self.finishedLoading = true
			self.tableView.reloadData()
		}
	}

	private final func resetFetchedResultsController() {
		do {
			signpost.begin(name: "resetting fetched results controller")
			fetchedResultsController = DependencyInjector.db.fetchedResultsController(
				type: ActivityDefinition.self,
				sortDescriptors: [NSSortDescriptor(key: "recordScreenIndex", ascending: true)],
				cacheName: "definitions")
			let fetchRequest = fetchedResultsController.fetchRequest
			let searchText: String = self.getSearchText()
			if !searchText.isEmpty {
				fetchRequest.predicate = NSPredicate(
					format: "name CONTAINS[cd] %@ OR activityDescription CONTAINS[cd] %@ OR SUBQUERY(tags, $tag, $tag.name CONTAINS[cd] %@) .@count > 0",
					searchText,
					searchText,
					searchText)
			}
			try fetchedResultsController.performFetch()
			signpost.end(name: "resetting fetched results controller")
		} catch {
			self.showError(
				title: "Could not retrieve activities",
				message: "Something went wrong while trying to retrieve the list of your activities. Sorry for the inconvenience.",
				tryAgain: loadActivitiyDefinitions)
			os_log("Failed to fetch medications: %@", type: .error, error.localizedDescription)
		}
	}

	private final func quickCreateAndStart() {
		let searchText = getSearchText()
		if !searchText.isEmpty {
			do {
				guard try !activityDefinitionWithNameExists(searchText) else {
					showError(title: "Activity named '\(searchText)' already exists.")
					return
				}
				let activityDefinition = try DependencyInjector.db.new(ActivityDefinition.self)
				activityDefinition.name = searchText
				let activity = try DependencyInjector.db.new(Activity.self)
				activity.definition = activityDefinition
				activity.startDate = Date()
				DependencyInjector.db.save()
				searchController.searchBar.text = ""
				loadActivitiyDefinitions()
			} catch {
				os_log("Failed to quick create / start activity: %@", error.localizedDescription)
				showError(title: "Failed to create and start", message: "Something went wrong while trying to save this activity. Sorry for the inconvenience.")
			}
		}
	}

	private final func getTimeTextFor(_ activity: Activity) -> String {
		var timeText: String
		let startsToday = activity.startDate.isToday()
		if startsToday {
			timeText = TimeOfDay(activity.startDate).toString()
		} else {
			timeText = DependencyInjector.util.calendar.string(for: activity.startDate, dateStyle: .short, timeStyle: .short)
		}
		if let endDate = activity.endDate {
			let endDateText: String
			if startsToday {
				endDateText = TimeOfDay(endDate).toString()
			} else {
				endDateText = DependencyInjector.util.calendar.string(for: endDate, dateStyle: .short, timeStyle: .short)
			}
			return "from " + timeText + " to " + endDateText
		} else {
			return "starting at " + timeText
		}
	}

	private final func showActivityDefinitionCreationScreen() {
		let controller = storyboard!.instantiateViewController(withIdentifier: "editActivityDefinition") as! EditActivityDefinitionTableViewController
		controller.notificationToSendOnAccept = Me.activityDefinitionCreated
		controller.initialName = getSearchText()
		navigationController?.pushViewController(controller, animated: true)
	}

	private final func showEditScreenForActivity(_ activity: Activity, autoFocusNote: Bool = false) {
		let controller = self.storyboard!.instantiateViewController(withIdentifier: "editActivity") as! EditActivityTableViewController
		controller.activity = activity
		controller.notificationToSendOnAccept = Me.activityEditedOrCreated
		controller.autoFocusNote = autoFocusNote

		self.navigationController?.pushViewController(controller, animated: false)
	}

	private final func getMostRecentlyStartedIncompleteActivity(for activityDefinition: ActivityDefinition) -> Activity? {
		let endDateVariableName = CommonSampleAttributes.endDate.variableName!
		let filteredActivities = activityDefinition.activities.filtered(using: NSPredicate(format: "%K == nil", endDateVariableName)) as! Set<Activity>

		if filteredActivities.count > 0 {
			let sortedFilteredActivities = filteredActivities.sorted(by: { $0.startDate > $1.startDate })
			return sortedFilteredActivities[0]
		}
		return nil
	}

	private final func getMostRecentActivity(_ activityDefinition: ActivityDefinition) -> Activity? {
		let keyName = CommonSampleAttributes.startDate.variableName!
		let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "definition.name == %@", activityDefinition.name)
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: keyName, ascending: false)]
		do {
			let activities = try DependencyInjector.db.query(fetchRequest)
			if activities.count > 0 {
				return activities[0]
			}
		} catch {
			os_log("Failed to fetch activities: %@", type: .error, error.localizedDescription)
		}
		return nil
	}

	private final func getSearchText() -> String {
		return searchController.searchBar.text!
	}

	private final func activityDefinitionWithNameExists(_ name: String) throws -> Bool {
		let fetchRequest: NSFetchRequest<ActivityDefinition> = ActivityDefinition.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name ==[cd] %@", name)
		let results = try DependencyInjector.db.query(fetchRequest)
		return results.count > 0
	}
}

// MARK: - UISearchResultsUpdating

extension RecordActivityTableViewController: UISearchResultsUpdating {

	public func updateSearchResults(for searchController: UISearchController) {
		loadActivitiyDefinitions()
	}
}
