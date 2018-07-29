//
//  ResultsViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

class ResultsViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

	public var dataType: DataTypes!

	public var extraInformation: [ExtraInformation]! {
		didSet {
			if error == nil && extraInformation != nil && samples != nil {
				DispatchQueue.main.async { self.viewIsReady() }
			}
		}
	}
	fileprivate var extraInformationValues: [String]!

	public var samples: [Sample]! {
		didSet {
			if error == nil && extraInformation != nil && samples != nil  {
				DispatchQueue.main.async { self.viewIsReady() }
			}
		}
	}

	public var error: Error? {
		didSet {
			DispatchQueue.main.async { self.tableView.reloadData() }
		}
	}

	fileprivate var lastSelectedRowIndex: Int!

	@IBOutlet weak var graphButton: UIBarButtonItem!

	public override func viewDidLoad() {
		disableGraphButton()
	}

    // MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

		os_log("Unexpected section index ($@) while determining number of rows in section", type: .error, String(section))
		return 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
			let cell = (tableView.dequeueReusableCell(withIdentifier: "statisticsCell", for: indexPath) as! ExtraInformationTableViewCell)
			cell.extraInformation = extraInformation[row]
			cell.value = extraInformationValues[row]
			return cell
		}

		if section == 1 {
			switch (dataType!) {
				case .heartRate:
					let sample = samples[row]
					let cell = (tableView.dequeueReusableCell(withIdentifier: "heartRateSampleCell", for: indexPath) as! HeartRateTableViewCell)
					cell.heartRate = (sample as! HeartRate)
					return cell
			}
		}

		os_log("Unexpected section index ($@) while instantiating cell", type: .error, String(section))
		return UITableViewCell()
	}

	// MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is GraphCustomizationViewController {
            let controller = segue.destination as! GraphCustomizationViewController
            controller.samples = samples
            controller.dataType = dataType
		}
	}

	// MARK: - Popover delegation

	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.none
	}

	// MARK: - Helper functions

	fileprivate func viewIsReady() {
		enableGraphButton()
		recomputeExtraInformation()
		tableView.reloadData()
	}

	fileprivate func waiting() -> Bool {
		return extraInformation == nil || samples == nil || extraInformationValues == nil
	}

	fileprivate func recomputeExtraInformation() {
		extraInformationValues = [String]()
		for index in 0 ..< extraInformation.count {
			extraInformationValues.append(try! extraInformation[index].compute(forSamples: samples))
		}
	}

	fileprivate func disableGraphButton() {
		graphButton.isEnabled = false
		graphButton.tintColor = UIColor.darkGray
	}

	fileprivate func enableGraphButton() {
		graphButton.isEnabled = true
		graphButton.tintColor = nil
	}
}
