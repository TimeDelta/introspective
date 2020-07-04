//
//  EndsWithStringAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 8/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Samples

public final class EndsWithStringAttributeRestriction: AnyAttributeRestriction, StringAttributeRestriction, Equatable {
	private typealias Me = EndsWithStringAttributeRestriction

	// MARK: - Attributes

	public static let suffixAttribute = TextAttribute(name: "Value", pluralName: "Values")
	public static let attributes: [Attribute] = [
		suffixAttribute,
	]

	// MARK: - Display Information

	override public final var attributedName: String { "Ends with" }
	override public final var description: String {
		restrictedAttribute.name.localizedCapitalized + " ends with '" + suffix + "'"
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

	override public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.suffixAttribute) { return suffix }
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	override public final func set(attribute: Attribute, to value: Any?) throws {
		if !attribute.equalTo(Me.suffixAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		guard let castedValue = value as? String else {
			throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
		}
		suffix = castedValue
	}

	// MARK: - Attribute Restriction Functions

	override public final func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		if sampleValue == nil { return suffix.isEmpty }
		guard let value = sampleValue as? String else {
			throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: sampleValue))
		}
		return value.localizedLowercase.hasSuffix(suffix)
	}

	override public func copy() -> AttributeRestriction {
		EndsWithStringAttributeRestriction(restrictedAttribute: restrictedAttribute, suffix: suffix)
	}

	override public func predicate() -> NSPredicate? {
		guard let variableName = restrictedAttribute.variableName else { return nil }
		return NSPredicate(format: "%K ENDSWITH[cd] %@", variableName, suffix)
	}

	// MARK: - Equality

	public static func == (lhs: EndsWithStringAttributeRestriction, rhs: EndsWithStringAttributeRestriction) -> Bool {
		lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is EndsWithStringAttributeRestriction) { return false }
		let other = otherAttributed as! EndsWithStringAttributeRestriction
		return equalTo(other)
	}

	override public final func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is EndsWithStringAttributeRestriction) { return false }
		let other = otherRestriction as! EndsWithStringAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: EndsWithStringAttributeRestriction) -> Bool {
		restrictedAttribute.equalTo(other.restrictedAttribute) && suffix == other.suffix
	}
}
