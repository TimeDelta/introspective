//
//  RecordActivityTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 11/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import CoreData
import Instructions
import os
import Presentr
import UIKit

import AttributeRestrictions
import Common
import DependencyInjection
import Persistence
import Queries
import Samples
import Settings
import UIExtensions

public final class RecordActivityTableViewController: UITableViewController {
	// MARK: - Static Variables

	private typealias Me = RecordActivityTableViewController

	private static let activityDefinitionCreated = Notification.Name("activityDefinitionCreated")
	private static let activityEditedOrCreated = Notification.Name("activityEdited")
	private static let activityDefinitionEdited = Notification.Name("activityDefinitionEdited")
	private static let exampleActivityName = "Example activity"

	private static let presenter = DependencyInjector.get(UiUtil.self).customPresenter(
		width: .full,
		height: .custom(size: 300),
		center: .topCenter
	)

	// MARK: - Instance Variables

	private final let searchController = UISearchController(searchResultsController: nil)

	private final var finishedLoading = false {
		didSet {
			searchController.searchBar.isUserInteractionEnabled = finishedLoading
			tableView.reloadData()
		}
	}

	private final var definitionEditIndex: IndexPath?

	private final var currentSort: NSSortDescriptor?
	private final let defaultSort = NSSortDescriptor(key: "recordScreenIndex", ascending: true)

	private final var activeActivitiesFetchedResultsController: NSFetchedResultsController<ActivityDefinition>!
	private final var inactiveActivitiesFetchedResultsController: NSFetchedResultsController<ActivityDefinition>!

	private final let coachMarksController = CoachMarksController()
	private final var coachMarksDataSourceAndDelegate: DefaultCoachMarksDataSourceAndDelegate!
	private final lazy var coachMarksInfo: [CoachMarkInfo] = [
		CoachMarkInfo(
			hint: "Tap the + button to create new activities. You can also type the name of a new activity in the search bar and long press the + button to quickly create and start it.",
			useArrow: true,
			view: { self.navigationItem.rightBarButtonItems?[0].value(forKey: "view") as? UIView }
		),
		CoachMarkInfo(
			hint: "You can filter on the name of an activity, its description or its tags.",
			useArrow: true,
			view: { self.searchController.searchBar }
		),
		CoachMarkInfo(
			hint: "This is the name of the activity.",
			useArrow: true,
			view: {
				let exampleActivityCell = self.tableView.visibleCells[0] as! RecordActivityDefinitionTableViewCell
				return exampleActivityCell.nameLabel
			},
			setup: {
				if self.tableView.visibleCells.isEmpty {
					self.searchController.searchBar.text = Me.exampleActivityName
					self.quickCreateAndStart()
				}
			}
		),
		CoachMarkInfo(
			hint: "If an activity is currently running, meaning it was started and has not yet been stopped, it will have a progress indicator here.",
			useArrow: true,
			view: {
				let exampleActivityCell = self.tableView.visibleCells[0] as! RecordActivityDefinitionTableViewCell
				return exampleActivityCell.progressIndicator
			}
		),
		CoachMarkInfo(
			hint: "All running activities will be bubbled to the top of the list",
			useArrow: true,
			view: { self.tableView.visibleCells[0] },
			setup: {
				let cell = self.tableView.visibleCells[0] as! RecordActivityDefinitionTableViewCell
				if !cell.running {
					self.searchController.searchBar.text = Me.exampleActivityName
					self.quickCreateAndStart()
				}
			}
		),
		CoachMarkInfo(
			hint: "To start or stop an activity, simply tap it.",
			useArrow: true,
			view: { self.tableView.visibleCells[0] }
		),
		CoachMarkInfo(
			hint: "You can also stop all activities by tapping this button.",
			useArrow: true,
			view: { self.navigationItem.rightBarButtonItems?[1].value(forKey: "view") as? UIView }
		),
		CoachMarkInfo(
			hint: "This is the total amount of time spent on this activity today.",
			useArrow: true,
			view: {
				let exampleActivityCell = self.tableView.visibleCells[0] as! RecordActivityDefinitionTableViewCell
				return exampleActivityCell.totalDurationTodayLabel
			}
		),
		CoachMarkInfo(
			hint: "This is the duration of the most recent time this activity was done.",
			useArrow: true,
			view: {
				let exampleActivityCell = self.tableView.visibleCells[0] as! RecordActivityDefinitionTableViewCell
				return exampleActivityCell.currentInstanceDurationLabel
			}
		),
		CoachMarkInfo(
			hint: "This is the start and end timestamps for the most recent instance of this activity.",
			useArrow: true,
			view: {
				let exampleActivityCell = self.tableView.visibleCells[0] as! RecordActivityDefinitionTableViewCell
				return exampleActivityCell.mostRecentTimeLabel
			}
		),
		CoachMarkInfo(
			hint: "Swipe left for actions related to individual instances of this activity. Swipe right for actions related to all instances of this activity.",
			useArrow: true,
			view: { self.tableView.visibleCells[0] }
		),
		CoachMarkInfo(
			hint: "Long press on an activity to reorder it.",
			useArrow: true,
			view: { self.tableView.visibleCells[0] }
		),
	]

