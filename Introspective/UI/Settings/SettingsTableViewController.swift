//
//  SettingsTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class SettingsTableViewController: UITableViewController {

	private typealias Me = SettingsTableViewController

	private static let identifiers = [
		"generalSettings",
		"moodSettings",
	]

	final override func viewDidLoad() {
		super.viewDidLoad()
	}

	// MARK: - Table view data source

	final override func numberOfSections(in tableView: UITableView) -> Int {
		if testing {
			return 2
		}
		return 1
	}

	final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if testing && section == 0 {
			return 2
		}
		return 2
	}

	final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if testing && indexPath.section == 0 {
			if indexPath.row == 0 {
				return tableView.dequeueReusableCell(withIdentifier: "generateTestData", for: indexPath)
			} else {
				return tableView.dequeueReusableCell(withIdentifier: "deleteCoreData", for: indexPath)
			}
		}
		return tableView.dequeueReusableCell(withIdentifier: Me.identifiers[indexPath.row], for: indexPath)
	}
}
