//
//  NotificationUtil.swift
//  Introspective
//
//  Created by Bryan Nova on 3/20/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol NotificationUtil {

	/// Creates a notification with a given name and sender and posts it to the notification center.
	/// - Parameter name: The name of the notification.
	/// - Parameter object: The object posting the notification.
	/// - Parameter userInfo: Optional information about the the notification.
	/// - Parameter qos: The type of background thread to use to post the notification.
	///                  If specified, post will happen asynchronously.
	///                  Otherwise post will happen synchronously.
	func post(_ name: NotificationName, object: Any?, userInfo: [UserInfoKey: Any]?, qos: DispatchQoS.QoSClass?)
}

extension NotificationUtil {

	/// Creates a notification with a given name and sender and posts it to the notification center.
	/// - Parameter name: The name of the notification.
	/// - Parameter object: The object posting the notification.
	/// - Parameter userInfo: Optional information about the the notification.
	/// - Parameter qos: The type of background thread to use to post the notification.
	///                  If specified, post will happen asynchronously.
	///                  Otherwise post will happen synchronously.
	func post(_ name: NotificationName, object: Any?, userInfo: [UserInfoKey: Any]? = nil, qos: DispatchQoS.QoSClass? = nil) {
		post(name, object: object, userInfo: userInfo, qos: qos)
	}
}

public final class NotificationUtilImpl: NotificationUtil {

	public final func post(_ name: NotificationName, object: Any?, userInfo: [UserInfoKey: Any]?, qos: DispatchQoS.QoSClass?) {
		if let qos = qos {
			DispatchQueue.global(qos: qos).async {
				NotificationCenter.default.post(name: name.toName(), object: object, userInfo: userInfo)
			}
		} else {
			NotificationCenter.default.post(name: name.toName(), object: object, userInfo: userInfo)
		}
	}

	// MARK: - Helper Functions

	/// This is just a pass-through method that will return the input. It is solely for syntactic
	/// sugar so that you don't have to type out "UserInfoKey." everywhere.
	private final func info(_ info: [UserInfoKey: Any]?) -> [AnyHashable: Any]? {
		return info
	}
}
