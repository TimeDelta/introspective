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
	// MARK: - Instance Variables

	final var changeNotification: Notification.Name!

	private final let log = Log()

	// MARK: - Functions

	func reset() {
		log.error("reset() not overriden")
	}
}
