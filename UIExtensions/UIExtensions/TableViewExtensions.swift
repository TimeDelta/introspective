//
//  TableViewExtensions.swift
//  Introspective
//
//  Created by Bryan Nova on 11/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public extension UITableView {
	/// - Note: This will still call the `setSelected` method on each `UITableViewCell` after reloading
	final func reloadAndReapplySelectionState() {
		let selectedIndexPaths = indexPathsForSelectedRows
		reloadData()
		if selectedIndexPaths != nil {
			for indexPath in selectedIndexPaths! {
				selectRow(at: indexPath, animated: false, scrollPosition: .none)
			}
		}
	}
}
