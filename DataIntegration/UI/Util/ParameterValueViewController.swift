//
//  AggregationParameterValueViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class ParameterValueViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {

	public var parameter: Parameter!
	public var parameterValue: String!

	@IBOutlet weak var picker: UIPickerView!
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var validationLabel: UILabel!
	@IBOutlet weak var acceptButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        picker.dataSource = self

        if parameter.possibleValues == nil {
			picker.isHidden = true
			picker.isUserInteractionEnabled = false
		} else {
			textView.isHidden = true
			textView.isUserInteractionEnabled = false
		}
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if parameter.possibleValues == nil {
			return 0
		}
		return parameter.possibleValues!.count
	}

	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return parameter.possibleValues![row]
	}

	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		parameterValue = parameter.possibleValues![row]
	}

	public func textViewDidChange(_ textView: UITextView) {
		if parameter.isValid(value: textView.text) {
			setValidState()
			parameterValue = textView.text
		} else {
			let errorMessage = parameter.errorMessageFor(invalidValue: textView.text)
			setInvalidState(errorMessage)
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
}
