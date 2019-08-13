//
//  MedicationDosesTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/12/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import SwiftDate

public final class MedicationDosesTableViewController: UITableViewController {

	// MARK: - Static Variables

	private typealias Me = MedicationDosesTableViewController
	static let dateRangeSet = Notification.Name("medicationDosesTableDateRangeSet")
	static let medicationDoseEdited = Notification.Name("medicationDoseEdited")
	private static let dateFilterPresenter: Presentr = {
		let customType = PresentationType.custom(width: .default, height: .custom(size: 438), center: .center)
		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()
	private static let medicationDosePresenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 250), center: .topCenter)
		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()

	// MARK: - IBOutlets

	@IBOutlet weak final var previousDateRangeButton: UIBarButtonItem!
	@IBOutlet weak final var dateRangeButton: UIBarButtonItem!
	@IBOutlet weak final var nextDateRangeButton: UIBarButtonItem!

	// MARK: - Instance Variables

	public final var medication: Medication! {
		didSet {
			resetFilteredDoses()
			tableView.reloadData()
		}
	}
	// leave not private for testing purposes
	final var filteredDoses = [MedicationDose]()
	private final var filterStartDate: Date?
	private final var filterEndDate: Date?
	private final var lastClickedIndex: Int!

	private final let log = Log()

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		extendedLayoutIncludesOpaqueBars = true

		dateRangeButton.accessibilityLabel = "filter dates button"

		navigationItem.rightBarButtonItem = self.editButtonItem
		navigationItem.title = medication.name

		observe(selector: #selector(dateRangeSet), name: Me.dateRangeSet)
		observe(selector: #selector(medicationDoseEdited), name: Me.medicationDoseEdited)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - TableViewDataSource

	public final override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	public final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filteredDoses.count
	}

	public final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "dose", for: indexPath)
		cell.textLabel?.text = getTextForDoseAt(indexPath.row)
		return cell
	}

	// MARK: - TableViewDelegate

	public final override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let dose = filteredDoses[indexPath.row]
		let delete = DependencyInjector.util.ui.tableViewRowAction(style: .destructive, title: "🗑️") { (_, indexPath) in
			let alert = DependencyInjector.util.ui.alert(
				title: "Are you sure you want to delete this dose?",
				message: self.getTextForDoseAt(indexPath.row),
				preferredStyle: .alert)
			alert.addAction(DependencyInjector.util.ui.alertAction(title: "Yes", style: .destructive) { _ in
				let indexToDelete = self.medication.doses.index(of: dose)
				let transaction = DependencyInjector.db.transaction()
				do {
					try retryOnFail({ try transaction.delete(dose) }, maxRetries: 2)
					try retryOnFail({ try transaction.commit() }, maxRetries: 2)
					self.medication.removeFromDoses(at: indexToDelete)
					self.resetFilteredDoses()
					tableView.deleteRows(at: [indexPath], with: .fade)
					tableView.reloadData()
				} catch {
					self.log.error("Failed to delete medication dose: %@", errorInfo(error))
					self.showError(title: "Failed to delete dose", error: error)
				}
			})
			alert.addAction(DependencyInjector.util.ui.alertAction(title: "No", style: .cancel, handler: nil))
			self.present(alert, animated: false, completion: nil)
		}
		delete.accessibilityLabel = "delete dose button"
		let dateText = DependencyInjector.util.calendar.string(for: dose.date, dateStyle: .long, timeStyle: .short)
		var dosageText = dose.dosage?.description ?? ""
		if !dosageText.isEmpty {
			dosageText += " "
		}
		delete.accessibilityHint = "Delete the \(dosageText)dose of \(medication.name) taken on \(dateText)"

		return [delete]
	}

	public final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let controller = viewController(named: "medicationDoseEditor") as! MedicationDoseEditorViewController
		controller.medicationDose = medication.doses.object(at: indexPath.row) as? MedicationDose
		controller.notificationToSendOnAccept = Me.medicationDoseEdited
		controller.medication = medication
		lastClickedIndex = medication.doses.index(of: filteredDoses[indexPath.row])
		customPresentViewController(Me.medicationDosePresenter, viewController: controller, animated: false)
		tableView.deselectRow(at: indexPath, animated: false)
	}

	// MARK: - Received Notifications

	@objc private final func dateRangeSet(notification: Notification) {
		filterStartDate = value(for: .fromDate, from: notification)
		filterEndDate = value(for: .toDate, from: notification)
		let enablePreviousAndNextButtons = filterStartDate != nil || filterEndDate != nil
		previousDateRangeButton.isEnabled = enablePreviousAndNextButtons
		nextDateRangeButton.isEnabled = enablePreviousAndNextButtons
		resetFilteredDoses()
		tableView.reloadData()
		resetDateRangeButtonTitle()
	}

	@objc private final func medicationDoseEdited(notification: Notification) {
		if let dose: MedicationDose = value(for: .dose, from: notification) {
			let transaction = DependencyInjector.db.transaction()
			do {
				let doseFromTransaction = try transaction.pull(savedObject: dose)
				medication = try transaction.pull(savedObject: medication)
				medication.replaceDoses(at: lastClickedIndex, with: doseFromTransaction)
				try retryOnFail({ try transaction.commit() }, maxRetries: 2)
				medication = try DependencyInjector.db.pull(savedObject: medication)
				resetFilteredDoses()
				tableView.reloadData()
			} catch {
				log.error("Failed to save medication and dose edit: %@", errorInfo(error))
				showError(
					title: "Failed to save dose of \(medication.name)",
					error: error,
					tryAgain: { self.medicationDoseEdited(notification: notification) })
			}
		}
	}

	// MARK: - Actions

	@IBAction final func filterDatesButtonPressed(_ sender: Any) {
		let controller = viewController(named: "dateRangeChooser", fromStoryboard: "Util") as! DateRangeViewController
		controller.initialFromDate = filterStartDate
		controller.initialToDate = filterEndDate
		controller.datePickerMode = .date
		controller.notificationToSendOnAccept = Me.dateRangeSet
		customPresentViewController(Me.dateFilterPresenter, viewController: controller, animated: false)
	}

	@IBAction final func previousDateRangeButtonPressed(_ sender: Any) {
		if filterStartDate == filterEndDate {
			filterStartDate = filterStartDate! - 1.days
			filterEndDate = filterEndDate! - 1.days
		} else if filterStartDate == nil {
			filterEndDate = filterEndDate! - 1.days
		} else if filterEndDate == nil {
			filterStartDate = filterStartDate! - 1.days
		} else {
			let difference = filterEndDate! - filterStartDate!
			filterStartDate = filterStartDate! - difference
			filterEndDate = filterEndDate! - difference
		}
		resetDateRangeButtonTitle()
		resetFilteredDoses()
		tableView.reloadData()
	}

	@IBAction final func nextDateRangeButtonPressed(_ sender: Any) {
		if filterStartDate == filterEndDate {
			filterStartDate = filterStartDate! + 1.days
			filterEndDate = filterEndDate! + 1.days
		} else if filterStartDate == nil {
			filterEndDate = filterEndDate! + 1.days
		} else if filterEndDate == nil {
			filterStartDate = filterStartDate! + 1.days
		} else {
			let difference = filterEndDate! - filterStartDate!
			filterStartDate = filterStartDate! + difference
			filterEndDate = filterEndDate! + difference
		}
		resetDateRangeButtonTitle()
		resetFilteredDoses()
		tableView.reloadData()
	}

	// MARK: - Helper Functions

	private final func getTextForDoseAt(_ index: Int) -> String {
		let dose = filteredDoses[index]
		var doseText = ""
		if let dosage = dose.dosage {
			doseText += dosage.description + " on "
		}
		doseText += DependencyInjector.util.calendar.string(for: dose.date, dateStyle: .medium, timeStyle: .short)
		return doseText
	}

	private final func resetFilteredDoses() {
		filteredDoses = medication.sortedDoses(ascending: false)
		if filterStartDate != nil || filterEndDate != nil {
			var startDate = filterStartDate
			if let start = startDate {
				if filterEndDate == nil {
					startDate = DependencyInjector.util.calendar.end(of: .day, in: start)
				}
			}
			var endDate = filterEndDate
			if let end = endDate {
				if filterStartDate == filterEndDate {
					endDate = DependencyInjector.util.calendar.end(of: .day, in: end)
				} else if filterStartDate == nil {
					endDate = DependencyInjector.util.calendar.start(of: .day, in: end)
				}
			}
			// note: can't use NSFetchedResultsController or predicates because of timezone requirements
			filteredDoses = filteredDoses.filter({
				if let start = startDate {
					if start > $0.date {
						return false
					}
				}
				if let end = endDate {
					if end < $0.date {
						return false
					}
				}
				return true
			})
		}
	}

	private final func resetDateRangeButtonTitle() {
		var dateText: String
		if filterStartDate == nil && filterEndDate == nil {
			dateText = "Filter Dates"
		} else if filterEndDate == filterStartDate {
			dateText = "On "
			dateText += DependencyInjector.util.calendar.string(for: filterStartDate!, dateStyle: .medium, timeStyle: .none)
		} else if filterEndDate == nil {
			dateText = "After "
			dateText += DependencyInjector.util.calendar.string(for: filterStartDate!, dateStyle: .medium, timeStyle: .none)
		} else if filterStartDate == nil {
			dateText = "Before "
			dateText += DependencyInjector.util.calendar.string(for: filterEndDate!, dateStyle: .medium, timeStyle: .none)
		} else {
			dateText = "From "
			dateText += DependencyInjector.util.calendar.string(for: filterStartDate!, dateStyle: .short, timeStyle: .none)
			dateText += " to "
			dateText += DependencyInjector.util.calendar.string(for: filterEndDate!, dateStyle: .short, timeStyle: .none)
		}
		dateRangeButton.title = dateText
		dateRangeButton.accessibilityValue = dateText
		dateRangeButton.accessibilityIdentifier = "filter dates button"
		dateRangeButton.accessibilityLabel = "filter dates button"
		dateRangeButton.accessibilityHint = "Filter the displayed doses of \(medication.name) by date range"
	}
}
