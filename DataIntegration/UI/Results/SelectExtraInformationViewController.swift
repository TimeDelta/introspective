//
//  SelectExtraInformationViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

final class SelectExtraInformationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

	public final var attributes: [Attribute]!
	public final var selectedAttribute: Attribute!
	public final var selectedInformation: ExtraInformation!

	@IBOutlet weak final var attributePicker: UIPickerView!
	@IBOutlet weak final var informationPicker: UIPickerView!

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

		if selectedInformation == nil {
			selectedInformation = getApplicableInformationTypesForSelectedAttribute()[0].init(selectedAttribute)
		};
		let selectedInformationIndex = getApplicableInformationTypesForSelectedAttribute().index(where: { type in return type.init(selectedAttribute).key == selectedInformation.key })!
		informationPicker.selectRow(selectedInformationIndex, inComponent: 0, animated: false)
	}

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

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if pickerView == attributePicker {
			return attributes[row].name
		}
		if pickerView == informationPicker {
			return getApplicableInformationTypesForSelectedAttribute()[row].init(selectedAttribute).key
		}
		os_log("Unknown picker view while attempting to retrieve title for row", type: .error)
		return nil
	}

	public final func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if pickerView == attributePicker {
			selectedAttribute = attributes[row]
			informationPicker.reloadAllComponents()
			selectedInformation = getApplicableInformationTypesForSelectedAttribute()[0].init(selectedAttribute)
		}
		if pickerView == informationPicker {
			selectedInformation = getApplicableInformationTypesForSelectedAttribute()[row].init(selectedAttribute)
		}
	}

	private final func getApplicableInformationTypesForSelectedAttribute() -> [ExtraInformation.Type] {
		return DependencyInjector.extraInformation.getApplicableInformationTypes(forAttribute: selectedAttribute)
	}
}
