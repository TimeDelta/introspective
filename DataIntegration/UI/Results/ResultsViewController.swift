//
//  ResultsViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

final class ResultsViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

	private typealias Me = ResultsViewController
	private static let cellHeights: [DataTypes: CGFloat] = [
		// HealthKit
		.heartRate: 44,
		.weight: 44,
		.bmi: 44,

		// CoreData
		.mood: 67,
	]

	public final var dataType: DataTypes!

	public final var extraInformation: [ExtraInformation]! {
		didSet {
			if error == nil && extraInformation != nil && samples != nil {
				DispatchQueue.main.async { self.viewIsReady() }
			}
		}
	}
	private final var extraInformationValues: [String]!

	public final var samples: [Sample]! {
		didSet {
			if error == nil && extraInformation != nil && samples != nil  {
				DispatchQueue.main.async { self.viewIsReady() }
			}
		}
	}

	public final var error: Error? {
		didSet {
			DispatchQueue.main.async { self.tableView.reloadData() }
		}
	}

	@IBOutlet weak final var actionsButton: UIBarButtonItem!

	private final var lastSelectedRowIndex: Int!
	private final var extraInformationEditIndex: Int!

	public final override func viewDidLoad() {
		disableActionsButton()
		self.navigationItem.setRightBarButton(actionsButton, animated: true)
	}

	// MARK: - Table view data source

	final override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	final override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Extra Information"
		} else if section == 1 {
			if dataType != nil {
				return dataType.description
			}
			return "Entries"
		} else {
			os_log("Unexpected section index while getting section title", type: .error)
			return nil
		}
	}

	final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if error != nil {
			if section == 1 {
				return 1
			}
			return 0
		}

		if waiting() {
			return 1
		}

		if section == 0 {
			return extraInformation.count
		}

		if section == 1 {
			return samples.count
		}

		os_log("Unexpected section index (%@) while determining number of rows in section", type: .error, String(section))
		return 0
	}

	final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let row = indexPath.row
		let section = indexPath.section

		if error != nil {
			let cell = tableView.dequeueReusableCell(withIdentifier: "errorCell", for: indexPath)
			var errorText = error!.localizedDescription
			if error is DisplayableError {
				errorText = (error as! DisplayableError).displayableDescription
			}
			cell.textLabel!.text = errorText
			return cell
		}

		if waiting() {
			return tableView.dequeueReusableCell(withIdentifier: "waitingCell", for: indexPath)
		}

		if section == 0 {
			let cell = (tableView.dequeueReusableCell(withIdentifier: "informationCell", for: indexPath) as! ExtraInformationTableViewCell)
			cell.extraInformation = extraInformation[row]
			cell.value = extraInformationValues[row]
			return cell
		}

		if section == 1 {
			switch (dataType!) {
				case .heartRate, .weight, .bmi:
					let sample = samples[row]
					let cell = (tableView.dequeueReusableCell(withIdentifier: "healthKitQuantitySampleCell", for: indexPath) as! HealthKitQuantitySampleTableViewCell)
					cell.sample = (sample as! HealthKitQuantitySample)
					return cell
				case .mood:
					let sample = samples[row]
					let cell = (tableView.dequeueReusableCell(withIdentifier: "moodSampleCell", for: indexPath) as! MoodTableViewCell)
					cell.mood = (sample as! Mood)
					return cell
			}
		}

		os_log("Unexpected section index (%@) while instantiating cell", type: .error, String(section))
		return UITableViewCell()
	}

	final override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return Me.cellHeights[dataType]!
	}

	// MARK: - TableView Editing

	final override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return indexPath.section == 0
	}

	final override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return indexPath.section == 0
	}

	final override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		extraInformation.swapAt(fromIndexPath.row, to.row)
		extraInformationValues.swapAt(fromIndexPath.row, to.row)
	}

	final override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
			self.extraInformation.remove(at: indexPath.row)
			self.extraInformationValues.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
			tableView.reloadData()
		}

		return [delete]
	}

	// MARK: - Navigation

	public final override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is ResultsActionsPopupViewController {
			let controller = segue.destination as! ResultsActionsPopupViewController
			controller.modalPresentationStyle = UIModalPresentationStyle.popover
			controller.popoverPresentationController!.delegate = self
			controller.currentlyEditing = isEditing
			let _ = controller.view
			controller.graphButton.addTarget(self, action: #selector(graphButtonPressed), for: .touchUpInside)
			controller.addInformationButton.addTarget(self, action: #selector(addInformationButtonPressed), for: .touchUpInside)
			controller.editButton.addTarget(self.editButtonItem.target, action: self.editButtonItem.action!, for: .touchUpInside)
		} else if segue.destination is SelectExtraInformationViewController {
			let informationCell = (sender as! UITableViewCell)
			extraInformationEditIndex = tableView.indexPath(for: informationCell)!.row
			let selectedInformation = extraInformation[extraInformationEditIndex]

			let controller = segue.destination as! SelectExtraInformationViewController
			controller.attributes = samples[0].attributes
			controller.selectedAttribute = selectedInformation.attribute
			controller.selectedInformation = selectedInformation
		}
	}

	@IBAction final func saveEditedExtraInformation(_ segue: UIStoryboardSegue) {
		let controller = segue.source as! SelectExtraInformationViewController
		extraInformation[extraInformationEditIndex] = controller.selectedInformation
		recomputeExtraInformation()
		tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
	}

	// MARK: - Popover delegation

	final func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.none
	}

	// MARK: - Helper functions

	private final func viewIsReady() {
		enableActionsButton()
		recomputeExtraInformation()
		tableView.reloadData()
	}

	private final func waiting() -> Bool {
		return extraInformation == nil || samples == nil || extraInformationValues == nil
	}

	private final func recomputeExtraInformation() {
		extraInformationValues = [String]()
		for index in 0 ..< extraInformation.count {
			extraInformationValues.append(try! extraInformation[index].compute(forSamples: samples))
		}
	}

	private final func disableActionsButton() {
		actionsButton.isEnabled = false
		actionsButton.tintColor = UIColor.darkGray
	}

	private final func enableActionsButton() {
		actionsButton.isEnabled = true
		actionsButton.tintColor = nil
	}

	@objc private final func graphButtonPressed() {
		let controller = UIStoryboard(name: "Graph", bundle: nil).instantiateViewController(withIdentifier: "GraphCustomizationViewController") as! GraphCustomizationViewController
		controller.samples = samples
		controller.dataType = dataType
		navigationController?.pushViewController(controller, animated: false)
	}

	@objc private final func addInformationButtonPressed() {
		let attribute = samples[0].dataType.defaultDependentAttribute
		let information = DependencyInjector.extraInformation.getApplicableInformationTypes(forAttribute: attribute)[0].init(attribute)
		extraInformation.append(information)
		recomputeExtraInformation()
		tableView.reloadData()
	}
}
