//
//  AttributeValueTypeViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class AttributeValueTypeViewController: UIViewController {

	public final var notificationToSendOnValueInvalid: Notification.Name!
	public final var notificationToSendOnValueValid: Notification.Name!

	public final var currentValue: Any!

	final func valueIsInvalid() {
		NotificationCenter.default.post(name: notificationToSendOnValueInvalid, object: nil, userInfo: nil)
	}

	final func valueIsValid() {
		NotificationCenter.default.post(name: notificationToSendOnValueValid, object: nil, userInfo: nil)
	}
}