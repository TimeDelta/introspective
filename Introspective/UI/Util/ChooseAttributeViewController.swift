//
//  ChooseAttributeViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 9/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

final class ChooseAttributeViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var attributePicker: UIPickerView!

	// MARK: - Instance Variables

	public final var attributes: [Attribute]!
	public final var selectedAttribute: Attribute?
	public final var notificationToSendOnAccept: Notification.Name!

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		attributePicker.dataSource = self
		attributePicker.delegate = self
		if selectedAttribute != nil {
			if let selectedIndex = attributes.index(where: { $0.equalTo(selectedAttribute!) }) {
				attributePicker.selectRow(selectedIndex, inComponent: 0, animated: false)
			} else {
				os_log("Could not find index for specified component", type: .error)
			}
		} else if attributes.count > 0 {
			selectedAttribute = attributes[0]
		} else {
			os_log("No attributes passed", type: .error)
		}
	}

	// MARK: - Button Actions

	@IBAction final func userPressedAccept(_ sender: Any) {
		NotificationCenter.default.post(name: notificationToSendOnAccept, object: selectedAttribute)
		dismiss(animated: true, completion: nil)
	}
}

// MARK: - UIPickerViewDataSource

extension ChooseAttributeViewController: UIPickerViewDataSource {

	public final func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public final func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return attributes.count
	}
}

// MARK: - UIPickerViewDelegate

extension ChooseAttributeViewController: UIPickerViewDelegate {

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return attributes[row].name
	}

	public final func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		selectedAttribute = attributes[row]
	}
}
