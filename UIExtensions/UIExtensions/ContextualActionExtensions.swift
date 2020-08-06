//
//  ContextualActionsExtensions.swift
//  UIExtensions
//
//  Created by Bryan Nova on 8/6/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection

extension UIContextualAction {
	/// Retrieve the value for the specified `UserInfoKey` from the given notification.
	/// - Parameter keyIsOptional: If true, no error will be logged if the specified key does not exist in the user info.
	/// - Note: Automatically logs when key is missing, wrong type or the notification does not have any user info.
	func value<Type>(for key: UserInfoKey, from notification: Notification, keyIsOptional: Bool = false) -> Type? {
		DependencyInjector.get(UiUtil.self).value(for: key, from: notification, keyIsOptional: keyIsOptional)
	}
}
