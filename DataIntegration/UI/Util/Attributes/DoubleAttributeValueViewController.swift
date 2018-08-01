//
//  DoubleAttributeValueViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/2/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class DoubleAttributeValueViewController: AttributeValueTypeViewController {

	public var doubleAttribute: DoubleAttribute!

	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var validationLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
		if currentValue != nil {
			textField.text = String(currentValue as! Double)
		} else {
			setErrorMessageFor(invalidValue: nil)
		}
	}

	@IBAction func valueChanged(_ sender: Any) {
		validate(value: textField.text)
	}

	fileprivate func validate(value: String?) {
		if value != nil && DependencyInjector.util.stringUtil.isNumber(value!) {
			currentValue = Double(value!)
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
