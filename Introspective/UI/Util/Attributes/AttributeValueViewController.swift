//
//  AttributeValueViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class AttributeValueViewController: UIViewController {

	// MARK: - Static Member Variables

	private typealias Me = AttributeValueViewController
	private static let valueIsInvalidNotification = Notification.Name("invalidValue")
	private static let valueIsValidNotification = Notification.Name("validValue")

	// MARK: - IBOutlets

	@IBOutlet weak final var stackView: UIStackView!
	@IBOutlet weak final var acceptButton: UIButton!

	// MARK: - Instance Member Variables

	public final var notificationToSendOnAccept: Notification.Name!
	public final var attribute: Attribute!
	public final var attributeValue: Any!

	private final var subViewController: AttributeValueTypeViewController!

	final override func viewDidLoad() {
		super.viewDidLoad()

		if attribute is SelectOneAttribute {
			let controller = UIStoryboard(name: "AttributeList", bundle: nil).instantiateViewController(withIdentifier: "selectOneAttribute") as! SelectOneAttributeValueViewController
			controller.currentValue = attributeValue
			controller.selectOneAttribute = (attribute as! SelectOneAttribute)
			subViewController = controller
		} else if attribute is MultiSelectAttribute {
			// TODO how to figure out what layout to use
			let controller = UIStoryboard(name: "AttributeList", bundle: nil).instantiateViewController(withIdentifier: "horizontalMultiSelectAttribute") as! HorizontalMultiSelectAttributeValueViewController
			controller.multiSelectAttribute = (attribute as! MultiSelectAttribute)
			controller.currentValue = attributeValue
			subViewController = controller
		} else if attribute is DateAttribute {
			let controller = UIStoryboard(name: "AttributeList", bundle: nil).instantiateViewController(withIdentifier: "dateAttribute") as! DateOrTimeAttributeValueViewController
			controller.dateAttribute = (attribute as! DateAttribute)
			controller.currentValue = attributeValue
			subViewController = controller
		} else if attribute is TimeOfDayAttribute {
			let controller = UIStoryboard(name: "AttributeList", bundle: nil).instantiateViewController(withIdentifier: "dateAttribute") as! DateOrTimeAttributeValueViewController
			controller.timeOfDayAttribute = (attribute as! TimeOfDayAttribute)
			controller.currentValue = attributeValue
			subViewController = controller
		} else if attribute is TextAttribute {
			let controller = UIStoryboard(name: "AttributeList", bundle: nil).instantiateViewController(withIdentifier: "textAttribute") as! TextAttributeValueViewController
			controller.textAttribute = (attribute as! TextAttribute)
			controller.currentValue = attributeValue
			subViewController = controller
		} else if attribute is NumericAttribute {
			let controller = UIStoryboard(name: "AttributeList", bundle: nil).instantiateViewController(withIdentifier: "numericAttribute") as! NumericAttributeValueViewController
			controller.numericAttribute = (attribute as! NumericAttribute)
			controller.currentValue = attributeValue
			subViewController = controller
		}

		if subViewController != nil {
			subViewController.notificationToSendOnValueInvalid = Me.valueIsInvalidNotification
			subViewController.notificationToSendOnValueValid = Me.valueIsValidNotification
			let containerView = ContainerView<AttributeValueTypeViewController>(parentController: self)
			containerView.install(subViewController)
			stackView.addArrangedSubview(containerView)

			NotificationCenter.default.addObserver(self, selector: #selector(disableAcceptButton), name: Me.valueIsInvalidNotification, object: nil)
			NotificationCenter.default.addObserver(self, selector: #selector(enableAcceptButton), name: Me.valueIsValidNotification, object: nil)
		}
	}

	@IBAction final func accepted(_ sender: Any) {
		NotificationCenter.default.post(name: notificationToSendOnAccept, object: subViewController.currentValue)
		dismiss(animated: true, completion: nil)
	}

	@objc private final func disableAcceptButton() {
		acceptButton.isEnabled = false
		acceptButton.isUserInteractionEnabled = false
		acceptButton.backgroundColor = UIColor.gray
	}

	@objc private final func enableAcceptButton() {
		acceptButton.isEnabled = true
		acceptButton.isUserInteractionEnabled = true
		acceptButton.backgroundColor = UIColor.black
	}
}
