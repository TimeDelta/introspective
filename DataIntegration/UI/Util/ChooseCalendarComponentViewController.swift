//
//  ChooseCalendarComponentViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 9/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

final class ChooseCalendarComponentViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var dataTypeSelector: UIPickerView!

	// MARK: - Instance Member Variables

	public final var selectedComponent: Calendar.Component?
	public final var notificationToSendOnAccept: Notification.Name!

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		dataTypeSelector.dataSource = self
		dataTypeSelector.delegate = self
		if selectedComponent != nil {
			if let selectedIndex = CalendarComponentAttribute.supportedComponents.index(of: selectedComponent!) {
				dataTypeSelector.selectRow(selectedIndex, inComponent: 0, animated: false)
			} else {
				os_log("Could not find index for specified component", type: .error)
			}
		}
	}

	// MARK: - Button Actions

	@IBAction final func userPressedAccept(_ sender: Any) {
		NotificationCenter.default.post(name: notificationToSendOnAccept, object: selectedComponent)
		dismiss(animated: true, completion: nil)
	}
}

// MARK: - UIPickerViewDataSource

extension ChooseCalendarComponentViewController: UIPickerViewDataSource {

	public final func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public final func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return CalendarComponentAttribute.supportedComponents.count
	}
}

// MARK: - UIPickerViewDelegate

extension ChooseCalendarComponentViewController: UIPickerViewDelegate {

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return CalendarComponentAttribute.supportedComponents[row].description
	}

	public final func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		selectedComponent = CalendarComponentAttribute.supportedComponents[row]
	}
}
