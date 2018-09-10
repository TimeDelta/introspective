//
//  SelectAttributeOrInformationViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 9/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

final class SelectAttributeOrInformationViewController: UIViewController {

	// MARK: - Instance Member Variables

	public final var sampleType: Sample.Type!
	/// This will never be nil. If the user chooses a piece of information, it will contain the attribute associated with that information.
	public final var attribute: Attribute!
	/// If the user chooses an attribute, this will be nil
	public final var information: ExtraInformation?
	public final var notificationToSendOnAccept: Notification.Name!

	// MARK: - IBOutlets

	@IBOutlet weak final var typeSelectSegmentedControl: UISegmentedControl!
	@IBOutlet weak final var attributePicker: UIPickerView!
	@IBOutlet weak final var informationPicker: UIPickerView!

	// MARK: - UIViewController Overrides

	override func viewDidLoad() {
		super.viewDidLoad()

		attributePicker.dataSource = self
		attributePicker.delegate = self

		if attribute == nil {
			attribute = sampleType.attributes[0]
		} else {
			if let index = sampleType.attributes.index(where: { $0.equalTo(attribute) }) {
				attributePicker.selectRow(index, inComponent: 0, animated: false)
			} else {
				os_log("Attribute passed is incompatible with specified sample type", type: .error)
			}
		}

		if information == nil {
			information = getApplicableInformationTypesForSelectedAttribute()[0].init(attribute)
		} else {
			typeSelectSegmentedControl.selectedSegmentIndex = 1
			set(informationPicker, enabled: true)
			let applicableInformation = getApplicableInformationTypesForSelectedAttribute().map { $0.init(attribute) }
			if let index = applicableInformation.index(where: { $0.equalTo(information!) }) {
				informationPicker.selectRow(index, inComponent: 0, animated: false)
			}
		}
	}

	// MARK: - Actions

	@IBAction func selectedTypeChanged(_ sender: Any) {
		let index = typeSelectSegmentedControl.selectedSegmentIndex
		if index == 0 {
			set(informationPicker, enabled: false)
		} else if index == 1 {
			set(informationPicker, enabled: true)
		} else {
			os_log("Unexpected selected index (%d) for segmented control when user changed value", type: .error, index)
		}
	}

	@IBAction func acceptButtonPressed(_ sender: Any) {
		let index = typeSelectSegmentedControl.selectedSegmentIndex
		var value: Any? = nil
		if index == 0 {
			value = attribute
		} else if index == 1 {
			value = information
		} else {
			os_log("Unexpected selected index (%d) for segmented control when user pressed Accept", type: .error, index)
		}
		NotificationCenter.default.post(name: notificationToSendOnAccept, object: value)
	}

	// MARK: - Helper Functions

	private final func set(_ view: UIView, enabled: Bool) {
		view.isHidden = !enabled
		view.isUserInteractionEnabled = enabled
	}

	private final func getApplicableInformationTypesForSelectedAttribute() -> [ExtraInformation.Type] {
		return DependencyInjector.extraInformation.getApplicableInformationTypes(forAttribute: attribute)
	}
}

// MARK: - UIPickerViewDataSource

extension SelectAttributeOrInformationViewController: UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if pickerView == attributePicker {
			return sampleType.attributes.count
		}
		if pickerView == informationPicker {
			return getApplicableInformationTypesForSelectedAttribute().count
		}
		os_log("Unknown picker view while attempting to retrieve number of rows", type: .error)
		return 0
	}
}

// MARK: - UIPickerViewDelegate

extension SelectAttributeOrInformationViewController: UIPickerViewDelegate {

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if pickerView == attributePicker {
			return sampleType.attributes[row].name
		}
		if pickerView == informationPicker {
			return getApplicableInformationTypesForSelectedAttribute()[row].init(attribute).name
		}
		os_log("Unknown picker view while attempting to retrieve title for row", type: .error)
		return nil
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if pickerView == attributePicker {
			attribute = sampleType.attributes[row]
			informationPicker.reloadAllComponents()
			let applicableInformationTypes = getApplicableInformationTypesForSelectedAttribute()
			if applicableInformationTypes.index(where: { $0 == type(of: information) }) == nil {
				information = applicableInformationTypes[0].init(attribute)
			}
		}
		if pickerView == informationPicker {
			information = getApplicableInformationTypesForSelectedAttribute()[row].init(attribute)
		}
		os_log("Unknown picker view while running didSelectRow", type: .error)
	}
}