	private final let signpost =
		Signpost(log: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Activity Display"))
	private final let log = Log()

	// MARK: - UIViewController Overrides

	override public final func viewDidLoad() {
		super.viewDidLoad()

		let addButton = barButton(
			title: "+",
			quickPress: #selector(quickPressAddButton),
			longPress: #selector(longPressAddButton)
		)
		let stopAllButton = UIBarButtonItem(
			title: "■",
			style: .plain,
			target: self,
			action: #selector(stopAllButtonPressed)
		)
		let sortButton = barButton(title: "⇅", action: #selector(sortButtonPressed))
		navigationItem.rightBarButtonItems = [addButton, stopAllButton, sortButton]

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
		observe(selector: #selector(sortByRecentCount), name: .timePeriodChosen)

		reorderOnLongPress(allowReorder: { $0.section == 1 && ($1 == nil || $1?.section == 1) })

		coachMarksDataSourceAndDelegate = DefaultCoachMarksDataSourceAndDelegate(
			coachMarksInfo,
			instructionsShownKey: .recordActivitiesInstructionsShown,
			cleanup: deleteExampleActivity,
			skipViewLayoutConstraints: defaultCoachMarkSkipViewConstraints()
		)
		coachMarksController.dataSource = coachMarksDataSourceAndDelegate
		coachMarksController.delegate = coachMarksDataSourceAndDelegate
		coachMarksController.skipView = defaultSkipInstructionsView()
	}

	override public final func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if !DependencyInjector.get(UserDefaultsUtil.self).bool(forKey: .recordActivitiesInstructionsShown) {
			coachMarksController.start(in: .window(over: self))
		}
	}

	override public final func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		coachMarksController.stop(immediately: true)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - TableView Data Source

	override public final func numberOfSections(in _: UITableView) -> Int {
		if !finishedLoading {
			return 1
		}
		return 2
	}

	override public final func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
		if !finishedLoading {
			return 1
		}
		if section == 0 {
			if let fetchedObjects = activeActivitiesFetchedResultsController.fetchedObjects {
				return fetchedObjects.count
			}
		} else if section == 1 {
			if let fetchedObjects = inactiveActivitiesFetchedResultsController.fetchedObjects {
				return fetchedObjects.count
			}
		}
		log.error("Unable to determine number of expected rows because fetched objects was nil")
		return 0
	}

	// MARK: - TableView Delegate

	override public final func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		if !finishedLoading {
			return tableView.dequeueReusableCell(withIdentifier: "waiting", for: indexPath)
		}

		let cell = tableView.dequeueReusableCell(
			withIdentifier: "activity",
			for: indexPath
		) as! RecordActivityDefinitionTableViewCell
		cell.activityDefinition = definition(at: indexPath)
		return cell
	}

