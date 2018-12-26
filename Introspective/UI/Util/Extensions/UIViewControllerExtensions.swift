//
//  UIViewControllerExtensions.swift
//  Introspective
//
//  Created by Bryan Nova on 11/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

extension UIViewController {

	final func observe(selector: Selector, name: Notification.Name, object: Any? = nil) {
		NotificationCenter.default.addObserver(self, selector: selector, name: name, object: object)
	}

	final func showError(title: String, message: String? = nil, tryAgain: (() -> Void)? = nil) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
		if let tryAgain = tryAgain {
			alert.addAction(UIAlertAction(title: "Try Again", style: .default){ _ in
				tryAgain()
			})
		}
		present(alert, animated: false, completion: nil)
	}

	/// Retrieve the value for the specified `UserInfoKey` from the given notification.
	/// - Parameter keyIsOptional: If true, no error will be logged if the specified key does not exist in the user info.
	/// - Note: Automatically logs when key is missing, wrong type or the notification does not have any user info.
	public func value<Type>(for key: UserInfoKey, from notification: Notification, keyIsOptional: Bool = false) -> Type? {
		return DependencyInjector.util.ui.value(for: key, from: notification, keyIsOptional: keyIsOptional)
	}

	/// This is just a pass-through method that will return the input. It is solely for syntactic
	/// sugar so that you don't have to type out "UserInfoKey." everywhere.
	final func info(_ info: [UserInfoKey: Any]) -> [AnyHashable: Any] {
		return DependencyInjector.util.ui.info(info)
	}

	final func viewController<Type: UIViewController>(named controllerName: String, fromStoryboard storyboardName: String? = nil) -> Type {
		if let storyboardName = storyboardName {
			return DependencyInjector.util.ui.controller(named: controllerName, from: storyboardName)
		}
		return storyboard!.instantiateViewController(withIdentifier: controllerName) as! Type
	}

	final func post(_ name: Notification.Name, object: Any? = self, userInfo: [AnyHashable: Any]? = nil) {
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
		}
	}
}
