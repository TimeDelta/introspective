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
	@IBOutlet weak final var scrollView: UIScrollView!
	@IBOutlet weak final var scrollContentView: UIView!

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

		view.translatesAutoresizingMaskIntoConstraints = false
		setScrollContentViewWidthConstraint()

		valuePicker.delegate = self
		valuePicker.dataSource = self

		setPickerToCurrentValue()

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

	public final override func didMove(toParent newParent: UIViewController?) {
		let viewForConstraint: UIView! = newParent?.view ?? view
		let contentViewWidthConstraint = valuePicker.heightAnchor.constraint(equalTo: viewForConstraint.heightAnchor, multiplier: CGFloat(0.27))
		contentViewWidthConstraint.priority = .required
		contentViewWidthConstraint.isActive = true
	}

	// MARK: - Received Notifications

	@objc private final func valueChanged(notification: Notification) {
		if let controllerIndex = attributeViewControllers.firstIndex(where: {
			$0.notificationToSendOnValueChange == notification.name
		}) {
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
				showError(title: "Failed to set \(attribute.name)", error: error)
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

	private final func setPickerToCurrentValue() {
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
	}

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
		for view in scrollContentView.subviews {
			scrollContentView.willRemoveSubview(view)
			view.removeFromSuperview()
		}
	}

	private final func populateScrollView() {
		var isFirstView = true
		var previousView: UIView!
		for attribute in currentValue.attributes {
			let controller = prepareControllerForAttribute(attribute)
			attributeViewControllers.append(controller)
			scrollContentView.addSubview(controller.view)
			controller.didMove(toParent: self)

			NSLayoutConstraint.activate([
				heightConstraintFor(controller.view, height: CGFloat(70)),
				controller.view.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
				controller.view.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
				getVerticalConstraintForAttributeControllerView(
					controller.view,
					lastView: previousView,
					isFirstView: &isFirstView),
			])
			previousView = controller.view
		}
		createAndAddAcceptButton(lastView: previousView)
	}

	private final func prepareControllerForAttribute(_ attribute: Attribute) -> AttributeViewController {
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
		return controller
	}

	private final func createAndAddAcceptButton(lastView: UIView!) {
		let acceptButton = UIButton(type: .custom)
		acceptButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
		acceptButton.backgroundColor = .black
		acceptButton.setTitleColor(.white, for: .normal)
		acceptButton.setTitle("Save", for: .normal)
		acceptButton.translatesAutoresizingMaskIntoConstraints = false
		scrollContentView.addSubview(acceptButton)
		NSLayoutConstraint.activate([
			heightConstraintFor(acceptButton, height: CGFloat(30)),
			acceptButton.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
			acceptButton.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
			acceptButton.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: verticalSpacing),
			// this constraint is required for the scroll view to scroll
			scrollContentView.bottomAnchor.constraint(equalTo: acceptButton.bottomAnchor),
		])
	}

	// MARK: Constraint Helper Functions

	private final func getVerticalConstraintForAttributeControllerView(_ view: UIView, lastView: UIView!, isFirstView: inout Bool)
	-> NSLayoutConstraint {
		if isFirstView {
			isFirstView = false
			return view.topAnchor.constraint(
				equalTo: scrollContentView.topAnchor,
				constant: verticalSpacing)
		} else {
			return view.topAnchor.constraint(
				equalTo: lastView.bottomAnchor,
				constant: verticalSpacing)
		}
	}

	private final func heightConstraintFor(_ view: UIView, height: CGFloat) -> NSLayoutConstraint {
		let heightConstraint = view.heightAnchor.constraint(equalToConstant: height)
		heightConstraint.priority = .required
		return heightConstraint
	}

	private final func setScrollContentViewWidthConstraint() {
		let contentViewWidthConstraint = scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
		contentViewWidthConstraint.priority = .required
		contentViewWidthConstraint.isActive = true
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
