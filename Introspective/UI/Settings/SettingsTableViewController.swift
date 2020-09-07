//
//  SettingsTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Globals
import UIExtensions

public final class SettingsTableViewController: UITableViewController {
	private typealias Me = SettingsTableViewController

	public static let disableGenerateTestData = Notification.Name("disableGenerateTestData")
	public static let enableGenerateTestData = Notification.Name("enableGenerateTestData")
	private static let resetInstructionPromptsCellIdentifier = "resetInstructionPrompts"
	private static let versionCellIdentifier = "version"
	private static let identifiers = [
		(
			section: "Settings",
			rows: [
				"general",
				"activitySettings",
				"moodSettings",
			]
		),
		(
			section: "Other",
			rows: [
				"export",
				resetInstructionPromptsCellIdentifier,
				versionCellIdentifier,
			]
		),
	]

	// MARK: - Instance Variables

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

	public final override func numberOfSections(in _: UITableView) -> Int {
		if Globals.testing {
			return 3
		}
		return 2
	}

	public final override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
		if Globals.testing && section == 0 {
			return 2
		}
		let section = Globals.testing ? section - 1 : section
		return Me.identifiers[section].rows.count
	}

	public final override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
		if Globals.testing && section == 0 {
			return "Testing Only"
		}
		let section = Globals.testing ? section - 1 : section
		return Me.identifiers[section].section
	}

	public final override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		if Globals.testing && indexPath.section == 0 {
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
			injected(UserDefaultsUtil.self).resetInstructionPrompts()
			tableView.deselectRow(at: _indexPath, animated: false)
		} else if Globals.testing && disableGenerateTestDataCell && _indexPath.section == 0 && _indexPath.row == 0 {
			tableView.deselectRow(at: _indexPath, animated: false)
		} else if indexPath(_indexPath, isNonTestOnlySectionRowNamed: Me.versionCellIdentifier) {
			let pasteboard = UIPasteboard.general
			pasteboard.string = versionString()
			tableView.deselectRow(at: _indexPath, animated: false)
		}
	}

	// MARK: - Received Notifications

	@objc private final func disableGenerateTestData(notification _: Notification) {
		disableGenerateTestDataCell = true
		tableView.reloadData()
	}

	@objc private final func enableGenerateTestData(notification _: Notification) {
		disableGenerateTestDataCell = false
		tableView.reloadData()
	}

	// MARK: - Helper Functions

	private final func indexPath(_ indexPath: IndexPath, isNonTestOnlySectionRowNamed rowIdentifier: String) -> Bool {
		indexPathIsNonTestOnlySection(indexPath) && identifier(for: indexPath) == rowIdentifier
	}

	private final func indexPathIsNonTestOnlySection(_ indexPath: IndexPath) -> Bool {
		!Globals.testing || indexPath.section != 0
	}

	private final func identifier(for indexPath: IndexPath) -> String {
		let section = Globals.testing ? indexPath.section - 1 : indexPath.section
		return Me.identifiers[section].rows[indexPath.row]
	}
}
