//
//  TestDataCreationSampleTypeTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 2/28/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Samples
import UIExtensions

public final class TestDataCreationSampleTypeTableViewCell: UITableViewCell {
	// MARK: - IBOutlets

	@IBOutlet final var generateDataSwitch: UISwitch!
	@IBOutlet final var sampleTypeNameLabel: UILabel!

	@IBOutlet final var numberOfDaysLabel: UILabel!
	@IBOutlet final var numberOfDaysTextField: UITextField!

	@IBOutlet final var samplesPerHourLabel: UILabel!
	@IBOutlet final var samplesPerHourTextField: UITextField!

	// MARK: - Instance Variables

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

	@IBAction final func shouldGenerateChanged(_: Any) {
		updateHideShowState()
		post(
			TestDataGenerationTableViewController.shouldGenerateSampleTypeChanged,
			userInfo: [
				.sampleType: sampleType,
				.shouldGenerate: generateDataSwitch.isOn,
			]
		)
	}

	@IBAction final func numberOfDaysChanged(_: Any) {
		guard let numberOfDays = Int(numberOfDaysTextField.text ?? "") else { return }
		post(
			TestDataGenerationTableViewController.numberOfDaysChanged,
			userInfo: [
				.sampleType: sampleType,
				.number: numberOfDays,
			]
		)
	}

	@IBAction final func samplesPerHourChanged(_: Any) {
		guard let samplesPerHour = Int(samplesPerHourTextField.text ?? "") else { return }
		post(
			TestDataGenerationTableViewController.samplesPerHourChanged,
			userInfo: [
				.sampleType: sampleType,
				.number: samplesPerHour,
			]
		)
	}

	// MARK: - Helper Functions

	private final func updateHideShowState() {
		injected(UiUtil.self)
			.setView(numberOfDaysLabel, enabled: generateDataSwitch.isOn, hidden: !generateDataSwitch.isOn)
		injected(UiUtil.self)
			.setView(numberOfDaysTextField, enabled: generateDataSwitch.isOn, hidden: !generateDataSwitch.isOn)
		injected(UiUtil.self)
			.setView(samplesPerHourLabel, enabled: generateDataSwitch.isOn, hidden: !generateDataSwitch.isOn)
		injected(UiUtil.self)
			.setView(samplesPerHourTextField, enabled: generateDataSwitch.isOn, hidden: !generateDataSwitch.isOn)
	}
}
