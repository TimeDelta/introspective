//
//  ResultsViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

class ResultsViewController<SampleType: Sample>: UITableViewController, UIPopoverPresentationControllerDelegate {

	public var dataType: DataTypes! {
		didSet {
			reloadInputViews()
		}
	}

	public var extraInformation: [ExtraInformation<SampleType>]! {
		didSet {
			if extraInformation != nil && samples != nil {
				viewIsReady()
			}
		}
	}
	fileprivate var extraInformationValues: [String]!

	public var samples: [SampleType]! {
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

	fileprivate var filteredSamples: [SampleType]!
	fileprivate var lastSelectedRowIndex: Int!

    // MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Statistics"
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

		os_log("Unexpected section index ($@) while instantiating cell", type: .error, String(section))
		return 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let row = indexPath.row

		if error != nil {
			let cell = tableView.dequeueReusableCell(withIdentifier: "errorCell", for: indexPath)
			cell.textLabel!.text = error!.localizedDescription
		}

		if waiting() {
			return tableView.dequeueReusableCell(withIdentifier: "waitingCell", for: indexPath)
		}

		if row <= extraInformation.count {
			let cell = (tableView.dequeueReusableCell(withIdentifier: "extraInformationCell", for: indexPath) as! ExtraInformationTableViewCell<SampleType>)
			cell.extraInformation = getExtraInformation(forRow: row)
			cell.value = getExtraInformationValue(forRow: row)
			return cell
		} else {
			switch (dataType!) {
				case .heartRate:
					let sample = getSample(forRow: row)
					let cell = (tableView.dequeueReusableCell(withIdentifier: "heartRateSampleCell", for: indexPath) as! HeartRateTableViewCell)
					cell.heartRate = (sample as! HeartRate)
					return cell
			}
		}
	}

	// MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is TimestampClickChoiceViewController {
            let source = (sender as! UITableViewCell)
			lastSelectedRowIndex = tableView.indexPath(for: source)!.row

            segue.destination.modalPresentationStyle = UIModalPresentationStyle.popover
            segue.destination.popoverPresentationController!.delegate = self
		}
	}

	// MARK: - Popover delegation

	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.none
	}

	// MARK: - Helper functions

	fileprivate func viewIsReady() {
		recomputeExtraInformation()
		filteredSamples = samples
		reloadInputViews()
	}

	fileprivate func getExtraInformation(forRow row: Int) -> ExtraInformation<SampleType> {
		return extraInformation[row]
	}

	fileprivate func getExtraInformationValue(forRow row: Int) -> String {
		return extraInformationValues[row]
	}

	fileprivate func getSample(forRow row: Int) -> Sample {
		let sampleIndex = row - filteredSamples.count
		return filteredSamples[sampleIndex]
	}

	fileprivate func getMinExtraInformationIndex() -> Int {
		return 0
	}

	fileprivate func getMaxExtraInformationIndex() -> Int {
		return extraInformation.count - 1
	}

	fileprivate func waiting() -> Bool {
		return extraInformation == nil || samples == nil || dataType == nil
	}

	fileprivate func resetFilteredSamples() {
		if samples == nil {
			filteredSamples = [SampleType]()
		} else {
			filteredSamples = samples
		}
		recomputeExtraInformation()
	}

	fileprivate func recomputeExtraInformation() {
		extraInformationValues = [String]()
		for index in 0 ..< extraInformation.count {
			extraInformationValues[index].append(extraInformation[index].compute(forSamples: filteredSamples))
		}
	}
}
