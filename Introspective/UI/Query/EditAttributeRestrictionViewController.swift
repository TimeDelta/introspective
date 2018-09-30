//
//  EditAttributeRestrictionViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public final class EditAttributeRestrictionViewController: UIViewController {

	private typealias Me = EditAttributeRestrictionViewController
	private static let doneEditing = Notification.Name("doneChoosingAttributeRestrictionAttributes")

	public final var notificationToSendWhenAccepted: Notification.Name!
	public final var sampleType: Sample.Type!
	public final var attributeRestriction: AttributeRestriction?

	@IBOutlet weak final var attributedChooserSubView: UIView!
	@IBOutlet weak final var attributePicker: UIPickerView!

	private final var attributedChooserViewController: AttributedChooserViewController!

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

		NotificationCenter.default.addObserver(self, selector: #selector(doneEditing), name: Me.doneEditing, object: nil)
	}

	@objc public final func doneEditing(notification: Notification) {
		NotificationCenter.default.post(name: notificationToSendWhenAccepted, object: notification.object, userInfo: nil)
		navigationController?.popViewController(animated: true)
	}

	private final func createAndInstallAttributedChooserViewController() {
		attributedChooserViewController = (UIStoryboard(name: "AttributeList", bundle: nil).instantiateViewController(withIdentifier: "attributedChooserViewController") as! AttributedChooserViewController)
		updateAttributedChooserViewValues()
		attributedChooserViewController.notificationToSendWhenAccepted = Me.doneEditing
		attributedChooserViewController.currentValue = attributeRestriction
		attributedChooserSubView.addSubview(attributedChooserViewController.view)
	}

	private final func updateAttributedChooserViewValues() {
		let selectedAttribute = currentlySelectedAttribute()
		var applicableAttributeRestrictionTypes: [AttributeRestriction.Type] = []
		var currentRestriction: AttributeRestriction? = nil
		applicableAttributeRestrictionTypes = DependencyInjector.restriction.typesFor(selectedAttribute)
		if selectedAttribute is DateAttribute && attributeRestriction is DateAttributeRestriction {
			currentRestriction = attributeRestriction
		} else if selectedAttribute is DoubleAttribute && attributeRestriction is DoubleAttributeRestriction {
			currentRestriction = attributeRestriction
		} else if selectedAttribute is IntegerAttribute && attributeRestriction is IntegerAttributeRestriction {
			currentRestriction = attributeRestriction
		} else if selectedAttribute is TextAttribute && attributeRestriction is StringAttributeRestriction {
			currentRestriction = attributeRestriction
		}
		let possibleValues = applicableAttributeRestrictionTypes.map { type in
			return type.init(restrictedAttribute: currentlySelectedAttribute())
		}
		attributedChooserViewController.possibleValues = possibleValues
		attributedChooserViewController.currentValue = currentRestriction ?? possibleValues[0]
		if attributedChooserSubView.subviews.count > 0 {
			attributedChooserViewController.reloadInputViews()
		}
	}

	private final func currentlySelectedAttribute() -> Attribute {
		return sampleType.attributes[attributePicker.selectedRow(inComponent: 0)]
	}
}

extension EditAttributeRestrictionViewController: UIPickerViewDataSource {

	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return sampleType.attributes.count
	}
}

extension EditAttributeRestrictionViewController: UIPickerViewDelegate {

	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return sampleType.attributes[row].name
	}

	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		updateAttributedChooserViewValues()
	}
}
