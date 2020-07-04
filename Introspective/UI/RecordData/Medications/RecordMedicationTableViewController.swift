//
//  RecordMedicationTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import CoreData
import Instructions
import os
import Presentr
import UIKit

import Common
import DependencyInjection
import Persistence
import Samples
import UIExtensions

public final class RecordMedicationTableViewController: UITableViewController {
	// MARK: - Static Variables

	private typealias Me = RecordMedicationTableViewController
	private static let cacheName = "allMedications"
	private static let medicationCreated = Notification.Name("medicationCreatedFromRecordScreen")
	private static let medicationEdited = Notification.Name("medicationEditedFromRecordScreen")
	private static let medicationDoseCreated = Notification.Name("medicationDoseCreated")
	private static let setDosePresenter: Presentr = DependencyInjector.get(UiUtil.self).customPresenter(
		width: .custom(size: 300),
		height: .custom(size: 250),
		center: .center
	)
	private static let presenter = DependencyInjector.get(UiUtil.self).customPresenter(
		width: .full,
		height: .custom(size: 300),
		center: .topCenter
	)

	private static let exampleMedicationName = "Example Medication"

	// MARK: - Instance Variables

	private final let searchController = UISearchController(searchResultsController: nil)
	private final var finishedLoading = false {
		didSet {
			searchController.searchBar.isUserInteractionEnabled = finishedLoading
			tableView.reloadData()
		}
	}

	private final var fetchedResultsController: NSFetchedResultsController<Medication>!

	private final var currentSort: NSSortDescriptor?
	private final let defaultSort = NSSortDescriptor(key: "recordScreenIndex", ascending: true)

	private final let coachMarksController = CoachMarksController()
	private final var coachMarksDataSourceAndDelegate: DefaultCoachMarksDataSourceAndDelegate!
	private final lazy var coachMarksInfo: [CoachMarkInfo] = [
		CoachMarkInfo(
			hint: "Tap the + button to create new medications. You can also type the name of a new medication in the search bar and long press the + button to quickly create and mark it as taken.",
			useArrow: true,
			view: { self.navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView }
		),
		CoachMarkInfo(
			hint: "This is the name of the medication. Tap it to edit the medication.",
			useArrow: true,
			view: {
				let exampleMedicationCell = self.tableView.visibleCells[0] as! RecordMedicationTableViewCell
				return exampleMedicationCell.medicationNameLabel
			},
			setup: {
				if self.tableView.visibleCells.isEmpty {
					self.searchController.searchBar.text = Me.exampleMedicationName
					self.quickCreateAndTake()
				}
			}
		),
		CoachMarkInfo(
			hint: "Press this button to quickly mark this medication as taken. Long pressing allows setting the dosage and date / time that it was taken.",
			useArrow: true,
			view: {
				let exampleMedicationCell = self.tableView.visibleCells[0] as! RecordMedicationTableViewCell
				return exampleMedicationCell.takeButton
			}
		),
		CoachMarkInfo(
			hint: "This displays the most recent date and time that this medication was taken. Tap to display the full history for this medication.",
			useArrow: true,
			view: {
				let exampleMedicationCell = self.tableView.visibleCells[0] as! RecordMedicationTableViewCell
				return exampleMedicationCell.lastTakenOnDateButton
			}
		),
		CoachMarkInfo(
			hint: "Long press on an activity to reorder it.",
			useArrow: true,
			view: { self.tableView.visibleCells[0] }
		),
	]

