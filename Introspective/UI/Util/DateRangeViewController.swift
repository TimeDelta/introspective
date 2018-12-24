//
//  DateRangeViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/12/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public final class DateRangeViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var enableFromDateSwitch: UISwitch!
	@IBOutlet weak final var fromDatePicker: UIDatePicker!
	@IBOutlet weak final var enableToDateSwitch: UISwitch!
	@IBOutlet weak final var toDatePicker: UIDatePicker!

	// MARK: - Instance Variables

	public final var datePickerMode: UIDatePicker.Mode = .date
	public final var initialFromDate: Date?
	public final var minFromDate: Date?
	public final var maxFromDate: Date?
	public final var initialToDate: Date?
	public final var minToDate: Date?
	public final var maxToDate: Date?
	public final var notificationToSendOnAccept: Notification.Name!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		fromDatePicker.datePickerMode = datePickerMode
		toDatePicker.datePickerMode = datePickerMode

		fromDatePicker.accessibilityIdentifier = "from date picker"
		toDatePicker.accessibilityIdentifier = "to date picker"

		if let fromDate = initialFromDate {
			fromDatePicker.date = fromDate
		} else {
			enableFromDateSwitch.isOn = false
		}
		if let toDate = initialToDate {
			toDatePicker.date = toDate
		} else {
			enableToDateSwitch.isOn = false
		}
		updateFromDatePickerState()
		updateToDatePickerState()

		fromDatePicker.minimumDate = minFromDate
		fromDatePicker.maximumDate = maxFromDate
		toDatePicker.minimumDate = minToDate
		toDatePicker.maximumDate = maxToDate
		#warning("add validation to ensure that to date is after from date")
	}

	// MARK: - Actions

	@IBAction final func saveButtonPressed(_ sender: Any) {
		var fromDate: Date? = nil
		if enableFromDateSwitch.isOn {
			fromDate = fromDatePicker.date
			if datePickerMode == .date {
				fromDate = DependencyInjector.util.calendar.start(of: .day, in: fromDatePicker.date)
			}
		}
		var toDate: Date? = nil
		if enableToDateSwitch.isOn {
			toDate = toDatePicker.date
			if datePickerMode == .date {
				toDate = DependencyInjector.util.calendar.start(of: .day, in: toDatePicker.date)
			}
		}
		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: self.notificationToSendOnAccept,
				object: self,
				userInfo: self.info([
					.fromDate: fromDate as Any,
					.toDate: toDate as Any,
				]))
		}
		dismiss(animated: true, completion: nil)
	}

	@IBAction final func fromDateSwitchToggled(_ sender: Any) {
		updateFromDatePickerState()
	}

	@IBAction final func toDateSwitchToggled(_ sender: Any) {
		updateToDatePickerState()
	}

	// MARK: - Helper Functions

	private final func updateFromDatePickerState() {
		fromDatePicker.isEnabled = enableFromDateSwitch.isOn
		fromDatePicker.isUserInteractionEnabled = enableFromDateSwitch.isOn
	}

	private final func updateToDatePickerState() {
		toDatePicker.isEnabled = enableToDateSwitch.isOn
		toDatePicker.isUserInteractionEnabled = enableToDateSwitch.isOn
	}
}
