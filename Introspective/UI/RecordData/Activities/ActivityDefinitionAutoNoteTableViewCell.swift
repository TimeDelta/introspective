//
//  ActivityDefinitionAutoNoteTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 12/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection

public final class ActivityDefinitionAutoNoteTableViewCell: UITableViewCell {

	// MARK: - Static Variables

	private typealias Me = ActivityDefinitionAutoNoteTableViewCell
	private static let descriptionPresenter = DependencyInjector.get(UiUtil.self).customPresenter(
		width: .custom(size: 300),
		height: .custom(size: 200),
		center: .center)

	// MARK: - IBOutlets

	@IBOutlet weak final var toggleSwitch: UISwitch! {
		didSet { updateUI() }
	}

	// MARK: - Instance Variables

	public final var notificationToSendOnChange: Notification.Name!
	public final var notificationToSendForPopup: Notification.Name!
	public final var autoNote: Bool! {
		didSet { updateUI() }
	}

	// MARK: - Actions

	@IBAction final func valueChanged(_ sender: Any) {
		NotificationCenter.default.post(
			name: notificationToSendOnChange,
			object: self,
			userInfo: info([
				.activityDefinitionAutoNote: toggleSwitch.isOn,
			]))
	}

	@IBAction final func showDescription(_ sender: Any) {
		let controller: DescriptionViewController = viewController(named: "description", fromStoryboard: "Util")
		controller.descriptionText = "Automatically display the edit screen for this activity with the note ready to be filled in on completion."
		NotificationCenter.default.post(
			name: notificationToSendForPopup,
			object: self,
			userInfo: info([
				.controller: controller,
				.presenter: Me.descriptionPresenter,
			]))
	}

	// MARK: - Helper Functions

	private final func updateUI() {
		guard let toggleSwitch = toggleSwitch else { return }
		guard let autoNote = autoNote else { return }
		toggleSwitch.isOn = autoNote
	}
}
