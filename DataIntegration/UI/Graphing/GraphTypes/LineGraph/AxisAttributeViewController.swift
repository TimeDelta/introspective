//
//  AxisAttributeViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class AxisAttributeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

	public final var attributes: [Attribute]!
	public final var selectedAttribute: Attribute!

	@IBOutlet weak final var attributePicker: UIPickerView!

	final override func viewDidLoad() {
		super.viewDidLoad()

		attributePicker.delegate = self
		attributePicker.dataSource = self

		var index: Int = 0
		for attribute in attributes {
			if selectedAttribute.name == attribute.name {
				break
			}
			index += 1
		}

		attributePicker.selectRow(index, inComponent: 0, animated: false)
	}

	public final func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public final func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return attributes.count
	}

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return attributes[row].name
	}

	public final func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		selectedAttribute = attributes[row]
	}
}
