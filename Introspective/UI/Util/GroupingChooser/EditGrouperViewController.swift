//
//  EditGrouperViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 5/8/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import SampleGroupers

public protocol EditGrouperViewController: UIViewController {
	var currentGrouper: SampleGrouper! { get set }
	var availableGroupers: [SampleGrouper]! { get set }
	var notificationToSendWhenAccepted: NotificationName! { get set }
}

/// Note: doesn't render properly unless wrapping the AtrtributedChooserViewController in this class
public final class EditGrouperViewControllerImpl: UIViewController, EditGrouperViewController {
	public final var currentGrouper: SampleGrouper!
	public final var availableGroupers: [SampleGrouper]!
	public final var notificationToSendWhenAccepted: NotificationName!

	/// Note: Keep this as a member variable because having it as a local variable causes weird behavior
	private final var controller: AttributedChooserViewController!

	public final override func viewDidLoad() {
		super.viewDidLoad()

		let notificationToObserve = Notification.Name(notificationToSendWhenAccepted.toName().rawValue + "_relay")
		observe(selector: #selector(relayNotification), name: notificationToObserve)

		controller = viewController(
			named: "attributedChooserViewController",
			fromStoryboard: "AttributeList"
		)
		controller.currentValue = currentGrouper
		controller.possibleValues = availableGroupers
		controller.notificationToSendWhenAccepted = notificationToObserve
		controller.pickerAccessibilityIdentifier = "grouper picker"
		controller.saveButtonAccessibilityIdentifier = "save grouper button"

		view.addSubview(controller.view)
		controller.didMove(toParent: self)
		NSLayoutConstraint.activate([
			controller.view.topAnchor.constraint(equalTo: view.topAnchor),
			controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			controller.view.leftAnchor.constraint(equalTo: view.leftAnchor),
			controller.view.rightAnchor.constraint(equalTo: view.rightAnchor),
		])
	}

	/// Send the notification with the user info key that would be expected
	@objc private final func relayNotification(notification: Notification) {
		if let grouper: SampleGrouper? = value(for: .attributed, from: notification) {
			syncPost(notificationToSendWhenAccepted, userInfo: [.sampleGrouper: grouper!])
			popFromNavigationController()
		}
	}
}
