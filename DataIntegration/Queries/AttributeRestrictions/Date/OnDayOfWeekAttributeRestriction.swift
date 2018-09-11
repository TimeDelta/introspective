//
//  OnDayOfWeekAttributeRestriction.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class OnDayOfWeekAttributeRestriction: DateAttributeRestriction, Equatable {

	private typealias Me = OnDayOfWeekAttributeRestriction

	public static func ==(lhs: OnDayOfWeekAttributeRestriction, rhs: OnDayOfWeekAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public static let daysOfWeekAttribute = DaysOfWeekAttribute()
	public static var attributes: [Attribute] = [
		daysOfWeekAttribute,
	]

	public final override var name: String { return "On day(s) of the week" }
	public final override var description: String {
		let daysOfWeekText = try! Me.daysOfWeekAttribute.convertToDisplayableString(from: daysOfWeek)
		return "On a " + daysOfWeekText
	}

	public final var daysOfWeek: Set<DayOfWeek>

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, daysOfWeek: Set<DayOfWeek>())
	}

	public required init(restrictedAttribute: Attribute, daysOfWeek: Set<DayOfWeek> = Set<DayOfWeek>()) {
		self.daysOfWeek = daysOfWeek
		super.init(restrictedAttribute: restrictedAttribute, attributes: Me.attributes)
	}

	public final override func value(of attribute: Attribute) throws -> Any {
		if attribute.name != Me.daysOfWeekAttribute.name {
			throw AttributeError.unknownAttribute
		}
		return daysOfWeek
	}

	public final override func set(attribute: Attribute, to value: Any) throws {
		if attribute.name != Me.daysOfWeekAttribute.name {
			throw AttributeError.unknownAttribute
		}
		guard let castedValue = value as? Set<DayOfWeek> else { throw AttributeError.typeMismatch }
		daysOfWeek = castedValue
	}

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		guard let sampleDate = try sample.value(of: restrictedAttribute) as? Date else { throw AttributeError.typeMismatch }
		return DependencyInjector.util.calendarUtil.date(sampleDate, isOnOneOf: daysOfWeek)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is OnDayOfWeekAttributeRestriction) { return false }
		let other = otherAttributed as! OnDayOfWeekAttributeRestriction
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is OnDayOfWeekAttributeRestriction) { return false }
		let other = otherRestriction as! OnDayOfWeekAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: OnDayOfWeekAttributeRestriction) -> Bool {
		return restrictedAttribute.equalTo(other.restrictedAttribute) && daysOfWeek == other.daysOfWeek
	}
}
