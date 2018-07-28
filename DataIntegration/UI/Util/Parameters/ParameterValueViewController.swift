//
//  AggregationParameterValueViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class ParameterValueViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, MultiSelectSegmentedControlDelegate {

	public var parameter: Parameter!
	public var parameterValue: Any!

	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var selectOnePicker: UIPickerView!
	@IBOutlet weak var multiSelect: MultiSelectSegmentedControl!
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var validationLabel: UILabel!
	@IBOutlet weak var acceptButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        checkForSelectOneParameter()
		checkForMultiSelectParameter()
		checkForDateParameter()
		checkForTextFieldParameter()
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		let selectParameter = parameter as! SelectParameter
		return selectParameter.possibleValues.count
	}

	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		let selectParameter = parameter as! SelectParameter
		let value = selectParameter.possibleValues[row]
		return try! selectParameter.convertToString(from: value)
	}

	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		let selectParameter = parameter as! SelectParameter
		parameterValue = selectParameter.possibleValues[row]
	}

	public func textViewDidChange(_ textView: UITextView) {
		if parameter.isValid(value: textView.text) {
			setValidState()
			parameterValue = try! parameter.convertToValue(from: textView.text)
		} else {
			let errorMessage = parameter.errorMessageFor(invalidValue: textView.text)
			setInvalidState(errorMessage)
		}
	}

	public func multiSelect(multiSelectSegmendedControl: MultiSelectSegmentedControl, didChangeValue value: Bool, atIndex index: Int) {
		var values = [Any]()
		let multiSelectParameter = parameter as! MultiSelectParameter
		for index in multiSelect.selectedSegmentIndexes {
			let value = multiSelectParameter.possibleValues[Int(index)]
			values.append(value)
		}
		parameterValue = try! multiSelectParameter.valueFromArray(values)
	}

	@IBAction func accepted(_ sender: Any) {
		if parameter is DateParameter {
			let dateParameter = parameter as! DateParameter
			if dateParameter.includeTime {
				parameterValue = datePicker.date
			} else {
				parameterValue = DependencyInjector.util.calendarUtil.start(of: .day, in: datePicker.date)
			}
		}
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

	fileprivate func checkForSelectOneParameter() {
		if !(parameter is SelectOneParameter) {
			selectOnePicker.isHidden = true
			selectOnePicker.isUserInteractionEnabled = false
		} else {
			selectOnePicker.delegate = self
			selectOnePicker.dataSource = self

			if parameterValue != nil {
				let selectOneParameter = parameter as! SelectOneParameter
				let index = selectOneParameter.indexOf(possibleValue: parameterValue!)
				if index != nil {
					selectOnePicker.selectRow(index!, inComponent: 0, animated: false)
				}
			}
		}
	}

	fileprivate func checkForMultiSelectParameter() {
		if !(parameter is MultiSelectParameter) {
			multiSelect.isHidden = true
			multiSelect.isEnabled = false
			multiSelect.isUserInteractionEnabled = false
		} else {
			let multiSelectParameter = parameter as! MultiSelectParameter
			multiSelect.removeAllSegments()
			var index = 0
			for value in multiSelectParameter.possibleValues {
				let segmentTitle = try! multiSelectParameter.convertToDisplayableString(from: value)
				multiSelect.insertSegment(withTitle: segmentTitle, at: index, animated: false)
				index += 1
			}
			multiSelect.delegate = self

			if parameterValue != nil {
				for value in try! multiSelectParameter.valueAsArray(parameterValue) {
					let index = multiSelectParameter.indexOf(possibleValue: value)
					if index != nil {
						multiSelect.selectedSegmentIndexes.insert(index!)
					}
				}
			}
		}
	}

	fileprivate func checkForDateParameter() {
		if !(parameter is DateParameter) {
			datePicker.isHidden = true
			datePicker.isEnabled = false
			datePicker.isUserInteractionEnabled = false
		} else {
			let dateParameter = parameter as! DateParameter
			if dateParameter.includeTime {
				datePicker.datePickerMode = .dateAndTime
			} else {
				datePicker.datePickerMode = .date
			}

			datePicker.minimumDate = dateParameter.earliestDate
			datePicker.maximumDate = dateParameter.latestDate

			if parameterValue != nil {
				let date = parameterValue as! Date
				datePicker.calendar = Calendar.autoupdatingCurrent
				datePicker.timeZone = Calendar.autoupdatingCurrent.timeZone
				datePicker.locale = Calendar.autoupdatingCurrent.locale
				datePicker.setDate(date, animated: false)
			}
		}
	}

	fileprivate func checkForTextFieldParameter() {
		if !(parameter is TextFieldParameter) {
			textView.isHidden = true
			textView.isUserInteractionEnabled = false
		} else if parameterValue != nil {
			textView.text = try! parameter.convertToString(from: parameterValue)
		}
	}
}
