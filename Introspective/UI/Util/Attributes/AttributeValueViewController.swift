//
//  AttributeValueViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

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
		} else {
			os_log("Unknown attribute type: ", type: .error, String(describing: type(of: attribute)))
		}

		if subViewController != nil {
			subViewController.notificationToSendOnValueInvalid = Me.valueIsInvalidNotification
			subViewController.notificationToSendOnValueValid = Me.valueIsValidNotification
			let containerView = ContainerView<AttributeValueTypeViewController>(parentController: self)
			containerView.install(subViewController)
			stackView.addArrangedSubview(containerView)

			NotificationCenter.default.addObserver(self, selector: #selector(disableSaveButton), name: Me.valueIsInvalidNotification, object: nil)
			NotificationCenter.default.addObserver(self, selector: #selector(enableSaveButton), name: Me.valueIsValidNotification, object: nil)
		}
	}

	@IBAction final func saveButtonPressed(_ sender: Any) {
		NotificationCenter.default.post(name: notificationToSendOnAccept, object: subViewController.currentValue)
		dismiss(animated: true, completion: nil)
	}

	@objc private final func disableSaveButton() {
		acceptButton.isEnabled = false
		acceptButton.isUserInteractionEnabled = false
		acceptButton.backgroundColor = UIColor.gray
	}

	@objc private final func enableSaveButton() {
		acceptButton.isEnabled = true
		acceptButton.isUserInteractionEnabled = true
		acceptButton.backgroundColor = UIColor.black
	}
}
