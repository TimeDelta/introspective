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
	private static let horizontalMultiSelectPresenter = DependencyInjector.util.ui.customPresenter(height: .custom(size: 100), center: .topCenter)
	private static let numericPresenter = DependencyInjector.util.ui.customPresenter(width: .full, height: .custom(size: 100), center: .topCenter)
	private static let dosagePresenter = DependencyInjector.util.ui.customPresenter(height: .custom(size: 100), center: .topCenter)
	private static let frequencyPresenter = DependencyInjector.util.ui.customPresenter(width: .custom(size: 250), height: .custom(size: 250), center: .topCenter)
	private static let multiSelectPresenter = DependencyInjector.util.ui.customPresenter(width: .full, height: .fluid(percentage: 0.45), center: .topCenter)
	private static let defaultPresenter = DependencyInjector.util.ui.customPresenter(width: .full, height: .custom(size: 200), center: .topCenter)

	// MARK: - IBOutlets

	@IBOutlet weak final var attributeDescriptionButton: UIButton!
	@IBOutlet weak final var attributeNameLabel: UILabel!
	@IBOutlet weak final var attributeValueButton: UIButton!
	@IBOutlet weak final var booleanValueSwitch: UISwitch!

	// MARK: - Instance Variables

	public final var attribute: Attribute!
	public final var attributeValue: Any!
	public final var notificationToSendOnValueChange: Notification.Name! {
		didSet {
			observe(selector: #selector(valueChanged), name: notificationToSendOnValueChange)
		}
	}

	private final let log = Log()

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()

		view.translatesAutoresizingMaskIntoConstraints = false

		setUpAttributeValueButtonConstraints()

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
		let controller: AttributeDescriptionViewController = viewController(named: "attributeDescription")
		controller.descriptionText = attribute.extendedDescription
		customPresentViewController(DependencyInjector.util.ui.defaultPresenter, viewController: controller, animated: false)
	}

	@IBAction final func valueButtonPressed(_ sender: Any) {
		if attribute is DaysOfWeekAttribute {
			showDaysOfWeekView()
		} else if attribute is MultiSelectAttribute {
			showMultiSelectView()
		} else if attribute is NumericAttribute {
			showNumericView()
		} else if attribute is DosageAttribute {
			showDosageView()
		} else if attribute is FrequencyAttribute {
			showFrequencyView()
		} else {
			showDefaultValueView()
		}
	}

	@IBAction final func booleanValueChanged(_ sender: Any) {
		attributeValue = booleanValueSwitch.isOn
		post(
			notificationToSendOnValueChange,
			userInfo: [
				.attributeValue: attributeValue,
			])
	}

	// MARK: - Received Notifications

	@objc private final func valueChanged(notification: Notification) {
		attributeValue = value(for: .attributeValue, from: notification)
		updateDisplay()
	}

	// MARK: - Show View Functions

	private final func showDaysOfWeekView() {
		let controller: HorizontalMultiSelectAttributeValueViewController = viewController(named: "horizontalMultiSelectAttribute")
		controller.multiSelectAttribute = (attribute as! MultiSelectAttribute)
		controller.currentValue = attributeValue
		controller.notificationToSendOnAccept = notificationToSendOnValueChange
		customPresentViewController(Me.horizontalMultiSelectPresenter, viewController: controller, animated: false)
	}

	private final func showMultiSelectView() {
		let controller: MultiSelectAttributeValueViewController = viewController(named: "multiSelectAttribute")
		controller.multiSelectAttribute = (attribute as! MultiSelectAttribute)
		controller.initialValue = attributeValue
		controller.notificationToSendOnAccept = notificationToSendOnValueChange
		customPresentViewController(Me.multiSelectPresenter, viewController: controller, animated: false)
	}

	private final func showNumericView() {
		let controller: NumericAttributeValueViewController = viewController(named: "numericAttribute")
		controller.numericAttribute = (attribute as! NumericAttribute)
		controller.currentValue = attributeValue
		controller.notificationToSendOnAccept = notificationToSendOnValueChange
		customPresentViewController(Me.numericPresenter, viewController: controller, animated: false)
	}

	private final func showDosageView() {
		let controller: SetMedicationDosageViewController = viewController(named: "setDosage")
		controller.initialDosage = attributeValue as? Dosage
		controller.notificationToSendOnAccept = notificationToSendOnValueChange
		customPresentViewController(Me.dosagePresenter, viewController: controller, animated: false)
	}

	private final func showFrequencyView() {
		let controller: FrequencyEditorViewController = viewController(named: "chooseFrequency", fromStoryboard: "Util")
		controller.initialFrequency = attributeValue as? Frequency
		controller.notificationToSendOnAccept = notificationToSendOnValueChange
		customPresentViewController(Me.frequencyPresenter, viewController: controller, animated: false)
	}

	private final func showDefaultValueView() {
		let controller: AttributeValueViewController = viewController(named: "attributeValue")
		controller.attribute = attribute
		controller.attributeValue = attributeValue
		controller.notificationToSendOnAccept = notificationToSendOnValueChange
		customPresentViewController(Me.defaultPresenter, viewController: controller, animated: false)
	}

	// MARK: - Helper Functions

	private final func updateDisplay() {
		if attribute is BooleanAttribute {
			if attributeValue == nil {
				attributeValue = true
			}
			booleanValueSwitch.isOn = attributeValue as! Bool
			hideAttributeValueButton()
		} else {
			updateDisplayForNonBooleanAttribute()
		}
	}

	private final func updateDisplayForNonBooleanAttribute() {
		hideSwitch()
		if attributeValue == nil {
			attributeValueButton.setTitle("Set value", for: .normal)
		} else {
			do {
				var attributeValueDescription = try attribute.convertToDisplayableString(from: attributeValue)
				if attributeValueDescription.isEmpty {
					attributeValueDescription = "Set value"
				}
				attributeValueButton.setTitle(attributeValueDescription, for: .normal)
			} catch {
				log.error(
					"Failed to convert %@ as %@ to displayable string: %@",
					String(describing: attributeValue),
					attribute.name,
					errorInfo(error))
			}
		}

		// this allows the value button to dynamiclly set its width based on its content
		let size = attributeValueButton.systemLayoutSizeFitting(
			UIView.layoutFittingCompressedSize,
			withHorizontalFittingPriority: .defaultHigh,
			verticalFittingPriority: .init(1))
		attributeValueButton.frame.size = size

		setAccessibility()
	}

	private final func setAccessibility() {
		attributeValueButton.accessibilityIdentifier = "set " + attribute.name.localizedLowercase + " button"
		do {
			attributeValueButton.accessibilityValue = try attribute.convertToDisplayableString(from: attributeValue)
		} catch {
			log.error(
				"Failed to set accessibility value on %@: %@",
				attributeValueButton.accessibilityIdentifier!,
				errorInfo(error))
		}
	}

	private final func hideSwitch() {
		booleanValueSwitch.isEnabled = false
		booleanValueSwitch.isUserInteractionEnabled = false
		booleanValueSwitch.isHidden = true
	}

	private final func hideAttributeValueButton() {
		attributeValueButton.isEnabled = false
		attributeValueButton.isUserInteractionEnabled = false
		attributeValueButton.isHidden = true
	}

	private final func setUpAttributeValueButtonConstraints() {
		attributeValueButton.translatesAutoresizingMaskIntoConstraints = false
		attributeValueButton.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor).isActive = true
		let heightConstraint = attributeValueButton.heightAnchor.constraint(equalToConstant: CGFloat(30))
		heightConstraint.priority = .required
		heightConstraint.isActive = true
		attributeValueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		attributeValueButton.topAnchor.constraint(equalTo: attributeNameLabel.bottomAnchor).isActive = true
	}
}
