//
//  ActivitySettingTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 12/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common

public class ActivitySettingTableViewCell: UITableViewCell {
	// MARK: - Static Variables

	private typealias Me = ActivitySettingTableViewCell

	private static let log = Log()

	// MARK: - Instance Variables

	final var changeNotification: Notification.Name!

	// MARK: - Functions

	func reset() {
		Me.log.error("reset() not overriden")
	}
}
