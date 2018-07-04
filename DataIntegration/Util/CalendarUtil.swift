//
//  CalendarUtil.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class CalendarUtil: NSObject {

	fileprivate static let componentOrdering: [Calendar.Component] = [.year, .month, .weekOfYear, .day, .hour, .minute, .second, .nanosecond]
	fileprivate static let change: [Calendar.Component: Bool] = [
		.year: false,
		.month: true,
		.weekOfYear: false,
		.day: true,
		.hour: true,
		.minute: true,
		.second: true,
		.nanosecond: true
	]

	/// Set all components of the specified date less than the specified component to the minimum value for that component.
	/// Supported components are: era, year, month, weekOfYear, day, hour, minute, second, nanosecond
	public func zeroAllComponents(toBeginningOf component: Calendar.Component, in date: Date) -> Date {
		let calendar = Calendar.current
		var finalDate = date
		var foundComponent = false
		for currentComponent in CalendarUtil.componentOrdering {
			if foundComponent && CalendarUtil.change[currentComponent]! {
				finalDate = calendar.date(bySetting: component, value: 0, of: finalDate)!
			} else if component == currentComponent {
				foundComponent = true
			}
		}
		return finalDate
	}
}
