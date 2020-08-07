//
//  AttributeViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Presentr
import UIKit

import Attributes
import Common
import DependencyInjection
import UIExtensions

final class AttributeViewController: UIViewController {
	// MARK: - Static Variables

	private typealias Me = AttributeViewController

	// MARK: Presenters

	private static let numericPresenter = injected(UiUtil.self).customPresenter(
		width: .full,
		height: .custom(size: 100),
		center: .topCenter
	)
	private static let dosagePresenter = injected(UiUtil.self).customPresenter(
		height: .custom(size: 100),
		center: .topCenter
	)
	private static let frequencyPresenter = injected(UiUtil.self).customPresenter(
		width: .custom(size: 250),
		height: .custom(size: 250),
		center: .topCenter
	)
	private static let multiSelectPresenter = injected(UiUtil.self).customPresenter(
		width: .full,
		height: .fluid(percentage: 0.45),
		center: .topCenter
	)
	private static let defaultPresenter = injected(UiUtil.self).customPresenter(
		width: .full,
		height: .custom(size: 200),
		center: .topCenter
	)
	private static let descriptionPresenter = injected(UiUtil.self).customPresenter(
		width: .custom(size: 300),
		height: .custom(size: 200),
		center: .center
	)

	// MARK: Logging

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var attributeDescriptionButton: UIButton!
	@IBOutlet final var attributeNameLabel: UILabel!
	@IBOutlet final var attributeValueButton: UIButton!
	@IBOutlet final var booleanValueSwitch: UISwitch!

	// MARK: - Instance Variables

	public final var attribute: Attribute!
	public final var attributeValue: Any!
	public final var notificationToSendOnValueChange: Notification.Name! {
		didSet {
			observe(selector: #selector(valueChanged), name: notificationToSendOnValueChange)
		}
	}

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

		observe(selector: #selector(errorOccurred), name: .showError)

		updateDisplay()
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	public final override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
		if let controller = segue.destination as? AttributeDescriptionViewController {
			controller.descriptionText = attribute.extendedDescription
		} else if let controller = segue.destination as? AttributeValueViewController {
			controller.attribute = attribute
			controller.attributeValue = attributeValue
		}
	}

	// MARK: - Button Actions

	@IBAction final func descriptionButtonPressed(_: Any) {
		let controller: AttributeDescriptionViewController = viewController(named: "attributeDescription")
		controller.descriptionText = attribute.extendedDescription
		customPresentViewController(Me.descriptionPresenter, viewController: controller, animated: false)
	}

	@IBAction final func valueButtonPressed(_: Any) {
		if attribute is MultiSelectAttribute {
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

	@IBAction final func booleanValueChanged(_: Any) {
		attributeValue = booleanValueSwitch.isOn
		post(
			notificationToSendOnValueChange,
			userInfo: [
				.attributeValue: attributeValue,
			]
		)
	}

	// MARK: - Received Notifications

	@objc private final func valueChanged(notification: Notification) {
		if let newValue: Any? = value(for: .attributeValue, from: notification) {
			attributeValue = newValue!
		}
		updateDisplay()
	}

	@objc private final func errorOccurred(notification: Notification) {
		let message: String? = value(for: .message, from: notification, keyIsOptional: true)
		if let title: String = value(for: .title, from: notification) {
			showError(title: title, message: message)
		}
	}

	// MARK: - Show View Functions

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
				Me.log.error(
					"Failed to convert %@ as %@ to displayable string: %@",
					String(describing: attributeValue),
					attribute.name,
					errorInfo(error)
				)
			}
		}

		// this allows the value button to dynamiclly set its width based on its content
		let size = attributeValueButton.systemLayoutSizeFitting(
			UIView.layoutFittingCompressedSize,
			withHorizontalFittingPriority: .defaultHigh,
			verticalFittingPriority: .init(1)
		)
		attributeValueButton.frame.size = size

		setAccessibility()
	}

	private final func setAccessibility() {
		attributeValueButton.accessibilityIdentifier = "set " + attribute.name.localizedLowercase + " button"
		do {
			attributeValueButton.accessibilityValue = try attribute.convertToDisplayableString(from: attributeValue)
		} catch {
			Me.log.error(
				"Failed to set accessibility value on %@: %@",
				attributeValueButton.accessibilityIdentifier!,
				errorInfo(error)
			)
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
