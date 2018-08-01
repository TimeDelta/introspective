//
//  DateAttributeValueViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class DateAttributeValueViewController: AttributeValueTypeViewController {

	public var dateAttribute: DateAttribute!

	@IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

		if dateAttribute.includeTime {
			datePicker.datePickerMode = .dateAndTime
		} else {
			datePicker.datePickerMode = .date
		}

		datePicker.minimumDate = dateAttribute.earliestDate
		datePicker.maximumDate = dateAttribute.latestDate

		if currentValue != nil {
			datePicker.calendar = Calendar.autoupdatingCurrent
			datePicker.timeZone = Calendar.autoupdatingCurrent.timeZone
			datePicker.locale = Calendar.autoupdatingCurrent.locale
			datePicker.setDate(currentValue as! Date, animated: false)
		}

		datePicker.addTarget(self, action: #selector(dateValueChanged), for: .valueChanged)
    }

    @objc fileprivate func dateValueChanged() {
		if dateAttribute.includeTime {
			currentValue = datePicker.date
		} else {
			currentValue = DependencyInjector.util.calendarUtil.start(of: .day, in: datePicker.date)
		}
	}
}
