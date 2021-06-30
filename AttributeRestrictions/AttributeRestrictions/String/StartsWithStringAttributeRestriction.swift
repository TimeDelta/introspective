//
//  StartsWithStringAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 8/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Samples

public final class StartsWithStringAttributeRestriction: AnyAttributeRestriction, StringAttributeRestriction,
	Equatable {
	private typealias Me = StartsWithStringAttributeRestriction

	// MARK: - Attributes

	public static let prefixAttribute = TextAttribute(id: 0, name: "Value", pluralName: "Values")
	public static let attributes: [Attribute] = [
		prefixAttribute,
	]

	// MARK: - Display Information

	public final override var attributedName: String { "Starts with" }
	public final override var description: String {
		restrictedAttribute.name.localizedCapitalized + " starts with '" + prefix + "'"
	}

	// MARK: - Instance Variables

	public final var prefix: String {
		didSet { prefix = prefix.localizedLowercase }
	}

	// MARK: - Initializers

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, prefix: "")
	}

	public init(restrictedAttribute: Attribute, prefix: String = "") {
		self.prefix = prefix
		super.init(restrictedAttribute: restrictedAttribute, attributes: Me.attributes)
	}

	// MARK: - Attributed Functions

	public final override func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.prefixAttribute) { return prefix }
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final override func set(attribute: Attribute, to value: Any?) throws {
		if !attribute.equalTo(Me.prefixAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		guard let castedValue = value as? String else {
			throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
		}
		prefix = castedValue
	}

	// MARK: - Attribute Restriction Functions

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		if sampleValue == nil { return prefix.isEmpty }
		guard let value = sampleValue as? String else {
			throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: sampleValue))
		}
		return value.localizedLowercase.starts(with: prefix)
	}

	public override func copy() -> AttributeRestriction {
		StartsWithStringAttributeRestriction(restrictedAttribute: restrictedAttribute, prefix: prefix)
	}

	public override func predicate() -> NSPredicate? {
		guard let variableName = restrictedAttribute.variableName else { return nil }
		return NSPredicate(format: "%K BEGINSWITH[cd] %@", variableName, prefix)
	}

	// MARK: - Equality

	public static func == (
		lhs: StartsWithStringAttributeRestriction,
		rhs: StartsWithStringAttributeRestriction
	) -> Bool {
		lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is StartsWithStringAttributeRestriction) { return false }
		let other = otherAttributed as! StartsWithStringAttributeRestriction
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is StartsWithStringAttributeRestriction) { return false }
		let other = otherRestriction as! StartsWithStringAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: StartsWithStringAttributeRestriction) -> Bool {
		restrictedAttribute.equalTo(other.restrictedAttribute) && prefix == other.prefix
	}
}
