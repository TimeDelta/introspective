//
//  EditSubDataTypeViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

class EditSubDataTypeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

	fileprivate typealias Me = EditSubDataTypeViewController

	fileprivate static let supportedTimeUnits: [Calendar.Component] = [
		.year,
		.month,
		.weekOfYear,
		.day,
		.hour,
		.minute,
		.second,
		.nanosecond
	]

	public var matcher: SubQueryMatcher!
	public var dataType: DataTypes!

	@IBOutlet weak var dataTypePicker: UIPickerView!
	@IBOutlet weak var matcherTypePicker: UIPickerView!
	@IBOutlet weak var valueTextField: UITextField!
	@IBOutlet weak var timeUnitPicker: UIPickerView!
	@IBOutlet weak var mostRecentOnlySwitch: UISwitch!
	@IBOutlet weak var validationLabel: UILabel!
	@IBOutlet weak var acceptButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()

		dataTypePicker.dataSource = self
		dataTypePicker.delegate = self
		matcherTypePicker.dataSource = self
		matcherTypePicker.delegate = self
		timeUnitPicker.dataSource = self
		timeUnitPicker.delegate = self

		for index in 0 ..< DataTypes.allTypes.count {
			if DataTypes.allTypes[index] == dataType {
				dataTypePicker.selectRow(index, inComponent: 0, animated: false)
				break
			}
		}

		mostRecentOnlySwitch.setOn(matcher.mostRecentOnly, animated: false)

		matcherTypePicker.selectRow(getIndexForMatcher(), inComponent: 0, animated: false)

		acceptButton.setTitle("Must fix issues", for: .disabled)
        acceptButton.setTitle("Accept", for: .normal)

		updateParameterViews()
	}

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if pickerView == dataTypePicker {
			return DataTypes.allTypes.count
		}
		if pickerView == matcherTypePicker {
			return SubQueryMatcherFactory.allMatchers.count
		}
		if pickerView == timeUnitPicker {
			return Me.supportedTimeUnits.count
		}

		os_log("Unknown UIPickerView when retrieving number of rows", type: .error)
		return 0
	}

	public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		var label: UILabel? = (view as? UILabel)
		if label == nil {
			label = UILabel()
		}
		label!.textAlignment = .center

		if pickerView == dataTypePicker {
			label!.text = DataTypes.allTypes[row].description
			label!.font = UIFont(name: "System", size: CGFloat(15))
		} else if pickerView == matcherTypePicker {
			label!.text = SubQueryMatcherFactory.allMatchers[row].genericDescription
			label!.font = UIFont(name: "System", size: CGFloat(19))
		} else if pickerView == timeUnitPicker {
			label!.text = CalendarUtil.componentNames[Me.supportedTimeUnits[row]]!
			let selectedMatcherIndex = matcherTypePicker.selectedRow(inComponent: 0)
			if SubQueryMatcherFactory.allMatchers[selectedMatcherIndex] == WithinXCalendarUnitsSubQueryMatcher.self {
				label!.text! += "s"
			}
			label!.font = UIFont(name: "System", size: CGFloat(19))
		} else {
			os_log("Unknown UIPickerView when retrieving view for row", type: .error)
		}

		return label!
	}

	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if pickerView == matcherTypePicker {
			let type: SubQueryMatcher.Type = SubQueryMatcherFactory.allMatchers[row]
			matcher = type.init()
			updateParameterViews()
		} else if pickerView == timeUnitPicker {
			let unit = Me.supportedTimeUnits[row]
			let id = getParameterId(for: .timeUnit)
			try! matcher.setParameter(id: id, value: unit)
		}
		validate()
	}

	@IBAction func textFieldValueChanged(_ sender: Any) {
		validate()
		let textValue = valueTextField.text!
		if DependencyInjector.util.stringUtil.isInteger(textValue) {
			let id = getParameterId(for: .integer)
			try! matcher.setParameter(id: id, value: Int(textValue)!)
		}
	}

	@IBAction func mostRecentOnlyChanged(_ sender: Any) {
		matcher.mostRecentOnly = mostRecentOnlySwitch.isOn
	}

	fileprivate func updateParameterViews() {
		timeUnitPicker.isHidden = true
		timeUnitPicker.isUserInteractionEnabled = false
		valueTextField.isHidden = true
		valueTextField.isEnabled = false
		valueTextField.isUserInteractionEnabled = false

		let matcherTypeIndex = getIndexForMatcher()

		let parameters = SubQueryMatcherFactory.allMatchers[matcherTypeIndex].parameters
		for (id, type) in parameters {
			switch (type) {
				case .integer:
					let value: Int = try! matcher.getParameterValue(id: id)

					valueTextField.isHidden = false
					valueTextField.isEnabled = true
					valueTextField.isUserInteractionEnabled = true

					valueTextField.text = String(value)
					break
				case .timeUnit:
					let value: Calendar.Component = try! matcher.getParameterValue(id: id)

					timeUnitPicker.isHidden = false
					timeUnitPicker.isUserInteractionEnabled = true

					var selectedTimeUnitIndex: Int = -1
					for index in 0 ..< Me.supportedTimeUnits.count {
						if Me.supportedTimeUnits[index] == value {
							selectedTimeUnitIndex = index
							break
						}
					}

					timeUnitPicker.selectRow(selectedTimeUnitIndex, inComponent: 0, animated: false)
					break
			}
		}
	}

	fileprivate func getIndexForMatcher() -> Int {
		for index in 0 ..< SubQueryMatcherFactory.allMatchers.count {
			if SubQueryMatcherFactory.allMatchers[index] == type(of: matcher!) {
				return index
			}
		}
		return -1
	}

	fileprivate func getParameterId(for targetType: ParamType) -> Int {
		for (id, type) in type(of: matcher).parameters {
			if type == targetType {
				return id
			}
		}
		return -1
	}

	fileprivate func validate() {
		if valueTextField.isEnabled {
			let text = valueTextField.text!
			if !DependencyInjector.util.stringUtil.isInteger(text) {
				setInvalidState("\"\(text)\" is not an integer")
				return
			}
		}
		setValidState()
	}

	fileprivate func setInvalidState(_ message: String) {
		disableAcceptButton()
		validationLabel.text = message
		validationLabel.reloadInputViews()
	}

	fileprivate func setValidState() {
		enableAcceptButton()
		validationLabel.text = ""
		validationLabel.reloadInputViews()
	}

	fileprivate func disableAcceptButton() {
		acceptButton.isEnabled = false
		acceptButton.isUserInteractionEnabled = false
		acceptButton.backgroundColor = UIColor.gray
	}

	fileprivate func enableAcceptButton() {
		acceptButton.isEnabled = true
		acceptButton.isUserInteractionEnabled = true
		acceptButton.backgroundColor = UIColor.black
	}
}
