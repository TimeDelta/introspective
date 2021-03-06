//
//  ActivityEndDateTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 11/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection

public protocol ActivityEndDateTableViewCell: UITableViewCell {
	var notificationToSendOnDateChange: Notification.Name! { get set }
	var endDate: Date? { get set }
}

public final class ActivityEndDateTableViewCellImpl: UITableViewCell, ActivityEndDateTableViewCell {
	// MARK: - IBOutlets

	@IBOutlet final var endDateLabel: UILabel!
	@IBOutlet final var clearButton: UIButton!

	// MARK: - Instance Variables

	public final var notificationToSendOnDateChange: Notification.Name!
	public final var endDate: Date? {
		didSet {
			if let endDate = endDate {
				endDateLabel.text = injected(CalendarUtil.self)
					.string(for: endDate, dateStyle: .medium, timeStyle: .medium)
			} else {
				endDateLabel.text = ""
			}
			endDateLabel.accessibilityValue = endDateLabel.text
			let hideClearButton = endDate == nil
			injected(UiUtil.self)
				.setButton(clearButton, enabled: !hideClearButton, hidden: hideClearButton)
		}
	}

	// MARK: - Actions

	@IBAction final func clearButtonPressed(_: Any) {
		endDate = nil
		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: self.notificationToSendOnDateChange,
				object: self,
				userInfo: self.info([
					.date: self.endDate as Any,
				])
			)
		}
	}
}
