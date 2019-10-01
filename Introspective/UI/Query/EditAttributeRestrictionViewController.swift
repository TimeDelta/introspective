//
//  EditAttributeRestrictionViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

import AttributeRestrictions
import Attributes
import DependencyInjection
import Samples

public protocol EditAttributeRestrictionViewController: UIViewController {

	var sampleType: Sample.Type! { get set }
	var attributeRestriction: AttributeRestriction? { get set }
}

public final class EditAttributeRestrictionViewControllerImpl: UIViewController, EditAttributeRestrictionViewController {

	// MARK: - Static Variables

	private typealias Me = EditAttributeRestrictionViewControllerImpl
	private static let doneEditing = Notification.Name("doneChoosingAttributeRestrictionAttributes")
	private static let valueChanged = Notification.Name("attributeRestrictionValueChanged")

	// MARK: - IBOutlets

	@IBOutlet weak final var attributedChooserSubView: UIView!
	@IBOutlet weak final var attributePicker: UIPickerView!

	// MARK: - Instance Variables

	public final var sampleType: Sample.Type!
	public final var attributeRestriction: AttributeRestriction?
	private final var attributedChooserViewController: AttributedChooserViewController!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		attributePicker.delegate = self
		attributePicker.dataSource = self

		selectInitialAttributeRestriction()
		setPickerHeightConstraint()

		createAndInstallAttributedChooserViewController()

		observe(selector: #selector(doneEditing), name: Me.doneEditing)
		observe(selector: #selector(valueChanged), name: Me.valueChanged)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Received Notifications

	@objc private final func doneEditing(notification: Notification) {
		if let attributeRestriction: AttributeRestriction? = value(for: .attributed, from: notification) {
			syncPost(.attributeRestrictionEdited, userInfo: [.attributeRestriction: attributeRestriction as Any])
			navigationController?.popViewController(animated: false)
		}
	}

	@objc private final func valueChanged(notification: Notification) {
		self.attributeRestriction = value(for: .attributed, from: notification)
	}

	// MARK: - Helper Functions

	private final func createAndInstallAttributedChooserViewController() {
		attributedChooserViewController = viewController(named: "attributedChooserViewController", fromStoryboard: "AttributeList")
		updateAttributedChooserViewValues()
		attributedChooserViewController.notificationToSendWhenAccepted = Me.doneEditing
		attributedChooserViewController.notificationToSendOnValueChange = Me.valueChanged
		attributedChooserViewController.currentValue = attributeRestriction
		attributedChooserViewController.pickerAccessibilityIdentifier = "attribute restriction"
		attributedChooserViewController.saveButtonAccessibilityIdentifier = "save attribute restriction button"

		attributedChooserSubView.addSubview(attributedChooserViewController.view)
		attributedChooserViewController.didMove(toParent: self)
		NSLayoutConstraint.activate([
			attributedChooserViewController.view.topAnchor.constraint(equalTo: attributedChooserSubView.topAnchor),
			attributedChooserViewController.view.bottomAnchor.constraint(equalTo: attributedChooserSubView.bottomAnchor),
			attributedChooserViewController.view.leftAnchor.constraint(equalTo: attributedChooserSubView.leftAnchor),
			attributedChooserViewController.view.rightAnchor.constraint(equalTo: attributedChooserSubView.rightAnchor),
		])
	}

	private final func updateAttributedChooserViewValues() {
		let selectedAttribute = currentlySelectedAttribute()
		var applicableAttributeRestrictionTypes: [AttributeRestriction.Type] = []
		applicableAttributeRestrictionTypes = DependencyInjector.get(AttributeRestrictionFactory.self).typesFor(selectedAttribute)
		let possibleValues = applicableAttributeRestrictionTypes.map { type in
			return type.init(restrictedAttribute: selectedAttribute)
		}
		if attributeRestrictionMatchesAttribute() {
			attributeRestriction?.restrictedAttribute = selectedAttribute
			attributedChooserViewController.currentValue = attributeRestriction
		} else {
			attributedChooserViewController.currentValue = possibleValues[0]
		}
		attributedChooserViewController.possibleValues = possibleValues
		if attributedChooserSubView.subviews.count > 0 {
			attributedChooserViewController.reloadInputViews()
		}
	}

	private final func currentlySelectedAttribute() -> Attribute {
		return sampleType.attributes[attributePicker.selectedRow(inComponent: 0)]
	}

	private final func attributeRestrictionMatchesAttribute() -> Bool {
		return attributeRestriction != nil &&
			DependencyInjector.get(AttributeRestrictionFactory.self).typesFor(currentlySelectedAttribute()).contains(where: {
				$0 == type(of: attributeRestriction!)
			})
	}

	private final func selectInitialAttributeRestriction() {
		if attributeRestriction != nil {
			let attribute = attributeRestriction!.restrictedAttribute
			if let index = sampleType.attributes.firstIndex(where: { $0.equalTo(attribute) }) {
				attributePicker.selectRow(index, inComponent: 0, animated: false)
			}
		}
	}

	// MARK: Constraint Helper Functions

	private final func setPickerHeightConstraint() {
		let heightConstraint = attributePicker.heightAnchor.constraint(
			equalTo: view.heightAnchor,
			multiplier: CGFloat(0.27))
		heightConstraint.priority = .required
		heightConstraint.isActive = true
	}
}

// MARK: - UIPickerViewDataSource

extension EditAttributeRestrictionViewControllerImpl: UIPickerViewDataSource {

	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return sampleType.attributes.count
	}
}

// MARK: - UIPickerViewDelegate

extension EditAttributeRestrictionViewControllerImpl: UIPickerViewDelegate {

	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return sampleType.attributes[row].name
	}

	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		updateAttributedChooserViewValues()
	}
}
