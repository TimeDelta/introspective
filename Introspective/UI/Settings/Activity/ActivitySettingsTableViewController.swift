//
//  ActivitySettingsTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 12/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Settings

public final class ActivitySettingsTableViewController: UITableViewController {
	// MARK: - Static Variables

	private typealias Me = ActivitySettingsTableViewController

	private static let descriptionPresenter = injected(UiUtil.self).customPresenter(
		width: .custom(size: 300),
		height: .custom(size: 200),
		center: .center
	)

	private static let changeNotifications = [
		Notification.Name("autoIgnoreChanged"),
		Notification.Name("autoTrimWhitespaceInActivityNotesChanged"),
	]

	private static let notificationHandlers: [Selector] = [
		#selector(autoIgnoreChanged),
		#selector(autoTrimWhitespaceInActivityNotesChanged),
	]

	private static let identifiers = [
		"autoIgnore",
		"autoTrimWhitespaceInActivityNotes",
	]

	private static let cellHeights: [CGFloat] = [
		87.0,
		58.0,
	]

	private static let log = Log()

	// MARK: - Instance Variables

	private final var autoIgnoreEnabled: Bool = injected(Settings.self).autoIgnoreEnabled
	private final var numberOfSeconds: Int = injected(Settings.self).autoIgnoreSeconds
	private final var autoTrimWhitespaceInActivityNotesEnabled: Bool = injected(Settings.self)
		.autoTrimWhitespaceInActivityNotes

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Reset",
			style: .plain,
			target: self,
			action: #selector(reset)
		)

		injected(UiUtil.self).setBackButton(for: self, title: "Settings", action: #selector(done))
		for i in 0 ..< Me.changeNotifications.count {
			observe(selector: Me.notificationHandlers[i], name: Me.changeNotifications[i])
		}
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Table view data source

	public final override func numberOfSections(in _: UITableView) -> Int {
		1
	}

	public final override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
		Me.identifiers.count
	}

	public final override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: Me.identifiers[indexPath.row],
			for: indexPath
		) as? ActivitySettingTableViewCell else {
			Me.log.error("Unable to create table view cell for identifier: %@", Me.identifiers[indexPath.row])
			return UITableViewCell()
		}
		cell.changeNotification = Me.changeNotifications[indexPath.row]
		return cell
	}

	public final override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		Me.cellHeights[indexPath.row]
	}

	// MARK: - Table view delegate

	public final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
	}

	// MARK: - Received Notifications

	@objc private final func autoIgnoreChanged(notification: Notification) {
		if let enabled: Bool = value(for: .autoIgnoreEnabled, from: notification) {
			autoIgnoreEnabled = enabled
		}
		if let seconds: Int = value(for: .autoIgnoreSeconds, from: notification) {
			numberOfSeconds = seconds
		}
	}

	@objc private final func autoTrimWhitespaceInActivityNotesChanged(notification: Notification) {
		if let enabled: Bool = value(for: .autoTrimWhitespaceInActivityNotes, from: notification) {
			autoTrimWhitespaceInActivityNotesEnabled = enabled
		}
	}

	// MARK: - Actions

	@objc private final func reset(_: Any) {
		injected(Settings.self).reset()
		for cell in tableView.visibleCells as! [ActivitySettingTableViewCell] {
			cell.reset()
		}
	}

	@IBAction final func autoIgnoreInformationButtonPressed(_: Any) {
		let controller: DescriptionViewController = viewController(named: "description", fromStoryboard: "Util")
		controller.descriptionText =
			"If an activity is completed before this many seconds have passed, it will not be saved. This only applies when tapping to stop a running activity on the record screen (including the stop all button)."
		customPresentViewController(Me.descriptionPresenter, viewController: controller, animated: false)
	}

	@IBAction final func autoTrimWhitespaceInActivityNotesInformationButtonPressed(_: Any) {
		let controller: DescriptionViewController = viewController(named: "description", fromStoryboard: "Util")
		controller.descriptionText =
			"Whether or not to remove empty space at the begining and end of each line of activity notes when saving."
		customPresentViewController(Me.descriptionPresenter, viewController: controller, animated: false)
	}

	// MARK: - Helper Functions

	@objc private final func done() {
		injected(Settings.self).setAutoIgnoreEnabled(autoIgnoreEnabled)
		if autoIgnoreEnabled {
			injected(Settings.self).setAutoIgnoreSeconds(numberOfSeconds)
		}
		injected(Settings.self)
			.setAutoTrimWhitespaceInActivityNotes(autoTrimWhitespaceInActivityNotesEnabled)
		saveAndGoBackToSettings()
	}

	@objc private final func saveAndGoBackToSettings() {
		do {
			try retryOnFail({ try injected(Settings.self).save() }, maxRetries: 2)
			navigationController?.popViewController(animated: false)
		} catch {
			Me.log.error("Failed to save activity settings: %@", errorInfo(error))
			showError(title: "Failed to save settins", error: error, tryAgain: saveAndGoBackToSettings)
		}
	}
}
