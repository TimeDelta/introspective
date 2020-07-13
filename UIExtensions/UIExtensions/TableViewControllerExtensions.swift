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

	/// This prevents the last UITableViewCell from sometimes being hidden by the tab bar
	final func setTableViewInsetsForTabBar() {
		if let rect = navigationController?.tabBarController?.tabBar.frame {
			let y = rect.size.height
			tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: y, right: 0)
			tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: y, right: 0)
		}
	}
}
