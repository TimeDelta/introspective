//
//  EndsWithStringAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 8/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class EndsWithStringAttributeRestriction: AnyAttributeRestriction, StringAttributeRestriction, PredicateAttributeRestriction, Equatable {

	private typealias Me = EndsWithStringAttributeRestriction

	// MARK: - Attributes

	public static let suffixAttribute = TextAttribute(name: "Value", pluralName: "Values")
	public static let attributes: [Attribute] = [
		suffixAttribute,
	]

	// MARK: - Display Information

	public final override var attributedName: String { return "Ends with" }
	public final override var description: String {
		return restrictedAttribute.name.localizedCapitalized + " ends with '" + suffix + "'"
	}

	// MARK: - Instance Variables

	public final var suffix: String {
		didSet { suffix = suffix.localizedLowercase }
	}

	// MARK: - Initializers

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, suffix: "")
	}

	public init(restrictedAttribute: Attribute, suffix: String = "") {
		self.suffix = suffix
		super.init(restrictedAttribute: restrictedAttribute, attributes: Me.attributes)
	}

	// MARK: - Attributed Functions

	public final override func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.suffixAttribute) { return suffix }
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final override func set(attribute: Attribute, to value: Any?) throws {
		if !attribute.equalTo(Me.suffixAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		guard let castedValue = value as? String else {
			throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
		}
		suffix = castedValue
	}

	// MARK: - Attribute Restriction Functions

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		if sampleValue == nil { return suffix.isEmpty }
		guard let value = sampleValue as? String else {
			throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: sampleValue))
		}
		return value.localizedLowercase.hasSuffix(suffix)
	}

	public override func copy() -> AttributeRestriction {
		return EndsWithStringAttributeRestriction(restrictedAttribute: restrictedAttribute, suffix: suffix)
	}

	public final func toPredicate() -> NSPredicate {
		return NSPredicate(format: "%K ENDSWITH[cd] %@", restrictedAttribute.variableName!, suffix)
	}

	// MARK: - Equality

	public static func ==(lhs: EndsWithStringAttributeRestriction, rhs: EndsWithStringAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is EndsWithStringAttributeRestriction) { return false }
		let other = otherAttributed as! EndsWithStringAttributeRestriction
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is EndsWithStringAttributeRestriction) { return false }
		let other = otherRestriction as! EndsWithStringAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: EndsWithStringAttributeRestriction) -> Bool {
		return restrictedAttribute.equalTo(other.restrictedAttribute) && suffix == other.suffix
	}
}