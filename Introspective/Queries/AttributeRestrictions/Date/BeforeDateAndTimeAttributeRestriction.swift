//
//  BeforeDateAndTimeAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class BeforeDateAndTimeAttributeRestriction: DateAttributeRestriction, PredicateAttributeRestriction, Equatable {

	private typealias Me = BeforeDateAndTimeAttributeRestriction

	public static func ==(lhs: BeforeDateAndTimeAttributeRestriction, rhs: BeforeDateAndTimeAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public static let dateAttribute = DateTimeAttribute(name: "Date")
	public static var attributes: [Attribute] = [
		dateAttribute,
	]

	public final override var attributedName: String { return "Before date and time" }
	public final override var description: String {
		let dateText = try! Me.dateAttribute.convertToDisplayableString(from: date)
		return "Before " + dateText
	}

	public var date: Date

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
		return sampleDate.isBeforeDate(date, granularity: .nanosecond)
	}

	public final func toPredicate() -> NSPredicate {
		return NSPredicate(format: "%K < %@", restrictedAttribute.variableName!, date as NSDate)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is BeforeDateAndTimeAttributeRestriction) { return false }
		let other = otherAttributed as! BeforeDateAndTimeAttributeRestriction
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is BeforeDateAndTimeAttributeRestriction) { return false }
		let other = otherRestriction as! BeforeDateAndTimeAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: BeforeDateAndTimeAttributeRestriction) -> Bool {
		return restrictedAttribute.equalTo(other.restrictedAttribute) && date == other.date
	}
}
