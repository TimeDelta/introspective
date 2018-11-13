//
//  SelectDateViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

public final class SelectDateViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var datePicker: UIDatePicker!

	// MARK: - Member Variables

	public final var initialDate: Date?
	public final var earliestPossibleDate: Date?
	public final var latestPossibleDate: Date?
	public final var datePickerMode: UIDatePicker.Mode = .dateAndTime {
		didSet {
			if datePickerMode == .countDownTimer {
				os_log("this view is not meant to do timers", type: .error)
			}
		}
	}

	public final var notificationToSendOnAccept: Notification.Name!

	// MARK: - UIViewController Overrides

	#warning("Add now / last buttons")
	public final override func viewDidLoad() {
		super.viewDidLoad()
		if let date = initialDate {
			datePicker.setDate(date, animated: false)
		}
		datePicker.minimumDate = earliestPossibleDate
		datePicker.maximumDate = latestPossibleDate
		datePicker.datePickerMode = datePickerMode
	}

	// MARK: - Actions

	@IBAction final func acceptButtonPressed(_ sender: Any) {
		var date = datePicker.date
		if datePickerMode == .date {
			date = DependencyInjector.util.calendar.start(of: .day, in: date)
		} else if date != initialDate {
			date = DependencyInjector.util.calendar.start(of: .minute, in: date)
		}
		NotificationCenter.default.post(name: notificationToSendOnAccept, object: date)
		dismiss(animated: true, completion: nil)
	}
}
