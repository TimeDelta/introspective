//
//  ContainsStringAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 8/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class ContainsStringAttributeRestriction: AnyAttributeRestriction, StringAttributeRestriction, Equatable {

	private typealias Me = ContainsStringAttributeRestriction

	// MARK: - Attributes

	public static let substringAttribute = TextAttribute(name: "Value", pluralName: "Values")
	public static let attributes: [Attribute] = [
		substringAttribute,
	]

	// MARK: - Display Information

	public final override var attributedName: String { return "Contains" }
	public final override var description: String {
		return restrictedAttribute.name.localizedCapitalized + " contains '" + substring + "'"
	}

	// MARK: - Instance Variables

	public final var substring: String

	// MARK: - Initializers

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, substring: "")
	}

	public init(restrictedAttribute: Attribute, substring: String = "") {
		self.substring = substring
		super.init(restrictedAttribute: restrictedAttribute, attributes: Me.attributes)
	}

	// MARK: - Attributed Functions

	public final override func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.substringAttribute) { return substring }
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final override func set(attribute: Attribute, to value: Any?) throws {
		if !attribute.equalTo(Me.substringAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		guard let castedValue = value as? String else {
			throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
		}
		substring = castedValue
	}

	// MARK: - Attribute Restriction Functions

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		if sampleValue == nil { return substring.isEmpty }
		guard let value = sampleValue as? String else {
			throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: sampleValue))
		}
		return value.contains(substring)
	}

	public override func copy() -> AttributeRestriction {
		return ContainsStringAttributeRestriction(restrictedAttribute: restrictedAttribute, substring: substring)
	}

	public override func predicate() -> NSPredicate? {
		guard let variableName = restrictedAttribute.variableName else { return nil }
		return NSPredicate(format: "%K CONTAINS[cd] %@", variableName, substring)
	}

	// MARK: - Equality

	public static func ==(lhs: ContainsStringAttributeRestriction, rhs: ContainsStringAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is ContainsStringAttributeRestriction) { return false }
		let other = otherAttributed as! ContainsStringAttributeRestriction
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is ContainsStringAttributeRestriction) { return false }
		let other = otherRestriction as! ContainsStringAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: ContainsStringAttributeRestriction) -> Bool {
		return restrictedAttribute.equalTo(other.restrictedAttribute) && substring == other.substring
	}
}
