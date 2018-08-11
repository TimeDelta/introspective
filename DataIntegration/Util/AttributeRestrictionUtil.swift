//
//  AttributeRestrictionUtil.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/15/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

//sourcery: AutoMockable
public protocol AttributeRestrictionUtil {
	func getMostRestrictiveStartAndEndDates(from attributeRestrictions: [AttributeRestriction]) -> (start: Date?, end: Date?)
	func getDaysOfWeekFrom(attributeRestrictions: [AttributeRestriction]) -> Set<DayOfWeek>
}

public class AttributeRestrictionUtilImpl: AttributeRestrictionUtil {

	public func getMostRestrictiveStartAndEndDates(from attributeRestrictions: [AttributeRestriction]) -> (start: Date?, end: Date?) {
		var latestStartDate: Date? = nil
		var earliestEndDate: Date? = nil
		for attributeRestriction in attributeRestrictions {
			switch (attributeRestriction) {
				case is AfterDateAndTimeAttributeRestriction:
					let restriction = attributeRestriction as! AfterDateAndTimeAttributeRestriction
					if isStartDateRestriction(restriction) && (latestStartDate == nil || restriction.date.isAfterDate(latestStartDate!, granularity: .nanosecond)) {
						latestStartDate = restriction.date
					}
					break
				case is BeforeDateAndTimeAttributeRestriction:
					let restriction = attributeRestriction as! BeforeDateAndTimeAttributeRestriction
					if isEndDateRestriction(restriction) && (earliestEndDate == nil || restriction.date.isBeforeDate(earliestEndDate!, granularity: .nanosecond)) {
						earliestEndDate = restriction.date
					}
					break
				case is OnDateAttributeRestriction:
					let restriction = attributeRestriction as! OnDateAttributeRestriction
					if isStartDateRestriction(restriction) && (latestStartDate == nil || restriction.date.isAfterDate(latestStartDate!, granularity: .nanosecond)) {
						latestStartDate = restriction.date
					} else if isEndDateRestriction(restriction) && (earliestEndDate == nil || restriction.date.isBeforeDate(earliestEndDate!, granularity: .nanosecond)) {
						earliestEndDate = restriction.date
					}
					break
				default:
					os_log("Skipping attribute restriction: $@", type: .debug, attributeRestriction.description)
					break
			}
		}
		return (start: latestStartDate, end: earliestEndDate)
	}

	public func getDaysOfWeekFrom(attributeRestrictions: [AttributeRestriction]) -> Set<DayOfWeek> {
		var daysOfWeek = Set<DayOfWeek>()
		for attributeRestriction in attributeRestrictions {
			if attributeRestriction is OnDayOfWeekAttributeRestriction {
				let restriction = attributeRestriction as! OnDayOfWeekAttributeRestriction
				daysOfWeek = daysOfWeek.union(restriction.daysOfWeek)
			}
		}
		return daysOfWeek
	}

	fileprivate func isStartDateRestriction(_ restriction: AttributeRestriction) -> Bool {
		return restriction.restrictedAttribute.name == CommonSampleAttributes.startDate.name
			|| restriction.restrictedAttribute.name == CommonSampleAttributes.timestamp.name
	}

	fileprivate func isEndDateRestriction(_ restriction: AttributeRestriction) -> Bool {
		return restriction.restrictedAttribute.name == CommonSampleAttributes.endDate.name
	}
}
