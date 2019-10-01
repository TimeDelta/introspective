//
//  DateExtension.swift
//  Introspective
//
//  Created by Bryan Nova on 7/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import DependencyInjection

public extension Date {

	func isToday() -> Bool {
		let now = Date()
		let startOfDay = DependencyInjector.get(CalendarUtil.self).start(of: .day, in: now)
		let endOfDay = DependencyInjector.get(CalendarUtil.self).end(of: .day, in: now)
		return isAfterDate(startOfDay, orEqual: true, granularity: .nanosecond) &&
			isBeforeDate(endOfDay, orEqual: true, granularity: .nanosecond)
	}

	func next(_ dayOfWeek: DayOfWeek) -> Date {
		return get(.forward, dayOfWeek)
	}

	func previous(_ dayOfWeek: DayOfWeek) -> Date {
		return get(.backward, dayOfWeek)
	}

	private func get(_ direction: Calendar.SearchDirection, _ dayOfWeek: DayOfWeek) -> Date {
		let dayIndex = dayOfWeek.intValue
		let calendar = Calendar(identifier: .gregorian)
		var nextDateComponent = DateComponents()
		nextDateComponent.weekday = dayIndex

		return calendar.nextDate(after: self, matching: nextDateComponent, matchingPolicy: .nextTime, direction: direction)!
	}
}
