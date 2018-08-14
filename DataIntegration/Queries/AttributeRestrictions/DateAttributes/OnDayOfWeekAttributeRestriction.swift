//
//  OnDayOfWeekAttributeRestriction.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class OnDayOfWeekAttributeRestriction: DateAttributeRestriction {

	fileprivate typealias Me = OnDayOfWeekAttributeRestriction

	public static let daysOfWeekAttribute = DaysOfWeekAttribute()
	public static var attributes: [Attribute] = [
		daysOfWeekAttribute,
	]

	public override var name: String { return "On day(s) of the week" }
	public override var description: String {
		let daysOfWeekText = try! Me.daysOfWeekAttribute.convertToDisplayableString(from: daysOfWeek)
		return "On a " + daysOfWeekText
	}

	public var daysOfWeek: Set<DayOfWeek>

	public required init(attribute: Attribute) {
		daysOfWeek = Set<DayOfWeek>()
		super.init(attribute: attribute, attributes: Me.attributes)
	}

	public override func value(of attribute: Attribute) throws -> Any {
		if attribute.name != Me.daysOfWeekAttribute.name {
			throw AttributeError.unknownAttribute
		}
		return daysOfWeek
	}

	public override func set(attribute: Attribute, to value: Any) throws {
		if attribute.name != Me.daysOfWeekAttribute.name {
			throw AttributeError.unknownAttribute
		}
		guard let castedValue = value as? Set<DayOfWeek> else { throw AttributeError.typeMismatch }
		daysOfWeek = castedValue
	}

	public override func samplePasses(_ sample: Sample) throws -> Bool {
		guard let sampleDate = try sample.value(of: restrictedAttribute) as? Date else { throw SampleError.typeMismatch }
		return DependencyInjector.util.calendarUtil.date(sampleDate, isOneOf: daysOfWeek)
	}
}
