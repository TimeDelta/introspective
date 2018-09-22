//
//  AttributeViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr

final class AttributeViewController: UIViewController {

	// MARK: - Static Member Variables

	private typealias Me = AttributeViewController
	private static let valueChanged = Notification.Name("attributeValueChanged")

	// MARK: - IBOutlets

	@IBOutlet weak final var attributeDescriptionButton: UIButton!
	@IBOutlet weak final var attributeNameLabel: UILabel!
	@IBOutlet weak final var attributeValueButton: UIButton!
	@IBOutlet weak final var booleanValueSwitch: UISwitch!

	// MARK: - Instance Member Variables

	public final var attribute: Attribute!
	public final var attributeValue: Any!

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()

		attributeNameLabel.text = attribute.name + ":"

		if attribute.extendedDescription == nil {
			attributeDescriptionButton.isHidden = true
			attributeDescriptionButton.isEnabled = false
			attributeDescriptionButton.isUserInteractionEnabled = false
		}

		NotificationCenter.default.addObserver(self, selector: #selector(valueChanged), name: Me.valueChanged, object: nil)

		updateDisplay()
	}

	public final override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is AttributeDescriptionViewController {
			let controller = segue.destination as! AttributeDescriptionViewController
			controller.descriptionText = attribute.extendedDescription
		} else if segue.destination is AttributeValueViewController {
			let controller = segue.destination as! AttributeValueViewController
			controller.attribute = attribute
			controller.attributeValue = attributeValue
		}
	}

	// MARK: - Button Actions

	@IBAction final func descriptionButtonPressed(_ sender: Any) {
		let controller = storyboard!.instantiateViewController(withIdentifier: "attributeDescription") as! AttributeDescriptionViewController
		controller.descriptionText = attribute.extendedDescription
		customPresentViewController(UiUtil.defaultPresenter, viewController: controller, animated: true)
	}

	@IBAction final func valueButtonPressed(_ sender: Any) {
		let controller = storyboard!.instantiateViewController(withIdentifier: "attributeValue") as! AttributeValueViewController
		controller.attribute = attribute
		controller.attributeValue = attributeValue
		customPresentViewController(UiUtil.defaultPresenter, viewController: controller, animated: true)
	}

	@IBAction final func booleanValueChanged(_ sender: Any) {
		attributeValue = booleanValueSwitch.isOn
	}

	// MARK: - Received Notifications

	@objc private final func valueChanged(notification: Notification) {
		attributeValue = notification.object
		updateDisplay()
	}

	// MARK: - Helper Functions

	private final func updateDisplay() {
		if attribute is BooleanAttribute {
			if attributeValue == nil {
				attributeValue = true
			}
			booleanValueSwitch.isOn = attributeValue as! Bool
			attributeValueButton.isEnabled = false
			attributeValueButton.isUserInteractionEnabled = false
			attributeValueButton.isHidden = true
		} else {
			booleanValueSwitch.isEnabled = false
			booleanValueSwitch.isUserInteractionEnabled = false
			booleanValueSwitch.isHidden = true
			if attributeValue == nil {
				attributeValueButton.setTitle("Set value", for: .normal)
			} else {
				var attributeValueDescription = try! attribute.convertToDisplayableString(from: attributeValue)
				if attributeValueDescription.isEmpty {
					attributeValueDescription = "Set value"
				}
				attributeValueButton.setTitle(attributeValueDescription, for: .normal)
			}
		}
	}
}
