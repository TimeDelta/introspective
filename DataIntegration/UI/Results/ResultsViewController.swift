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

	public var dataType: DataTypes! {
		didSet {
			reloadInputViews()
		}
	}

	public var extraInformation: [ExtraInformation]! {
		didSet {
			if extraInformation != nil && samples != nil {
				viewIsReady()
			}
		}
	}
	fileprivate var extraInformationValues: [String]!

	public var samples: [Sample]! {
		didSet {
			if extraInformation != nil && samples != nil  {
				viewIsReady()
			}
		}
	}

	public var error: Error? {
		didSet {
			reloadInputViews()
		}
	}

	fileprivate var filteredSamples: [Sample]!
	fileprivate var lastSelectedRowIndex: Int!

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
		if waiting() {
			return 1
		}

		if section == 0 {
			return extraInformation.count
		}

		if section == 1 {
			return filteredSamples.count
		}

		os_log("Unexpected section index ($@) while determining number of rows in section", type: .error, String(section))
		return 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let row = indexPath.row
		let section = indexPath.section

		if error != nil {
			let cell = tableView.dequeueReusableCell(withIdentifier: "errorCell", for: indexPath)
			cell.textLabel!.text = error!.localizedDescription
		}

		if waiting() {
			return tableView.dequeueReusableCell(withIdentifier: "waitingCell", for: indexPath)
		}

		if section == 0 {
			let cell = (tableView.dequeueReusableCell(withIdentifier: "statisticsCell", for: indexPath) as! ExtraInformationTableViewCell)
			cell.extraInformation = getExtraInformation(forRow: row)
			cell.value = getExtraInformationValue(forRow: row)
			return cell
		}

		if section == 1 {
			switch (dataType!) {
				case .heartRate:
					let sample = filteredSamples[row]
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
//		if segue.destination is TimestampClickChoiceViewController {
//            let source = (sender as! UITableViewCell)
//			lastSelectedRowIndex = tableView.indexPath(for: source)!.row
//
//            segue.destination.modalPresentationStyle = UIModalPresentationStyle.popover
//            segue.destination.popoverPresentationController!.delegate = self
//		}
	}

	// MARK: - Popover delegation

	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.none
	}

	// MARK: - Helper functions

	fileprivate func viewIsReady() {
		resetFilteredSamples()
		recomputeExtraInformation()
		reloadInputViews()
	}

	fileprivate func getExtraInformation(forRow row: Int) -> ExtraInformation {
		return extraInformation[row]
	}

	fileprivate func getExtraInformationValue(forRow row: Int) -> String {
		return extraInformationValues[row]
	}

	fileprivate func waiting() -> Bool {
		return extraInformation == nil || samples == nil || dataType == nil
	}

	fileprivate func resetFilteredSamples() {
		if samples == nil {
			filteredSamples = [Sample]()
		} else {
			filteredSamples = samples
		}
		recomputeExtraInformation()
	}

	fileprivate func recomputeExtraInformation() {
		extraInformationValues = [String]()
		for index in 0 ..< extraInformation.count {
			extraInformationValues.append(try! extraInformation[index].compute(forSamples: filteredSamples))
		}
	}
}
