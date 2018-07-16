//
//  TimeConstraintUtil.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/15/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class TimeConstraintUtil {

	public func getStartAndEndDatesFrom(timeConstraints: Set<TimeConstraint>) -> (start: Date?, end: Date?) {
		var startDate: Date? = nil
		var endDate: Date? = nil
		for timeConstraint in timeConstraints {
			if timeConstraint.specificDate != nil {
				switch (timeConstraint.useStartOrEndDate) {
					case .start:
						startDate = timeConstraint.specificDate!
						break
					case .end:
						endDate = timeConstraint.specificDate!
						break
				}
			}
		}
		return (start: startDate, end: endDate)
	}

	public func getDaysOfWeekFrom(timeConstraints: Set<TimeConstraint>) -> Set<DayOfWeek> {
		var daysOfWeek = Set<DayOfWeek>()
		for timeConstraint in timeConstraints {
			if !timeConstraint.daysOfWeek.isEmpty {
				daysOfWeek = daysOfWeek.union(timeConstraint.daysOfWeek)
			}
		}
		return daysOfWeek
	}
}
