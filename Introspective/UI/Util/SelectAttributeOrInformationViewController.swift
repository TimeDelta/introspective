//
//  SelectAttributeOrInformationViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 9/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Attributes
import Common
import DependencyInjection
import SampleGroupInformation
import Samples

final class SelectAttributeOrInformationViewController: UIViewController {
	// MARK: - IBOutlets

	@IBOutlet final var typeSelectSegmentedControl: UISegmentedControl!
	@IBOutlet final var attributePicker: UIPickerView!
	@IBOutlet final var informationPicker: UIPickerView!

	// MARK: - Instance Variables

	public final var sampleType: Sample.Type!
	/// This will never be nil. If the user chooses a piece of information, it will contain the attribute associated with that information.
	public final var attribute: Attribute!
	/// If the user chooses an attribute, this will be nil
	public final var information: SampleGroupInformation?
	public final var notificationToSendOnAccept: Notification.Name!

	private final let log = Log()

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
				log.error("Attribute passed is incompatible with specified sample type")
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

	@IBAction func selectedTypeChanged(_: Any) {
		let index = typeSelectSegmentedControl.selectedSegmentIndex
		if index == 0 {
			set(informationPicker, enabled: false)
		} else if index == 1 {
			set(informationPicker, enabled: true)
		} else {
			log.error("Unexpected selected index (%d) for segmented control when user changed value", index)
		}
	}

	@IBAction func acceptButtonPressed(_: Any) {
		let index = typeSelectSegmentedControl.selectedSegmentIndex
		var userInfo: [AnyHashable: Any]?
		if index == 0 {
			userInfo = info([.attribute: attribute])
		} else if index == 1 {
			userInfo = info([.information: information as Any])
		} else {
			log.error("Unexpected selected index (%d) for segmented control when user pressed Accept", index)
		}
		NotificationCenter.default.post(name: notificationToSendOnAccept, object: self, userInfo: userInfo)
	}

	// MARK: - Helper Functions

	private final func set(_ view: UIView, enabled: Bool) {
		view.isHidden = !enabled
		view.isUserInteractionEnabled = enabled
	}

	private final func getApplicableInformationTypesForSelectedAttribute() -> [SampleGroupInformation.Type] {
		DependencyInjector.get(SampleGroupInformationFactory.self)
			.getApplicableInformationTypes(forAttribute: attribute)
	}
}

// MARK: - UIPickerViewDataSource

extension SelectAttributeOrInformationViewController: UIPickerViewDataSource {
	public func numberOfComponents(in _: UIPickerView) -> Int {
		1
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
		if pickerView == attributePicker {
			return sampleType.attributes.count
		}
		if pickerView == informationPicker {
			return getApplicableInformationTypesForSelectedAttribute().count
		}
		log.error("Unknown picker view while attempting to retrieve number of rows")
		return 0
	}
}

// MARK: - UIPickerViewDelegate

extension SelectAttributeOrInformationViewController: UIPickerViewDelegate {
	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
		if pickerView == attributePicker {
			return sampleType.attributes[row].name.localizedCapitalized
		}
		if pickerView == informationPicker {
			return getApplicableInformationTypesForSelectedAttribute()[row].init(attribute).name.localizedCapitalized
		}
		log.error("Unknown picker view while attempting to retrieve title for row")
		return nil
	}

	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
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
		log.error("Unknown picker view while running didSelectRow")
	}
}
