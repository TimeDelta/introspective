//
//  AttributeViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr

final class AttributeViewController: UIViewController {

	// MARK: - Static Variables

	private typealias Me = AttributeViewController
	private static let horizontalMultiSelectPresenter = UiUtil.customPresenter(height: .custom(size: 100))
	private static let numericPresenter = UiUtil.customPresenter(height: .custom(size: 100))
	private static let dosagePresenter = UiUtil.customPresenter(height: .custom(size: 100))
	private static let frequencyPresenter = UiUtil.customPresenter(width: .custom(size: 250), height: .custom(size: 250))

	// MARK: - IBOutlets

	@IBOutlet weak final var attributeDescriptionButton: UIButton!
	@IBOutlet weak final var attributeNameLabel: UILabel!
	@IBOutlet weak final var attributeValueButton: UIButton!
	@IBOutlet weak final var booleanValueSwitch: UISwitch!

	// MARK: - Instance Variables

	public final var attribute: Attribute! {
		didSet {
			valueChangedNotification = Notification.Name("attributeValueChanged_" + attribute.name)
			NotificationCenter.default.addObserver(self, selector: #selector(valueChanged), name: valueChangedNotification, object: nil)
		}
	}
	public final var attributeValue: Any!
	private var valueChangedNotification: Notification.Name!

	// MARK: - UIViewController Overrides

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

	deinit {
		NotificationCenter.default.removeObserver(self)
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
		if attribute is MultiSelectAttribute {
			let controller = storyboard!.instantiateViewController(withIdentifier: "horizontalMultiSelectAttribute") as! HorizontalMultiSelectAttributeValueViewController
			controller.multiSelectAttribute = (attribute as! MultiSelectAttribute)
			controller.currentValue = attributeValue
			controller.notificationToSendOnAccept = valueChangedNotification
			customPresentViewController(Me.horizontalMultiSelectPresenter, viewController: controller, animated: true)
		} else if attribute is NumericAttribute {
			let controller = storyboard!.instantiateViewController(withIdentifier: "numericAttribute") as! NumericAttributeValueViewController
			controller.numericAttribute = (attribute as! NumericAttribute)
			controller.currentValue = attributeValue
			controller.notificationToSendOnAccept = valueChangedNotification
			customPresentViewController(Me.numericPresenter, viewController: controller, animated: true)
		} else if attribute is DosageAttribute {
			let controller = storyboard!.instantiateViewController(withIdentifier: "setDosage") as! SetMedicationDosageViewController
			controller.initialDosage = attributeValue as? Dosage
			controller.notificationToSendOnAccept = valueChangedNotification
			customPresentViewController(Me.dosagePresenter, viewController: controller, animated: true)
		} else if attribute is FrequencyAttribute {
			let controller = UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "chooseFrequency") as! FrequencyEditorViewController
			controller.initialFrequency = attributeValue as? Frequency
			controller.notificationToSendOnAccept = valueChangedNotification
			customPresentViewController(Me.frequencyPresenter, viewController: controller, animated: true)
		} else {
			let controller = storyboard!.instantiateViewController(withIdentifier: "attributeValue") as! AttributeValueViewController
			controller.attribute = attribute
			controller.attributeValue = attributeValue
			controller.notificationToSendOnAccept = valueChangedNotification
			customPresentViewController(UiUtil.defaultPresenter, viewController: controller, animated: true)
		}
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
