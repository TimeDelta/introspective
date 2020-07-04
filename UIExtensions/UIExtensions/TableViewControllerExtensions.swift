//
//  TableViewControllerExtensions.swift
//  Introspective
//
//  Created by Bryan Nova on 12/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection

public extension UITableViewController {
	final func tableViewCell<Type: UITableViewCell>(
		withIdentifier identifier: String,
		for indexPath: IndexPath
	) -> Type {
		DependencyInjector.get(UiUtil.self).tableViewCell(
			from: tableView,
			withIdentifier: identifier,
			for: indexPath,
			as: Type.self
		)
	}

	final func reorderOnLongPress(allowReorder: ((IndexPath, IndexPath?) -> Bool)? = nil) {
		let reorderRecognizer = LongPressReorderGestureRecognizer({ self }, allowReorder: allowReorder)
		tableView.addGestureRecognizer(reorderRecognizer)
	}
}
