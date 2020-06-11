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

	// MARK: - IBOutlets

	@IBOutlet weak final var stackView: UIStackView!
	@IBOutlet weak final var acceptButton: UIButton!

	// MARK: - Instance Variables

	public final var notificationToSendOnAccept: Notification.Name!
	public final var attribute: Attribute!
	public final var attributeValue: Any!

	private final var subViewController: AttributeValueTypeViewController!

	private final let log = Log()

	// MARK: UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()

		if attribute is SelectOneAttribute {
			let controller = storyboard!.instantiateViewController(withIdentifier: "selectOneAttribute") as! SelectOneAttributeValueViewController
			controller.currentValue = attributeValue
			controller.selectOneAttribute = (attribute as! SelectOneAttribute)
			subViewController = controller
		} else if attribute is DateAttribute {
			let controller = storyboard!.instantiateViewController(withIdentifier: "dateAttribute") as! DateOrTimeAttributeValueViewController
			controller.dateAttribute = (attribute as! DateAttribute)
			controller.currentValue = attributeValue
			subViewController = controller
		} else if attribute is TimeOfDayAttribute {
			let controller = storyboard!.instantiateViewController(withIdentifier: "dateAttribute") as! DateOrTimeAttributeValueViewController
			controller.timeOfDayAttribute = (attribute as! TimeOfDayAttribute)
			controller.currentValue = attributeValue
			subViewController = controller
		} else if attribute is TextAttribute {
			let controller = storyboard!.instantiateViewController(withIdentifier: "textAttribute") as! TextAttributeValueViewController
			controller.textAttribute = (attribute as! TextAttribute)
			controller.currentValue = attributeValue
			subViewController = controller
		} else if attribute is DurationAttribute {
			let controller = storyboard!.instantiateViewController(withIdentifier: "durationAttribute") as! DurationAttributeValueViewController
			controller.currentValue = attributeValue
			subViewController = controller
		} else {
			log.error("Unknown attribute type: %@", String(describing: type(of: attribute)))
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

	@IBAction final func saveButtonPressed(_ sender: Any) {
		NotificationCenter.default.post(
			name: notificationToSendOnAccept,
			object: self,
			userInfo: info([
				.attributeValue: subViewController.currentValue,
			]))
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
