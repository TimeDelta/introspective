//
//  UIViewControllerExtensions.swift
//  Introspective
//
//  Created by Bryan Nova on 11/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Instructions
import Presentr
import UIKit
import UserNotifications

import Common
import DependencyInjection

public extension UIViewController {
	final func observe(selector: Selector, name: NotificationName, object: Any? = nil) {
		NotificationCenter.default.addObserver(self, selector: selector, name: name.toName(), object: object)
	}

	final func observe(selector: Selector, name: Notification.Name, object: Any? = nil) {
		NotificationCenter.default.addObserver(self, selector: selector, name: name, object: object)
	}

	final func stopObserving(_ name: NotificationName, object: Any? = nil) {
		NotificationCenter.default.removeObserver(self, name: name.toName(), object: object)
		DependencyInjector.get(UiUtil.self).stopObserving(self, name: name, object: object)
	}

	@objc open func showError(
		title: String,
		message: String? = "Sorry for the inconvenience.",
		error: Error? = nil,
		tryAgain: (() -> Void)? = nil,
		onDismiss: ((UIAlertAction) -> Void)? = nil,
		onDonePresenting: (() -> Void)? = nil
	) {
		var realTitle = title
		var realMessage = message
		if let error = error as? DisplayableError {
			realTitle = error.displayableTitle
			if let description = error.displayableDescription {
				realMessage = description
			}
		}

		let alert = UIAlertController(title: realTitle, message: realMessage, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: onDismiss))
		if let tryAgain = tryAgain {
			alert.addAction(UIAlertAction(title: "Try Again", style: .default) { _ in
				tryAgain()
			})
		}
		present(alert, animated: false, completion: onDonePresenting)
	}

	final func hideKeyboardOnTapNonTextInput() {
		let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
			target: self,
			action: #selector(dismissKeyboard)
		)
		tapRecognizer.cancelsTouchesInView = false
		view.addGestureRecognizer(tapRecognizer)
	}

	@objc final func dismissKeyboard(_ tapRecognizer: UITapGestureRecognizer) {
		let view = tapRecognizer.view
		let loc = tapRecognizer.location(in: view)
		if let tappedView = view?.hitTest(loc, with: nil) {
			if !(tappedView is UITextInputTraits) {
				self.view.endEditing(true)
			}
		} else {
			self.view.endEditing(true)
		}
	}

	/// Retrieve the value for the specified `UserInfoKey` from the given notification.
	/// - Parameter keyIsOptional: If true, no error will be logged if the specified key does not exist in the user info.
	/// - Note: Automatically logs when key is missing, wrong type or the notification does not have any user info.
	func value<Type>(for key: UserInfoKey, from notification: Notification, keyIsOptional: Bool = false) -> Type? {
		DependencyInjector.get(UiUtil.self).value(for: key, from: notification, keyIsOptional: keyIsOptional)
	}

	/// This is just a pass-through method that will return the input. It is solely for syntactic
	/// sugar so that you don't have to type out "UserInfoKey." everywhere.
	final func info(_ info: [UserInfoKey: Any]) -> [AnyHashable: Any] {
		DependencyInjector.get(UiUtil.self).info(info)
	}

	/// - Parameter storyboardName: If not provided, will attempt to pull the controller from same storyboard as this controller.
	final func viewController<Type: UIViewController>(
		named controllerName: String,
		fromStoryboard storyboardName: String? = nil
	) -> Type {
		if let storyboardName = storyboardName {
			return DependencyInjector.get(UiUtil.self)
				.controller(named: controllerName, from: storyboardName, as: Type.self)
		}
		return DependencyInjector.get(UiUtil.self).controller(named: controllerName, from: storyboard!, as: Type.self)
	}

	final func post(_ name: Notification.Name, object: Any? = self, userInfo: [UserInfoKey: Any]? = nil) {
		DependencyInjector.get(UiUtil.self).post(name: name, object: object, userInfo: userInfo)
	}

	final func post(_ name: NotificationName, object: Any? = self, userInfo: [UserInfoKey: Any]? = nil) {
		post(name.toName(), object: object, userInfo: userInfo)
	}

	final func syncPost(_ name: NotificationName, object: Any? = self, userInfo: [UserInfoKey: Any]? = nil) {
		DependencyInjector.get(NotificationUtil.self).post(name, object: object, userInfo: userInfo, qos: nil)
	}

	final func syncPost(_ name: Notification.Name, object: Any? = self, userInfo: [UserInfoKey: Any]? = nil) {
		DependencyInjector.get(NotificationUtil.self).post(name, object: object, userInfo: userInfo, qos: nil)
	}

	final func present(
		_ viewController: UIViewController,
		using presenter: Presentr,
		animated: Bool = false,
		completion: (() -> Void)? = nil
	) {
		DependencyInjector.get(UiUtil.self)
			.present(viewController, on: self, using: presenter, animated: animated, completion: completion)
	}

	final func presentView(
		_ viewController: UIViewController,
		animated: Bool = false,
		completion: (() -> Void)? = nil
	) {
		DependencyInjector.get(UiUtil.self).present(self, viewController, animated: animated, completion: completion)
	}

	final func pushToNavigationController(_ controller: UIViewController, animated: Bool = false) {
		DependencyInjector.get(UiUtil.self)
			.push(controller: controller, toNavigationController: navigationController, animated: animated)
	}

	final func popFromNavigationController(animated: Bool = false) {
		DependencyInjector.get(UiUtil.self).popFrom(navigationController, animated: animated)
	}

	final func defaultSkipInstructionsView() -> CoachMarkSkipView {
		let skipView = CoachMarkSkipDefaultView()
		skipView.setTitle("Skip instructions", for: .normal)
		skipView.frame = CGRect(x: 0.0, y: 0.0, width: skipView.frame.width, height: skipView.frame.height)
		return skipView
	}

	final func defaultCoachMarkSkipViewConstraints() -> [CoachMarkSkipViewConstraint] {
		[
			HorizontallyCenteredCoachMarkSkipViewConstraint(),
			GenericCoachMarkSkipViewConstraint(
				skipViewAttribute: .bottom,
				relatedBy: .equal,
				parentViewAttribute: .bottomMargin
			),
		]
	}

	final func sendUserNotification(
		withContent content: UNMutableNotificationContent,
		id: String,
		repeats: Bool = false,
		interval: TimeInterval = 1
	) {
		DependencyInjector.get(UiUtil.self)
			.sendUserNotification(withContent: content, id: id, repeats: repeats, interval: interval)
	}

	final func barButton(title: String, action: Selector) -> UIBarButtonItem {
		UIBarButtonItem(title: title, style: .plain, target: self, action: action)
	}

	final func barButton(title: String, quickPress: Selector, longPress: Selector) -> UIBarButtonItem {
		let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: longPress)
		let button = UIButton(type: .custom)
		button.setTitle(title, for: .normal)
		// same color as normal button text
		button.setTitleColor(UIColor(red: 47 / 255, green: 124 / 255, blue: 246 / 255, alpha: 1), for: .normal)
		button.addTarget(self, action: quickPress, for: .touchUpInside)
		button.addGestureRecognizer(longPressRecognizer)
		return UIBarButtonItem(customView: button)
	}
}
