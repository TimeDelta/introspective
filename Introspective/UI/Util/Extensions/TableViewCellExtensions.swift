//
//  TableViewCellExtensions.swift
//  Introspective
//
//  Created by Bryan Nova on 12/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

extension UITableViewCell {

	final func value<Type>(for key: UserInfoKey, from notification: Notification) -> Type? {
		return DependencyInjector.util.ui.value(for: key, from: notification)
	}

	final func info(_ info: [UserInfoKey: Any]) -> [AnyHashable: Any] {
		return DependencyInjector.util.ui.info(info)
	}
}
