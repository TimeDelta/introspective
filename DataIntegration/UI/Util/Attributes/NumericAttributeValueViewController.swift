//
//  NumericAttributeValueViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/2/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

class NumericAttributeValueViewController: AttributeValueTypeViewController {

	public var numericAttribute: NumericAttribute!

	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var validationLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
		if currentValue != nil {
			if numericAttribute is DoubleAttribute {
				textField.text = String(currentValue as! Double)
			} else if numericAttribute is IntegerAttribute {
				textField.text = String(currentValue as! Int)
			} else {
				os_log("Forgot a type of NumericAttribute when setting initial value for text field", type: .error)
			}
		} else {
			setErrorMessageFor(invalidValue: nil)
		}
	}

	@IBAction func valueChanged(_ sender: Any) {
		validate(value: textField.text)
	}

	fileprivate func validate(value: String?) {
		if value != nil && numericAttribute.isValid(value: value!) {
			currentValue = try! numericAttribute.convertToValue(from: value!)
			validationLabel.text = ""
			valueIsValid()
		} else {
			setErrorMessageFor(invalidValue: value)
			valueIsInvalid()
		}
	}

	fileprivate func setErrorMessageFor(invalidValue value: String?) {
		if value == nil || value!.isEmpty {
			validationLabel.text = "Must enter a value"
		} else {
			validationLabel.text = "\"\(value!)\" is not a number"
		}
	}
}
