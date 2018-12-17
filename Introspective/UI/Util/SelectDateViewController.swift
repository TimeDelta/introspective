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
	@IBOutlet weak final var lastButton: UIButton!

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
	public final var lastDate: Date?
	public final var notificationToSendOnAccept: Notification.Name!

	private final var currentDateIsFromNowOrLastButton = false

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()
		if let date = initialDate {
			datePicker.setDate(date, animated: false)
		}
		datePicker.minimumDate = earliestPossibleDate
		datePicker.maximumDate = latestPossibleDate
		datePicker.datePickerMode = datePickerMode

		lastButton.isEnabled = lastDate != nil
		lastButton.isUserInteractionEnabled = lastDate != nil
		lastButton.isHidden = lastDate == nil
	}

	// MARK: - Actions

	@IBAction final func lastButtonPressed(_ sender: Any) {
		if let date = lastDate {
			datePicker.date = date
			currentDateIsFromNowOrLastButton = true
		} else {
			os_log("last date was unexpectedly nil", type: .error)
		}
	}

	@IBAction final func nowButtonPressed(_ sender: Any) {
		datePicker.date = Date()
		currentDateIsFromNowOrLastButton = true
	}

	@IBAction func datePickerValueChanged(_ sender: Any) {
		currentDateIsFromNowOrLastButton = false
	}

	@IBAction final func acceptButtonPressed(_ sender: Any) {
		var date = datePicker.date
		if datePickerMode == .date {
			date = DependencyInjector.util.calendar.start(of: .day, in: date)
		} else if date != initialDate && !currentDateIsFromNowOrLastButton {
			date = DependencyInjector.util.calendar.start(of: .minute, in: date)
		}
		NotificationCenter.default.post(name: notificationToSendOnAccept, object: date)
		dismiss(animated: true, completion: nil)
	}
}
