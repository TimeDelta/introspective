//
//  UiUtil.swift
//  Introspective
//
//  Created by Bryan Nova on 9/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import UserNotifications

//sourcery: AutoMockable
public protocol UiUtil {

	var defaultPresenter: Presentr { get }
	var hasTopNotch: Bool { get }

	func customPresenter(width: ModalSize, height: ModalSize, center: ModalCenterPosition) -> Presentr
	func setView(_ view: UIView, enabled: Bool?, hidden: Bool?)
	func setButton(_ button: UIButton, enabled: Bool?, hidden: Bool?)
	@discardableResult
	func setBackButton(for viewController: UIViewController, title: String, action selector: Selector) -> UIBarButtonItem
	func addSaveButtonToKeyboardFor(_ textView: UITextView, target: Any?, action: Selector?)
	func addSaveButtonToKeyboardFor(_ textField: UITextField, target: Any?, action: Selector?)
	/// Retrieve the value for the specified `UserInfoKey` from the given notification.
	/// - Parameter keyIsOptional: If true, no error will be logged if the specified key does not exist in the user info.
	/// - Note: Automatically logs when key is missing, wrong type or the notification does not have any user info.
	func value<Type>(for key: UserInfoKey, from notification: Notification, keyIsOptional: Bool) -> Type?
	/// This is just a pass-through method that will return the input. It is solely for syntactic
	/// sugar so that you don't have to type out "UserInfoKey." everywhere.
	func info(_ info: [UserInfoKey: Any]) -> [AnyHashable: Any]

	func controller<Type: UIViewController>(named controllerName: String, from storyboardName: String, as: Type.Type) -> Type
	func controller<Type: UIViewController>(named controllerName: String, from storyboard: UIStoryboard, as: Type.Type) -> Type
	func tableViewCell<Type: UITableViewCell>(
		from tableView: UITableView,
		withIdentifier identifier: String,
		for indexPath: IndexPath,
		as: Type.Type)
	-> Type
	func documentPicker(docTypes: [String], in pickerMode: UIDocumentPickerMode) -> UIDocumentPickerViewController
	func alert(title: String?, message: String?, preferredStyle: UIAlertController.Style) -> UIAlertController
	func tableViewRowAction(
		style: UITableViewRowAction.Style,
		title: String?,
		handler: @escaping (UITableViewRowAction, IndexPath) -> Void)
	-> UITableViewRowAction
	func alertAction(
		title: String?,
		style: UIAlertAction.Style,
		handler: ((UIAlertAction) -> Void)?)
	-> UIAlertAction
	func contextualAction(
		style: UIContextualAction.Style,
		title: String?,
		handler: @escaping UIContextualAction.Handler)
	-> UIContextualAction

	/// - Note: This is just for testability
	func stopObserving(_ observer: Any, name: NotificationName?, object: Any?)
	/// - Note: This is just for testability
	func post(name: Notification.Name, object: Any?, userInfo: [AnyHashable: Any]?)
	/// - Note: This is just for testability
	func post(name: NotificationName, object: Any?, userInfo: [AnyHashable: Any]?)

	/// Present `controllerBeingPresented` from `presentingController` then run `completion` if provided.
	/// - Note: This is just for testability
	func present(
		_ presentingController: UIViewController,
		_ controllerBeingPresented: UIViewController,
		animated: Bool,
		completion: (() -> Void)?)
	/// Present `viewController` from `presentingController` using `presenter`.
	/// - Note: This is just for testability
	func present(
		_ viewController: UIViewController,
		on presentingController: UIViewController,
		using presenter: Presentr,
		animated: Bool,
		completion: (() -> Void)?)

	/// - Note: This is just for testability
	func push(controller: UIViewController, toNavigationController navigationController: UINavigationController?, animated: Bool)
	/// - Note: This is just for testability
	func popFrom(_ navigationController: UINavigationController?, animated: Bool)

	func sendUserNotification(
		withContent content: UNMutableNotificationContent,
		id: String,
		repeats: Bool,
		interval: TimeInterval)
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

	/// This is mainly for testability
	func stopObserving(_ observer: Any, name: NotificationName? = nil, object: Any? = nil) {
		stopObserving(observer, name: name, object: object)
	}

	func present(
		_ presentingController: UIViewController,
		_ controllerBeingPresented: UIViewController,
		animated: Bool = false,
		completion: (() -> Void)? = nil)
	{
		present(presentingController, controllerBeingPresented, animated: animated, completion: completion)
	}

	func sendUserNotification(
		withContent content: UNMutableNotificationContent,
		id: String,
		repeats: Bool = false,
		interval: TimeInterval = 1)
	{
		sendUserNotification(withContent: content, id: id, repeats: repeats, interval: interval)
	}
}

public final class UiUtilImpl: UiUtil {

	private final let log = Log()

