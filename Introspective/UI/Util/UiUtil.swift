//
//  UiUtil.swift
//  Introspective
//
//  Created by Bryan Nova on 9/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import os

//sourcery: AutoMockable
public protocol UiUtil {

	var defaultPresenter: Presentr { get }

	func customPresenter(width: ModalSize, height: ModalSize, center: ModalCenterPosition) -> Presentr
	func setView(_ view: UIView, enabled: Bool?, hidden: Bool?)
	func setButton(_ button: UIButton, enabled: Bool?, hidden: Bool?)
	func setBackButton(for viewController: UIViewController, title: String, action selector: Selector)
	func addDoneButtonToKeyboardFor(_ textView: UITextView, target: Any?, action: Selector?)
	/// Retrieve the value for the specified `UserInfoKey` from the given notification.
	/// - Parameter keyIsOptional: If true, no error will be logged if the specified key does not exist in the user info.
	/// - Note: Automatically logs when key is missing, wrong type or the notification does not have any user info.
	func value<Type>(for key: UserInfoKey, from notification: Notification, keyIsOptional: Bool) -> Type?
	/// This is just a pass-through method that will return the input. It is solely for syntactic
	/// sugar so that you don't have to type out "UserInfoKey." everywhere.
	func info(_ info: [UserInfoKey: Any]) -> [AnyHashable: Any]
	func controller<Type: UIViewController>(named controllerName: String, from storyboardName: String) -> Type
}

extension UiUtil {

	func customPresenter(width: ModalSize = .default, height: ModalSize = .default, center: ModalCenterPosition = .center) -> Presentr {
		return customPresenter(width: width, height: height, center: center)
	}

	func setView(_ view: UIView, enabled: Bool? = nil, hidden: Bool? = nil) {
		setView(view, enabled: enabled, hidden: hidden)
	}

	func setButton(_ button: UIButton, enabled: Bool? = nil, hidden: Bool? = nil) {
		setButton(button, enabled: enabled, hidden: hidden)
	}

	/// Retrieve the value for the specified `UserInfoKey` from the given notification.
	/// - Parameter keyIsOptional: If true, no error will be logged if the specified key does not exist in the user info.
	/// - Note: Automatically logs when key is missing, wrong type or the notification does not have any user info.
	func value<Type>(for key: UserInfoKey, from notification: Notification, keyIsOptional: Bool = false) -> Type? {
		return value(for: key, from: notification, keyIsOptional: keyIsOptional)
	}
}

public final class UiUtilImpl: UiUtil {

	public final let defaultPresenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 200), center: .center)
		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()

	public func customPresenter(width: ModalSize, height: ModalSize, center: ModalCenterPosition) -> Presentr {
		let customType = PresentationType.custom(width: width, height: height, center: center)
		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}

	public func setView(_ view: UIView, enabled: Bool?, hidden: Bool?) {
		view.isHidden = hidden ?? view.isHidden
		view.isUserInteractionEnabled = enabled ?? view.isUserInteractionEnabled
	}

	public func setButton(_ button: UIButton, enabled: Bool? = nil, hidden: Bool? = nil) {
		button.isEnabled = enabled ?? button.isEnabled
		setView(button, enabled: enabled, hidden: hidden)
	}

	public func setBackButton(for viewController: UIViewController, title: String, action selector: Selector) {
		// Disable the swipe to make sure user presses button
		viewController.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

		// Replace the default back button
		viewController.navigationItem.setHidesBackButton(true, animated: false)

		let button = UIButton(type: .system)
		button.setImage(UIImage(named: "back-button"), for: .normal)
		button.setTitle(title, for: .normal)
		button.sizeToFit()
		button.addTarget(viewController, action: selector, for: .touchUpInside)

		let backButton = UIBarButtonItem(customView: button)
		viewController.navigationItem.leftBarButtonItem = backButton
	}

	public func addDoneButtonToKeyboardFor(_ textView: UITextView, target: Any?, action: Selector?) {
		let keyboardToolBar = UIToolbar()
		keyboardToolBar.sizeToFit()

		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: target, action: action)
		keyboardToolBar.setItems([flexibleSpace, doneButton, flexibleSpace], animated: true)

		textView.inputAccessoryView = keyboardToolBar
	}

	/// Retrieve the value for the specified `UserInfoKey` from the given notification.
	/// - Parameter keyIsOptional: If true, no error will be logged if the specified key does not exist in the user info.
	/// - Note: Automatically logs when key is missing, wrong type or the notification does not have any user info.
	public func value<Type>(for key: UserInfoKey, from notification: Notification, keyIsOptional: Bool = false) -> Type? {
		if let userInfo = notification.userInfo {
			guard userInfo.keys.contains(key) else {
				if !keyIsOptional {
					os_log("Missing user info key for '%@' notification: %@", type: .error, notification.name.rawValue, key.description)
				}
				return nil
			}
			let value = userInfo[key]
			if value is Type || value is Optional<Type> {
				return value as? Type
			}
			os_log("Wrong object type for '%@' notification: %@", type: .error, notification.name.rawValue, key.description)
			return nil
		}
		os_log("No user info for '%@' notification", type: .error, notification.name.rawValue)
		return nil
	}

	/// This is just a pass-through method that will return the input. It is solely for syntactic
	/// sugar so that you don't have to type out "UserInfoKey." everywhere.
	public func info(_ info: [UserInfoKey: Any]) -> [AnyHashable: Any] {
		return info
	}

	public func controller<Type: UIViewController>(named controllerName: String, from storyboardName: String) -> Type {
		return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: controllerName) as! Type
	}
}
