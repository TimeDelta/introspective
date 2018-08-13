//
//  EditDataTypeViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class EditDataTypeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

	fileprivate typealias Me = EditDataTypeViewController

	fileprivate static let values = DataTypes.allTypes.map { (type: DataTypes) -> String in
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

	var selectedIndex: Int!

	@IBOutlet weak var dataTypeSelector: UIPickerView!

	override func viewDidLoad() {
		super.viewDidLoad()
		dataTypeSelector.dataSource = self
		dataTypeSelector.delegate = self
		dataTypeSelector.selectRow(selectedIndex, inComponent: 0, animated: false)
	}

	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return DataTypes.allTypes.count
	}

	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return Me.values[row]
	}
}
