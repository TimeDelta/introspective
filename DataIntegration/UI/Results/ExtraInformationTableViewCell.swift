//
//  ResultOperationTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class ExtraInformationTableViewCell: UITableViewCell {

	public var extraInformation: ExtraInformation! {
		didSet {
			if extraInformation == nil { return }
			var text = ""
			if value != nil {
				text = value
			}
			keyValueLabel.text = extraInformation.key + ": " + text
		}
	}

	public var value: String! {
		didSet {
			if value == nil { return }
			var text = ""
			if extraInformation != nil {
				text = extraInformation.key + ": "
			}
			keyValueLabel.text = text + value
		}
	}

	@IBOutlet weak var keyValueLabel: UILabel!
}
