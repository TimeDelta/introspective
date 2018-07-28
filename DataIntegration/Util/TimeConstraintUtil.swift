//
//  TimeConstraintUtil.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/15/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class TimeConstraintUtil {

	public func getMostRestrictiveStartAndEndDates(from timeConstraints: [TimeConstraint]) -> (start: Date?, end: Date?) {
		var latestStartDate: Date? = nil
		var earliestEndDate: Date? = nil
		for timeConstraint in timeConstraints {
			if timeConstraint is StartsAfterTimeConstraint {
				let startsAfter = timeConstraint as! StartsAfterTimeConstraint
				if latestStartDate == nil || startsAfter.date.isAfterDate(latestStartDate!, granularity: .nanosecond) {
					latestStartDate = startsAfter.date
				}
			} else if timeConstraint is EndsBeforeTimeConstraint {
				let endsBefore = timeConstraint as! EndsBeforeTimeConstraint
				if earliestEndDate == nil || endsBefore.date.isBeforeDate(earliestEndDate!, granularity: .nanosecond) {
					earliestEndDate = endsBefore.date
				}
			} else if timeConstraint is StartsOnDateTimeConstraint {
				let startsOn = timeConstraint as! StartsOnDateTimeConstraint
				if latestStartDate == nil || startsOn.date.isAfterDate(latestStartDate!, granularity: .nanosecond) {
					latestStartDate = startsOn.date
				}
			} else if timeConstraint is EndsOnDateTimeConstraint {
				let endsOn = timeConstraint as! EndsOnDateTimeConstraint
				if earliestEndDate == nil || endsOn.date.isBeforeDate(earliestEndDate!, granularity: .nanosecond) {
					earliestEndDate = endsOn.date
				}
			}
		}
		return (start: latestStartDate, end: earliestEndDate)
	}

	public func getDaysOfWeekFrom(timeConstraints: [TimeConstraint]) -> Set<DayOfWeek> {
		var daysOfWeek = Set<DayOfWeek>()
		for timeConstraint in timeConstraints {
			if timeConstraint is StartsOnDayOfWeekTimeConstraint {
				let constraint = timeConstraint as! StartsOnDayOfWeekTimeConstraint
				daysOfWeek = daysOfWeek.union(constraint.daysOfWeek)
			}
		}
		return daysOfWeek
	}
}
