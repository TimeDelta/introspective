//
//  MedicationDosesTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/12/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Presentr
import SwiftDate
import UIKit

import Common
import DependencyInjection
import Persistence
import SampleGroupInformation
import Samples

public final class MedicationDosesTableViewController: UITableViewController {
	// MARK: - Static Variables

	private typealias Me = MedicationDosesTableViewController

	// MARK: Notification Names

	static let dateRangeSet = Notification.Name("medicationDosesTableDateRangeSet")
	static let medicationDoseEdited = Notification.Name("medicationDoseEdited")

	// MARK: Section Indexes

	private static let informationSectionIndex = 0
	private static let dosesSectionIndex = 1

	// MARK: Presenters

	private static let dateFilterPresenter: Presentr = {
		let customType = PresentationType.custom(width: .default, height: .custom(size: 438), center: .center)
		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()

	private static let medicationDosePresenter: Presentr = {
		let customType = PresentationType.custom(
			width: .custom(size: 300),
			height: .custom(size: 250),
			center: .topCenter
		)
		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()

	// MARK: Information

	private static let information = [
		CountInformation(MedicationDose.defaultIndependentAttribute),
		SumInformation(MedicationDose.dosage),
	]

	// MARK: Logging

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var previousDateRangeButton: UIBarButtonItem!
	@IBOutlet final var dateRangeButton: UIBarButtonItem!
	@IBOutlet final var nextDateRangeButton: UIBarButtonItem!

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

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		extendedLayoutIncludesOpaqueBars = true

		dateRangeButton.accessibilityLabel = "filter dates button"

		navigationItem.rightBarButtonItem = editButtonItem
		navigationItem.title = medication.name

		setTableViewInsetsForTabBar()

		observe(selector: #selector(dateRangeSet), name: Me.dateRangeSet)
		observe(selector: #selector(medicationDoseEdited), name: Me.medicationDoseEdited)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - TableViewDataSource

	public final override func numberOfSections(in _: UITableView) -> Int {
		2
	}

	public final override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case Me.informationSectionIndex:
			return Me.information.count
		case Me.dosesSectionIndex:
			return filteredDoses.count
		default:
			Me.log.error("Unknown section index: %d", section)
			return 0
		}
	}

	public final override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == Me.dosesSectionIndex {
			return "Doses"
		}
		return nil
	}

	public final override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "dose", for: indexPath)

		switch indexPath.section {
		case Me.informationSectionIndex:
			cell.textLabel?.text = computeInformation(at: indexPath.row)
		case Me.dosesSectionIndex:
			cell.textLabel?.text = getTextForDoseAt(indexPath.row)
		default:
			Me.log.error("Unknown section index: %d", indexPath.section)
		}

