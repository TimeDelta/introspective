//
//  TableViewCellExtensions.swift
//  Introspective
//
//  Created by Bryan Nova on 12/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

extension UITableViewCell {

	final func value<Type>(for key: UiUtil.UserInfoKey, from notification: Notification) -> Type? {
		return UiUtil.value(for: key, from: notification)
	}

	final func info(_ info: [UiUtil.UserInfoKey: Any]) -> [AnyHashable: Any] {
		return UiUtil.info(info)
	}
}
