//
//  StartsWithStringAttributeRestriction.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class StartsWithStringAttributeRestriction: AnyAttributeRestriction, StringAttributeRestriction, PredicateAttributeRestriction, Equatable {

	private typealias Me = StartsWithStringAttributeRestriction

	public static func ==(lhs: StartsWithStringAttributeRestriction, rhs: StartsWithStringAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public static let prefixAttribute = TextAttribute(name: "Value", pluralName: "Values")
	public static let attributes: [Attribute] = [
		prefixAttribute,
	]

	public final override var name: String { return "Text starts with" }
	public final override var description: String {
		return restrictedAttribute.name.localizedCapitalized + " starts with '" + prefix + "'"
	}

	public final var prefix: String

	public required convenience init(attribute: Attribute) {
		self.init(attribute: attribute, prefix: "")
	}

	public init(attribute: Attribute, prefix: String = "") {
		self.prefix = prefix
		super.init(attribute: attribute, attributes: Me.attributes)
	}

	public final override func value(of attribute: Attribute) throws -> Any {
		if attribute.name == Me.prefixAttribute.name { return prefix }
		throw AttributeError.unknownAttribute
	}

	public final override func set(attribute: Attribute, to value: Any) throws {
		if attribute.name != Me.prefixAttribute.name { throw AttributeError.unknownAttribute }
		guard let castedValue = value as? String else { throw AttributeError.typeMismatch }
		prefix = castedValue
	}

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		guard let value = try sample.value(of: restrictedAttribute) as? String else { throw AttributeError.typeMismatch }
		return value.starts(with: prefix)
	}

	public final func toPredicate() -> NSPredicate {
		return NSPredicate(format: "%K BEGINSWITH[cd] %@", restrictedAttribute.variableName, prefix)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is StartsWithStringAttributeRestriction) { return false }
		let other = otherAttributed as! StartsWithStringAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is StartsWithStringAttributeRestriction) { return false }
		let other = otherRestriction as! StartsWithStringAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: StartsWithStringAttributeRestriction) -> Bool {
		return restrictedAttribute.equalTo(other.restrictedAttribute) && prefix == other.prefix
	}
}

