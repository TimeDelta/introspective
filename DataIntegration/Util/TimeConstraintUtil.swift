//
//  TimeConstraintUtil.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/15/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class TimeConstraintUtil {

	public func getDateConstraintsFrom(timeConstraints: Set<TimeConstraint>) -> [(start: Date?, end: Date?, type: TimeConstraint.ConstraintType)] {
		var constraints = [(start: Date?, end: Date?, type: TimeConstraint.ConstraintType)]()
		for timeConstraint in timeConstraints {
			if timeConstraint.specificDate != nil {
				if timeConstraint.useStartOrEndDate == .start {
					constraints.append((start: timeConstraint.specificDate!, end: nil, type: timeConstraint.constraintType))
				} else {
					constraints.append((start: nil, end: timeConstraint.specificDate!, type: timeConstraint.constraintType))
				}
			}
		}
		return constraints
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

	/// - Precondition: All passed time constraints are valid
	public func sample(_ sample: Sample, meets timeConstraints: Set<TimeConstraint>) -> Bool {
		for timeConstraint in timeConstraints {
			assert(timeConstraint.isValid(), "Precondition violated: invalid time constraint passed")
		}

		let daysOfWeek = getDaysOfWeekFrom(timeConstraints: timeConstraints)
		if !daysOfWeek.isEmpty {
			if !DependencyInjector.util.sampleUtil.sample(sample, occursOnOneOf: daysOfWeek) {
				return false
			}
		}

		let dateConstraints = getDateConstraintsFrom(timeConstraints: timeConstraints)
		for constraint in dateConstraints {
			if constraint.start != nil {
				if !date(sample.dates[.start]!, matches: constraint.type, to: constraint.start!) {
					return false
				}
			} else if constraint.end != nil {
				if !date(sample.dates[.end]!, matches: constraint.type, to: constraint.end!) {
					return false
				}
			}
		}

		return true
	}

	fileprivate func date(_ date1: Date, matches constraint: TimeConstraint.ConstraintType, to date2: Date) -> Bool {
		switch (constraint) {
			case .before:
				if !date1.isBeforeDate(date2, granularity: .minute) {
					return false
				}
				break
			case .after:
				if !date1.isAfterDate(date2, granularity: .minute) {
					return false
				}
				break
			case .on:
				if !DependencyInjector.util.calendarUtil.date(date1, occursOnSame: .day, as: date2) {
					return false
				}
		}
		return true
	}
}
