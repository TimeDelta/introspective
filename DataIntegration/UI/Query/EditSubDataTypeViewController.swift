//
//  EditSubDataTypeViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

class EditSubDataTypeViewController: UIViewController {

	fileprivate typealias Me = EditSubDataTypeViewController
	fileprivate static let doneEditing = Notification.Name("doneChoosingSubDataType")

	public var notificationToSendWhenAccepted: Notification.Name!
	public var matcher: SubQueryMatcher!
	public var dataType: DataTypes!

	@IBOutlet weak var dataTypePicker: UIPickerView!
	@IBOutlet weak var attributedChooserSubView: UIView!

	fileprivate var attributedChooserViewController: AttributedChooserViewController!

	override func viewDidLoad() {
		super.viewDidLoad()

		dataTypePicker.dataSource = self
		dataTypePicker.delegate = self

		for index in 0 ..< DataTypes.allTypes.count {
			if DataTypes.allTypes[index] == dataType {
				dataTypePicker.selectRow(index, inComponent: 0, animated: false)
				break
			}
		}

		createAndInstallAttributedChooserViewController()

		NotificationCenter.default.addObserver(self, selector: #selector(doneEditing), name: Me.doneEditing, object: nil)
	}

	@objc public func doneEditing(notification: Notification) {
		let savedValue = QueryViewController.DataTypeInfo(dataType, notification.object as! SubQueryMatcher)
		NotificationCenter.default.post(name: notificationToSendWhenAccepted, object: savedValue, userInfo: nil)
		_ = navigationController?.popViewController(animated: true)
	}

	fileprivate func createAndInstallAttributedChooserViewController() {
		attributedChooserViewController = (UIStoryboard(name: "AttributeList", bundle: nil).instantiateViewController(withIdentifier: "attributedChooserViewController") as! AttributedChooserViewController)
		updateAttributedChooserViewValues()
		attributedChooserViewController.notificationToSendWhenAccepted = Me.doneEditing
		attributedChooserSubView.addSubview(attributedChooserViewController.view)
	}

	fileprivate func updateAttributedChooserViewValues() {
		let possibleValues = SubQueryMatcherFactoryImpl.allMatcherTypes.map { type in
			return type.init()
		}
		attributedChooserViewController.possibleValues = possibleValues
		attributedChooserViewController.currentValue = matcher ?? possibleValues[0]
		if attributedChooserSubView.subviews.count > 0 {
			attributedChooserViewController.reloadInputViews()
		}
	}
}

extension EditSubDataTypeViewController: UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return DataTypes.allTypes.count
	}
}

extension EditSubDataTypeViewController: UIPickerViewDelegate {

	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return DataTypes.allTypes[row].description
	}

	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		dataType = DataTypes.allTypes[row]
	}
}
