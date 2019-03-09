//
//  UIViewControllerExtensions.swift
//  Introspective
//
//  Created by Bryan Nova on 11/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import Instructions

extension UIViewController {

	final func observe(selector: Selector, name: Notification.Name, object: Any? = nil) {
		NotificationCenter.default.addObserver(self, selector: selector, name: name, object: object)
	}

	@objc public func showError(
		title: String,
		message: String? = "Sorry for the inconvenience.",
		error: Error? = nil,
		tryAgain: (() -> Void)? = nil,
		onDismiss: ((UIAlertAction) -> Void)? = nil,
		onDonePresenting: (() -> Void)? = nil)
	{
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
			alert.addAction(UIAlertAction(title: "Try Again", style: .default){ _ in
				tryAgain()
			})
		}
		present(alert, animated: false, completion: onDonePresenting)
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

	/// - Parameter storyboardName: If not provided, will attempt to pull the controller from same storyboard as this controller.
	final func viewController<Type: UIViewController>(named controllerName: String, fromStoryboard storyboardName: String? = nil) -> Type {
		if let storyboardName = storyboardName {
			return DependencyInjector.util.ui.controller(named: controllerName, from: storyboardName, as: Type.self)
		}
		return storyboard!.instantiateViewController(withIdentifier: controllerName) as! Type
	}

	final func post(_ name: Notification.Name, object: Any? = self, userInfo: [AnyHashable: Any]? = nil) {
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
		}
	}

	final func present(_ viewController: UIViewController, using presenter: Presentr, animated: Bool = false) {
		customPresentViewController(presenter, viewController: viewController, animated: animated)
	}

	final func defaultSkipInstructionsView() -> CoachMarkSkipView {
		let skipView = CoachMarkSkipDefaultView()
		skipView.setTitle("Skip instructions", for: .normal)
		skipView.frame = CGRect(x: 0.0, y: 0.0, width: skipView.frame.width, height: skipView.frame.height)
		return skipView
	}

	final func defaultCoachMarkSkipViewConstraints() -> [CoachMarkSkipViewConstraint] {
		return [
			HorizontallyCenteredCoachMarkSkipViewConstraint(),
			GenericCoachMarkSkipViewConstraint(
				skipViewAttribute: .bottom,
				relatedBy: .equal,
				parentViewAttribute: .bottomMargin),
		]
	}
}
