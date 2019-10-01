//
//  ChooseCalendarComponentViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 9/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Attributes
import Common

final class ChooseCalendarComponentViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var calendarComponentPicker: UIPickerView!

	// MARK: - Instance Variables

	public final var selectedComponent: Calendar.Component?
	public final var notificationToSendOnAccept: Notification.Name!
	public final var applicableComponents: [Calendar.Component]! = CalendarComponentAttribute.supportedComponents

	private final let log = Log()

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		calendarComponentPicker.dataSource = self
		calendarComponentPicker.delegate = self
		if let selectedComponent = selectedComponent {
			if let selectedIndex = applicableComponents.index(of: selectedComponent) {
				calendarComponentPicker.selectRow(selectedIndex, inComponent: 0, animated: false)
			} else {
				log.error("Could not find index for specified component")
			}
		}
	}

	// MARK: - Button Actions

	@IBAction final func userPressedAccept(_ sender: Any) {
		NotificationCenter.default.post(
			name: notificationToSendOnAccept,
			object: self,
			userInfo: info([
				.calendarComponent: selectedComponent as Any,
			]))
		dismiss(animated: false, completion: nil)
	}
}

// MARK: - UIPickerViewDataSource

extension ChooseCalendarComponentViewController: UIPickerViewDataSource {

	public final func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public final func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return applicableComponents.count
	}
}

// MARK: - UIPickerViewDelegate

extension ChooseCalendarComponentViewController: UIPickerViewDelegate {

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return applicableComponents[row].description.localizedCapitalized
	}

	public final func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		selectedComponent = applicableComponents[row]
	}
}
