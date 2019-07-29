//
//  RecordMedicationTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import Instructions

import CoreData
import os

public final class RecordMedicationTableViewController: UITableViewController {

	// MARK: - Static Variables

	private typealias Me = RecordMedicationTableViewController
	private static let cacheName = "allMedications"
	private static let medicationCreated = Notification.Name("medicationCreatedFromRecordScreen")
	private static let medicationEdited = Notification.Name("medicationEditedFromRecordScreen")
	private static let medicationDoseCreated = Notification.Name("medicationDoseCreated")
	private static let setDosePresenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 250), center: .center)
		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()
	private static let dosesViewPresenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 500), center: .center)
		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()
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

	private final let coachMarksController = CoachMarksController()
	private final var coachMarksDataSourceAndDelegate: DefaultCoachMarksDataSourceAndDelegate!
	private final lazy var coachMarksInfo: [CoachMarkInfo] = [
		CoachMarkInfo(
			hint: "Tap the + button to create new medications. You can also type the name of a new medication in the search bar and long press the + button to quickly create and mark it as taken.",
			useArrow: true,
			view: { return self.navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView }),
		CoachMarkInfo(
			hint: "This is the name of the medication. Tap it to edit the medication.",
			useArrow: true,
			view: {
				let exampleMedicationCell = self.tableView.visibleCells[0] as! RecordMedicationTableViewCell
				return exampleMedicationCell.medicationNameLabel
			},
			setup: {
				if self.tableView.visibleCells.count == 0 {
					self.searchController.searchBar.text = Me.exampleMedicationName
					self.quickCreateAndTake()
				}
			}),
		CoachMarkInfo(
			hint: "Press this button to mark this medication as taken. You will be able to set the dosage and date / time taken.",
			useArrow: true,
			view: {
				let exampleMedicationCell = self.tableView.visibleCells[0] as! RecordMedicationTableViewCell
				return exampleMedicationCell.takeButton
			}),
		CoachMarkInfo(
			hint: "This displays the most recent date and time that this medication was taken. Tap to display the full history for this medication.",
			useArrow: true,
			view: {
				let exampleMedicationCell = self.tableView.visibleCells[0] as! RecordMedicationTableViewCell
				return exampleMedicationCell.lastTakenOnDateButton
			}),
		CoachMarkInfo(
			hint: "Long press on an activity to reorder it.",
			useArrow: true,
			view: { return self.tableView.visibleCells[0]}),
	]

	private final let log = Log()
	private final let signpost = Signpost(log: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Medication Display"))

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(addButtonPressed))

		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search Medications"
		searchController.hidesNavigationBarDuringPresentation = false
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		definesPresentationContext = true

		loadMedications()

		observe(selector: #selector(medicationCreated), name: Me.medicationCreated)
		observe(selector: #selector(presentSetDoseView), name: RecordMedicationTableViewCell.shouldPresentMedicationDoseView)
		observe(selector: #selector(errorOccurred), name: RecordMedicationTableViewCell.errorOccurred)
		observe(selector: #selector(presentMedicationDosesTableView), name: RecordMedicationTableViewCell.shouldPresentDosesView)
		observe(selector: #selector(medicationEdited), name: Me.medicationEdited)

		reorderOnLongPress()

		coachMarksDataSourceAndDelegate = DefaultCoachMarksDataSourceAndDelegate(
			coachMarksInfo,
			instructionsShownKey: .recordMedicationsInstructionsShown,
			cleanup: deleteExampleMedication,
			skipViewLayoutConstraints: defaultCoachMarkSkipViewConstraints())
		coachMarksController.dataSource = coachMarksDataSourceAndDelegate
		coachMarksController.delegate = coachMarksDataSourceAndDelegate
		coachMarksController.skipView = defaultSkipInstructionsView()
	}

	public final override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if !DependencyInjector.util.userDefaults.bool(forKey: .recordMedicationsInstructionsShown) {
			coachMarksController.start(in: .window(over: self))
		}
	}

	public final override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		coachMarksController.stop(immediately: true)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - UITableViewDataSource

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
		log.error("Unable to determine number of expected rows because fetched objects was nil")
		return 0
	}

	public final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if !finishedLoading {
			return tableView.dequeueReusableCell(withIdentifier: "waiting", for: indexPath)
		}
		let cell = tableView.dequeueReusableCell(withIdentifier: "recordMedication", for: indexPath) as! RecordMedicationTableViewCell
		cell.medication = fetchedResultsController.object(at: indexPath)
		return cell
	}

	public final override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if !finishedLoading {
			return 44
		}
		return 81
	}

	// MARK: - UITableViewDelegate

	public final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard finishedLoading else { return }
		let controller: EditMedicationViewController = viewController(named: "editMedication")
		controller.notificationToSendOnAccept = Me.medicationEdited
		controller.medication = fetchedResultsController.object(at: indexPath)
		navigationController?.pushViewController(controller, animated: false)
	}

	// MARK: - Table view editing

	public final override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .destructive, title: "🗑️") { (_, indexPath) in
			let medication = self.fetchedResultsController.object(at: indexPath)
			let alert = UIAlertController(
				title: "Are you sure you want to delete \(medication.name)?",
				message: "This will delete all history for this activity.",
				preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
				do {
					let transaction = DependencyInjector.db.transaction()
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

	public final override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		let medicationsFromIndex = Int(fetchedResultsController.object(at: fromIndexPath).recordScreenIndex)
		let medicationsToIndex = Int(fetchedResultsController.object(at: to).recordScreenIndex)
		let searchText = getSearchText()
		searchController.searchBar.text = ""
		resetFetchedResultsController()
		do {
			let transaction = DependencyInjector.db.transaction()
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

	@objc private final func medicationCreated(notification: Notification) {
		loadMedications()
	}

	@objc private final func medicationEdited(notification: Notification) {
		loadMedications()
	}

	@objc private final func presentSetDoseView(notification: Notification) {
		if
			let notificationToSend: Notification.Name = value(for: .notificationName, from: notification),
			let medication: Medication = value(for: .medication, from: notification)
		{
			let controller: MedicationDoseEditorViewController = viewController(named: "medicationDoseEditor")
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

	@IBAction private final func addButtonPressed(_ sender: Any, forEvent event: UIEvent) {
		if let touch = event.allTouches?.first {
			if touch.tapCount == 1 { // tap
				showMedicationCreationScreen()
			} else if touch.tapCount == 0 { // long press
				quickCreateAndTake()
			}
		} else {
			showMedicationCreationScreen()
		}
	}

	// MARK: - Helper Functions

	private final func loadMedications() {
		resetFetchedResultsController()
		finishedLoading = true
		tableView.reloadData()
	}

	private final func resetFetchedResultsController() {
		do {
			signpost.begin(name: "resetting fetched results controller")
			fetchedResultsController = DependencyInjector.db.fetchedResultsController(
				type: Medication.self,
				sortDescriptors: [NSSortDescriptor(key: "recordScreenIndex", ascending: true)],
				cacheName: "medications")
			let fetchRequest = fetchedResultsController.fetchRequest
			let searchText: String = getSearchText()
			if !searchText.isEmpty {
				fetchRequest.predicate = NSPredicate(
					format: "name CONTAINS[cd] %@ OR (notes != nil AND notes CONTAINS[cd] %@)",
					searchText,
					searchText)
			}
			try fetchedResultsController.performFetch()
			signpost.end(name: "resetting fetched results controller")
		} catch {
			log.error("Failed to fetch medications: %@", errorInfo(error))
			showError(
				title: "Failed to retrieve activities",
				message: "Something went wrong while trying to retrieve the list of your activities. Sorry for the inconvenience.",
				error: error,
				tryAgain: loadMedications)
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
				let transaction = DependencyInjector.db.transaction()

				let medication = try transaction.new(Medication.self)
				medication.name = searchText
				medication.setSource(.introspective)
				medication.recordScreenIndex = Int16(try DependencyInjector.db.query(Medication.fetchRequest()).count)
				let dose = try transaction.new(MedicationDose.self)
				dose.medication = medication
				dose.date = Date()
				dose.dosage = medication.dosage
				try retryOnFail({ try transaction.commit() }, maxRetries: 2)
				searchController.searchBar.text = ""
				loadMedications()
			} catch {
				log.error("Failed to quick create / start medication: %@", errorInfo(error))
				showError(
					title: "Failed to create and start",
					message: "Something went wrong while trying to save this medication. Sorry for the inconvenience.",
					error: error)
			}
		}
	}

	private final func medicationWithNameExists(_ name: String) throws -> Bool {
		let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name ==[cd] %@", name)
		let results = try DependencyInjector.db.query(fetchRequest)
		return results.count > 0
	}

	private final func getSearchText() -> String {
		return searchController.searchBar.text!
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
			let medications = try DependencyInjector.db.query(medicationFetchRequest)
			for medication in medications {
				let transaction = DependencyInjector.db.transaction()
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

	public func updateSearchResults(for searchController: UISearchController) {
		resetFetchedResultsController()
		tableView.reloadData()
	}
}