	private final let log = Log()
	private final let signpost =
		Signpost(log: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Medication Display"))

	// MARK: - UIViewController Overrides

	override public final func viewDidLoad() {
		super.viewDidLoad()

		let addButton = barButton(
			title: "+",
			quickPress: #selector(quickPressAddButton),
			longPress: #selector(longPressAddButton)
		)
		let sortButton = barButton(title: "⇅", action: #selector(sortButtonPressed))
		navigationItem.rightBarButtonItems = [addButton, sortButton]

		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search Medications"
		searchController.hidesNavigationBarDuringPresentation = false
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		definesPresentationContext = true

		loadMedications()

		observe(selector: #selector(medicationCreated), name: Me.medicationCreated)
		observe(
			selector: #selector(presentSetDoseView),
			name: RecordMedicationTableViewCell.shouldPresentMedicationDoseView
		)
		observe(selector: #selector(errorOccurred), name: RecordMedicationTableViewCell.errorOccurred)
		observe(
			selector: #selector(presentMedicationDosesTableView),
			name: RecordMedicationTableViewCell.shouldPresentDosesView
		)
		observe(selector: #selector(medicationEdited), name: Me.medicationEdited)

		coachMarksDataSourceAndDelegate = DefaultCoachMarksDataSourceAndDelegate(
			coachMarksInfo,
			instructionsShownKey: .recordMedicationsInstructionsShown,
			cleanup: deleteExampleMedication,
			skipViewLayoutConstraints: defaultCoachMarkSkipViewConstraints()
		)
		coachMarksController.dataSource = coachMarksDataSourceAndDelegate
		coachMarksController.delegate = coachMarksDataSourceAndDelegate
		coachMarksController.skipView = defaultSkipInstructionsView()
	}

	override public final func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if !DependencyInjector.get(UserDefaultsUtil.self).bool(forKey: .recordMedicationsInstructionsShown) {
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

	// MARK: - UITableViewDataSource

	override public final func numberOfSections(in _: UITableView) -> Int {
		1
	}

	override public final func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
		if !finishedLoading {
			return 1
		}
		if let fetchedObjects = fetchedResultsController.fetchedObjects {
			return fetchedObjects.count
		}
		log.error("Unable to determine number of expected rows because fetched objects was nil")
		return 0
	}

	override public final func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		if !finishedLoading {
			return tableView.dequeueReusableCell(withIdentifier: "waiting", for: indexPath)
		}
		let cell = tableView.dequeueReusableCell(
			withIdentifier: "recordMedication",
			for: indexPath
		) as! RecordMedicationTableViewCell
		cell.medication = fetchedResultsController.object(at: indexPath)
		return cell
	}

	override public final func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
		if !finishedLoading {
			return 44
		}
		return 81
	}

	// MARK: - UITableViewDelegate

	override public final func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard finishedLoading else { return }
		let controller: EditMedicationViewController = viewController(named: "editMedication")
		controller.notificationToSendOnAccept = Me.medicationEdited
		controller.medication = fetchedResultsController.object(at: indexPath)
		navigationController?.pushViewController(controller, animated: false)
	}

	// MARK: - Table view editing

	override public final func tableView(
		_: UITableView,
		editActionsForRowAt indexPath: IndexPath
	) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .destructive, title: "🗑️") { _, indexPath in
			let medication = self.fetchedResultsController.object(at: indexPath)
			let alert = UIAlertController(
				title: "Are you sure you want to delete \(medication.name)?",
				message: "This will delete all history for this activity.",
				preferredStyle: .alert
			)
			alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
				do {
					let transaction = DependencyInjector.get(Database.self).transaction()
					try transaction.delete(medication)
					try retryOnFail({ try transaction.commit() }, maxRetries: 2)
					self.loadMedications()
				} catch {
					self.log.error("Failed to delete medication: %@", errorInfo(error))
					self.showError(title: "Failed to delete medication", error: error)
				}
			})
			alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
			self.present(alert, animated: false, completion: nil)
		}

		return [delete]
	}

	override public final func tableView(_: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		let medicationsFromIndex = Int(fetchedResultsController.object(at: fromIndexPath).recordScreenIndex)
		let medicationsToIndex = Int(fetchedResultsController.object(at: to).recordScreenIndex)
		let searchText = getSearchText()
		searchController.searchBar.text = ""
		resetFetchedResultsController()
		do {
			let transaction = DependencyInjector.get(Database.self).transaction()
			if medicationsFromIndex < medicationsToIndex {
				for i in medicationsFromIndex + 1 ... medicationsToIndex {
					if let medication = fetchedResultsController.fetchedObjects?[i] {
						try transaction.pull(savedObject: medication).recordScreenIndex -= 1
					} else {
						log.error("Failed to get medication for index %d", i)
					}
				}
			} else {
				for i in medicationsToIndex ..< medicationsFromIndex {
					if let medication = fetchedResultsController.fetchedObjects?[i] {
						try transaction.pull(savedObject: medication).recordScreenIndex += 1
					} else {
						log.error("Failed to get medication for index %d", i)
					}
				}
			}
			if let medication = fetchedResultsController.fetchedObjects?[medicationsFromIndex] {
				try transaction.pull(savedObject: medication).recordScreenIndex = Int16(medicationsToIndex)
			} else {
				log.error("Failed to get medication for index %d", medicationsFromIndex)
			}
			try retryOnFail({ try transaction.commit() }, maxRetries: 2)
		} catch {
			log.error("Failed to reorder medications: %@", errorInfo(error))
		}
		searchController.searchBar.text = searchText
		loadMedications()
	}

	// MARK: - Received Notifications

	@objc private final func medicationCreated(notification _: Notification) {
		loadMedications()
	}

	@objc private final func medicationEdited(notification _: Notification) {
		loadMedications()
	}

	@objc private final func presentSetDoseView(notification: Notification) {
		if
			let notificationToSend: Notification.Name = value(for: .notificationName, from: notification),
			let medication: Medication = value(for: .medication, from: notification) {
			let controller = viewController(named: "medicationDoseEditor") as! MedicationDoseEditorViewController
			controller.notificationToSendOnAccept = notificationToSend
			controller.medication = medication
			customPresentViewController(Me.setDosePresenter, viewController: controller, animated: false)
		}
	}

	@objc private final func presentMedicationDosesTableView(notification: Notification) {
		if let medication: Medication = value(for: .medication, from: notification) {
			let controller: MedicationDosesTableViewController = viewController(named: "medicationDoses")
			controller.medication = medication
			navigationController?.pushViewController(controller, animated: false)
		}
	}

	@objc private final func errorOccurred(notification: Notification) {
		if let title: String = value(for: .title, from: notification) {
			let message: String? = value(for: .message, from: notification) ?? "Sorry for the inconvenience."
			showError(title: title, message: message)
		}
	}

	// MARK: - Button Actions

	@IBAction final func quickPressAddButton() {
		showMedicationCreationScreen()
	}

	@IBAction final func longPressAddButton() {
		quickCreateAndTake()
	}

	@IBAction final func sortButtonPressed() {
		let actionsController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		actionsController.addAction(getSortAlphabeticallyAction())
		actionsController.addAction(getSortZetabeticallyAction())
		if currentSort != nil {
			actionsController.addAction(getUseDefaultSortAction())
		}
		actionsController.addAction(getEditDefaultSortAction())
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
				self.loadMedications()
			}
		)
	}

	private final func getSortZetabeticallyAction() -> UIAlertAction {
		DependencyInjector.get(UiUtil.self).alertAction(
			title: "Sort Zetabetically",
			style: .default,
			handler: { _ in
				self.currentSort = NSSortDescriptor(key: "name", ascending: false)
				self.loadMedications()
			}
		)
	}

	private final func getUseDefaultSortAction() -> UIAlertAction {
		DependencyInjector.get(UiUtil.self).alertAction(
			title: "Use Default Sort Order",
			style: .default,
			handler: { _ in
				self.currentSort = nil
				self.loadMedications()
			}
		)
	}

	private final func getEditDefaultSortAction() -> UIAlertAction {
		DependencyInjector.get(UiUtil.self).alertAction(
			title: isEditing ? "Done Editing Default Sort Order" : "Edit Default Sort Order",
			style: .default,
			handler: { _ in
				self.currentSort = nil
				_ = self.editButtonItem.target?.perform(self.editButtonItem.action)
				self.loadMedications()
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

	private final func loadMedications() {
		resetFetchedResultsController()
		finishedLoading = true
		tableView.reloadData()
	}

	private final func resetFetchedResultsController() {
		do {
			signpost.begin(name: "resetting fetched results controller")
			fetchedResultsController = DependencyInjector.get(Database.self).fetchedResultsController(
				type: Medication.self,
				sortDescriptors: [currentSort ?? defaultSort],
				cacheName: "medications"
			)
			let fetchRequest = fetchedResultsController.fetchRequest
			let searchText: String = getSearchText()
			if !searchText.isEmpty {
				fetchRequest.predicate = NSPredicate(
					format: "name CONTAINS[cd] %@ OR (notes != nil AND notes CONTAINS[cd] %@)",
					searchText,
					searchText
				)
			}
			try fetchedResultsController.performFetch()
			signpost.end(name: "resetting fetched results controller")
		} catch {
			log.error("Failed to fetch medications: %@", errorInfo(error))
			showError(
				title: "Failed to retrieve activities",
				message: "Something went wrong while trying to retrieve the list of your activities. Sorry for the inconvenience.",
				error: error,
				tryAgain: loadMedications
			)
		}
	}

	private final func quickCreateAndTake() {
		let searchText = getSearchText()
		if !searchText.isEmpty {
			do {
				guard try !medicationWithNameExists(searchText) else {
					showError(title: "Activity named '\(searchText)' already exists.")
					return
				}
				let transaction = DependencyInjector.get(Database.self).transaction()

				let medication = try transaction.new(Medication.self)
				medication.name = searchText
				medication.setSource(.introspective)
				medication
					.recordScreenIndex = Int16(
						try DependencyInjector.get(Database.self)
							.query(Medication.fetchRequest()).count
					)
				let dose = try transaction.new(MedicationDose.self)
				dose.medication = medication
				dose.date = Date()
				dose.dosage = medication.dosage
				try retryOnFail({ try transaction.commit() }, maxRetries: 2)
				searchController.searchBar.text = ""
				loadMedications()
			} catch {
				log.error("Failed to quick create & take medication: %@", errorInfo(error))
				showError(
					title: "Failed to create and start",
					message: "Something went wrong while trying to save this medication. Sorry for the inconvenience.",
					error: error
				)
			}
		}
	}

	private final func medicationWithNameExists(_ name: String) throws -> Bool {
		let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name ==[cd] %@", name)
		let results = try DependencyInjector.get(Database.self).query(fetchRequest)
		return !results.isEmpty
	}

	private final func getSearchText() -> String {
		searchController.searchBar.text!
	}

	private final func showMedicationCreationScreen() {
		let controller: EditMedicationViewController = viewController(named: "editMedication")
		controller.notificationToSendOnAccept = Me.medicationCreated
		controller.initialName = getSearchText()
		navigationController?.pushViewController(controller, animated: false)
	}

	private final func deleteExampleMedication() {
		let medicationFetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
		medicationFetchRequest.predicate = NSPredicate(format: "name == %@", Me.exampleMedicationName)
		do {
			let medications = try DependencyInjector.get(Database.self).query(medicationFetchRequest)
			for medication in medications {
				let transaction = DependencyInjector.get(Database.self).transaction()
				try transaction.delete(medication)
				try retryOnFail({ try transaction.commit() }, maxRetries: 2)
				loadMedications()
			}
		} catch {
			log.error("Failed to fetch activities while retrieving most recent: %@", errorInfo(error))
		}
	}
}

// MARK: - UISearchResultsUpdating

extension RecordMedicationTableViewController: UISearchResultsUpdating {
	/// This is used to provide a hook into setting the search text for testing. For some reason
	/// passing searchController into resetFetchedResultsController() directly from
	/// updateSearchResults() to use it instead results in localSearchController.searchBar being
	/// nil in that function even though it is not nil when passed in.
	public func setSearchText(_ text: String) {
		searchController.searchBar.text = text
	}

	public func updateSearchResults(for _: UISearchController) {
		resetFetchedResultsController()
		tableView.reloadData()
	}
}
