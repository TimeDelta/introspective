//
//  ResultsViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import CoreData
import os

final class ResultsViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

	// MARK: - Public Member Variables

	public final var samples: [Sample]! {
		didSet {
			if error == nil && samples != nil  {
				DispatchQueue.global(qos: .userInteractive).async { self.viewIsReady() }
			}
		}
	}

	public final var error: Error? {
		didSet {
			DispatchQueue.main.async { self.tableView.reloadData() }
		}
	}

	// MARK: - IBOutlets

	@IBOutlet weak final var actionsButton: UIBarButtonItem!

	// MARK: - Private Member Variables

	private final var extraInformation = [ExtraInformation]()
	private final var extraInformationValues: [String]!
	private final var lastSelectedRowIndex: Int!
	private final var extraInformationEditIndex: Int!
	private final var actionsPresenter: Presentr!
	private final var finishedLoading = false

	// MARK: - UIViewController Overloads

	public final override func viewDidLoad() {
		disableActionsButton()
		actionsButton.target = self
		actionsButton.action = #selector(presentActions)

		NotificationCenter.default.addObserver(self, selector: #selector(graphButtonPressed), name: ResultsActionsPopupViewController.graphSamples, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(addInformationButtonPressed), name: ResultsActionsPopupViewController.addInformation, object: nil)
		NotificationCenter.default.addObserver(editButtonItem.target!, selector: editButtonItem.action!, name: ResultsActionsPopupViewController.graphSamples, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(deleteAllSamples), name: ResultsActionsPopupViewController.deleteAllSamples, object: nil)

		self.navigationItem.setRightBarButton(actionsButton, animated: true)
		finishedLoading = true
	}

	// MARK: - Table view data source

	final override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	final override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Extra Information"
		} else if section == 1 {
			if samples != nil && samples.count > 0 {
				return samples[0].name.capitalized
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
			let sample = samples[row]
			switch (samples[0]) {
				case is BloodPressure:
					let cell = (tableView.dequeueReusableCell(withIdentifier: "bloodPressureCell", for: indexPath) as! BloodPressureTableViewCell)
					cell.sample = (sample as! BloodPressure)
					return cell
				case is HealthKitQuantitySample:
					let cell = (tableView.dequeueReusableCell(withIdentifier: "healthKitQuantitySampleCell", for: indexPath) as! HealthKitQuantitySampleTableViewCell)
					cell.sample = (sample as! HealthKitQuantitySample)
					return cell
				case is Mood:
					let cell = (tableView.dequeueReusableCell(withIdentifier: "moodSampleCell", for: indexPath) as! MoodTableViewCell)
					cell.mood = (sample as! Mood)
					return cell
				case is SexualActivity:
					let cell = (tableView.dequeueReusableCell(withIdentifier: "sexualActivityCell", for: indexPath) as! SexualActivityTableViewCell)
					cell.sample = (sample as! SexualActivity)
					return cell
				default:
					fatalError("Forgot a type of Sample")
			}
		}

		os_log("Unexpected section index (%@) while instantiating cell", type: .error, String(section))
		return UITableViewCell()
	}

	final override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 0 || waiting() { return 44 }
		switch (samples[indexPath.row]) {
			case is BloodPressure, is BodyMassIndex, is HeartRate, is LeanBodyMass, is SexualActivity, is Weight:
				return 44
			case is Mood:
				return 67
			default:
				fatalError("Forgot a type of Sample")
		}
	}

	// MARK: - TableView Editing

	final override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return indexPath.section == 0 || samplesAreDeletable()
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
			if indexPath.section == 0 {
				self.extraInformation.remove(at: indexPath.row)
				self.extraInformationValues.remove(at: indexPath.row)
			} else if indexPath.section == 1 {
				guard let managedSample = self.samples[indexPath.row] as? NSManagedObject else { return }
				DispatchQueue.global(qos: .background).async {
					DependencyInjector.db.delete(managedSample)
					DependencyInjector.db.save()
				}
				self.samples.remove(at: indexPath.row)
			}
			tableView.deleteRows(at: [indexPath], with: .fade)
			tableView.reloadData()
		}

		return [delete]
	}

	// MARK: - Navigation

	public final override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is SelectExtraInformationViewController {
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

	@objc private final func presentActions() {
		let actionsController = storyboard!.instantiateViewController(withIdentifier: "resultsActions") as! ResultsActionsPopupViewController
		actionsController.sampleType = type(of: samples[0]).name
		customPresentViewController(actionsPresenter, viewController: actionsController, animated: true)
	}

	private final func viewIsReady() {
		while !finishedLoading {} // this ensures that the actions button does not get disabled after everything loads
		DispatchQueue.main.async {
			self.enableActionsButton()
			self.recomputeExtraInformation()
			self.tableView.reloadData()
		}
	}

	private final func waiting() -> Bool {
		return samples == nil
	}

	private final func recomputeExtraInformation() {
		extraInformationValues = [String]()
		for index in 0 ..< extraInformation.count {
			extraInformationValues.append(try! extraInformation[index].compute(forSamples: samples))
		}
	}

	private final func samplesAreDeletable() -> Bool {
		return (samples != nil && samples.count > 0 && samples[0] is CoreDataSample)
	}

	private final func disableActionsButton() {
		actionsButton.isEnabled = false
		actionsButton.tintColor = UIColor.darkGray
	}

	private final func enableActionsButton() {
		setActionsPresenter()
		actionsButton.isEnabled = true
		actionsButton.tintColor = nil
	}

	private final func setActionsPresenter() {
		let customType: PresentationType
		if samplesAreDeletable() {
			customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 144), center: .center)
		} else {
			customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 106), center: .center)
		}
		actionsPresenter = Presentr(presentationType: customType)
		actionsPresenter.dismissTransitionType = .crossDissolve
		actionsPresenter.roundCorners = true
	}

	@objc private final func graphButtonPressed() {
		let controller = UIStoryboard(name: "Graph", bundle: nil).instantiateViewController(withIdentifier: "GraphCustomizationViewController") as! GraphCustomizationViewController
		controller.samples = samples
		navigationController?.pushViewController(controller, animated: false)
	}

	@objc private final func addInformationButtonPressed() {
		let attribute = type(of: samples[0]).defaultDependentAttribute
		let information = DependencyInjector.extraInformation.getApplicableInformationTypes(forAttribute: attribute)[0].init(attribute)
		extraInformation.append(information)
		recomputeExtraInformation()
		tableView.reloadData()
	}

	@objc private final func deleteAllSamples() {
		DispatchQueue.global(qos: .userInitiated).async {
			// TODO - tell the user something went wrong if an error is thrown here
			try! DependencyInjector.db.deleteAll(self.samples as! [NSManagedObject])
			DependencyInjector.db.save()
		}
		navigationController!.popViewController(animated: true)
	}
}
