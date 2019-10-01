//
//  DateOrTimeAttributeValueViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Attributes
import Common
import DependencyInjection

public final class DateOrTimeAttributeValueViewController: AttributeValueTypeViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var datePicker: UIDatePicker!

	// MARK: - Instance Variables

	public final var dateAttribute: DateAttribute!
	public final var timeOfDayAttribute: TimeOfDayAttribute!

	private final let log = Log()

	// MARK: - UIViewController Overrides

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

		if let date = currentValue as? Date {
			datePicker.setDate(date, animated: false)
		} else if let time = currentValue as? TimeOfDay {
			datePicker.setDate(Date(time), animated: false)
		} else {
			log.error("Unknown value type: %@", String(describing: currentValue))
		}
	}

	// MARK: - Actions

	@IBAction final func dateValueChanged(_ sender: Any) {
		if timeOfDayAttribute != nil {
			currentValue = TimeOfDay(datePicker.date)
		} else if dateAttribute.includeTime {
			currentValue = datePicker.date
		} else {
			currentValue = DependencyInjector.get(CalendarUtil.self).start(of: .day, in: datePicker.date)
		}
	}
}
