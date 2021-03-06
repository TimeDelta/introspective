//
//  TextAttributeValueViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/2/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Attributes

public final class TextAttributeValueViewController: AttributeValueTypeViewController, UITextViewDelegate {
	// MARK: - IBOutlets

	@IBOutlet final var textView: UITextView!
	@IBOutlet final var validationLabel: UILabel!

	// MARK: - Instance Variables

	public final var textAttribute: TextAttribute!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()
		textView.delegate = self
		if let text = currentValue as? String {
			textView.text = text
		}
		textView.becomeFirstResponder()
	}

	// MARK: - Functions

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
