//
//  BeforeDateAndTimeAttributeRestriction.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class BeforeDateAndTimeAttributeRestriction: DateAttributeRestriction, PredicateAttributeRestriction, Equatable {

	fileprivate typealias Me = BeforeDateAndTimeAttributeRestriction

	public static func ==(lhs: BeforeDateAndTimeAttributeRestriction, rhs: BeforeDateAndTimeAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public static let dateAttribute = DateTimeAttribute()
	public static var attributes: [Attribute] = [
		dateAttribute,
	]

	public override var name: String { return "Before date and time" }
	public override var description: String {
		let dateText = try! Me.dateAttribute.convertToDisplayableString(from: date)
		return "Before " + dateText
	}

	public var date: Date

	public required convenience init(attribute: Attribute) {
		self.init(attribute: attribute, date: Date())
	}

	public init(attribute: Attribute, date: Date = Date()) {
		self.date = date
		super.init(attribute: attribute, attributes: Me.attributes)
	}

	public override func value(of attribute: Attribute) throws -> Any {
		if attribute.name != Me.dateAttribute.name {
			throw AttributeError.unknownAttribute
		}
		return date
	}

	public override func set(attribute: Attribute, to value: Any) throws {
		if attribute.name != Me.dateAttribute.name {
			throw AttributeError.unknownAttribute
		}
		guard let castedValue = value as? Date else { throw AttributeError.typeMismatch }
		date = castedValue
	}

	public override func samplePasses(_ sample: Sample) throws -> Bool {
		guard let sampleDate = try sample.value(of: restrictedAttribute) as? Date else { throw SampleError.typeMismatch }
		return sampleDate.isBeforeDate(date, granularity: .second)
	}

	public func toPredicate() -> NSPredicate {
		return NSPredicate(format: "%K < %@", restrictedAttribute.variableName, date as NSDate)
	}

	public func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is BeforeDateAndTimeAttributeRestriction) { return false }
		let other = otherAttributed as! BeforeDateAndTimeAttributeRestriction
		return equalTo(other)
	}

	public func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is BeforeDateAndTimeAttributeRestriction) { return false }
		let other = otherRestriction as! BeforeDateAndTimeAttributeRestriction
		return equalTo(other)
	}

	public func equalTo(_ other: BeforeDateAndTimeAttributeRestriction) -> Bool {
		return date == other.date
	}
}
