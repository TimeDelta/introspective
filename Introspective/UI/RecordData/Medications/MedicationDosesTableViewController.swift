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
import os

public final class MedicationDosesTableViewController: UITableViewController {

	// MARK: - Static Variables

	private typealias Me = MedicationDosesTableViewController
	private static let dateRangeSet = Notification.Name("medicationDosesTableDateRangeSet")
	private static let medicationDoseEdited = Notification.Name("medicationDoseEdited")
	private static let dateFiliterPresenter: Presentr = {
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
	private final var filteredDoses: NSOrderedSet!
	private final var filterStartDate: Date?
	private final var filterEndDate: Date?
	private final var lastClickedIndex: Int!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.rightBarButtonItem = self.editButtonItem
		navigationItem.title = medication.name
		NotificationCenter.default.addObserver(self, selector: #selector(dateRangeSet), name: Me.dateRangeSet, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(medicationDoseEdited), name: Me.medicationDoseEdited, object: nil)
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
		let dose = self.medication.doses.object(at: indexPath.row) as! MedicationDose
		let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
			let alert = UIAlertController(
				title: "Are you sure you want to delete this dose?",
				message: self.getTextForDoseAt(indexPath.row),
				preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
				self.medication.removeFromDoses(at: indexPath.row)
				DependencyInjector.db.delete(dose)
				self.resetFilteredDoses()
				tableView.deleteRows(at: [indexPath], with: .fade)
				tableView.reloadData()
			})
			alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
			self.present(alert, animated: false, completion: nil)
		}
		delete.accessibilityLabel = "delete dose button"
		let dateText = DependencyInjector.util.calendar.string(for: dose.timestamp, inFormat: "MMMM d, yyyy 'at' H:mm")
		var dosageText = dose.dosage?.description ?? ""
		if !dosageText.isEmpty {
			dosageText += " "
		}
		delete.accessibilityHint = "Delete the \(dosageText)dose of \(medication.name) taken on \(dateText)"

		return [delete]
	}

	public final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let controller = storyboard!.instantiateViewController(withIdentifier: "medicationDoseEditor") as! MedicationDoseEditorViewController
		controller.medicationDose = medication.doses.object(at: indexPath.row) as? MedicationDose
		controller.notificationToSendOnAccept = Me.medicationDoseEdited
		lastClickedIndex = indexPath.row
		customPresentViewController(Me.medicationDosePresenter, viewController: controller, animated: true)
	}

	// MARK: - Received Notificaitons

	@objc private final func dateRangeSet(notification: Notification) {
		if let dates = notification.object as? (from: Date?, to: Date?) {
			filterStartDate = dates.from
			filterEndDate = dates.to
			let enablePreviousAndNextButtons = filterStartDate != nil || filterEndDate != nil
			previousDateRangeButton.isEnabled = enablePreviousAndNextButtons
			nextDateRangeButton.isEnabled = enablePreviousAndNextButtons
			resetFilteredDoses()
			tableView.reloadData()
			resetDateRangeButtonTitle()
		} else {
			os_log("Wrong type returned from notification: %@", type: .error, String(describing: type(of: notification.object)))
		}
	}

	@objc private final func medicationDoseEdited(notification: Notification) {
		if let dose = notification.object as? MedicationDose {
			medication.replaceDoses(at: lastClickedIndex, with: dose)
			DependencyInjector.db.save()
			resetFilteredDoses()
			tableView.reloadData()
		}
	}

	// MARK: - Actions

	@IBAction final func filterDatesButtonPressed(_ sender: Any) {
		let controller = UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "dateRangeChooser") as! DateRangeViewController
		controller.initialFromDate = filterStartDate
		controller.initialToDate = filterEndDate
		controller.maxFromDate = Date()
		controller.maxToDate = Date() + 1.days
		controller.datePickerMode = .date
		controller.notificationToSendOnAccept = Me.dateRangeSet
		customPresentViewController(Me.dateFiliterPresenter, viewController: controller, animated: true)
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
		let dose = filteredDoses.object(at: index) as! MedicationDose
		var doseText = ""
		if let dosage = dose.dosage {
			doseText += dosage.description + " on "
		}
		doseText += DependencyInjector.util.calendar.string(for: dose.timestamp, inFormat: "MMM d, yyyy 'at' H:mm")
		return doseText
	}

	private final func resetFilteredDoses() {
		filteredDoses = NSOrderedSet(array: medication.sortedDoses(ascending: false))
		if filterStartDate != nil || filterEndDate != nil {
			var filterPredicates = [NSPredicate]()
			if var startDate = filterStartDate {
				if filterEndDate == nil {
					startDate = DependencyInjector.util.calendar.end(of: .day, in: startDate)
				}
				filterPredicates.append(NSPredicate(format: "%K > %@", "timestamp", startDate as NSDate))
			}
			if var endDate = filterEndDate {
				if filterStartDate == filterEndDate {
					endDate = DependencyInjector.util.calendar.end(of: .day, in: endDate)
				} else if filterStartDate == nil {
					endDate = DependencyInjector.util.calendar.start(of: .day, in: endDate)
				}
				filterPredicates.append(NSPredicate(format: "%K < %@", "timestamp", endDate as NSDate))
			}
			filteredDoses = filteredDoses.filtered(using: NSCompoundPredicate(andPredicateWithSubpredicates: filterPredicates))
		}
	}

	private final func resetDateRangeButtonTitle() {
		var dateText: String
		if filterStartDate == nil && filterEndDate == nil {
			dateText = "Filter Dates"
		} else if filterEndDate == filterStartDate {
			dateText = "On "
			dateText += DependencyInjector.util.calendar.string(for: filterStartDate!, inFormat: "MMM d, yyyy")
		} else if filterEndDate == nil {
			dateText = "After "
			dateText += DependencyInjector.util.calendar.string(for: filterStartDate!, inFormat: "MMM d, yyyy")
		} else if filterStartDate == nil {
			dateText = "Before "
			dateText += DependencyInjector.util.calendar.string(for: filterEndDate!, inFormat: "MMM dd, yyyy")
		} else {
			dateText = "From "
			dateText += DependencyInjector.util.calendar.string(for: filterStartDate!, inFormat: "M/d/yy")
			dateText += " to "
			dateText += DependencyInjector.util.calendar.string(for: filterEndDate!, inFormat: "M/d/yy")
		}
		dateRangeButton.title = dateText
		dateRangeButton.accessibilityValue = dateText
		dateRangeButton.accessibilityIdentifier = "filter dates button"
		dateRangeButton.accessibilityLabel = "filter dates button"
		dateRangeButton.accessibilityHint = "Filter the displayed doses of \(medication.name) by date range"
	}
}
