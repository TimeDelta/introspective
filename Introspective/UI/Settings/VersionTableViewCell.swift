//
//  VersionTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 6/28/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import UIKit

import Common

class VersionTableViewCell: UITableViewCell {

	override func awakeFromNib() {
		super.awakeFromNib()
		textLabel?.text = "Version: " + versionString() + " (tap to copy)"
	}
}
