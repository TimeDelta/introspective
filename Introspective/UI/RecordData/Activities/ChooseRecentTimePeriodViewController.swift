//
//  ChooseRecentTimePeriodViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 6/9/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection

public protocol ChooseRecentTimePeriodViewController: UIViewController {
	/// Set the initial number of time units
	var initialNumTimeUnits: Int? { get set }
	/// Set the initial time unit
	var initialTimeUnit: Calendar.Component? { get set }
}

public final class ChooseRecentTimePeriodViewControllerImpl: UIViewController, ChooseRecentTimePeriodViewController {
	// MARK: - Static Variables

	private typealias Me = ChooseRecentTimePeriodViewControllerImpl

	public static let supportedTimeUnits: [Calendar.Component] = [
		.year,
		.month,
		.weekOfYear,
		.day,
		.hour,
		.minute,
	]

	// MARK: - IBOutlets

	@IBOutlet final var sortByLabel: UILabel!

	@IBOutlet final var numTimeUnitsField: UITextField!
	@IBOutlet final var timeUnitPicker: UIPickerView!

	@IBOutlet final var sortButton: UIButton!

	// MARK: - Instance Variables

	public final var initialNumTimeUnits: Int?
	public final var initialTimeUnit: Calendar.Component?

	private final let log = Log()

	// MARK: - UIViewController Overloads

	override public final func viewDidLoad() {
		timeUnitPicker.delegate = self

		if let initialNumTimeUnits = initialNumTimeUnits {
			numTimeUnitsField.text = String(initialNumTimeUnits)
		}

		if let initialTimeUnit = initialTimeUnit {
			if let index = Me.supportedTimeUnits.firstIndex(of: initialTimeUnit) {
				timeUnitPicker.selectRow(index, inComponent: 0, animated: false)
			} else {
				log.error("Unknown initial time unit: %@", initialTimeUnit.description)
			}
		}

		validate()
	}

	// MARK: - Actions

	@IBAction final func sortButtonPressed() {
		let chosenTimeUnit = Me.supportedTimeUnits[timeUnitPicker.selectedRow(inComponent: 0)]
		guard let numString = numTimeUnitsField.text else { return }
		guard DependencyInjector.get(StringUtil.self).isInteger(numString) else { return }
		guard let numTimeUnits = Int(numString) else { return }
		post(
			.timePeriodChosen,
			userInfo: [
				UserInfoKey.number: numTimeUnits,
				UserInfoKey.calendarComponent: chosenTimeUnit,
			]
		)
		dismiss(animated: false, completion: nil)
	}

	@IBAction final func numTimeUnitsChanged(_: Any) {
		validate()
	}

	// MARK: - Helper Functions

	private final func numberIsValid() -> Bool {
		guard let numString = numTimeUnitsField.text else {
			return false
		}
		guard DependencyInjector.get(StringUtil.self).isInteger(numString) else {
			return false
		}
		return true
	}

	private final func validate() {
		if numberIsValid() {
			if #available(iOS 13.0, *) {
				sortByLabel.textColor = .label
			} else {
				sortByLabel.textColor = .black
			}
			DependencyInjector.get(UiUtil.self).setButton(sortButton, enabled: true, hidden: false)
		} else {
			sortByLabel.textColor = .red
			DependencyInjector.get(UiUtil.self).setButton(sortButton, enabled: false, hidden: false)
		}
	}
}

// MARK: - UIPickerViewDelegate

extension ChooseRecentTimePeriodViewControllerImpl: UIPickerViewDelegate {
	public final func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
		Me.supportedTimeUnits[row].description.localizedCapitalized
	}
}

// MARK: - UIPickerViewDataSource

extension ChooseRecentTimePeriodViewControllerImpl: UIPickerViewDataSource {
	public final func numberOfComponents(in _: UIPickerView) -> Int {
		1
	}

	public final func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
		Me.supportedTimeUnits.count
	}
}
