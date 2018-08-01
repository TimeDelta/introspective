//
//  AttributeValueTypeViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class AttributeValueTypeViewController: UIViewController {

	public var notificationToSendOnValueInvalid: Notification.Name!
	public var notificationToSendOnValueValid: Notification.Name!

	public var currentValue: Any!

	func valueIsInvalid() {
		NotificationCenter.default.post(name: notificationToSendOnValueInvalid, object: nil, userInfo: nil)
	}

	func valueIsValid() {
		NotificationCenter.default.post(name: notificationToSendOnValueValid, object: nil, userInfo: nil)
	}
}
