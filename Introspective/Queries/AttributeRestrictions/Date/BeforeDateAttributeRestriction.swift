//
//  BeforeDateAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 7/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class BeforeDateAttributeRestriction: DateAttributeRestriction, PredicateAttributeRestriction, Equatable {

	private typealias Me = BeforeDateAttributeRestriction

	public static func ==(lhs: BeforeDateAttributeRestriction, rhs: BeforeDateAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public static let dateAttribute = DateOnlyAttribute()
	public static var attributes: [Attribute] = [
		dateAttribute,
	]

	public final override var name: String { return "Before date" }
	public final override var description: String {
		let dateText = try! Me.dateAttribute.convertToDisplayableString(from: date)
		return "Before " + dateText
	}

	public final var date: Date {
		didSet {
			date = DependencyInjector.util.calendarUtil.start(of: .day, in: date)
		}
	}

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, date: Date())
	}

	public init(restrictedAttribute: Attribute, date: Date = Date()) {
		self.date = date
		super.init(restrictedAttribute: restrictedAttribute, attributes: Me.attributes)
	}

	public final override func value(of attribute: Attribute) throws -> Any {
		if attribute.name != Me.dateAttribute.name {
			throw AttributeError.unknownAttribute
		}
		return date
	}

	public final override func set(attribute: Attribute, to value: Any) throws {
		if attribute.name != Me.dateAttribute.name {
			throw AttributeError.unknownAttribute
		}
		guard let castedValue = value as? Date else { throw AttributeError.typeMismatch }
		date = castedValue
	}

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		guard let sampleDate = try sample.value(of: restrictedAttribute) as? Date else { throw AttributeError.typeMismatch }
		return sampleDate.isBeforeDate(date, granularity: .second)
	}

	public final func toPredicate() -> NSPredicate {
		return NSPredicate(format: "%K < %@", restrictedAttribute.variableName, date as NSDate)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is BeforeDateAttributeRestriction) { return false }
		let other = otherAttributed as! BeforeDateAttributeRestriction
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is BeforeDateAttributeRestriction) { return false }
		let other = otherRestriction as! BeforeDateAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: BeforeDateAttributeRestriction) -> Bool {
		return restrictedAttribute.equalTo(other.restrictedAttribute) && date == other.date
	}
}
