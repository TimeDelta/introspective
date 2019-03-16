//
//  IsTodayDateAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 3/15/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

public final class IsTodayDateAttributeRestriction: DateAttributeRestriction, Equatable {

	// MARK: - Display Information

	public final override var attributedName: String { return "Is Today" }
	public final override var description: String {
		return restrictedAttribute.name + " " + attributedName.localizedLowercase
	}

	// MARK: - Instance Variables

	private final let log = Log()

	// MARK: - Initializers

	public required init(restrictedAttribute: Attribute) {
		super.init(restrictedAttribute: restrictedAttribute, attributes: [])
	}

	// MARK: - Attribute Functions

	public final override func value(of attribute: Attribute) throws -> Any? {
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final override func set(attribute: Attribute, to value: Any?) throws {
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	// MARk: - Attribute Restriction Functions

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		if sampleValue == nil { return false }
		guard let sampleDate = sampleValue as? Date else {
			throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: sampleValue))
		}
		return sampleDate.isToday()
	}

	// MARK: - Equality

	public static func ==(lhs: IsTodayDateAttributeRestriction, rhs: IsTodayDateAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is IsTodayDateAttributeRestriction) { return false }
		let other = otherAttributed as! IsTodayDateAttributeRestriction
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is IsTodayDateAttributeRestriction) { return false }
		let other = otherRestriction as! IsTodayDateAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: IsTodayDateAttributeRestriction) -> Bool {
		return restrictedAttribute.equalTo(other.restrictedAttribute)
	}
}
