//
//  SelectDateViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public final class SelectDateViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var datePicker: UIDatePicker!

	// MARK: - Member Variables

	public final var initialDate: Date?
	public final var earliestPossibleDate: Date?
	public final var latestPossibleDate: Date?
	public final var datePickerMode: UIDatePicker.Mode = .dateAndTime

	public final var notificationToSendOnAccept: Notification.Name!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()
		if let date = initialDate {
			datePicker.setDate(date, animated: false)
		}
		datePicker.minimumDate = earliestPossibleDate
		datePicker.maximumDate = latestPossibleDate
		datePicker.datePickerMode = datePickerMode
	}

	// MARK: - Button Actions

	@IBAction final func acceptButtonPressed(_ sender: Any) {
		NotificationCenter.default.post(name: notificationToSendOnAccept, object: datePicker.date)
		dismiss(animated: true, completion: nil)
	}
}
