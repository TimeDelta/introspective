//
//  SettingsTableViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

	private let identifiers = [
		"generalSettings",
		"moodSettings",
	]

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: identifiers[indexPath.row], for: indexPath)
	}
}
