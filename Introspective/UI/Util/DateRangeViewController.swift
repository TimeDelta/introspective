//
//  DateRangeViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/12/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection

public protocol DateRangeViewController: UIViewController {
	var datePickerMode: UIDatePicker.Mode { get set }
	var initialFromDate: Date? { get set }
	var fromDateRequired: Bool { get set }
	var minFromDate: Date? { get set }
	var maxFromDate: Date? { get set }
	var initialToDate: Date? { get set }
	var toDateRequired: Bool { get set }
	var minToDate: Date? { get set }
	var maxToDate: Date? { get set }
	var notificationToSendOnAccept: Notification.Name! { get set }
}

public final class DateRangeViewControllerImpl: UIViewController, DateRangeViewController {
	// MARK: - IBOutlets

	@IBOutlet final var enableFromDateSwitch: UISwitch!
	@IBOutlet final var fromDatePicker: UIDatePicker!
	@IBOutlet final var enableToDateSwitch: UISwitch!
	@IBOutlet final var toDatePicker: UIDatePicker!
	@IBOutlet final var saveButton: UIButton!

	// MARK: - Instance Variables

	public final var datePickerMode: UIDatePicker.Mode = .date
	public final var initialFromDate: Date?
	public final var fromDateRequired = false
	public final var minFromDate: Date?
	public final var maxFromDate: Date?
	public final var initialToDate: Date?
	public final var toDateRequired = false
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
		} else if !fromDateRequired {
			enableFromDateSwitch.isOn = false
		} else {
			enableFromDateSwitch.isOn = true
			enableFromDateSwitch.isEnabled = false
		}
		if let toDate = initialToDate {
			toDatePicker.date = toDate
		} else if !toDateRequired {
			enableToDateSwitch.isOn = false
		} else {
			enableToDateSwitch.isOn = true
			enableToDateSwitch.isEnabled = false
		}
		updateFromDatePickerState()
		updateToDatePickerState()

		fromDatePicker.minimumDate = minFromDate
		fromDatePicker.maximumDate = maxFromDate
		toDatePicker.minimumDate = minToDate
		toDatePicker.maximumDate = maxToDate

		fromDatePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
		toDatePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
	}

	// MARK: - Actions

	@IBAction final func saveButtonPressed(_: Any) {
		let fromDate: Date? = getFromDate()
		let toDate: Date? = getToDate()
		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: self.notificationToSendOnAccept,
				object: self,
				userInfo: self.info([
					.fromDate: fromDate as Any,
					.toDate: toDate as Any,
				])
			)
		}
		dismiss(animated: false, completion: nil)
	}

	@IBAction final func fromDateSwitchToggled(_: Any) {
		updateFromDatePickerState()
		dateChanged()
	}

	@IBAction final func toDateSwitchToggled(_: Any) {
		updateToDatePickerState()
		dateChanged()
	}

	// MARK: - Helper Functions

	@objc private final func dateChanged() {
		if let fromDate = getFromDate(), let toDate = getToDate() {
			injected(UiUtil.self).setButton(saveButton, enabled: fromDate <= toDate, hidden: false)
			if #available(iOS 13.0, *) {
				saveButton.backgroundColor = saveButton.isEnabled ? .label : .systemGray
			} else {
				saveButton.backgroundColor = saveButton.isEnabled ? .black : .gray
			}
		} else {
			injected(UiUtil.self).setButton(saveButton, enabled: true, hidden: false)
			if #available(iOS 13.0, *) {
				saveButton.backgroundColor = .label
			} else {
				saveButton.backgroundColor = .black
			}
		}
	}

	private final func updateFromDatePickerState() {
		fromDatePicker.isEnabled = enableFromDateSwitch.isOn
		fromDatePicker.isUserInteractionEnabled = enableFromDateSwitch.isOn
	}

	private final func updateToDatePickerState() {
		toDatePicker.isEnabled = enableToDateSwitch.isOn
		toDatePicker.isUserInteractionEnabled = enableToDateSwitch.isOn
	}

	private final func getFromDate() -> Date? {
		var fromDate: Date?
		if enableFromDateSwitch.isOn {
			fromDate = fromDatePicker.date
			if datePickerMode == .date {
				fromDate = injected(CalendarUtil.self).start(of: .day, in: fromDatePicker.date)
			}
//			fromDate = constrainDate(fromDate, from: minFromDate, to: maxFromDate)
		}
		return fromDate
	}

	private final func getToDate() -> Date? {
		var toDate: Date?
		if enableToDateSwitch.isOn {
			toDate = toDatePicker.date
			if datePickerMode == .date {
				toDate = injected(CalendarUtil.self).start(of: .day, in: toDatePicker.date)
			}
//			toDate = constrainDate(toDate, from: minToDate, to: maxToDate)
		}
		return toDate
	}

	private final func constrainDate(_ date: Date?, from minDate: Date?, to maxDate: Date?) -> Date? {
		if let date = date {
			if let maxDate = maxDate {
				if date > maxDate {
					return maxDate
				}
			}
			if let minDate = minDate {
				if date < minDate {
					return minDate
				}
			}
		}
		return date
	}
}
