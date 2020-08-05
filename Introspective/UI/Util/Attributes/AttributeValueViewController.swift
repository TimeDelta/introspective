//
//  AttributeValueViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Attributes
import Common
import UIExtensions

final class AttributeValueViewController: UIViewController {
	// MARK: - Static Variables

	private typealias Me = AttributeValueViewController

	private static let valueIsInvalidNotification = Notification.Name("invalidValue")
	private static let valueIsValidNotification = Notification.Name("validValue")

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var stackView: UIStackView!
	@IBOutlet final var acceptButton: UIButton!

	// MARK: - Instance Variables

	public final var notificationToSendOnAccept: Notification.Name!
	public final var attribute: Attribute!
	public final var attributeValue: Any!

	private final var subViewController: AttributeValueTypeViewController!

	// MARK: UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()

		if attribute is SelectOneAttribute {
			let controller = viewController(named: "selectOneAttribute") as! SelectOneAttributeValueViewController
			controller.currentValue = attributeValue
			controller.selectOneAttribute = (attribute as! SelectOneAttribute)
			subViewController = controller
		} else if attribute is DateAttribute {
			let controller = viewController(named: "dateAttribute") as! DateOrTimeAttributeValueViewController
			controller.dateAttribute = (attribute as! DateAttribute)
			controller.currentValue = attributeValue
			subViewController = controller
		} else if attribute is TimeOfDayAttribute {
			let controller = viewController(named: "dateAttribute") as! DateOrTimeAttributeValueViewController
			controller.timeOfDayAttribute = (attribute as! TimeOfDayAttribute)
			controller.currentValue = attributeValue
			subViewController = controller
		} else if attribute is TextAttribute {
			let controller = viewController(named: "textAttribute") as! TextAttributeValueViewController
			controller.textAttribute = (attribute as! TextAttribute)
			controller.currentValue = attributeValue
			subViewController = controller
		} else if attribute is DurationAttribute {
			let controller = viewController(named: "durationAttribute") as! DurationAttributeValueViewController
			controller.currentValue = attributeValue
			subViewController = controller
		} else {
			Me.log.error("Unknown attribute type: %@", String(describing: type(of: attribute)))
		}

		if subViewController != nil {
			subViewController.notificationToSendOnValueInvalid = Me.valueIsInvalidNotification
			subViewController.notificationToSendOnValueValid = Me.valueIsValidNotification
			let containerView = ContainerView<AttributeValueTypeViewController>(parentController: self)
			containerView.install(subViewController)
			stackView.addArrangedSubview(containerView)

			observe(selector: #selector(disableSaveButton), name: Me.valueIsInvalidNotification)
			observe(selector: #selector(enableSaveButton), name: Me.valueIsValidNotification)
		}
	}

	// MARK: - Actions

	@IBAction final func saveButtonPressed(_: Any) {
		NotificationCenter.default.post(
			name: notificationToSendOnAccept,
			object: self,
			userInfo: info([
				.attributeValue: subViewController.currentValue,
			])
		)
		dismiss(animated: false, completion: nil)
	}

	// MARK: - Received Notifications

	@objc private final func disableSaveButton() {
		acceptButton.isEnabled = false
		acceptButton.isUserInteractionEnabled = false
		if #available(iOS 13.0, *) {
			acceptButton.backgroundColor = .systemGray
		} else {
			acceptButton.backgroundColor = .gray
		}
	}

	@objc private final func enableSaveButton() {
		acceptButton.isEnabled = true
		acceptButton.isUserInteractionEnabled = true
		if #available(iOS 13.0, *) {
			acceptButton.backgroundColor = .label
		} else {
			acceptButton.backgroundColor = .black
		}
	}
}
