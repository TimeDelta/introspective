//
//  TestDataCreationSampleTypeTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 2/28/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

public final class TestDataCreationSampleTypeTableViewCell: UITableViewCell {

	// MARK: - IBOutlets

	@IBOutlet weak final var generateDataSwitch: UISwitch!
	@IBOutlet weak final var sampleTypeNameLabel: UILabel!

	@IBOutlet weak final var numberOfDaysLabel: UILabel!
	@IBOutlet weak final var numberOfDaysTextField: UITextField!

	@IBOutlet weak final var samplesPerHourLabel: UILabel!
	@IBOutlet weak final var samplesPerHourTextField: UITextField!

	// MARK: - Member Variables

	public final var sampleType: Sample.Type! {
		didSet {
			if let sampleType = sampleType {
				sampleTypeNameLabel.text = sampleType.name
			}
		}
	}

	final var options: TestDataGenerationTableViewController.Options! {
		didSet {
			if let options = options {
				generateDataSwitch.isOn = options.shouldGenerate
				numberOfDaysTextField.text = String(options.numberOfDays)
				samplesPerHourTextField.text = String(options.samplesPerHour)
				updateHideShowState()
			}
		}
	}

	// MARK: - Actions

	@IBAction final func shouldGenerateChanged(_ sender: Any) {
		updateHideShowState()
		post(
			TestDataGenerationTableViewController.shouldGenerateSampleTypeChanged,
			userInfo: [
				.sampleType: sampleType,
				.shouldGenerate: generateDataSwitch.isOn,
			])
	}

	@IBAction final func numberOfDaysChanged(_ sender: Any) {
		guard let numberOfDays = Int(numberOfDaysTextField.text ?? "") else { return }
		post(
			TestDataGenerationTableViewController.numberOfDaysChanged,
			userInfo: [
				.sampleType: sampleType,
				.number: numberOfDays,
			])
	}

	@IBAction final func samplesPerHourChanged(_ sender: Any) {
		guard let samplesPerHour = Int(samplesPerHourTextField.text ?? "") else { return }
		post(
			TestDataGenerationTableViewController.samplesPerHourChanged,
			userInfo: [
				.sampleType: sampleType,
				.number: samplesPerHour,
			])
	}

	// MARK: - Helper Functions

	private final func updateHideShowState() {
		DependencyInjector.util.ui.setView(numberOfDaysLabel, enabled: generateDataSwitch.isOn, hidden: !generateDataSwitch.isOn)
		DependencyInjector.util.ui.setView(numberOfDaysTextField, enabled: generateDataSwitch.isOn, hidden: !generateDataSwitch.isOn)
		DependencyInjector.util.ui.setView(samplesPerHourLabel, enabled: generateDataSwitch.isOn, hidden: !generateDataSwitch.isOn)
		DependencyInjector.util.ui.setView(samplesPerHourTextField, enabled: generateDataSwitch.isOn, hidden: !generateDataSwitch.isOn)
	}
}
