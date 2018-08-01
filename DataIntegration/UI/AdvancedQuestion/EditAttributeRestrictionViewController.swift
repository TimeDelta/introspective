//
//  EditAttributeRestrictionViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public class EditAttributeRestrictionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

	fileprivate typealias Me = EditAttributeRestrictionViewController
	fileprivate static let doneEditing = Notification.Name("doneChoosingAttributeRestrictionAttributes")

	public var notificationToSendWhenAccepted: Notification.Name!
	public var dataType: DataTypes!
	public var attributeRestriction: AttributeRestriction!

	@IBOutlet weak var attributedChooserSubView: UIView!
	@IBOutlet weak var attributePicker: UIPickerView!

	fileprivate var attributedChooserViewController: AttributedChooserViewController!

	public override func viewDidLoad() {
		attributePicker.delegate = self
		attributePicker.dataSource = self

		createAndInstallAttributedChooserViewController()

		NotificationCenter.default.addObserver(self, selector: #selector(doneEditing), name: Me.doneEditing, object: nil)
	}

	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return DataTypes.attributesFor(dataType).count
	}

	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return DataTypes.attributesFor(dataType)[row].name
	}

	@objc public func doneEditing(notification: Notification) {
		NotificationCenter.default.post(name: notificationToSendWhenAccepted, object: notification.object, userInfo: nil)
		_ = navigationController?.popViewController(animated: true)
	}

	fileprivate func createAndInstallAttributedChooserViewController() {
		attributedChooserViewController = (UIStoryboard(name: "AttributeList", bundle: nil).instantiateViewController(withIdentifier: "attributedChooserViewController") as! AttributedChooserViewController)
		updateAttributedChooserViewValues()
		attributedChooserViewController.notificationToSendWhenAccepted = Me.doneEditing
		attributedChooserSubView.addSubview(attributedChooserViewController.view)
	}

	fileprivate func updateAttributedChooserViewValues() {
		let selectedAttribute = currentlySelectedAttribute()
		var applicableAttributeRestrictionTypes: [AttributeRestriction.Type] = []
		var currentRestriction: AttributeRestriction? = nil
		if selectedAttribute is DateAttribute {
			applicableAttributeRestrictionTypes = AttributeRestrictionFactory.dateTypes
			if attributeRestriction is DateAttributeRestriction {
				currentRestriction = attributeRestriction
			}
		} else if selectedAttribute is DoubleAttribute {
			applicableAttributeRestrictionTypes = AttributeRestrictionFactory.numberTypes
			if attributeRestriction is DoubleAttributeRestriction {
				currentRestriction = attributeRestriction
			}
		}
		let possibleValues = applicableAttributeRestrictionTypes.map { type in
			return type.init(attribute: currentlySelectedAttribute())
		}
		attributedChooserViewController.possibleValues = possibleValues
		attributedChooserViewController.currentValue = currentRestriction
	}

	fileprivate func currentlySelectedAttribute() -> Attribute {
		return DataTypes.attributesFor(dataType)[attributePicker.selectedRow(inComponent: 0)]
	}
}
