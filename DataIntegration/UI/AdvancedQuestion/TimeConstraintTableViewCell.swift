//
//  TimeConstraintTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os
import SwiftDate

class TimeConstraintTableViewCell: UITableViewCell {

	@IBOutlet weak var label: UILabel!

	public var timeConstraint: TimeConstraint! {
		didSet {
			guard let timeConstraint = timeConstraint else { return }
			label.text = timeConstraint.description
		}
	}
}
