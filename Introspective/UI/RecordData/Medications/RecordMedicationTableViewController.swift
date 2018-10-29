//
//  RecordMedicationTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import CoreData
import Presentr
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

	// MARK: - Instance Variables

	private final let searchController = UISearchController(searchResultsController: nil)
	private final var medications = [Medication]() {
		didSet { resetFilteredMedications() }
	}
	private final var filteredMedications = [Medication]()
	private final var errorMessage: String? {
		didSet {
			if errorMessage != nil { tableView.reloadData() }
		}
	}
	private final var finishedLoading = false {
		didSet {
			searchController.searchBar.isUserInteractionEnabled = finishedLoading
			tableView.reloadData()
		}
	}

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.rightBarButtonItem = self.editButtonItem
		DispatchQueue.global(qos: .userInteractive).async {
			do {
				let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
				fetchRequest.sortDescriptors = [NSSortDescriptor(key: "recordScreenIndex", ascending: true)]
				let medications = try DependencyInjector.db.query(fetchRequest)
				DispatchQueue.main.async {
					self.medications = medications
					self.finishedLoading = true
					self.tableView.reloadData()
				}
			} catch {
				self.errorMessage = "Something went wrong while trying to retrieve the list of your medications."
				os_log("Failed to fetch medications: %@", type: .error, error.localizedDescription)
			}
		}

		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search Medications"
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		definesPresentationContext = true

		NotificationCenter.default.addObserver(self, selector: #selector(medicationCreated), name: Me.medicationCreated, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(presentSetDoseView), name: RecordMedicationTableViewCell.shouldPresentMedicationDoseView, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(errorOccurred), name: RecordMedicationTableViewCell.errorOccurred, object: nil)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(presentMedicationDosesTableView),
			name: RecordMedicationTableViewCell.shouldPresentDosesView,
			object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(medicationEdited), name: Me.medicationEdited, object: nil)
	}

	// MARK: - TableViewDataSource

	public final override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	public final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if !finishedLoading || errorMessage != nil {
			return 1
		}
		return filteredMedications.count
	}

	public final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if errorMessage != nil {
			let cell = tableView.dequeueReusableCell(withIdentifier: "errorMessage", for: indexPath)
			cell.textLabel!.text = errorMessage
			return cell
		}
		if !finishedLoading {
			return tableView.dequeueReusableCell(withIdentifier: "waiting", for: indexPath)
		}
		let cell = tableView.dequeueReusableCell(withIdentifier: "recordMedication", for: indexPath) as! RecordMedicationTableViewCell
		cell.medication = filteredMedications[indexPath.row]
		return cell
	}

	public final override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if errorMessage == nil && !finishedLoading {
			return 44
		}
		return 81
	}

	// MARK: - TableViewDelegate

	public final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let controller = storyboard!.instantiateViewController(withIdentifier: "editMedication") as! EditMedicationViewController
		controller.notificationToSendOnAccept = Me.medicationEdited
		controller.medication = filteredMedications[indexPath.row]
		navigationController?.pushViewController(controller, animated: true)
	}

	// MARK: - Table view editing

	public final override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
			let medication = self.filteredMedications[indexPath.row]
			let alert = UIAlertController(title: "Are you sure you want to delete \(medication.name)?", message: nil, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
				if let index = self.medications.firstIndex(of: medication) {
					self.medications.remove(at: index)
					DispatchQueue.global(qos: .background).async {
						DependencyInjector.db.delete(medication)
					}
					tableView.deleteRows(at: [indexPath], with: .fade)
					tableView.reloadData()
				}
			})
			alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
			self.present(alert, animated: false, completion: nil)
		}

		return [delete]
	}

	public final override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		let medicationsFromIndex = Int(filteredMedications[fromIndexPath.row].recordScreenIndex)
		let medicationsToIndex = Int(filteredMedications[to.row].recordScreenIndex)
		if medicationsFromIndex < medicationsToIndex {
			for i in medicationsFromIndex + 1 ... medicationsToIndex {
				medications[i].recordScreenIndex -= 1
			}
		} else {
			for i in medicationsToIndex ..< medicationsFromIndex {
				medications[i].recordScreenIndex += 1
			}
		}
		medications[medicationsFromIndex].recordScreenIndex = Int16(medicationsToIndex)
		let medication = medications.remove(at: medicationsFromIndex)
		medications.insert(medication, at: Int(medication.recordScreenIndex))
		DependencyInjector.db.save()
		resetFilteredMedications()
		tableView.reloadData()
	}

	// MARK: - Received Notifications

	@objc private final func medicationCreated(notification: Notification) {
		if let medication = notification.object as? Medication {
			medication.recordScreenIndex = Int16(medications.count)
			DependencyInjector.db.save()
			medications.append(medication)
			resetFilteredMedications()
			tableView.reloadData()
		}
	}

	@objc private final func medicationEdited(notification: Notification) {
		if let medication = notification.object as? Medication {
			DependencyInjector.db.save()
			medications[Int(medication.recordScreenIndex)] = medication
			resetFilteredMedications()
			tableView.reloadData()
		}
	}

	@objc private final func presentSetDoseView(notification: Notification) {
		if let userInfo = notification.userInfo {
			let controller = storyboard!.instantiateViewController(withIdentifier: "medicationDoseEditor") as! MedicationDoseEditorViewController
			controller.medication = userInfo[RecordMedicationTableViewCell.medicationUserInfoKey] as? Medication
			controller.notificationToSendOnAccept = userInfo[RecordMedicationTableViewCell.notificationUserInfoKey] as? Notification.Name
			customPresentViewController(Me.setDosePresenter, viewController: controller, animated: false)
		} else {
			os_log("Required UserInfo not set on notification: %@", type: .error, notification.debugDescription)
		}
	}

	@objc private final func presentMedicationDosesTableView(notification: Notification) {
		let controller = storyboard!.instantiateViewController(withIdentifier: "medicationDoses") as! MedicationDosesTableViewController
		controller.medication = notification.object as? Medication
		navigationController?.pushViewController(controller, animated: true)
	}

	@objc private final func errorOccurred(notification: Notification) {
		let alert = UIAlertController(title: notification.object as? String, message: "Sorry for the inconvenience.", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
		present(alert, animated: false, completion: nil)
	}

	// MARK: - Button Actions

	@IBAction final func addButtonPressed(_ sender: Any) {
		let controller = storyboard!.instantiateViewController(withIdentifier: "editMedication") as! EditMedicationViewController
		controller.notificationToSendOnAccept = Me.medicationCreated
		controller.initialName = getSearchText()
		navigationController?.pushViewController(controller, animated: true)
	}

	// MARK: - Helper Functions

	private final func resetFilteredMedications() {
		let searchText = getSearchText().localizedLowercase
		filteredMedications = medications
		if !searchText.isEmpty {
			filteredMedications = filteredMedications.filter({ medication in
				var notesMatch = false
				if let notes = medication.notes?.localizedLowercase {
					notesMatch = notes.contains(searchText)
				}
				return medication.name.localizedLowercase.contains(searchText) || notesMatch
			})
		}
	}

	private final func getSearchText() -> String {
		return searchController.searchBar.text!
	}
}

// MARK: - UISearchResultsUpdating

extension RecordMedicationTableViewController: UISearchResultsUpdating {
	public func updateSearchResults(for searchController: UISearchController) {
		resetFilteredMedications()
		tableView.reloadData()
	}
}