	override public final func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
		if !finishedLoading {
			return 44
		}
		return 57
	}

	override public final func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard finishedLoading else { return }
		let activityDefinition = definition(at: indexPath)
		guard let cell = visibleCellFor(indexPath) else {
			return
		}
		if cell.running {
			if let activity = getMostRecentlyStartedIncompleteActivity(for: activityDefinition) {
				stopActivity(activity, associatedCell: cell)
			} else {
				log.error("Could not find activity to stop.")
				showError(title: "Failed to stop activity")
			}
		} else {
			startActivity(for: activityDefinition, cell: cell)
		}
		loadActivitiyDefinitions()
	}

	// MARK: - TableView Reordering

	override public final func tableView(_: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		indexPath.section == 1
	}

	override public final func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		let definitionsFromIndex = Int(definition(at: fromIndexPath).recordScreenIndex)
		let definitionsToIndex = Int(definition(at: to).recordScreenIndex)
		do {
			let allFetchedResultsController = try getAllFetchedResultsController()
			let transaction = DependencyInjector.get(Database.self).transaction()
			if definitionsFromIndex < definitionsToIndex {
				for i in definitionsFromIndex + 1 ... definitionsToIndex {
					if let definition = allFetchedResultsController.fetchedObjects?[i] {
						try transaction.pull(savedObject: definition).recordScreenIndex -= 1
					} else {
						log.error("Failed to get activity definition for index %d", i)
					}
				}
			} else {
				for i in definitionsToIndex ..< definitionsFromIndex {
					if let definition = allFetchedResultsController.fetchedObjects?[i] {
						try transaction.pull(savedObject: definition).recordScreenIndex += 1
					} else {
						log.error("Failed to get activity definition for index %d", i)
					}
				}
			}
			if let definition = allFetchedResultsController.fetchedObjects?[definitionsFromIndex] {
				try transaction.pull(savedObject: definition).recordScreenIndex = Int16(definitionsToIndex)
			} else {
				log.error("Failed to get activity definition for index %d", definitionsFromIndex)
			}
			try retryOnFail({ try transaction.commit() }, maxRetries: 2)
		} catch {
			log.error("Failed to reorder activities: %@", errorInfo(error))
		}
		resetInactiveActivitiesFetchedResultsController()
		tableView.reloadSections(IndexSet(arrayLiteral: 1), with: .automatic)
	}

	// MARK: - Swipe Actions

	override public final func tableView(
		_: UITableView,
		leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
	) -> UISwipeActionsConfiguration? {
		let activityDefinition = definition(at: indexPath)

		var actions = [
			getDeleteActivityDefinitionActionFor(activityDefinition, at: indexPath),
			getEditActivityDefinitionActionFor(activityDefinition, at: indexPath),
		]
		if activityDefinition.activities.count > 0 {
			actions.append(getViewHistoryActionFor(activityDefinition))
		}
		return UISwipeActionsConfiguration(actions: actions)
	}

	override public final func tableView(
		_: UITableView,
		trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
	) -> UISwipeActionsConfiguration? {
		let activityDefinition = definition(at: indexPath)

		var actions = [UIContextualAction]()
		if let activity = getMostRecentActivity(activityDefinition) {
			actions.append(getDeleteActivityActionFor(activity))
			actions.append(getEditLastActionFor(activity))
		}
		actions.append(getAddNewActionFor(activityDefinition))

		return UISwipeActionsConfiguration(actions: actions)
	}

	private final func getViewHistoryActionFor(_ definition: ActivityDefinition) -> UIContextualAction {
		let action = DependencyInjector.get(UiUtil.self).contextualAction(style: .normal, title: "History") { _, _, _ in
			let query = DependencyInjector.get(QueryFactory.self).activityQuery()
			query.expression = EqualToStringAttributeRestriction(
				restrictedAttribute: Activity.nameAttribute,
				value: definition.name
			)
			let controller = self.viewController(named: "results", fromStoryboard: "Results") as! ResultsViewController
			controller.query = query
			query.runQuery { result, error in
				if error != nil {
					DispatchQueue.main.async {
						controller.showError(title: "Failed to run query", error: error)
					}
					return
				}
				controller.samples = result?.samples
			}
			controller.query = query
			controller.backButtonTitle = "Activities"
			self.pushToNavigationController(controller)
		}
		action.accessibilityLabel = "view all history for \(definition.name)"
		action.backgroundColor = .blue
		return action
	}

	private final func getDeleteActivityActionFor(_ activity: Activity) -> UIContextualAction {
		let deleteAction = DependencyInjector.get(UiUtil.self)
			.contextualAction(style: .destructive, title: "🗑️ Last") { _, _, _ in
				let timeText = self.getTimeTextFor(activity)
				let alert = UIAlertController(
					title: "Are you sure you want to delete '\(activity.definition.name)'?",
					message: "This will only delete the most recent instance \(timeText).",
					preferredStyle: .alert
				)
				alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
					do {
						let transaction = DependencyInjector.get(Database.self).transaction()
						try transaction.delete(activity)
						try retryOnFail({ try transaction.commit() }, maxRetries: 2)
						self.loadActivitiyDefinitions()
					} catch {
						self.log.error("Failed to delete activity: %@", errorInfo(error))
						self.showError(title: "Failed to delete activity instance", error: error)
					}
				})
				alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
				self.present(alert, animated: false, completion: nil)
			}
		deleteAction.accessibilityLabel = "delete most recent \(activity.definition.name)"
		return deleteAction
	}

	private final func getEditLastActionFor(_ activity: Activity) -> UIContextualAction {
		let editLast = DependencyInjector.get(UiUtil.self)
			.contextualAction(style: .normal, title: "✎ Last") { _, _, _ in
				self.showEditScreenForActivity(activity)
			}
		editLast.backgroundColor = .orange
		return editLast
	}

	private final func getAddNewActionFor(_ activityDefinition: ActivityDefinition) -> UIContextualAction {
		let addNew = DependencyInjector.get(UiUtil.self).contextualAction(style: .normal, title: "+") { _, _, _ in
			let controller = self.viewController(named: "editActivity") as! EditActivityTableViewController
			controller.definition = activityDefinition
			controller.notificationToSendOnAccept = Me.activityEditedOrCreated

			self.navigationController?.pushViewController(controller, animated: false)
		}
		addNew.backgroundColor = .blue
		return addNew
	}

	private final func getDeleteActivityDefinitionActionFor(
		_ activityDefinition: ActivityDefinition,
		at _: IndexPath
	) -> UIContextualAction {
		DependencyInjector.get(UiUtil.self).contextualAction(style: .destructive, title: "🗑️ All") { _, _, _ in
			let alert = UIAlertController(
				title: "Are you sure you want to delete \(activityDefinition.name)?",
				message: "This will delete all history for this activity.",
				preferredStyle: .alert
			)
			alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
				do {
					let transaction = DependencyInjector.get(Database.self).transaction()
					try transaction.delete(activityDefinition)
					try retryOnFail({ try transaction.commit() }, maxRetries: 2)
					self.loadActivitiyDefinitions()
				} catch {
					self.log.error("Failed to delete activity definition: %@", errorInfo(error))
					self.showError(title: "Failed to delete activity", error: error)
				}
			})
			alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
			self.present(alert, animated: false, completion: nil)
		}
	}

	private final func getEditActivityDefinitionActionFor(
		_ activityDefinition: ActivityDefinition,
		at indexPath: IndexPath
	) -> UIContextualAction {
		let editDefinitionAction = DependencyInjector.get(UiUtil.self)
			.contextualAction(style: .normal, title: "✎ All") { _, _, _ in
				self.definitionEditIndex = indexPath
				let controller: EditActivityDefinitionTableViewController = self
					.viewController(named: "editActivityDefinition")
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
		if let activityDefinition: ActivityDefinition? = value(for: .activityDefinition, from: notification) {
			do {
				let transaction = DependencyInjector.get(Database.self).transaction()
				if let activityDefinition = activityDefinition {
					let allDefinitionsController = try getAllFetchedResultsController()
					let newIndex = Int16(allDefinitionsController.fetchedObjects?.count ?? 1) - 1
					try transaction.pull(savedObject: activityDefinition).recordScreenIndex = newIndex
					try retryOnFail({ try transaction.commit() }, maxRetries: 2)
				}
				loadActivitiyDefinitions()
			} catch {
				log.error("Failed to save activity definition: %@", errorInfo(error))
				showError(
					title: "Failed to save activity",
					error: error,
					tryAgain: { self.activityDefinitionCreated(notification: notification) }
				)
			}
		}
	}

	@objc private final func activityEditedOrCreated(notification _: Notification) {
		loadActivitiyDefinitions()
	}

	@objc private final func activityDefinitionEdited(notification _: Notification) {
		if let indexPath = definitionEditIndex {
			tableView.reloadRows(at: [indexPath], with: .automatic)
		} else {
			log
				.error(
					"Failed to find activity definition in original set. Resorting to reload of activity definitions."
				)
			loadActivitiyDefinitions()
		}
	}

	@objc private final func sortByRecentCount(notification: Notification) {
		guard let numTimeUnits: Int = value(for: .number, from: notification) else { return }
		guard let timeUnit: Calendar.Component = value(for: .calendarComponent, from: notification) else { return }
		do {
			let transaction = DependencyInjector.get(Database.self).transaction()
			let allDefinitions = try transaction.query(ActivityDefinition.fetchRequest())
			var counts = [String: Int]()
			for definition in allDefinitions {
				let recentActivities: NSFetchRequest<NSFetchRequestResult> = Activity.fetchRequest()
				let minStartDate = DependencyInjector.get(CalendarUtil.self).ago(numTimeUnits, timeUnit)
				recentActivities.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
					NSPredicate(format: "startDate > %@", minStartDate as NSDate),
					NSPredicate(format: "definition == %@", definition),
				])
				counts[definition.name] = try transaction.count(recentActivities)
			}
			let sortedDefinitions = try allDefinitions.sorted { (definition1, definition2) throws -> Bool in
				if counts[definition1.name]! > counts[definition2.name]! {
					return true
				}
				if counts[definition1.name]! < counts[definition2.name]! {
					return false
				}

				guard let mostRecent1 = self.getMostRecentActivity(definition1) else { return false }
				guard let mostRecent2 = self.getMostRecentActivity(definition2) else { return true }
				return mostRecent1.start.isAfterDate(mostRecent2.start, orEqual: true, granularity: .second)
			}
			var i: Int16 = 0
			for definition in sortedDefinitions {
				definition.recordScreenIndex = i
				i += 1
			}
			try retryOnFail({ try transaction.commit() }, maxRetries: 2)

			currentSort = nil
			loadActivitiyDefinitions()
		} catch {
			showError(title: "Failed to sort by recent count. Sorry for thee inconvenience.")
		}
	}

	// MARK: - Actions

	@IBAction final func quickPressAddButton() {
		showActivityDefinitionCreationScreen()
	}

	@IBAction final func longPressAddButton() {
		quickCreateAndStart()
	}

	@IBAction final func stopAllButtonPressed(_ sender: Any) {
		do {
			let activitiesToAutoNote = try DependencyInjector.get(ActivityDAO.self).stopAllActivities()
			loadActivitiyDefinitions()
			for activity in activitiesToAutoNote {
				showEditScreenForActivity(activity, autoFocusNote: true)
			}
		} catch {
			showError(
				title: "Failed to stop activities",
				message: "Something went wrong while trying to stop all activities. Sorry for the inconvenience.",
				error: error,
				tryAgain: { self.stopAllButtonPressed(sender) }
			)
		}
	}

	@IBAction final func sortButtonPressed() {
		let actionsController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		actionsController.addAction(getSortAlphabeticallyAction())
		actionsController.addAction(getSortZetabeticallyAction())
		actionsController.addAction(getManualSortAction())
		actionsController.addAction(getSortByRecentCountAction())
		actionsController.addAction(DependencyInjector.get(UiUtil.self).alertAction(
			title: "Cancel",
			style: .cancel,
			handler: nil
		))
		present(actionsController, animated: false, completion: nil)
	}

	private final func getSortAlphabeticallyAction() -> UIAlertAction {
		DependencyInjector.get(UiUtil.self).alertAction(
			title: "Sort Alphabetically",
			style: .default,
			handler: { _ in
				self.currentSort = NSSortDescriptor(key: "name", ascending: true)
				self.loadActivitiyDefinitions()
			}
		)
	}

	private final func getSortZetabeticallyAction() -> UIAlertAction {
		DependencyInjector.get(UiUtil.self).alertAction(
			title: "Sort Zetabetically",
			style: .default,
			handler: { _ in
				self.currentSort = NSSortDescriptor(key: "name", ascending: false)
				self.loadActivitiyDefinitions()
			}
		)
	}

	private final func getManualSortAction() -> UIAlertAction {
		DependencyInjector.get(UiUtil.self).alertAction(
			title: "Manual Sort",
			style: .default,
			handler: { _ in
				self.currentSort = nil
				self.loadActivitiyDefinitions()
			}
		)
	}

	private final func getSortByRecentCountAction() -> UIAlertAction {
		DependencyInjector.get(UiUtil.self).alertAction(
			title: "Permanent Sort by Recent Count",
			style: .default,
			handler: { _ in self.presentSortByRecentCountOptions() }
		)
	}

	// MARK: - Helper Functions

	private final func presentSortByRecentCountOptions() {
		let controller = viewController(named: "chooseRecentTimePeriod") as! ChooseRecentTimePeriodViewController
		controller.initialTimeUnit = .weekOfYear
		controller.initialNumTimeUnits = 2
		present(controller, using: Me.presenter)
	}

	private final func loadActivitiyDefinitions() {
		resetFetchedResultsControllers()
		finishedLoading = true
		tableView.reloadData()
	}

	private final func getSearchTextPredicate(_ searchText: String) -> NSPredicate {
		NSPredicate(
			format: "name CONTAINS[cd] %@ OR activityDescription CONTAINS[cd] %@ OR SUBQUERY(tags, $tag, $tag.name CONTAINS[cd] %@) .@count > 0",
			searchText,
			searchText,
			searchText
		)
	}

	private final func quickCreateAndStart() {
		let searchText = getSearchText()
		if !searchText.isEmpty {
			do {
				guard try !activityDefinitionWithNameExists(searchText) else {
					showError(title: "Activity named '\(searchText)' already exists.")
					return
				}
				let activityDefinition = try DependencyInjector.get(ActivityDAO.self).createDefinition(name: searchText)
				try DependencyInjector.get(ActivityDAO.self).createActivity(definition: activityDefinition)
				searchController.searchBar.text = ""
				loadActivitiyDefinitions()
			} catch {
				log.error("Failed to quick create / start activity: %@", errorInfo(error))
				showError(
					title: "Failed to create and start",
					message: "Something went wrong while trying to save this activity. Sorry for the inconvenience.",
					error: error
				)
			}
		}
	}

	private final func startActivity(
		for activityDefinition: ActivityDefinition,
		cell: RecordActivityDefinitionTableViewCell
	) {
		do {
			try DependencyInjector.get(ActivityDAO.self).startActivity(activityDefinition)
			// just calling updateUiElements here doesn't display the progress indicator for some reason
			cell.activityDefinition = try DependencyInjector.get(Database.self).pull(savedObject: activityDefinition)
		} catch {
			log.error("Failed to start activity: %@", errorInfo(error))
			showError(title: "Failed to start activity", error: error)
		}
	}

	private final func stopActivity(_ activity: Activity, associatedCell: RecordActivityDefinitionTableViewCell) {
		let now = Date()
		if DependencyInjector.get(ActivityDAO.self).autoIgnoreIfAppropriate(activity, end: now) {
			associatedCell.updateUiElements()
			return
		}
		do {
			let transaction = DependencyInjector.get(Database.self).transaction()
			activity.end = now
			try retryOnFail({ try transaction.commit() }, maxRetries: 2)
			associatedCell.updateUiElements()
			if activity.definition.autoNote {
				showEditScreenForActivity(activity, autoFocusNote: true)
			}
		} catch {
			showError(title: "Failed to stop activity", error: error)
		}
	}

	private final func getTimeTextFor(_ activity: Activity) -> String {
		var timeText: String
		let startsToday = activity.start.isToday()
		if startsToday {
			timeText = TimeOfDay(activity.start).toString()
		} else {
			timeText = DependencyInjector.get(CalendarUtil.self)
				.string(for: activity.start, dateStyle: .short, timeStyle: .short)
		}
		if let endDate = activity.end {
			let endDateText: String
			if startsToday {
				endDateText = TimeOfDay(endDate).toString()
			} else {
				endDateText = DependencyInjector.get(CalendarUtil.self)
					.string(for: endDate, dateStyle: .short, timeStyle: .short)
			}
			return "from " + timeText + " to " + endDateText
		} else {
			return "starting at " + timeText
		}
	}

	private final func showActivityDefinitionCreationScreen() {
		let controller: EditActivityDefinitionTableViewController = viewController(named: "editActivityDefinition")
		controller.notificationToSendOnAccept = Me.activityDefinitionCreated
		controller.initialName = getSearchText()
		navigationController?.pushViewController(controller, animated: false)
	}

	private final func showEditScreenForActivity(_ activity: Activity, autoFocusNote: Bool = false) {
		let controller = viewController(named: "editActivity") as! EditActivityTableViewController
		controller.activity = activity
		controller.notificationToSendOnAccept = Me.activityEditedOrCreated
		controller.autoFocusNote = autoFocusNote

		pushToNavigationController(controller, animated: false)
	}

	private final func getMostRecentlyStartedIncompleteActivity(for activityDefinition: ActivityDefinition)
		-> Activity? {
		do {
			return try DependencyInjector.get(ActivityDAO.self)
				.getMostRecentlyStartedIncompleteActivity(for: activityDefinition)
		} catch {
			log.error("Failed to fetch most recent activity: %@", errorInfo(error))
			return nil
		}
	}

	private final func getMostRecentActivity(_ activityDefinition: ActivityDefinition) -> Activity? {
		do {
			return try DependencyInjector.get(ActivityDAO.self)
				.getMostRecentActivity(activityDefinition)
		} catch {
			log.error("Failed to fetch activities while retrieving most recent: %@", errorInfo(error))
			return nil
		}
	}

	private final func getSearchText() -> String {
		searchController.searchBar.text!
	}

	private final func activityDefinitionWithNameExists(_ name: String) throws -> Bool {
		try DependencyInjector.get(ActivityDAO.self).activityDefinitionWithNameExists(name)
	}

	private final func deleteExampleActivity() {
		let definitionFetchRequest: NSFetchRequest<ActivityDefinition> = ActivityDefinition.fetchRequest()
		definitionFetchRequest.predicate = NSPredicate(format: "name == %@", Me.exampleActivityName)
		do {
			let definitions = try DependencyInjector.get(Database.self).query(definitionFetchRequest)
			for definition in definitions {
				let transaction = DependencyInjector.get(Database.self).transaction()
				try transaction.delete(definition)
				try retryOnFail({ try transaction.commit() }, maxRetries: 2)
				loadActivitiyDefinitions()
			}
		} catch {
			log.error("Failed to fetch activities while retrieving most recent: %@", errorInfo(error))
		}
	}

	private final func definition(at indexPath: IndexPath) -> ActivityDefinition {
		if indexPath.section == 0 {
			return activeActivitiesFetchedResultsController.object(at: indexPath)
		}
		let offsetIndexPath = IndexPath(row: indexPath.row, section: 0)
		return inactiveActivitiesFetchedResultsController.object(at: offsetIndexPath)
	}

	private final func visibleCellFor(_ indexPath: IndexPath) -> RecordActivityDefinitionTableViewCell? {
		let targetDefinition = definition(at: indexPath)
		let cells = tableView.visibleCells.map { $0 as! RecordActivityDefinitionTableViewCell }
		for cell in cells {
			if cell.activityDefinition.equalTo(targetDefinition) {
				return cell
			}
		}
		return nil
	}

	// MARK: FetchedResultsController Helpers

	private final func resetFetchedResultsControllers() {
		resetActiveActivitiesFetchedResultsController()
		resetInactiveActivitiesFetchedResultsController()
	}

	private final func resetActiveActivitiesFetchedResultsController() {
		do {
			signpost.begin(name: "resetting active fetched results controller")
			activeActivitiesFetchedResultsController = DependencyInjector.get(Database.self).fetchedResultsController(
				type: ActivityDefinition.self,
				sortDescriptors: [currentSort ?? defaultSort],
				cacheName: "activeDefinitions"
			)
			let fetchRequest = activeActivitiesFetchedResultsController.fetchRequest

			let isActivePredicate =
				NSPredicate(format: "SUBQUERY(activities, $activity, $activity.endDate == nil) .@count > 0")
			fetchRequest.predicate = isActivePredicate

			let searchText: String = getSearchText()
			if !searchText.isEmpty {
				fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
					isActivePredicate,
					getSearchTextPredicate(searchText),
				])
			}

			try activeActivitiesFetchedResultsController.performFetch()
			signpost.end(name: "resetting active fetched results controller")
		} catch {
			log.error("Failed to fetch active activities: %@", errorInfo(error))
			showError(
				title: "Failed to retrieve activities",
				message: "Something went wrong while trying to retrieve the list of your activities. Sorry for the inconvenience.",
				error: error,
				tryAgain: loadActivitiyDefinitions
			)
		}
	}

	private final func resetInactiveActivitiesFetchedResultsController() {
		do {
			signpost.begin(name: "resetting inactive fetched results controller")
			inactiveActivitiesFetchedResultsController = DependencyInjector.get(Database.self).fetchedResultsController(
				type: ActivityDefinition.self,
				sortDescriptors: [currentSort ?? defaultSort],
				cacheName: "definitions"
			)
			let fetchRequest = inactiveActivitiesFetchedResultsController.fetchRequest

			let isInactivePredicate =
				NSPredicate(format: "SUBQUERY(activities, $activity, $activity.endDate == nil) .@count == 0")
			fetchRequest.predicate = isInactivePredicate

			let searchText: String = getSearchText()
			if !searchText.isEmpty {
				fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
					isInactivePredicate,
					getSearchTextPredicate(searchText),
				])
			}

			try inactiveActivitiesFetchedResultsController.performFetch()
			signpost.end(name: "resetting inactive fetched results controller")
		} catch {
			log.error("Failed to fetch activities: %@", errorInfo(error))
			showError(
				title: "Failed to retrieve activities",
				message: "Something went wrong while trying to retrieve the list of your activities. Sorry for the inconvenience.",
				error: error,
				tryAgain: loadActivitiyDefinitions
			)
		}
	}

	private final func getAllFetchedResultsController() throws -> NSFetchedResultsController<ActivityDefinition> {
		signpost.begin(name: "getting all fetched results controller")
		let controller = DependencyInjector.get(Database.self).fetchedResultsController(
			type: ActivityDefinition.self,
			sortDescriptors: [currentSort ?? defaultSort],
			cacheName: "definitions"
		)
		try controller.performFetch()
		signpost.end(name: "getting all fetched results controller")
		return controller
	}
}

// MARK: - UISearchResultsUpdating

extension RecordActivityTableViewController: UISearchResultsUpdating {
	/// This is used to provide a hook into setting the search text for testing. For some reason
	/// passing searchController into resetFetchedResultsControllers() directly from
	/// updateSearchResults() to use it instead results in localSearchController.searchBar being
	/// nil in that function even though it is not nil when passed in.
	public func setSearchText(_ text: String) {
		searchController.searchBar.text = text
	}

	public func updateSearchResults(for _: UISearchController) {
		loadActivitiyDefinitions()
	}
}
