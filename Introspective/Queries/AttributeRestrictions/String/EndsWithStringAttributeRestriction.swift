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

	public static func ==(lhs: EndsWithStringAttributeRestriction, rhs: EndsWithStringAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public static let suffixAttribute = TextAttribute(name: "Value", pluralName: "Values")
	public static let attributes: [Attribute] = [
		suffixAttribute,
	]

	public final override var attributedName: String { return "Text ends with" }
	public final override var description: String {
		return restrictedAttribute.name.localizedCapitalized + " ends with '" + suffix + "'"
	}

	public final var suffix: String

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, suffix: "")
	}

	public init(restrictedAttribute: Attribute, suffix: String = "") {
		self.suffix = suffix
		super.init(restrictedAttribute: restrictedAttribute, attributes: Me.attributes)
	}

	public final override func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.suffixAttribute) { return suffix }
		throw AttributeError.unknownAttribute
	}

	public final override func set(attribute: Attribute, to value: Any?) throws {
		if attribute.name != Me.suffixAttribute.name { throw AttributeError.unknownAttribute }
		guard let castedValue = value as? String else { throw AttributeError.typeMismatch }
		suffix = castedValue
	}

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		guard let value = try sample.value(of: restrictedAttribute) as? String else { throw AttributeError.typeMismatch }
		return value.hasSuffix(suffix)
	}

	public final func toPredicate() -> NSPredicate {
		return NSPredicate(format: "%K ENDSWITH[cd] %@", restrictedAttribute.variableName!, suffix)
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
