//
//  RecordNumberViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 12/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Settings

public final class RecordNumberViewController: UIViewController {
	// MARK: - Static Variables

	private typealias Me = RecordNumberViewController
	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var numberTextField: UITextField!

	// MARK: - Instance Variables

	public final var max: Double = 0
	public final var min: Double = 0
	public final var number: Double?
	public final var notificationToSendOnAccept: Notification.Name!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		let number = self.number ?? (max - min) / 2 + min
		numberTextField.text = String(number)
		injected(UiUtil.self).addSaveButtonToKeyboardFor(
			numberTextField,
			target: self,
			action: #selector(saveClicked)
		)
		numberTextField.becomeFirstResponder()
	}

	// MARK: - Actions

	@IBAction final func textFieldValueChanged(_: Any) {
		let numberText = numberTextField.text!
		guard !numberText.hasSuffix(".") else { return }
		if let number = Double(numberText) {
			if min <= number && number <= max {
				self.number = number
			} else if number > max {
				self.number = max
				numberTextField.text = injected(MoodUiUtil.self).valueToString(max)
			} else {
				self.number = min
				numberTextField.text = injected(MoodUiUtil.self).valueToString(min)
			}
		}
	}

	@objc private final func saveClicked(_: Any) {
		guard let number = number else {
			Me.log.error("Tried to save number without a value")
			return
		}
		post(
			notificationToSendOnAccept,
			userInfo: [
				.number: number,
			]
		)
		dismiss(animated: false)
	}
}