		return cell
	}

	// MARK: - TableViewDelegate

	public final override func tableView(
		_ tableView: UITableView,
		editActionsForRowAt indexPath: IndexPath
	) -> [UITableViewRowAction]? {
		guard indexPath.section != Me.informationSectionIndex else { return nil }

		let dose = filteredDoses[indexPath.row]
		let delete = DependencyInjector.get(UiUtil.self).tableViewRowAction(
			style: .destructive,
			title: "🗑️"
		) { _, indexPath in
			let alert = DependencyInjector.get(UiUtil.self).alert(
				title: "Are you sure you want to delete this dose?",
				message: self.getTextForDoseAt(indexPath.row),
				preferredStyle: .alert
			)
			alert.addAction(DependencyInjector.get(UiUtil.self).alertAction(
				title: "Yes",
				style: .destructive
			) { _ in
				let indexToDelete = self.medication.doses.index(of: dose)
				let transaction = DependencyInjector.get(Database.self).transaction()
				do {
					try retryOnFail({ try transaction.delete(dose) }, maxRetries: 2)
					try retryOnFail({ try transaction.commit() }, maxRetries: 2)
					self.medication.removeFromDoses(at: indexToDelete)
					self.resetFilteredDoses()
					tableView.deleteRows(at: [indexPath], with: .fade)
					tableView.reloadData()
				} catch {
					Me.log.error("Failed to delete medication dose: %@", errorInfo(error))
					self.showError(title: "Failed to delete dose", error: error)
				}
			})
			alert.addAction(DependencyInjector.get(UiUtil.self).alertAction(
				title: "No",
				style: .cancel,
				handler: nil
			))
			self.present(alert, animated: false, completion: nil)
		}
		delete.accessibilityLabel = "delete dose button"
		let dateText = DependencyInjector.get(CalendarUtil.self)
			.string(for: dose.date, dateStyle: .long, timeStyle: .short)
		var dosageText = dose.dosage?.description ?? ""
		if !dosageText.isEmpty {
			dosageText += " "
		}
		delete.accessibilityHint = "Delete the \(dosageText)dose of \(medication.name) taken on \(dateText)"

		return [delete]
	}

	public final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard indexPath.section != Me.informationSectionIndex else {
			tableView.deselectRow(at: indexPath, animated: false)
			return
		}

		let controller = viewController(named: "medicationDoseEditor") as! MedicationDoseEditorViewController
		controller.medicationDose = filteredDoses[indexPath.row]
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
			let transaction = DependencyInjector.get(Database.self).transaction()
			do {
				let doseFromTransaction = try transaction.pull(savedObject: dose)
				medication = try transaction.pull(savedObject: medication)
				medication.replaceDoses(at: lastClickedIndex, with: doseFromTransaction)
				try retryOnFail({ try transaction.commit() }, maxRetries: 2)
				medication = try DependencyInjector.get(Database.self).pull(savedObject: medication)
				resetFilteredDoses()
				tableView.reloadData()
			} catch {
				Me.log.error("Failed to save medication and dose edit: %@", errorInfo(error))
				showError(
					title: "Failed to save dose of \(medication.name)",
					error: error,
					tryAgain: { self.medicationDoseEdited(notification: notification) }
				)
			}
		}
	}

	// MARK: - Actions

	@IBAction final func filterDatesButtonPressed(_: Any) {
		let controller = viewController(named: "dateRangeChooser", fromStoryboard: "Util") as! DateRangeViewController
		controller.initialFromDate = filterStartDate
		controller.initialToDate = filterEndDate
		controller.datePickerMode = .date
		controller.notificationToSendOnAccept = Me.dateRangeSet
		customPresentViewController(Me.dateFilterPresenter, viewController: controller, animated: false)
	}

	@IBAction final func previousDateRangeButtonPressed(_: Any) {
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

	@IBAction final func nextDateRangeButtonPressed(_: Any) {
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

	private final func computeInformation(at index: Int) -> String? {
		let information = Me.information[index]
		do {
			let value = try information.compute(forSamples: filteredDoses)
			return information.description + ": \(value)"
		} catch {
			Me.log.error("Failed to compute %@ for filtered doses: %@", information.description, errorInfo(error))
			return nil
		}
	}

	private final func getTextForDoseAt(_ index: Int) -> String {
		let dose = filteredDoses[index]
		var doseText = ""
		if let dosage = dose.dosage {
			doseText += dosage.description + " on "
		}
		doseText += DependencyInjector.get(CalendarUtil.self)
			.string(for: dose.date, dateStyle: .medium, timeStyle: .short)
		return doseText
	}

	private final func resetFilteredDoses() {
		filteredDoses = medication.sortedDoses(ascending: false)
		if filterStartDate != nil || filterEndDate != nil {
			var startDate = filterStartDate
			if let start = startDate {
				if filterEndDate == nil {
					startDate = DependencyInjector.get(CalendarUtil.self).end(of: .day, in: start)
				}
			}
			var endDate = filterEndDate
			if let end = endDate {
				if filterStartDate == filterEndDate {
					endDate = DependencyInjector.get(CalendarUtil.self).end(of: .day, in: end)
				} else if filterStartDate == nil {
					endDate = DependencyInjector.get(CalendarUtil.self).start(of: .day, in: end)
				}
			}
			// note: can't use NSFetchedResultsController or predicates because of timezone requirements
			filteredDoses = filteredDoses.filter {
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
			}
		}
	}

	private final func resetDateRangeButtonTitle() {
		var dateText: String
		if filterStartDate == nil && filterEndDate == nil {
			dateText = "Filter Dates"
		} else if filterEndDate == filterStartDate {
			dateText = "On "
			dateText += DependencyInjector.get(CalendarUtil.self)
				.string(for: filterStartDate!, dateStyle: .medium, timeStyle: .none)
		} else if filterEndDate == nil {
			dateText = "After "
			dateText += DependencyInjector.get(CalendarUtil.self)
				.string(for: filterStartDate!, dateStyle: .medium, timeStyle: .none)
		} else if filterStartDate == nil {
			dateText = "Before "
			dateText += DependencyInjector.get(CalendarUtil.self)
				.string(for: filterEndDate!, dateStyle: .medium, timeStyle: .none)
		} else {
			dateText = "From "
			dateText += DependencyInjector.get(CalendarUtil.self)
				.string(for: filterStartDate!, dateStyle: .short, timeStyle: .none)
			dateText += " to "
			dateText += DependencyInjector.get(CalendarUtil.self)
				.string(for: filterEndDate!, dateStyle: .short, timeStyle: .none)
		}
		dateRangeButton.title = dateText
		dateRangeButton.accessibilityValue = dateText
		dateRangeButton.accessibilityIdentifier = "filter dates button"
		dateRangeButton.accessibilityLabel = "filter dates button"
		dateRangeButton.accessibilityHint = "Filter the displayed doses of \(medication.name) by date range"
	}
}
