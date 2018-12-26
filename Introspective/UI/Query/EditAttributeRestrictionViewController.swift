//
//  EditAttributeRestrictionViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

public final class EditAttributeRestrictionViewController: UIViewController {

	// MARK: - Static Variables

	private typealias Me = EditAttributeRestrictionViewController
	private static let doneEditing = Notification.Name("doneChoosingAttributeRestrictionAttributes")
	private static let valueChanged = Notification.Name("attributeRestrictionValueChanged")

	// MARK: - IBOutlets

	@IBOutlet weak final var attributedChooserSubView: UIView!
	@IBOutlet weak final var attributePicker: UIPickerView!

	// MARK: - Instance Variables

	public final var notificationToSendWhenAccepted: Notification.Name!
	public final var sampleType: Sample.Type!
	public final var attributeRestriction: AttributeRestriction?
	private final var attributedChooserViewController: AttributedChooserViewController!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		attributePicker.delegate = self
		attributePicker.dataSource = self

		if attributeRestriction != nil {
			let attribute = attributeRestriction!.restrictedAttribute
			if let index = sampleType.attributes.firstIndex(where: { $0.equalTo(attribute) }) {
				attributePicker.selectRow(index, inComponent: 0, animated: false)
			}
		}
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
			NotificationCenter.default.post(
				name: notificationToSendWhenAccepted,
				object: notification.object,
				userInfo: info([
					.attributeRestriction: attributeRestriction as Any,
				]))
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
		attributedChooserSubView.addSubview(attributedChooserViewController.view)
	}

	private final func updateAttributedChooserViewValues() {
		let selectedAttribute = currentlySelectedAttribute()
		var applicableAttributeRestrictionTypes: [AttributeRestriction.Type] = []
		applicableAttributeRestrictionTypes = DependencyInjector.restriction.typesFor(selectedAttribute)
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
		return attributeRestriction != nil && DependencyInjector.restriction.typesFor(currentlySelectedAttribute()).contains(where: { $0 == type(of: attributeRestriction!) })
	}
}

// MARK: - UIPickerViewDataSource

extension EditAttributeRestrictionViewController: UIPickerViewDataSource {

	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return sampleType.attributes.count
	}
}

// MARK: - UIPickerViewDelegate

extension EditAttributeRestrictionViewController: UIPickerViewDelegate {

	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return sampleType.attributes[row].name
	}

	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		updateAttributedChooserViewValues()
	}
}