	public final let defaultPresenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 200), center: .center)
		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		customPresenter.backgroundTap = .noAction
		return customPresenter
	}()

	public final var hasTopNotch: Bool {
		if #available(iOS 11.0,  *) {
			return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
		}
		return false
	}

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

	@discardableResult
	public func setBackButton(for viewController: UIViewController, title: String, action selector: Selector) -> UIBarButtonItem {
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

		return backButton
	}

	public func addSaveButtonToKeyboardFor(_ textView: UITextView, target: Any?, action: Selector?) {
		textView.inputAccessoryView = getKeyboardToolbarWithSaveButton(target: target, action: action)
	}

	public func addSaveButtonToKeyboardFor(_ textField: UITextField, target: Any?, action: Selector?) {
		textField.inputAccessoryView = getKeyboardToolbarWithSaveButton(target: target, action: action)
	}

	/// Retrieve the value for the specified `UserInfoKey` from the given notification.
	/// - Parameter keyIsOptional: If true, no error will be logged if the specified key does not exist in the user info.
	/// - Note: Automatically logs when key is missing, wrong type or the notification does not have any user info.
	public func value<Type>(for key: UserInfoKey, from notification: Notification, keyIsOptional: Bool = false) -> Type? {
		if let userInfo = notification.userInfo {
			guard userInfo.keys.contains(key) else {
				if !keyIsOptional {
					log.error("Missing user info key for '%@' notification: %@", notification.name.rawValue, key.description)
				}
				return nil
			}
			let value = userInfo[key]
			if value is Type || value is Optional<Type> {
				return value as? Type
			}
			log.error("Wrong object type for '%@' notification: %@", notification.name.rawValue, key.description)
			return nil
		}
		log.error("No user info for '%@' notification", notification.name.rawValue)
		return nil
	}

	/// This is just a pass-through method that will return the input. It is solely for syntactic
	/// sugar so that you don't have to type out "UserInfoKey." everywhere.
	public func info(_ info: [UserInfoKey: Any]) -> [AnyHashable: Any] {
		return info
	}

	public func controller<Type: UIViewController>(named controllerName: String, from storyboardName: String, as: Type.Type) -> Type {
		return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: controllerName) as! Type
	}

	public func controller<Type: UIViewController>(named controllerName: String, from storyboard: UIStoryboard, as: Type.Type) -> Type {
		return storyboard.instantiateViewController(withIdentifier: controllerName) as! Type
	}

	public func tableViewCell<Type: UITableViewCell>(
		from tableView: UITableView,
		withIdentifier identifier: String,
		for indexPath: IndexPath,
		as: Type.Type)
	-> Type {
		return tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Type
	}

	public func documentPicker(docTypes: [String], in pickerMode: UIDocumentPickerMode) -> UIDocumentPickerViewController {
		return UIDocumentPickerViewController(documentTypes: docTypes, in: pickerMode)
	}

	public func alert(title: String?, message: String?, preferredStyle: UIAlertController.Style) -> UIAlertController {
		return UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
	}

	public func tableViewRowAction(
		style: UITableViewRowAction.Style,
		title: String?,
		handler: @escaping (UITableViewRowAction, IndexPath) -> Void)
	-> UITableViewRowAction {
		return UITableViewRowAction(style: style, title: title, handler: handler)
	}

	public func alertAction(
		title: String?,
		style: UIAlertAction.Style,
		handler: ((UIAlertAction) -> Void)?)
	-> UIAlertAction {
		return UIAlertAction(title: title, style: style, handler: handler)
	}

	public func contextualAction(
		style: UIContextualAction.Style,
		title: String?,
		handler: @escaping UIContextualAction.Handler)
	-> UIContextualAction {
		return UIContextualAction(style: style, title: title, handler: handler)
	}

	public func stopObserving(_ observer: Any, name: NotificationName?, object: Any?) {
		NotificationCenter.default.removeObserver(observer, name: name?.toName(), object: object)
	}

	public func post(name: NotificationName, object: Any?, userInfo: [AnyHashable: Any]?) {
		post(name: name.toName(), object: object, userInfo: userInfo)
	}

	public func post(name: Notification.Name, object: Any?, userInfo: [AnyHashable: Any]?) {
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
		}
	}

	public func present(
		_ presentingController: UIViewController,
		_ controllerBeingPresented: UIViewController,
		animated: Bool,
		completion: (() -> Void)?)
	{
		presentingController.present(controllerBeingPresented, animated: animated, completion: completion)
	}

	public func present(
		_ viewController: UIViewController,
		on presentingController: UIViewController,
		using presenter: Presentr,
		animated: Bool,
		completion: (() -> Void)?)
	{
		presentingController.customPresentViewController(presenter, viewController: viewController, animated: animated, completion: completion)
	}

	public func push(
		controller: UIViewController,
		toNavigationController navigationController: UINavigationController?,
		animated: Bool)
	{
		navigationController?.pushViewController(controller, animated: animated)
	}

	public func popFrom(_ navigationController: UINavigationController?, animated: Bool) {
		navigationController?.popViewController(animated: animated)
	}

	public func sendUserNotification(
		withContent content: UNMutableNotificationContent,
		id: String,
		repeats: Bool,
		interval: TimeInterval)
	{
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: repeats)
		let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
		Log().debug("Sending user notification: %@", content.title)
		UNUserNotificationCenter.current().add(request) { (error : Error?) in
			if let error = error {
				Log().error("Failed to send user notification (%@): %@", content.title, errorInfo(error))
			}
		}
	}

	// MARK: - Helper Functions

	private final func getKeyboardToolbarWithSaveButton(target: Any?, action: Selector?) -> UIToolbar {
		let keyboardToolbar = UIToolbar()
		keyboardToolbar.sizeToFit()

		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let doneButton = UIBarButtonItem(barButtonSystemItem: .save, target: target, action: action)
		keyboardToolbar.setItems([flexibleSpace, doneButton, flexibleSpace], animated: false)

		return keyboardToolbar
	}
}
