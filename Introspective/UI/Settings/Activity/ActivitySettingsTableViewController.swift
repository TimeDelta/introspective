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

	private static let descriptionPresenter = DependencyInjector.get(UiUtil.self).customPresenter(
		width: .custom(size: 300),
		height: .custom(size: 200),
		center: .center)

	private static let changeNotifications = [
		Notification.Name("autoIgnoreChanged"),
	]

	private static let identifiers = [
		"autoIgnore",
	]

	private static let cellHeights: [CGFloat] = [
		87.0,
	]

	// MARK: - Instance Variables

	private final var autoIgnoreEnabled: Bool = DependencyInjector.get(Settings.self).autoIgnoreEnabled
	private final var numberOfSeconds: Int = DependencyInjector.get(Settings.self).autoIgnoreSeconds

	private final let log = Log()

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset))

		DependencyInjector.get(UiUtil.self).setBackButton(for: self, title: "Settings", action: #selector(done))
		observe(selector: #selector(autoIgnoreChanged), name: Me.changeNotifications[0])
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Table view data source

	public final override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	public final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	public final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Me.identifiers[indexPath.row], for: indexPath) as! ActivitySettingTableViewCell
		cell.changeNotification = Me.changeNotifications[indexPath.row]
		return cell
	}

	public final override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return Me.cellHeights[indexPath.row]
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

	// MARK: - Actions

	@objc private final func reset(_ sender: Any) {
		DependencyInjector.get(Settings.self).reset()
		for cell in tableView.visibleCells as! [ActivitySettingTableViewCell] {
			cell.reset()
		}
	}

	@IBAction final func informationButtonPressed(_ sender: Any) {
		let controller: DescriptionViewController = viewController(named: "description", fromStoryboard: "Util")
		controller.descriptionText = "If an activity is completed before this many seconds have passed, it will not be saved. This only applies when tapping to stop a running activity on the record screen (including the stop all button)."
		customPresentViewController(Me.descriptionPresenter, viewController: controller, animated: false)
	}

	// MARK: - Helper Functions

	@objc private final func done() {
		DependencyInjector.get(Settings.self).setAutoIgnoreEnabled(autoIgnoreEnabled)
		if autoIgnoreEnabled {
			DependencyInjector.get(Settings.self).setAutoIgnoreSeconds(numberOfSeconds)
		}
		saveAndGoBackToSettings()
	}

	@objc private final func saveAndGoBackToSettings() {
		do {
			try retryOnFail({ try DependencyInjector.get(Settings.self).save() }, maxRetries: 2)
			self.navigationController?.popViewController(animated: false)
		} catch {
			log.error("Failed to save activity settings: %@", errorInfo(error))
			showError(title: "Failed to save settins", error: error, tryAgain: saveAndGoBackToSettings)
		}
	}
}
