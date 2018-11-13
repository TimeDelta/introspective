//
//  SelectOneAttributeValueViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public final class SelectOneAttributeValueViewController: AttributeValueTypeViewController, UIPickerViewDelegate, UIPickerViewDataSource {

	public final var selectOneAttribute: SelectOneAttribute!

	@IBOutlet weak final var selectOnePicker: UIPickerView!

	public final override func viewDidLoad() {
		super.viewDidLoad()

		selectOnePicker.delegate = self
		selectOnePicker.dataSource = self

		if currentValue != nil {
			let index = selectOneAttribute.indexOf(possibleValue: currentValue!)
			if index != nil {
				selectOnePicker.selectRow(index!, inComponent: 0, animated: false)
			}
		}
	}

	public final func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public final func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return selectOneAttribute.possibleValues.count
	}

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		let value = selectOneAttribute.possibleValues[row]
		return try! selectOneAttribute.convertToDisplayableString(from: value)
	}

	public final func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		currentValue = selectOneAttribute.possibleValues[row]
	}
}
