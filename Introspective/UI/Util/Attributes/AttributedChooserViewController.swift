//
//  AttributedChooserViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class AttributedChooserViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var valuePicker: UIPickerView! {
		didSet {
			guard let valuePicker = valuePicker else { return }
			valuePicker.accessibilityIdentifier = pickerAccessibilityIdentifier
		}
	}
	@IBOutlet weak final var attributeScrollView: UIScrollView!

	// MARK: - Instance Variables

	public final var possibleValues: [Attributed]!
	public final var currentValue: Attributed! {
		didSet {
			guard !initialSetDone else { return }
			sendValueChangeNotification()
			initialSetDone = true
		}
	}
	public final var notificationToSendWhenAccepted: Notification.Name!
	public final var notificationToSendOnValueChange: Notification.Name?
	public final var pickerAccessibilityIdentifier: String? {
		didSet {
			guard let valuePicker = valuePicker else { return }
			valuePicker.accessibilityIdentifier = pickerAccessibilityIdentifier
		}
	}

	private final var attributeViewControllers: [AttributeViewController]!
	private final let verticalSpacing = CGFloat(5)
	private final var initialSetDone = false

	private final let log = Log()

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()

		valuePicker.delegate = self
		valuePicker.dataSource = self

		if currentValue == nil {
			currentValue = possibleValues[0]
			valuePicker.selectRow(0, inComponent: 0, animated: false)
		} else {
			var index = 0
			for value in possibleValues {
				if value.attributedName == currentValue.attributedName {
					valuePicker.selectRow(index, inComponent: 0, animated: false)
					break
				}
				index += 1
			}
		}

		attributeViewControllers = [AttributeViewController]()
		populateScrollView()
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	public final override func reloadInputViews() {
		super.reloadInputViews()
		valuePicker.reloadAllComponents()
		resetScrollView()
		populateScrollView()
	}

	// MARK: - Received Notifications

	@objc private final func valueChanged(notification: Notification) {
		if let controllerIndex = attributeViewControllers.firstIndex(where: { $0.notificationToSendOnValueChange == notification.name }) {
			do {
				let attribute = attributeViewControllers[controllerIndex].attribute!
				try currentValue.set(attribute: attribute, to: value(for: .attributeValue, from: notification))
				sendValueChangeNotification()
			} catch {
				log.error("Failed to set attribute value: %@", errorInfo(error))
			}
		}
	}

	// MARK: - Actions

	@objc final func saveButtonPressed() {
		for controller in attributeViewControllers {
			let attribute = controller.attribute!
			let attributeValue = controller.attributeValue!
			do {
				try currentValue.set(attribute: attribute, to: attributeValue)
			} catch {
				log.error(
					"Failed to set %@ of %@ to %@: %@",
					attribute.name,
					currentValue.attributedName,
					String(describing: attributeValue),
					errorInfo(error))
				showError(title: "Failed to set \(attribute.name)")
			}
		}
		NotificationCenter.default.post(
			name: notificationToSendWhenAccepted,
			object: self,
			userInfo: info([
				.attributed: currentValue,
			]))
	}

	// MARK: - Helper Functions

	private final func sendValueChangeNotification() {
		if let valueChangedNotification = notificationToSendOnValueChange {
			DispatchQueue.main.async {
				NotificationCenter.default.post(
					name: valueChangedNotification,
					object: self,
					userInfo: self.info([
						.attributed: self.currentValue,
					]))
			}
		}
	}

	private final func resetScrollView() {
		attributeViewControllers = [AttributeViewController]()
		for view in attributeScrollView.subviews {
			attributeScrollView.willRemoveSubview(view)
			view.removeFromSuperview()
		}
	}

	private final func populateScrollView() {
		populateAttributes()
		createAndAddAcceptButton()
	}

	private final func populateAttributes() {
		var yPos = CGFloat(0)
		let height = CGFloat(70)
		for attribute in currentValue.attributes {
			let controller: AttributeViewController = viewController(named: "attributeView", fromStoryboard: "AttributeList")
			controller.attribute = attribute
			do {
				controller.attributeValue = try currentValue.value(of: attribute)
			} catch {
				log.error("Failed to retrieve %@ of %@: %@", attribute.name, currentValue.attributedName, errorInfo(error))
				// let the user continue
			}
			let valueChangedNotification = Notification.Name("attributeValueChanged_" + attribute.name)
			observe(selector: #selector(valueChanged), name: valueChangedNotification)
			controller.notificationToSendOnValueChange = valueChangedNotification
			let x = attributeScrollView.frame.minX
			controller.view.frame = CGRect(x: x, y: yPos, width: subViewWidth(), height: height)
			attributeViewControllers.append(controller)
			attributeScrollView.addSubview(controller.view)
			controller.didMove(toParent: self)
			yPos += height + verticalSpacing
		}
	}

	private final func createAndAddAcceptButton() {
		let controller: AttributeListAcceptButtonViewController = viewController(named: "acceptButton", fromStoryboard: "AttributeList")
		let x = attributeScrollView.frame.minX
		controller.view.frame = CGRect(x: x, y: getNextYPosForScrollView(), width: subViewWidth(), height: 30)
		controller.acceptButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
		attributeScrollView.addSubview(controller.view)
		controller.didMove(toParent: self)
	}

	private final func getNextYPosForScrollView() -> CGFloat {
		var yPos = CGFloat(0)
		for view in attributeScrollView.subviews {
			yPos += view.frame.height + verticalSpacing
		}
		return yPos
	}

	private func subViewWidth() -> CGFloat {
		return attributeScrollView.frame.maxX - attributeScrollView.frame.minX - attributeScrollView.adjustedContentInset.right - attributeScrollView.adjustedContentInset.left
	}
}

// MARK: - UIPickerViewDataSource

extension AttributedChooserViewController: UIPickerViewDataSource {

	public final func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public final func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return possibleValues.count
	}
}

// MARK: - UIPickerViewDelegate

extension AttributedChooserViewController: UIPickerViewDelegate {

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return possibleValues[row].attributedName
	}

	public final func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		let newValue = possibleValues[row]
		for attribute in newValue.attributes {
			if currentValue.attributes.contains(where: { $0.equalTo(attribute) }) {
				do {
					let attributeCurrentValue = try currentValue.value(of: attribute)
					try newValue.set(attribute: attribute, to: attributeCurrentValue)
				} catch {
					log.error(
						"Failed to set or retrieve %@ of %@ or %@: %@",
						attribute.name,
						currentValue.attributedName,
						newValue.attributedName,
						errorInfo(error))
					// ignore and move on
				}
			}
		}
		currentValue = newValue
		resetScrollView()
		populateScrollView()
	}
}
