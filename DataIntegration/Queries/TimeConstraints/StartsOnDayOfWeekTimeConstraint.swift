//
//  StartsOnWeekdayTimeConstraint.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class StartsOnDayOfWeekTimeConstraint: TimeConstraint {

	fileprivate typealias Me = StartsOnDayOfWeekTimeConstraint

	public static let daysOfWeekAttribute = DaysOfWeekAttribute()
	public static var attributes: [Attribute] = [
		daysOfWeekAttribute,
	]

	public let name: String = "Starts on day of week"
	public let attributes: [Attribute] = Me.attributes
	public var description: String {
		let daysOfWeekText = try! Me.daysOfWeekAttribute.convertToDisplayableString(from: daysOfWeek)
		return "Starts on " + daysOfWeekText
	}

	public fileprivate(set) var daysOfWeek: Set<DayOfWeek>

	public required init() {
		daysOfWeek = Set<DayOfWeek>()
	}

	public func value(of attribute: Attribute) throws -> Any {
		if attribute.name != Me.daysOfWeekAttribute.name {
			throw AttributeError.unknownAttribute
		}
		return daysOfWeek
	}

	public func set(attribute: Attribute, to value: Any) throws {
		if attribute.name != Me.daysOfWeekAttribute.name {
			throw AttributeError.unknownAttribute
		}
		guard let castedValue = value as? Set<DayOfWeek> else { throw AttributeError.typeMismatch }
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
