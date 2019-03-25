//
//  CoreDataSampleUtil.swift
//  Introspective
//
//  Created by Bryan Nova on 3/3/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

public protocol CoreDataSampleUtil {

	/// This will convert the given date from the time zone for the specified id
	/// if available and the user has convert time zones enabled.
	func convertTimeZoneIfApplicable(for date: Date, timeZoneId: String?) -> Date
}

public final class CoreDataSampleUtilImpl: CoreDataSampleUtil {

	/// This will convert the given date from the time zone for the specified id
	/// if available and the user has convert time zones enabled.
	public func convertTimeZoneIfApplicable(for date: Date, timeZoneId: String?) -> Date {
		guard DependencyInjector.settings.convertTimeZones else { return date }
		if let timeZoneId = timeZoneId {
			if let timeZone = TimeZone(identifier: timeZoneId) {
				return DependencyInjector.util.calendar.convert(date, from: timeZone, to: TimeZone.autoupdatingCurrent)
			}
		}
		return date
	}
}
