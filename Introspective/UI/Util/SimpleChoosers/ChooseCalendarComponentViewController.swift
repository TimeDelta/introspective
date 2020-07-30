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
	// MARK: - Static Variables

	private typealias Me = ChooseCalendarComponentViewController

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var calendarComponentPicker: UIPickerView!

	// MARK: - Instance Variables

	public final var selectedComponent: Calendar.Component?
	public final var notificationToSendOnAccept: Notification.Name!
	public final var applicableComponents: [Calendar.Component]! = CalendarComponentAttribute.supportedComponents

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		calendarComponentPicker.dataSource = self
		calendarComponentPicker.delegate = self
		if let selectedComponent = selectedComponent {
			if let selectedIndex = applicableComponents.index(of: selectedComponent) {
				calendarComponentPicker.selectRow(selectedIndex, inComponent: 0, animated: false)
			} else {
				Me.log.error("Could not find index for specified component")
			}
		}
	}

	// MARK: - Button Actions

	@IBAction final func userPressedAccept(_: Any) {
		NotificationCenter.default.post(
			name: notificationToSendOnAccept,
			object: self,
			userInfo: info([
				.calendarComponent: selectedComponent as Any,
			])
		)
		dismiss(animated: false, completion: nil)
	}
}

// MARK: - UIPickerViewDataSource

extension ChooseCalendarComponentViewController: UIPickerViewDataSource {
	public final func numberOfComponents(in _: UIPickerView) -> Int {
		1
	}

	public final func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
		applicableComponents.count
	}
}

// MARK: - UIPickerViewDelegate

extension ChooseCalendarComponentViewController: UIPickerViewDelegate {
	public final func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
		applicableComponents[row].description.localizedCapitalized
	}

	public final func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
		selectedComponent = applicableComponents[row]
	}
}
