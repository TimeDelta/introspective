//
//  TableViewCellExtensions.swift
//  Introspective
//
//  Created by Bryan Nova on 12/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

extension UITableViewCell {

	final func observe(selector: Selector, name: NotificationName, object: Any? = nil) {
		NotificationCenter.default.addObserver(self, selector: selector, name: name.toName(), object: object)
	}

	final func observe(selector: Selector, name: Notification.Name, object: Any? = nil) {
		NotificationCenter.default.addObserver(self, selector: selector, name: name, object: object)
	}

	/// Retrieve the value for the specified `UserInfoKey` from the given notification.
	/// - Parameter keyIsOptional: If true, no error will be logged if the specified key does not exist in the user info.
	/// - Note: Automatically logs when key is missing, wrong type or the notification does not have any user info.
	final func value<Type>(for key: UserInfoKey, from notification: Notification, keyIsOptional: Bool = false) -> Type? {
		return DependencyInjector.util.ui.value(for: key, from: notification, keyIsOptional: keyIsOptional)
	}

	/// This is just a pass-through method that will return the input. It is solely for syntactic
	/// sugar so that you don't have to type out "UserInfoKey." everywhere.
	final func info(_ info: [UserInfoKey: Any]) -> [AnyHashable: Any] {
		return DependencyInjector.util.ui.info(info)
	}

	final func viewController<Type: UIViewController>(named controllerName: String, fromStoryboard storyboardName: String) -> Type {
		return DependencyInjector.util.ui.controller(named: controllerName, from: storyboardName, as: Type.self)
	}

	final func post(_ name: Notification.Name, object: Any? = self, userInfo: [AnyHashable: Any]? = nil) {
		DependencyInjector.util.ui.post(name: name, object: object, userInfo: userInfo)
	}

	final func post(_ name: NotificationName, object: Any? = self, userInfo: [UserInfoKey: Any]? = nil) {
		DependencyInjector.util.ui.post(name: name, object: object, userInfo: userInfo)
	}

	final func syncPost(_ name: NotificationName, object: Any? = self, userInfo: [UserInfoKey: Any]? = nil) {
		DependencyInjector.util.notification.post(name, object: object, userInfo: userInfo, qos: nil)
	}

	final func syncPost(_ name: Notification.Name, object: Any? = self, userInfo: [UserInfoKey: Any]? = nil) {
		DependencyInjector.util.notification.post(name, object: object, userInfo: userInfo, qos: nil)
	}
}
