//
//  AttributeValueViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class AttributeValueViewController: UIViewController {

	fileprivate typealias Me = AttributeValueViewController
	fileprivate static let valueIsInvalidNotification = Notification.Name("invalidValue")
	fileprivate static let valueIsValidNotification = Notification.Name("validValue")

	public var attribute: Attribute!
	public var attributeValue: Any!

	@IBOutlet weak var stackView: UIStackView!
	@IBOutlet weak var acceptButton: UIButton!

	fileprivate var subViewController: AttributeValueTypeViewController!

    override func viewDidLoad() {
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
			let controller = UIStoryboard(name: "AttributeList", bundle: nil).instantiateViewController(withIdentifier: "dateAttribute") as! DateAttributeValueViewController
			controller.dateAttribute = (attribute as! DateAttribute)
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

	@IBAction func accepted(_ sender: Any) {
		attributeValue = subViewController.currentValue
	}

	@objc fileprivate func disableAcceptButton() {
		acceptButton.isEnabled = false
		acceptButton.isUserInteractionEnabled = false
		acceptButton.backgroundColor = UIColor.gray
	}

	@objc fileprivate func enableAcceptButton() {
		acceptButton.isEnabled = true
		acceptButton.isUserInteractionEnabled = true
		acceptButton.backgroundColor = UIColor.black
	}
}
