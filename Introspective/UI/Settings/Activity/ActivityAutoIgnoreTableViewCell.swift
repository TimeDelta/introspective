//
//  ActivityAutoIgnoreTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 12/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import DependencyInjection
import Settings
import UIExtensions

public final class ActivityAutoIgnoreTableViewCell: ActivitySettingTableViewCell {
	// MARK: - IBOutlets

	@IBOutlet final var toggleSwitch: UISwitch! {
		didSet { resetToggleSwitch() }
	}

	@IBOutlet final var label1: UILabel!
	@IBOutlet final var numberOfSecondsTextField: UITextField! {
		didSet { resetTextField() }
	}

	@IBOutlet final var label2: UILabel!

	// MARK: - Actions

	@IBAction final func switchToggled(_: Any) {
		updateUiPerToggleSwitch()
		sendValueChangedNotification()
	}

	@IBAction final func numberOfSecondsChanged(_: Any) {
		if numberOfSecondsIsValid() {
			sendValueChangedNotification()
		}
	}

	@IBAction final func finishedEditingNumberOfSeconds(_: Any) {
		if !numberOfSecondsIsValid() {
			numberOfSecondsTextField.text = "1"
		}
	}

	// MARK: - Other Functions

	public final override func reset() {
		resetToggleSwitch()
		resetTextField()
	}

	// MARK: - Helper Functions

	private final func numberOfSecondsIsValid() -> Bool {
		let text = numberOfSecondsTextField.text
		return text != nil && !text!.isEmpty && Int(text!)! >= 1
	}

	private final func sendValueChangedNotification() {
		NotificationCenter.default.post(
			name: changeNotification,
			object: self,
			userInfo: info([
				.autoIgnoreEnabled: toggleSwitch.isOn,
				.autoIgnoreSeconds: Int(numberOfSecondsTextField.text!)!,
			])
		)
	}

	private final func updateUiPerToggleSwitch() {
		numberOfSecondsTextField.isEnabled = toggleSwitch.isOn
		numberOfSecondsTextField.isUserInteractionEnabled = toggleSwitch.isOn
		label1.isEnabled = toggleSwitch.isOn
		label2.isEnabled = toggleSwitch.isOn
	}

	private final func resetToggleSwitch() {
		guard let toggleSwitch = toggleSwitch else { return }
		toggleSwitch.isOn = DependencyInjector.get(Settings.self).autoIgnoreEnabled
		updateUiPerToggleSwitch()
	}

	private final func resetTextField() {
		guard let numberOfSecondsTextField = numberOfSecondsTextField else { return }
		numberOfSecondsTextField.text = String(DependencyInjector.get(Settings.self).autoIgnoreSeconds)
	}
}
