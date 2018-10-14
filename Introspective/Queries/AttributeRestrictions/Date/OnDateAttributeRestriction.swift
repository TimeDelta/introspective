//
//  OnDateAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftDate

public final class OnDateAttributeRestriction: DateAttributeRestriction, PredicateAttributeRestriction, Equatable {

	private typealias Me = OnDateAttributeRestriction

	public static func ==(lhs: OnDateAttributeRestriction, rhs: OnDateAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public static let dateAttribute = DateOnlyAttribute()
	public static var attributes: [Attribute] = [
		dateAttribute,
	]

	public final override var attributedName: String { return "On a specific date" }
	public final override var description: String {
		let dateText = try! Me.dateAttribute.convertToDisplayableString(from: date)
		return "On " + dateText
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
		return DependencyInjector.util.calendarUtil.date(sampleDate, occursOnSame: .day, as: date)
	}

	public final func toPredicate() -> NSPredicate {
		let nextDay = Calendar.autoupdatingCurrent.date(byAdding: .day, value: 1, to: date)!
		return NSPredicate(format: "%K >= %@ AND %K < %@", restrictedAttribute.variableName!, date as NSDate, restrictedAttribute.variableName!, nextDay as NSDate)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is OnDateAttributeRestriction) { return false }
		let other = otherAttributed as! OnDateAttributeRestriction
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is OnDateAttributeRestriction) { return false }
		let other = otherRestriction as! OnDateAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: OnDateAttributeRestriction) -> Bool {
		return restrictedAttribute.equalTo(other.restrictedAttribute) && date == other.date
	}
}
