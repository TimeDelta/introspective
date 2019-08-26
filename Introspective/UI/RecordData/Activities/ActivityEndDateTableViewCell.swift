//
//  ActivityEndDateTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 11/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public protocol ActivityEndDateTableViewCell: UITableViewCell {

	var notificationToSendOnDateChange: Notification.Name! { get set }
	var endDate: Date? { get set }
}

public final class ActivityEndDateTableViewCellImpl: UITableViewCell, ActivityEndDateTableViewCell {

	// MARK: - IBOutlets

	@IBOutlet weak final var endDateLabel: UILabel!
	@IBOutlet weak final var clearButton: UIButton!

	// MARK: - Instance Variables

	public final var notificationToSendOnDateChange: Notification.Name!
	public final var endDate: Date? {
		didSet {
			if let endDate = endDate {
				endDateLabel.text = DependencyInjector.util.calendar.string(for: endDate, dateStyle: .medium, timeStyle: .medium)
			} else {
				endDateLabel.text = ""
			}
			endDateLabel.accessibilityValue = endDateLabel.text
			let hideClearButton = endDate == nil
			DependencyInjector.util.ui.setButton(clearButton, enabled: !hideClearButton, hidden: hideClearButton)
		}
	}

	// MARK: - Actions

	@IBAction final func clearButtonPressed(_ sender: Any) {
		endDate = nil
		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: self.notificationToSendOnDateChange,
				object: self,
				userInfo: self.info([
					.date: self.endDate as Any,
				]))
		}
	}
}
