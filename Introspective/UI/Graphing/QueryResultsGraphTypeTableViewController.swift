//
//  QueryResultsGraphTypeTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 9/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class QueryResultsGraphTypeTableViewController: UITableViewController {

	public final var samples: [Sample]!

	// MARK: - Navigation

	final override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if var controller = segue.destination as? QueryResultsGraphCustomizationViewController {
			controller.samples = samples
		}
	}
}
