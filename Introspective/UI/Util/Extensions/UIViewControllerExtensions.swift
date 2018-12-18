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

	final func value<Type>(for key: UiUtil.UserInfoKey, from notification: Notification) -> Type? {
		return UiUtil.value(for: key, from: notification)
	}

	final func info(_ info: [UiUtil.UserInfoKey: Any]) -> [AnyHashable: Any] {
		return UiUtil.info(info)
	}
}
