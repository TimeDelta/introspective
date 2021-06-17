//
//  PainLocationTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 6/16/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import UIKit

import Common

public final class PainLocationTableViewCell: UITableViewCell {
	// MARK: - IBOutlets

	@IBOutlet final var locationTextField: UITextField!

	// MARK: - Instance Variables

	public final var notificationToSendOnChange: Notification.Name!
	public final var location: String? {
		didSet {
			locationTextField.text = location ?? ""
		}
	}

	// MARK: - Actions

	@IBAction final func nameChanged(_: Any) {
		post(
			notificationToSendOnChange,
			userInfo: [
				.text: locationTextField.text ?? "",
			]
		)
	}
}
