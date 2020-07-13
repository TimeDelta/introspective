//
//  AutoTrimWhitespaceInActivityNotesTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 7/11/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import UIKit

import DependencyInjection
import Settings

class AutoTrimWhitespaceInActivityNotesTableViewCell: ActivitySettingTableViewCell {
	// MARK: - IBOutlets

	@IBOutlet final var toggleSwitch: UISwitch! {
		didSet { resetToggleSwitch() }
	}

	@IBOutlet final var label: UILabel!

	// MARK: - Actions

	@IBAction final func valueChangeed(_: Any) {
		sendValueChangedNotification()
	}

	// MARK: - Other Functions

	public final override func reset() {
		resetToggleSwitch()
	}

	// MARK: - Helper Functions

	private final func resetToggleSwitch() {
		guard let toggleSwitch = toggleSwitch else { return }
		toggleSwitch.isOn = DependencyInjector.get(Settings.self).autoTrimWhitespaceInActivityNotes
	}

	private final func sendValueChangedNotification() {
		NotificationCenter.default.post(
			name: changeNotification,
			object: self,
			userInfo: info([
				.autoTrimWhitespaceInActivityNotes: toggleSwitch.isOn,
			])
		)
	}
}
