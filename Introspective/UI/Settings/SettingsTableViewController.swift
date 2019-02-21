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

	private static let resetInstructionPromptsCellIdentifier = "resetInstructionPrompts"
	private static let identifiers = [
		"activitySettings",
		"moodSettings",
		resetInstructionPromptsCellIdentifier,
	]

	// MARK: - Table view data source

	public final override func numberOfSections(in tableView: UITableView) -> Int {
		if testing {
			return 2
		}
		return 1
	}

	public final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if testing && section == 0 {
			return 2
		}
		return Me.identifiers.count
	}

	public final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if testing && indexPath.section == 0 {
			if indexPath.row == 0 {
				return tableView.dequeueReusableCell(withIdentifier: "generateTestData", for: indexPath)
			} else {
				return tableView.dequeueReusableCell(withIdentifier: "deleteCoreData", for: indexPath)
			}
		}
		return tableView.dequeueReusableCell(withIdentifier: Me.identifiers[indexPath.row], for: indexPath)
	}

	// MARK: - Table view delegate

	public final override func tableView(_ tableView: UITableView, didSelectRowAt _indexPath: IndexPath) {
		if indexPath(_indexPath, isNonTestOnlySectionRowNamed: Me.resetInstructionPromptsCellIdentifier) {
			UserDefaults().set(false, forKey: UserDefaultKeys.queryViewInstructionsShown)
			UserDefaults().set(false, forKey: UserDefaultKeys.recordActivitiesInstructionsShown)
			UserDefaults().set(false, forKey: UserDefaultKeys.recordMedicationsInstructionsShown)
			tableView.deselectRow(at: _indexPath, animated: false)
		}
	}

	// MARK: - Helper Functions

	private final func indexPath(_ indexPath: IndexPath, isNonTestOnlySectionRowNamed rowIdentifier: String) -> Bool {
		return indexPathIsNonTestOnlySection(indexPath) && Me.identifiers[indexPath.row] == rowIdentifier
	}

	private final func indexPathIsNonTestOnlySection(_ indexPath: IndexPath) -> Bool {
		return !testing || indexPath.section != 0
	}
}
