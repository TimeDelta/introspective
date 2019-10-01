//
//  SelectExtraInformationViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Attributes
import Common
import DependencyInjection
import SampleGroupInformation

protocol SelectExtraInformationViewController: UIViewController {

	var attributes: [Attribute]! { get set }
	var selectedAttribute: Attribute! { get set }
	var selectedInformation: ExtraInformation! { get set }
	var limitToNumericInformation: Bool { get set }
	var notificationToSendWhenFinished: NotificationName! { get set }
	/// Setting this allows to filter sent notifications
	var notificationFilter: Any? { get set }
}

final class SelectExtraInformationViewControllerImpl: UIViewController, SelectExtraInformationViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var attributePicker: UIPickerView!
	@IBOutlet weak final var informationPicker: UIPickerView!

	// MARK: - Instance Variables

	public final var attributes: [Attribute]!
	public final var selectedAttribute: Attribute!
	public final var selectedInformation: ExtraInformation!
	public final var limitToNumericInformation: Bool = false
	public final var notificationToSendWhenFinished: NotificationName!
	public final var notificationFilter: Any?

	private final let log = Log()

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
		if let selectedAttributeIndex = attributes.index(where: { $0.equalTo(selectedAttribute) }) {
			attributePicker.selectRow(selectedAttributeIndex, inComponent: 0, animated: false)
		} else {
			log.error("Failed to find attribute in attributes array")
		}

		if let selectedInformationIndex = indexOfSelectedInformation() {
			informationPicker.selectRow(selectedInformationIndex, inComponent: 0, animated: false)
		}

		if selectedInformation == nil {
			let row = informationPicker.selectedRow(inComponent: 0)
			selectedInformation = getApplicableInformationTypesForSelectedAttribute()[row].init(selectedAttribute)
		}
	}

	@IBAction final func acceptButtonPressed(_ sender: Any) {
		DispatchQueue.main.async {
			self.syncPost(
				self.notificationToSendWhenFinished,
				object: self.notificationFilter ?? self,
				userInfo: [
					.information: self.selectedInformation,
				])
		}
		if let navigationController = navigationController {
			navigationController.popViewController(animated: false)
		} else {
			dismiss(animated: false, completion: nil)
		}
	}

	// MARK: - Helper Functions

	private final func getApplicableInformationTypesForSelectedAttribute() -> [ExtraInformation.Type] {
		if limitToNumericInformation {
			return DependencyInjector.get(ExtraInformationFactory.self).getApplicableNumericInformationTypes(forAttribute: selectedAttribute)
		} else {
			return DependencyInjector.get(ExtraInformationFactory.self).getApplicableInformationTypes(forAttribute: selectedAttribute)
		}
	}

	private final func indexOfSelectedInformation() -> Int? {
		if selectedInformation == nil { return nil }
		let index = getApplicableInformationTypesForSelectedAttribute().index(where: { $0.init(selectedAttribute).equalTo(selectedInformation!) })
		if index == nil {
			log.error("Failed to find information in information array")
		}
		return index
	}
}

// MARK: - UIPickerViewDataSource

extension SelectExtraInformationViewControllerImpl: UIPickerViewDataSource {

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
		log.error("Unknown picker view while attempting to retrieve number of rows")
		return 0
	}
}

// MARK: - UIPickerViewDelegate

extension SelectExtraInformationViewControllerImpl: UIPickerViewDelegate {

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if pickerView == attributePicker {
			return attributes[row].name.localizedCapitalized
		}
		if pickerView == informationPicker {
			return getApplicableInformationTypesForSelectedAttribute()[row].init(selectedAttribute).name.localizedCapitalized
		}
		log.error("Unknown picker view while attempting to retrieve title for row")
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
		log.error("Unknown picker view while running didSelectRow")
	}
}
