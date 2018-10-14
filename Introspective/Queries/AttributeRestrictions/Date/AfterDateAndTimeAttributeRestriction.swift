//
//  AfterDateAndTimeAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 7/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class AfterDateAndTimeAttributeRestriction: DateAttributeRestriction, PredicateAttributeRestriction, Equatable {

	private typealias Me = AfterDateAndTimeAttributeRestriction

	public static func ==(lhs: AfterDateAndTimeAttributeRestriction, rhs: AfterDateAndTimeAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public static let dateAttribute = DateTimeAttribute()
	public static var attributes: [Attribute] = [
		dateAttribute,
	]

	public final override var attributedName: String { return "After date and time" }
	public final override var description: String {
		let dateText = try! Me.dateAttribute.convertToDisplayableString(from: date)
		return "After " + dateText
	}

	public final var date: Date

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, date: Date())
	}

	public init(restrictedAttribute: Attribute, date: Date = Date()) {
		self.date = date
		super.init(restrictedAttribute: restrictedAttribute, attributes: Me.attributes)
	}

	public final override func value(of attribute: Attribute) throws -> Any? {
		if attribute.name != Me.dateAttribute.name {
			throw AttributeError.unknownAttribute
		}
		return date
	}

	public final override func set(attribute: Attribute, to value: Any?) throws {
		if attribute.name != Me.dateAttribute.name {
			throw AttributeError.unknownAttribute
		}
		guard let castedValue = value as? Date else { throw AttributeError.typeMismatch }
		date = castedValue
	}

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		guard let sampleDate = try sample.value(of: restrictedAttribute) as? Date else { throw AttributeError.typeMismatch }
		return sampleDate.isAfterDate(date, granularity: .nanosecond)
	}

	public final func toPredicate() -> NSPredicate {
		return NSPredicate(format: "%K > %@", restrictedAttribute.variableName!, date as NSDate)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is AfterDateAndTimeAttributeRestriction) { return false }
		let other = otherAttributed as! AfterDateAndTimeAttributeRestriction
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is AfterDateAndTimeAttributeRestriction) { return false }
		let other = otherRestriction as! AfterDateAndTimeAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: AfterDateAndTimeAttributeRestriction) -> Bool {
		return restrictedAttribute.equalTo(other.restrictedAttribute) && date == other.date
	}
}
