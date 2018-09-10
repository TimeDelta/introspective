//
//  ResultOperationTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class ExtraInformationTableViewCell: UITableViewCell {

	public final var extraInformation: ExtraInformation! {
		didSet {
			if extraInformation == nil { return }
			var text = ""
			if value != nil {
				text = value
			}
			keyValueLabel.text = extraInformation.description + ": " + text
		}
	}

	public final var value: String! {
		didSet {
			if value == nil { return }
			var text = ""
			if extraInformation != nil {
				text = extraInformation.description + ": "
			}
			keyValueLabel.text = text + value
		}
	}

	@IBOutlet weak final var keyValueLabel: UILabel!
}
