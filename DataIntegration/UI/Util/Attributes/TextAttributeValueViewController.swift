//
//  TextAttributeValueViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/2/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class TextAttributeValueViewController: AttributeValueTypeViewController, UITextViewDelegate {

	public var textAttribute: TextAttribute!

	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var validationLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
		textView.delegate = self
		if currentValue != nil {
			textView.text = (currentValue as! String)
		}
	}

	public func textViewDidChange(_ textView: UITextView) {
		if textAttribute.isValid(value: textView.text) {
			setValidState()
			currentValue = textView.text
		} else {
			let errorMessage = textAttribute.errorMessageFor(invalidValue: textView.text)
			setInvalidState(errorMessage)
		}
	}

	fileprivate func setInvalidState(_ message: String) {
		valueIsInvalid()
		validationLabel.text = message
		validationLabel.reloadInputViews()
	}

	fileprivate func setValidState() {
		valueIsValid()
		validationLabel.text = ""
		validationLabel.reloadInputViews()
	}
}
