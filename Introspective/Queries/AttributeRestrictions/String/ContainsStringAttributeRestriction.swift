//
//  ContainsStringAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 8/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class ContainsStringAttributeRestriction: AnyAttributeRestriction, StringAttributeRestriction, PredicateAttributeRestriction, Equatable {

	private typealias Me = ContainsStringAttributeRestriction

	public static func ==(lhs: ContainsStringAttributeRestriction, rhs: ContainsStringAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public static let substringAttribute = TextAttribute(name: "Value", pluralName: "Values")
	public static let attributes: [Attribute] = [
		substringAttribute,
	]

	public final override var attributedName: String { return "Contains" }
	public final override var description: String {
		return restrictedAttribute.name.localizedCapitalized + " contains '" + substring + "'"
	}

	public final var substring: String

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, substring: "")
	}

	public init(restrictedAttribute: Attribute, substring: String = "") {
		self.substring = substring
		super.init(restrictedAttribute: restrictedAttribute, attributes: Me.attributes)
	}

	public final override func value(of attribute: Attribute) throws -> Any? {
		if attribute.name == Me.substringAttribute.name { return substring }
		throw AttributeError.unknownAttribute
	}

	public final override func set(attribute: Attribute, to value: Any?) throws {
		if attribute.name != Me.substringAttribute.name { throw AttributeError.unknownAttribute }
		guard let castedValue = value as? String else { throw AttributeError.typeMismatch }
		substring = castedValue
	}

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		guard let value = try sample.value(of: restrictedAttribute) as? String else { throw AttributeError.typeMismatch }
		return value.contains(substring)
	}

	public final func toPredicate() -> NSPredicate {
		return NSPredicate(format: "%K CONTAINS[cd] %@", restrictedAttribute.variableName!, substring)
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
