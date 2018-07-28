//
//  StartsOnWeekdayTimeConstraint.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class StartsOnDayOfWeekTimeConstraint: TimeConstraint {

	public static var name: String = "Starts on day of week"

	fileprivate typealias Me = StartsOnDayOfWeekTimeConstraint

	public static let daysOfWeekParameter = DaysOfWeekParameter()
	public static var parameters: [Parameter] = [
		daysOfWeekParameter,
	]

	public var description: String {
		let daysOfWeekText = try! Me.daysOfWeekParameter.convertToDisplayableString(from: daysOfWeek)
		return "Starts on " + daysOfWeekText
	}

	public fileprivate(set) var daysOfWeek: Set<DayOfWeek>

	public required init() {
		daysOfWeek = Set<DayOfWeek>()
	}

	public func get(parameter: Parameter) throws -> Any {
		if parameter.name != Me.daysOfWeekParameter.name {
			throw ParameterError.unknownParameter
		}
		return daysOfWeek
	}

	public func set(parameter: Parameter, to value: Any) throws {
		if parameter.name != Me.daysOfWeekParameter.name {
			throw ParameterError.unknownParameter
		}
		guard let castedValue = value as? Set<DayOfWeek> else { throw ParameterError.typeMismatch }
		daysOfWeek = castedValue
	}

	public func isValid() -> Bool {
		return true
	}

	public func sampleAdheres(_ sample: Sample) -> Bool {
		let sampleStartDate = sample.dates[.start]!
		return DependencyInjector.util.calendarUtil.date(sampleStartDate, isOneOf: daysOfWeek)
	}

	fileprivate func sortDaysOfWeek() -> [DayOfWeek] {
		return daysOfWeek.sorted { (day1, day2) -> Bool in
			return day1.intValue < day2.intValue
		}
	}
}
