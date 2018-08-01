//
//  EndsOnDayOfWeekTimeConstraint.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class EndsOnDayOfWeekTimeConstraint: TimeConstraint {

	fileprivate typealias Me = EndsOnDayOfWeekTimeConstraint

	public static let daysOfWeekAttribute = DaysOfWeekAttribute()
	public static var attributes: [Attribute] = [
		daysOfWeekAttribute,
	]

	public let name: String = "Ends on day of week"
	public let attributes: [Attribute] = Me.attributes
	public var description: String {
		let daysOfWeekText = try! Me.daysOfWeekAttribute.convertToDisplayableString(from: daysOfWeek)
		return "Ends on " + daysOfWeekText
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
		let sampleEndDate = sample.dates[.end]!
		return DependencyInjector.util.calendarUtil.date(sampleEndDate, isOneOf: daysOfWeek)
	}

	fileprivate func sortDaysOfWeek() -> [DayOfWeek] {
		return daysOfWeek.sorted { (day1, day2) -> Bool in
			day1.intValue < day2.intValue
		}
	}
}
