//
//  SourcesTableViewController.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class SourcesTableViewController: UITableViewController {

	let SOURCES_FILE = "sources.json"
	var sources: Array<Source>

	required init?(coder aDecoder: NSCoder) {
		if DependencyInjector.codableStorage.fileExists(SOURCES_FILE, in: .documents) {
			sources = try! DependencyInjector.codableStorage.retrieve(SOURCES_FILE, from: .documents, as: [Source].self)
		} else {
			sources = Array<Source>()
		}
		super.init(coder: aDecoder)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// display an Edit button in the navigation bar for this view controller
		self.navigationItem.rightBarButtonItem = self.editButtonItem
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is SourceDefinitionViewController {
			// TODO
//			let controller = (segue.destination as! SourceDefinitionViewController)
//			controller.source =
		}
	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 0
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

		// Configure the cell...

		return cell
	}

	// Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			// Delete the row from the data source
			tableView.deleteRows(at: [indexPath], with: .fade)
		} else if editingStyle == .insert {
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		}
	}
}
