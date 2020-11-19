//
//  DateExtension.swift
//  Introspective
//
//  Created by Bryan Nova on 7/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import DependencyInjection
import Foundation

public extension Date {
	func isToday() -> Bool {
		let now = Date()
		let startOfDay = injected(CalendarUtil.self).start(of: .day, in: now)
		let endOfDay = injected(CalendarUtil.self).end(of: .day, in: now)
		return isAfterDate(startOfDay, orEqual: true, granularity: .nanosecond) &&
			isBeforeDate(endOfDay, orEqual: true, granularity: .nanosecond)
	}

	func next(_ dayOfWeek: DayOfWeek) -> Date {
		get(.forward, dayOfWeek)
	}

	func previous(_ dayOfWeek: DayOfWeek) -> Date {
		get(.backward, dayOfWeek)
	}

	func start(of component: Calendar.Component) -> Date {
		injected(CalendarUtil.self).start(of: component, in: self)
	}

	private func get(_ direction: Calendar.SearchDirection, _ dayOfWeek: DayOfWeek) -> Date {
		let dayIndex = dayOfWeek.intValue
		let calendar = Calendar(identifier: .gregorian)
		var nextDateComponent = DateComponents()
		nextDateComponent.weekday = dayIndex

		return calendar.nextDate(
			after: self,
			matching: nextDateComponent,
			matchingPolicy: .nextTime,
			direction: direction
		)!
	}
}
