//
//  AttributeViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class AttributeViewController: UIViewController, UIPopoverPresentationControllerDelegate {

	public final var attribute: Attribute!
	public final var attributeValue: Any!

	@IBOutlet weak final var attributeDescriptionButton: UIButton!
	@IBOutlet weak final var attributeNameLabel: UILabel!
	@IBOutlet weak final var attributeValueButton: UIButton!
	@IBOutlet weak final var booleanValueSwitch: UISwitch!

	final override func viewDidLoad() {
		super.viewDidLoad()

		attributeNameLabel.text = attribute.name + ":"

		if attribute.extendedDescription == nil {
			attributeDescriptionButton.isHidden = true
			attributeDescriptionButton.isEnabled = false
			attributeDescriptionButton.isUserInteractionEnabled = false
		}

		updateDisplay()
	}

	final func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.none
	}

	public final override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		segue.destination.modalPresentationStyle = UIModalPresentationStyle.popover
		segue.destination.popoverPresentationController!.delegate = self

		if segue.destination is AttributeDescriptionViewController {
			let controller = segue.destination as! AttributeDescriptionViewController
			controller.descriptionText = attribute.extendedDescription
		} else if segue.destination is AttributeValueViewController {
			let controller = segue.destination as! AttributeValueViewController
			controller.attribute = attribute
			controller.attributeValue = attributeValue
		}
	}

	@IBAction final func booleanValueChanged(_ sender: Any) {
		attributeValue = booleanValueSwitch.isOn
	}

	@IBAction final func saveAttributeValue(_ segue: UIStoryboardSegue) {
		let controller = (segue.source as! AttributeValueViewController)
		attributeValue = controller.attributeValue!
		updateDisplay()
	}

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
