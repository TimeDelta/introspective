//
//  RecordMedicationTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import CoreData
import Instructions
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

	// MARK: Notification Names

	private static let medicationCreated = Notification.Name("medicationCreatedFromRecordScreen")
	private static let medicationEdited = Notification.Name("medicationEditedFromRecordScreen")
	private static let medicationDoseCreated = Notification.Name("medicationDoseCreated")

	// MARK: Presenters

	private static let setDosePresenter: Presentr = injected(UiUtil.self).customPresenter(
		width: .custom(size: 300),
		height: .custom(size: 250),
		center: .topCenter
	)
	private static let presenter = injected(UiUtil.self).customPresenter(
		width: .full,
		height: .custom(size: 300),
		center: .topCenter
	)

	// MARK: Logging / Performance

	private static let log = Log()
	private static let signpost = Signpost(log: Log(category: "Medication Display"))

	// MARK: - Instance Variables

	final fileprivate var sortButton: UIBarButtonItem!

	final fileprivate let searchController = UISearchController(searchResultsController: nil)
	private final var finishedLoading = false {
		didSet {
			DispatchQueue.main.async {
				self.searchController.searchBar.isUserInteractionEnabled = self.finishedLoading
				self.tableView.reloadData()
			}
		}
	}

	private final var fetchedResultsController: NSFetchedResultsController<Medication>!

	private final var currentSort: NSSortDescriptor?
	private final let defaultSort = NSSortDescriptor(key: "recordScreenIndex", ascending: true)

	private final let coachMarksController = CoachMarksController()
	private final var coachMarksDataSourceAndDelegate: CoachMarksDataSourceAndDelegate!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		let addButton = barButton(
			title: "+",
			quickPress: #selector(quickPressAddButton),
			longPress: #selector(longPressAddButton)
		)
		sortButton = barButton(title: "⇅", action: #selector(sortButtonPressed))
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
			selector: #selector(presentLastDoseView),
			name: RecordMedicationTableViewCell.shouldPresentLastDoseView
		)
		observe(selector: #selector(medicationEdited), name: Me.medicationEdited)
		observe(selector: #selector(persistenceLayerDidRefresh), name: .persistenceLayerDidRefresh)
		observe(selector: #selector(persistenceLayerWillRefresh), name: .persistenceLayerWillRefresh)

		coachMarksDataSourceAndDelegate = RecordMedicationTableViewControllerCoachMarksDataSourceAndDelegate(self)
		coachMarksController.dataSource = coachMarksDataSourceAndDelegate
		coachMarksController.delegate = coachMarksDataSourceAndDelegate
		coachMarksController.skipView = DefaultCoachMarksDataSourceAndDelegate.defaultSkipInstructionsView()
	}

	public final override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if !injected(UserDefaultsUtil.self).bool(forKey: .recordMedicationsInstructionsShown) {
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

	public final override func numberOfSections(in _: UITableView) -> Int {
		1
	}

	public final override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
		if !finishedLoading {
			return 1
		}
		if let fetchedObjects = fetchedResultsController.fetchedObjects {
			return fetchedObjects.count
		}
		Me.log.error("Unable to determine number of expected rows because fetched objects was nil")
		return 0
	}

	public final override func tableView(
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

	public final override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
		if !finishedLoading {
			return 44
		}
		return 81
	}

	// MARK: - UITableViewDelegate

	public final override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard finishedLoading else { return }
		let controller: MedicationDosesTableViewController = viewController(named: "medicationDoses")
		controller.medication = fetchedResultsController.object(at: indexPath)
		pushToNavigationController(controller, animated: false)
	}

	// MARK: - Table view editing

	public final override func tableView(
		_: UITableView,
		trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
	) -> UISwipeActionsConfiguration? {
		UISwipeActionsConfiguration(actions: [
			getEditAction(for: indexPath),
			getDeleteAction(for: indexPath),
		])
	}

	public final override func tableView(_: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		let medicationsFromIndex = Int(fetchedResultsController.object(at: fromIndexPath).recordScreenIndex)
		let medicationsToIndex = Int(fetchedResultsController.object(at: to).recordScreenIndex)
		let searchText = getSearchText()
		searchController.searchBar.text = ""
		resetFetchedResultsController()
		do {
			let transaction = injected(Database.self).transaction()
			if medicationsFromIndex < medicationsToIndex {
				for i in medicationsFromIndex + 1 ... medicationsToIndex {
					if let medication = fetchedResultsController.fetchedObjects?[i] {
						try transaction.pull(savedObject: medication).recordScreenIndex -= 1
					} else {
						Me.log.error("Failed to get medication for index %d", i)
					}
				}
			} else {
				for i in medicationsToIndex ..< medicationsFromIndex {
					if let medication = fetchedResultsController.fetchedObjects?[i] {
						try transaction.pull(savedObject: medication).recordScreenIndex += 1
					} else {
						Me.log.error("Failed to get medication for index %d", i)
					}
				}
			}
			if let medication = fetchedResultsController.fetchedObjects?[medicationsFromIndex] {
				try transaction.pull(savedObject: medication).recordScreenIndex = Int16(medicationsToIndex)
			} else {
				Me.log.error("Failed to get medication for index %d", medicationsFromIndex)
			}
			try retryOnFail({ try transaction.commit() }, maxRetries: 2)
		} catch {
			Me.log.error("Failed to reorder medications: %@", errorInfo(error))
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
		// swiftformat:disable all
		if
			let notificationToSend: Notification.Name = value(for: .notificationName, from: notification),
			let medication: Medication = value(for: .medication, from: notification)
		{
			let controller = viewController(named: "medicationDoseEditor") as! MedicationDoseEditorViewController
			controller.notificationToSendOnAccept = notificationToSend
			controller.medication = medication
			customPresentViewController(Me.setDosePresenter, viewController: controller, animated: false)
		}
		// swiftformat:enable all
	}

	@objc private final func presentLastDoseView(notification: Notification) {
		// swiftformat:disable all
		if
			let notificationToSend: Notification.Name = value(for: .notificationName, from: notification),
			let medication: Medication = value(for: .medication, from: notification)
		{
			do {
				guard let mostRecentDose = try injected(MedicationDAO.self).mostRecentDoseOf(medication) else {
					Me.log.error("tried to present most recent dose editor for medication that has never been taken")
					return
				}
				let controller = viewController(named: "medicationDoseEditor") as! MedicationDoseEditorViewController
				controller.notificationToSendOnAccept = notificationToSend
				controller.medication = medication
				controller.medicationDose = mostRecentDose
				customPresentViewController(Me.setDosePresenter, viewController: controller, animated: false)
			} catch {
				showError(title: "Failed to get most recent dose of \(medication.name)", error: error)
			}
		}
		// swiftformat:enable all
	}

	@objc private final func errorOccurred(notification: Notification) {
		if let title: String = value(for: .title, from: notification) {
			let message: String? = value(for: .message, from: notification) ?? "Sorry for the inconvenience."
			showError(title: title, message: message)
		}
	}

	@objc private final func persistenceLayerDidRefresh(notification _: Notification) {
		finishedLoading = true
	}

	@objc private final func persistenceLayerWillRefresh(notification _: Notification) {
		finishedLoading = false
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
		actionsController.addAction(injected(UiUtil.self).alertAction(
			title: "Cancel",
			style: .cancel,
			handler: nil
		))
		present(actionsController, animated: false, completion: nil)
	}

	private final func getSortAlphabeticallyAction() -> UIAlertAction {
		injected(UiUtil.self).alertAction(
			title: "Sort Alphabetically",
			style: .default,
			handler: { _ in
				self.currentSort = NSSortDescriptor(key: "name", ascending: true)
				self.loadMedications()
			}
		)
	}

	private final func getSortZetabeticallyAction() -> UIAlertAction {
		injected(UiUtil.self).alertAction(
			title: "Sort Zetabetically",
			style: .default,
			handler: { _ in
				self.currentSort = NSSortDescriptor(key: "name", ascending: false)
				self.loadMedications()
			}
		)
	}

	private final func getUseDefaultSortAction() -> UIAlertAction {
		injected(UiUtil.self).alertAction(
			title: "Use Default Sort Order",
			style: .default,
			handler: { _ in
				self.currentSort = nil
				self.loadMedications()
			}
		)
	}

	private final func getEditDefaultSortAction() -> UIAlertAction {
		injected(UiUtil.self).alertAction(
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
		injected(UiUtil.self).alertAction(
			title: "Permanent Sort by Recent Count",
			style: .default,
			handler: { _ in self.presentSortByRecentCountOptions() }
		)
	}

	private final func getDeleteAction(for indexPath: IndexPath) -> UIContextualAction {
		injected(UiUtil.self).contextualAction(style: .destructive, title: "🗑️") { _, _, completion in
			let medication = self.fetchedResultsController.object(at: indexPath)
			let alert = UIAlertController(
				title: "Are you sure you want to delete \(medication.name)?",
				message: "This will delete all history for this medication.",
				preferredStyle: .alert
			)
			alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
				do {
					let transaction = injected(Database.self).transaction()
					try transaction.delete(medication)
					try retryOnFail({ try transaction.commit() }, maxRetries: 2)
					self.loadMedications()
				} catch {
					Me.log.error("Failed to delete medication: %@", errorInfo(error))
					self.showError(title: "Failed to delete medication", error: error)
				}
			})
			alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
			self.present(alert, animated: false, completion: { completion(true) })
		}
	}

	private final func getEditAction(for indexPath: IndexPath) -> UIContextualAction {
		let edit = injected(UiUtil.self).contextualAction(style: .normal, title: "Edit") { _, _, completion in
			let controller: EditMedicationViewController = self.viewController(named: "editMedication")
			controller.notificationToSendOnAccept = Me.medicationEdited
			controller.medication = self.fetchedResultsController.object(at: indexPath)
			completion(true)
			self.pushToNavigationController(controller)
		}
		edit.backgroundColor = .orange
		return edit
	}

	// MARK: - Helper Functions

	private final func presentSortByRecentCountOptions() {
		let controller = viewController(named: "chooseRecentTimePeriod") as! ChooseRecentTimePeriodViewController
		controller.initialTimeUnit = .weekOfYear
		controller.initialNumTimeUnits = 2
		present(controller, using: Me.presenter)
	}

	final fileprivate func loadMedications() {
		resetFetchedResultsController()
		finishedLoading = true
	}

	private final func resetFetchedResultsController() {
		do {
			Me.signpost.begin(name: "resetting fetched results controller")
			fetchedResultsController = injected(Database.self).fetchedResultsController(
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
			Me.signpost.end(name: "resetting fetched results controller")
		} catch {
			Me.log.error("Failed to fetch medications: %@", errorInfo(error))
			Me.signpost.end(name: "resetting fetched results controller")
			showError(
				title: "Failed to retrieve activities",
				message: "Something went wrong while trying to retrieve the list of your activities. Sorry for the inconvenience.",
				error: error,
				tryAgain: loadMedications
			)
		}
	}

	final fileprivate func quickCreateAndTake() {
		let searchText = getSearchText()
		if !searchText.isEmpty {
			do {
				guard try !medicationWithNameExists(searchText) else {
					showError(title: "Medication named '\(searchText)' already exists.")
					return
				}
				let transaction = injected(Database.self).transaction()

				let medication = try transaction.new(Medication.self)
				medication.name = searchText
				medication.setSource(.introspective)
				medication
					.recordScreenIndex = Int16(
						try injected(Database.self)
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
				Me.log.error("Failed to quick create & take medication: %@", errorInfo(error))
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
		let results = try injected(Database.self).query(fetchRequest)
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

// MARK: - Instructions

/// This class is used to break retain cycles between `RecordMedicationTableViewController` and the closures used by `CoachMarkInfo`, preventing them from causing memory leaks
final fileprivate class RecordMedicationTableViewControllerCoachMarksDataSourceAndDelegate: CoachMarksDataSourceAndDelegate {
	// MARK: Type Aliases

	private typealias Me = RecordMedicationTableViewControllerCoachMarksDataSourceAndDelegate
	private typealias Super = DefaultCoachMarksDataSourceAndDelegate
	private typealias ControllerClass = RecordMedicationTableViewController

	// MARK: Static Variables

	private static let exampleMedicationName = "Example Medication"

	private static let log = Log()

	// MARK: Instance Variables

	private weak final var controller: RecordMedicationTableViewController?

	private lazy final var coachMarksInfo: [CoachMarkInfo] = [
		CoachMarkInfo(
			hint: "Tap the + button to create new medications. You can also type the name of a new medication in the search bar and long press the + button to quickly create and mark it as taken.",
			useArrow: true,
			view: { self.controller?.navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView }
		),
		CoachMarkInfo(
			hint: "This is the name of the medication. Tap it to view dose history.",
			useArrow: true,
			view: { self.getExampleMedicationCell()?.medicationNameLabel },
			setup: {
				guard let controller = self.controller else { return }
				if controller.tableView.visibleCells.isEmpty {
					controller.searchController.searchBar.text = Me.exampleMedicationName
					controller.quickCreateAndTake()
				}
			}
		),
		CoachMarkInfo(
			hint: "Press this button to quickly mark this medication as taken. Long pressing allows setting the dosage and date / time that it was taken.",
			useArrow: true,
			view: { self.getExampleMedicationCell()?.takeButton }
		),
		CoachMarkInfo(
			hint: "This displays the most recent date and time that this medication was taken. Tap to edit the most recent dose.",
			useArrow: true,
			view: { self.getExampleMedicationCell()?.lastTakenOnDateButton }
		),
		CoachMarkInfo(
			hint: "Sorting options can be accessed here.",
			useArrow: true,
			view: { self.controller?.sortButton.value(forKey: "view") as? UIView }
		),
	]

	private lazy var delegate: DefaultCoachMarksDataSourceAndDelegate = {
		DefaultCoachMarksDataSourceAndDelegate(
			coachMarksInfo,
			instructionsShownKey: .recordMedicationsInstructionsShown,
			cleanup: deleteExampleMedication,
			skipViewLayoutConstraints: Super.defaultCoachMarkSkipViewConstraints()
		)
	}()

	// MARK: Initializers

	public init(_ controller: RecordMedicationTableViewController) {
		self.controller = controller
	}

	// MARK: Functions

	public final func coachMarksController(
		_ coachMarksController: CoachMarksController,
		coachMarkViewsAt index: Int,
		madeFrom coachMark: CoachMark
	) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
		delegate.coachMarksController(coachMarksController, coachMarkViewsAt: index, madeFrom: coachMark)
	}

	public final func coachMarksController(
		_ coachMarksController: CoachMarksController,
		coachMarkAt index: Int
	) -> CoachMark {
		delegate.coachMarksController(coachMarksController, coachMarkAt: index)
	}

	public final func numberOfCoachMarks(for controller: CoachMarksController) -> Int {
		delegate.numberOfCoachMarks(for: controller)
	}

	public final func coachMarksController(
		_ coachMarksController: CoachMarksController,
		constraintsForSkipView skipView: UIView,
		inParent parentView: UIView
	) -> [NSLayoutConstraint]? {
		delegate.coachMarksController(coachMarksController, constraintsForSkipView: skipView, inParent: parentView)
	}

	public final func coachMarksController(
		_ coachMarksController: CoachMarksController,
		didEndShowingBySkipping skipped: Bool
	) {
		delegate.coachMarksController(coachMarksController, didEndShowingBySkipping: skipped)
	}

	private final func deleteExampleMedication() {
		let medicationFetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
		medicationFetchRequest.predicate = NSPredicate(format: "name == %@", Me.exampleMedicationName)
		do {
			let medications = try injected(Database.self).query(medicationFetchRequest)
			for medication in medications {
				let transaction = injected(Database.self).transaction()
				try transaction.delete(medication)
				try retryOnFail({ try transaction.commit() }, maxRetries: 2)
				controller?.loadMedications()
			}
		} catch {
			Me.log.error("Failed to delete example medication: %@", errorInfo(error))
		}
	}

	private final func getExampleMedicationCell() -> RecordMedicationTableViewCell? {
		guard let controller = self.controller else { return nil }
		guard controller.tableView.visibleCells.count > 0 else {
			Me.log.error("No visible cells while trying to present instruction")
			return nil
		}
		let cell = controller.tableView.visibleCells[0]
		guard let exampleMedicationCell = cell as? RecordMedicationTableViewCell else {
			Me.log.error(
				"unable to cast to RecordMedicationTableViewCell: was a %@",
				String(describing: type(of: cell))
			)
			return nil
		}
		return exampleMedicationCell
	}
}
