//
//  AttributeSelectionViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 9/8/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class AttributeSelectionViewController: UIViewController {

	// MARK: - Instance Member Variables

	public final var attributes: [Attribute]!
	public final var selectedAttribute: Attribute!
	public final var notificationToSendWhenAccepted: Notification.Name!

	// MARK: - IBOutlets

	@IBOutlet weak final var attributePicker: UIPickerView!

	// MARK: - UIViewController Overrides

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

	// MARK: - Button Actions

	@IBAction func acceptButtonPressed(_ sender: Any) {
		NotificationCenter.default.post(name: notificationToSendWhenAccepted, object: selectedAttribute)
		dismiss(animated: true, completion: nil)
	}
}

// MARK: - UIPickerViewDataSource

extension AttributeSelectionViewController: UIPickerViewDataSource {

	public final func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public final func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return attributes.count
	}
}

// MARK: - UIPickerViewDelegate

extension AttributeSelectionViewController: UIPickerViewDelegate {

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return attributes[row].name
	}

	public final func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		selectedAttribute = attributes[row]
	}
}
