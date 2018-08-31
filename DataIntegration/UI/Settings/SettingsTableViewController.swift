//
//  SettingsTableViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class SettingsTableViewController: UITableViewController {

	private final let identifiers = [
		"generalSettings",
		"moodSettings",
	]

	final override func viewDidLoad() {
		super.viewDidLoad()
	}

	// MARK: - Table view data source

	final override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}

	final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: identifiers[indexPath.row], for: indexPath)
	}
}
