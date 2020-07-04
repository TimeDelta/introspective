//
//  EmptyStringAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 3/13/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Samples

public final class EmptyStringAttributeRestriction: AnyAttributeRestriction, StringAttributeRestriction {
	// MARK: - Display Information

	override public final var attributedName: String { "Empty" }
	override public final var description: String {
		restrictedAttribute.name.localizedCapitalized + " is empty"
	}

	// MARK: - Initializers

	public required init(restrictedAttribute: Attribute) {
		super.init(restrictedAttribute: restrictedAttribute)
	}

	// MARK: - Attribute Restriction Functions

	override public final func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		if sampleValue == nil { return true }
		guard let value = sampleValue as? String else {
			throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: sampleValue))
		}
		return value.isEmpty
	}

	override public func copy() -> AttributeRestriction {
		EmptyStringAttributeRestriction(restrictedAttribute: restrictedAttribute)
	}

	override public func predicate() -> NSPredicate? {
		guard let variableName = restrictedAttribute.variableName else { return nil }
		return NSPredicate(format: "%K.length == 0", variableName)
	}

	// MARK: - Attributed Functions

	override public final func value(of attribute: Attribute) throws -> Any? {
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	override public final func set(attribute: Attribute, to _: Any?) throws {
		throw UnknownAttributeError(attribute: attribute, for: self)
	}
}
