//
//  EditDataTypeViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class EditDataTypeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

	private typealias Me = EditDataTypeViewController

	private static let values = DataTypes.allTypes.map { (type: DataTypes) -> String in
		return type.description
	}

	static func indexFor(type: String) -> Int {
		var index = 0
		for value in values {
			if value == type {
				return index
			}
			index += 1
		}
		return -1 // this will never happen
	}

	final var selectedIndex: Int!
	final var notificationToSendOnAccept: Notification.Name!

	@IBOutlet weak final var dataTypeSelector: UIPickerView!

	final override func viewDidLoad() {
		super.viewDidLoad()
		dataTypeSelector.dataSource = self
		dataTypeSelector.delegate = self
		dataTypeSelector.selectRow(selectedIndex, inComponent: 0, animated: false)
	}

	public final func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public final func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return DataTypes.allTypes.count
	}

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return Me.values[row]
	}

	@IBAction func userPressedAccept(_ sender: Any) {
		NotificationCenter.default.post(name: notificationToSendOnAccept, object: dataTypeSelector.selectedRow(inComponent: 0))
		dismiss(animated: true, completion: nil)
	}
}
