//
//  SettingsTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public final class SettingsTableViewController: UITableViewController {

	private typealias Me = SettingsTableViewController

	public static let disableGenerateTestData = Notification.Name("disableGenerateTestData")
	public static let enableGenerateTestData = Notification.Name("enableGenerateTestData")
	private static let resetInstructionPromptsCellIdentifier = "resetInstructionPrompts"
	private static let identifiers = [
		(
			section: "Settings",
			rows: [
				"general",
				"activitySettings",
				"moodSettings",
			]),
		(
			section: "Other",
			rows: [
				"export",
				resetInstructionPromptsCellIdentifier,
			]),
	]

	// MARK: - Member Variables

	private final var disableGenerateTestDataCell = false

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		observe(selector: #selector(enableGenerateTestData), name: Me.enableGenerateTestData)
		observe(selector: #selector(disableGenerateTestData), name: Me.disableGenerateTestData)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Table view data source

	public final override func numberOfSections(in tableView: UITableView) -> Int {
		if testing {
			return 3
		}
		return 2
	}

	public final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if testing && section == 0 {
			return 2
		}
		return Me.identifiers[section].rows.count
	}

	public final override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if testing && section == 0 {
			return "Testing Only"
		}
		return Me.identifiers[section].section
	}

	public final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if testing && indexPath.section == 0 {
			if indexPath.row == 0 {
				if disableGenerateTestDataCell {
					return tableView.dequeueReusableCell(withIdentifier: "progress", for: indexPath)
				}
				return tableView.dequeueReusableCell(withIdentifier: "generateTestData", for: indexPath)
			}
			return tableView.dequeueReusableCell(withIdentifier: "deleteCoreData", for: indexPath)
		}
		return tableView.dequeueReusableCell(withIdentifier: identifier(for: indexPath), for: indexPath)
	}

	// MARK: - Table view delegate

	public final override func tableView(_ tableView: UITableView, didSelectRowAt _indexPath: IndexPath) {
		if indexPath(_indexPath, isNonTestOnlySectionRowNamed: Me.resetInstructionPromptsCellIdentifier) {
			UserDefaults().set(false, forKey: UserDefaultKeys.queryViewInstructionsShown)
			UserDefaults().set(false, forKey: UserDefaultKeys.recordActivitiesInstructionsShown)
			UserDefaults().set(false, forKey: UserDefaultKeys.recordMedicationsInstructionsShown)
			tableView.deselectRow(at: _indexPath, animated: false)
		} else if testing && disableGenerateTestDataCell && _indexPath.section == 0 && _indexPath.row == 0 {
			tableView.deselectRow(at: _indexPath, animated: false)
		}
	}

	// MARK: - Received Notifications

	@objc private final func disableGenerateTestData(notification: Notification) {
		disableGenerateTestDataCell = true
		tableView.reloadData()
	}

	@objc private final func enableGenerateTestData(notification: Notification) {
		disableGenerateTestDataCell = false
		tableView.reloadData()
	}

	// MARK: - Helper Functions

	private final func indexPath(_ indexPath: IndexPath, isNonTestOnlySectionRowNamed rowIdentifier: String) -> Bool {
		return indexPathIsNonTestOnlySection(indexPath) && identifier(for: indexPath) == rowIdentifier
	}

	private final func indexPathIsNonTestOnlySection(_ indexPath: IndexPath) -> Bool {
		return !testing || indexPath.section != 0
	}

	private final func identifier(for indexPath: IndexPath) -> String {
		return Me.identifiers[indexPath.section].rows[indexPath.row]
	}
}
