//
//  SelectExtraInformationViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

final class SelectExtraInformationViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var attributePicker: UIPickerView!
	@IBOutlet weak final var informationPicker: UIPickerView!

	// MARK: - Instance Variables

	public final var attributes: [Attribute]!
	public final var selectedAttribute: Attribute!
	public final var selectedInformation: ExtraInformation!
	public final var limitToNumericInformation: Bool = false
	public final var notificationToSendWhenFinished: Notification.Name!

	// MARK: - UIViewController Overloads

	final override func viewDidLoad() {
		super.viewDidLoad()

		attributePicker.delegate = self
		attributePicker.dataSource = self
		informationPicker.delegate = self
		informationPicker.dataSource = self

		if selectedAttribute == nil {
			selectedAttribute = attributes[0]
		}
		let selectedAttributeIndex = attributes.index(where: { attribute in return attribute.name == selectedAttribute.name })!
		attributePicker.selectRow(selectedAttributeIndex, inComponent: 0, animated: false)

		if let selectedInformationIndex = indexOfSelectedInformation() {
			informationPicker.selectRow(selectedInformationIndex, inComponent: 0, animated: false)
		}
	}

	@IBAction final func acceptButtonPressed(_ sender: Any) {
		NotificationCenter.default.post(name: notificationToSendWhenFinished, object: selectedInformation)
		if navigationController != nil {
			let _ = navigationController!.popViewController(animated: true)
		} else {
			dismiss(animated: false, completion: nil)
		}
	}

	// MARK: - Helper Functions

	private final func getApplicableInformationTypesForSelectedAttribute() -> [ExtraInformation.Type] {
		if limitToNumericInformation {
			return DependencyInjector.extraInformation.getApplicableNumericInformationTypes(forAttribute: selectedAttribute)
		} else {
			return DependencyInjector.extraInformation.getApplicableInformationTypes(forAttribute: selectedAttribute)
		}
	}

	private final func indexOfSelectedInformation() -> Int? {
		if selectedInformation == nil { return nil }
		return getApplicableInformationTypesForSelectedAttribute().index(where: { $0.init(selectedAttribute).equalTo(selectedInformation!) })
	}
}

// MARK: - UIPickerViewDataSource

extension SelectExtraInformationViewController: UIPickerViewDataSource {

	public final func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public final func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if pickerView == attributePicker {
			return attributes.count
		}
		if pickerView == informationPicker {
			return getApplicableInformationTypesForSelectedAttribute().count
		}
		os_log("Unknown picker view while attempting to retrieve number of rows", type: .error)
		return 0
	}
}

// MARK: - UIPickerViewDelegate

extension SelectExtraInformationViewController: UIPickerViewDelegate {

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if pickerView == attributePicker {
			return attributes[row].name
		}
		if pickerView == informationPicker {
			return getApplicableInformationTypesForSelectedAttribute()[row].init(selectedAttribute).name
		}
		os_log("Unknown picker view while attempting to retrieve title for row", type: .error)
		return nil
	}

	public final func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if pickerView == attributePicker {
			selectedAttribute = attributes[row]
			informationPicker.reloadAllComponents()
			let applicableInformationTypes = getApplicableInformationTypesForSelectedAttribute()
			if let index = applicableInformationTypes.index(where: { $0 == type(of: selectedInformation) }) {
				selectedInformation = applicableInformationTypes[index].init(selectedAttribute)
			} else {
				selectedInformation = applicableInformationTypes[0].init(selectedAttribute)
			}
		}
		if pickerView == informationPicker {
			selectedInformation = getApplicableInformationTypesForSelectedAttribute()[row].init(selectedAttribute)
		}
		os_log("Unknown picker view while running didSelectRow", type: .error)
	}
}
