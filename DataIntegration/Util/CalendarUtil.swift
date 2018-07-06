//
//  CalendarUtil.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftDate

public class CalendarUtil: NSObject {

	/// Set all components of the specified date less than the specified component to the minimum value for that component.
	/// - Parameter toBeginningOf: Must be one of the following values: `.year`, `.month`, `.weekOfYear`, `.day`, `.hour`, `.minute`, `.second`, `.nanosecond`
	public func start(of component: Calendar.Component, in date: Date) -> Date {
		let calendar = Calendar.autoupdatingCurrent
		let dateInRegion = DateInRegion(date, region: Region(calendar: calendar, zone: calendar.timeZone))
		let start = dateInRegion.dateAtStartOf(component)
		return start.date
	}

	/// Set all components of the specified date less than the specified component to the maximum value for that component.
	/// - Parameter toBeginningOf: Must be one of the following values: `.year`, `.month`, `.weekOfYear`, `.day`, `.hour`, `.minute`, `.second`, `.nanosecond`
	public func end(of component: Calendar.Component, in date: Date) -> Date {
		let calendar = Calendar.autoupdatingCurrent
		let dateInRegion = DateInRegion(date, region: Region(calendar: calendar, zone: calendar.timeZone))
		let end = dateInRegion.dateAtEndOf(component)
		return end.date
	}
}
