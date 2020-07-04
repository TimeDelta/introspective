//
//  GroupNameTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 4/28/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

public final class GroupNameTableViewCell: UITableViewCell {
	// MARK: - IBOutlets

	@IBOutlet final var textField: UITextField!

	// MARK: - Instance Variables

	public final var groupName: String! {
		didSet {
			guard let groupName = groupName else { return }
			textField.text = groupName
		}
	}

	// MARK: - Actions

	@IBAction final func nameChanged(_: Any) {
		syncPost(.groupNameEdited, object: self, userInfo: [.text: textField.text ?? ""])
	}
}
