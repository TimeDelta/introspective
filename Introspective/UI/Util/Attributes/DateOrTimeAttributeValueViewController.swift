//
//  DateOrTimeAttributeValueViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public final class DateOrTimeAttributeValueViewController: AttributeValueTypeViewController {

	public final var dateAttribute: DateAttribute!
	public final var timeOfDayAttribute: TimeOfDayAttribute!

	@IBOutlet weak final var datePicker: UIDatePicker!

	public final override func viewDidLoad() {
		super.viewDidLoad()

		if dateAttribute != nil {
			if dateAttribute.includeTime {
				datePicker.datePickerMode = .dateAndTime
			} else {
				datePicker.datePickerMode = .date
			}

			datePicker.minimumDate = dateAttribute.earliestDate
			datePicker.maximumDate = dateAttribute.latestDate
		} else {
			datePicker.datePickerMode = .time
		}

		datePicker.calendar = Calendar.autoupdatingCurrent
		datePicker.timeZone = Calendar.autoupdatingCurrent.timeZone
		datePicker.locale = Calendar.autoupdatingCurrent.locale

		if currentValue != nil {
			if currentValue is Date {
				datePicker.setDate(currentValue as! Date, animated: false)
			} else {
				datePicker.setDate(Date(currentValue as! TimeOfDay), animated: false)
			}
		}
	}

	@IBAction final func dateValueChanged(_ sender: Any) {
		if timeOfDayAttribute != nil {
			currentValue = TimeOfDay(datePicker.date)
		} else if dateAttribute.includeTime {
			currentValue = datePicker.date
		} else {
			currentValue = DependencyInjector.util.calendar.start(of: .day, in: datePicker.date)
		}
	}
}
