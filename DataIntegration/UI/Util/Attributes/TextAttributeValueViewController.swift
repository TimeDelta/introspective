//
//  TextAttributeValueViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/2/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class TextAttributeValueViewController: AttributeValueTypeViewController, UITextViewDelegate {

	public final var textAttribute: TextAttribute!

	@IBOutlet weak final var textView: UITextView!
	@IBOutlet weak final var validationLabel: UILabel!

	final override func viewDidLoad() {
		super.viewDidLoad()
		textView.delegate = self
		if currentValue != nil {
			textView.text = (currentValue as! String)
		}
	}

	public final func textViewDidChange(_ textView: UITextView) {
		if textAttribute.isValid(value: textView.text) {
			setValidState()
			currentValue = textView.text
		} else {
			let errorMessage = textAttribute.errorMessageFor(invalidValue: textView.text)
			setInvalidState(errorMessage)
		}
	}

	private final func setInvalidState(_ message: String) {
		valueIsInvalid()
		validationLabel.text = message
		validationLabel.reloadInputViews()
	}

	private final func setValidState() {
		valueIsValid()
		validationLabel.text = ""
		validationLabel.reloadInputViews()
	}
}
