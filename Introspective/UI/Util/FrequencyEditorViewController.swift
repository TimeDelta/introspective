//
//  FrequencyEditorViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public final class FrequencyEditorViewController: UIViewController {

	// MARK: - Static Variables

	private typealias Me = FrequencyEditorViewController
	private static let timeUnits: [Calendar.Component] = [
		.month,
		.weekOfYear,
		.day,
		.hour,
		.minute,
		.second,
	]
	private static let defaultTimeUnit: Calendar.Component = .day

	// MARK: - IBOutlets

	@IBOutlet weak final var amountTextField: UITextField!
	@IBOutlet weak final var timeUnitPicker: UIPickerView!

	// MARK: - Instance Variables

	public final var notificationToSendOnAccept: Notification.Name!
	public final var initialFrequency: Frequency?

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		timeUnitPicker.dataSource = self
		timeUnitPicker.delegate = self

		if initialFrequency != nil {
			amountTextField.text = String(initialFrequency!.timesPerTimeUnit)
			if let index = Me.timeUnits.firstIndex(of: initialFrequency!.timeUnit) {
				timeUnitPicker.selectRow(index, inComponent: 0, animated: false)
			}
		} else if let index = Me.timeUnits.firstIndex(of: Me.defaultTimeUnit) {
			timeUnitPicker.selectRow(index, inComponent: 0, animated: false)
		}
	}

	// MARK: - Button Actions

	@IBAction final func saveButtonPressed(_ sender: Any) {
		var frequency: Frequency? = nil
		if let times = amountTextField?.text {
			if !times.isEmpty && DependencyInjector.util.string.isNumber(times) {
				let timeUnit = Me.timeUnits[timeUnitPicker.selectedRow(inComponent: 0)]
				frequency = Frequency(Double(times)!, timeUnit)
			}
		}
		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: self.notificationToSendOnAccept,
				object: self,
				userInfo: self.info([
					.frequency: frequency as Any,
				]))
		}
		dismiss(animated: false, completion: nil)
	}
}

// MARK: - UIPickerViewDataSource

extension FrequencyEditorViewController: UIPickerViewDataSource {

	public final func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public final func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return Me.timeUnits.count
	}
}

// MARK: - UIPickerViewDelegate

extension FrequencyEditorViewController: UIPickerViewDelegate {

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return Me.timeUnits[row].description.localizedCapitalized
	}
}
