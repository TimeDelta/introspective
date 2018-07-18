//
//  ResultOperationTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class ExtraInformationTableViewCell<SampleType: Sample>: UITableViewCell {

	public var extraInformation: ExtraInformation! {
		didSet {
			if extraInformation == nil { return }
			var text = ""
			if value != nil {
				text = value
			}
			keyValueLabel.text = extraInformation.key + ": " + text
			datesLabel.text = getDateText()
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
	@IBOutlet weak var datesLabel: UILabel!

	/// - Precondition: extraInformation is not `nil`
	fileprivate func getDateText() -> String {
		assert(extraInformation != nil)

		if extraInformation.startDate != nil && extraInformation.endDate != nil {
			return DependencyInjector.util.calendarUtil.string(for: extraInformation.startDate!) + " to " + DependencyInjector.util.calendarUtil.string(for: extraInformation.endDate!)
		} else if extraInformation.startDate != nil {
			return "starting at " + DependencyInjector.util.calendarUtil.string(for: extraInformation.startDate!)
		} else {
			return "until " + DependencyInjector.util.calendarUtil.string(for: extraInformation.endDate!)
		}
	}
}
