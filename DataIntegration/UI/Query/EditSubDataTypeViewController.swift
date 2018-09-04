//
//  EditSubDataTypeViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

final class EditSubDataTypeViewController: UIViewController {

	private typealias Me = EditSubDataTypeViewController
	private static let doneEditing = Notification.Name("doneChoosingSubDataType")

	public final var notificationToSendWhenAccepted: Notification.Name!
	public final var matcher: SubQueryMatcher!
	public final var sampleType: Sample.Type!

	@IBOutlet weak final var dataTypePicker: UIPickerView!
	@IBOutlet weak final var attributedChooserSubView: UIView!

	private final var attributedChooserViewController: AttributedChooserViewController!

	final override func viewDidLoad() {
		super.viewDidLoad()

		dataTypePicker.dataSource = self
		dataTypePicker.delegate = self

		let index = DependencyInjector.sample.allTypes().index { $0 == sampleType }
		if index != nil {
			dataTypePicker.selectRow(index!, inComponent: 0, animated: false)
		}


		createAndInstallAttributedChooserViewController()

		NotificationCenter.default.addObserver(self, selector: #selector(doneEditing), name: Me.doneEditing, object: nil)
	}

	@objc public final func doneEditing(notification: Notification) {
		let savedValue = QueryViewController.DataTypeInfo(sampleType, notification.object as! SubQueryMatcher)
		NotificationCenter.default.post(name: notificationToSendWhenAccepted, object: savedValue, userInfo: nil)
		_ = navigationController?.popViewController(animated: true)
	}

	private final func createAndInstallAttributedChooserViewController() {
		attributedChooserViewController = (UIStoryboard(name: "AttributeList", bundle: nil).instantiateViewController(withIdentifier: "attributedChooserViewController") as! AttributedChooserViewController)
		updateAttributedChooserViewValues()
		attributedChooserViewController.notificationToSendWhenAccepted = Me.doneEditing
		attributedChooserSubView.addSubview(attributedChooserViewController.view)
	}

	private final func updateAttributedChooserViewValues() {
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

	final func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	final func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return DependencyInjector.sample.allTypes().count
	}
}

extension EditSubDataTypeViewController: UIPickerViewDelegate {

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return DependencyInjector.sample.allTypes()[row].name
	}

	public final func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		sampleType = DependencyInjector.sample.allTypes()[row]
	}
}
