//
//  ActivitySettingTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 12/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

public class ActivitySettingTableViewCell: UITableViewCell {

	// MARK: - Instance Variables

	final var changeNotification: Notification.Name!

	// MARK: - Functions

	func reset() {
		os_log("reset() not overriden", type: .error)
	}
}
