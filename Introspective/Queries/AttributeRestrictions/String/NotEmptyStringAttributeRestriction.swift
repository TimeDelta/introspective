//
//  NotEmptyStringAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 3/13/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

public final class NotEmptyStringAttributeRestriction: AnyAttributeRestriction, StringAttributeRestriction {

	// MARK: - Display Information

	public final override var attributedName: String { return "Not Empty" }
	public final override var description: String {
		return restrictedAttribute.name.localizedCapitalized + " is not empty"
	}

	// MARK: - Initializers

	public required init(restrictedAttribute: Attribute) {
		super.init(restrictedAttribute: restrictedAttribute)
	}

	// MARK: - Attribute Restriction Functions

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		if sampleValue == nil { return false }
		guard let value = sampleValue as? String else {
			throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: sampleValue))
		}
		return !value.isEmpty
	}

	public final func toPredicate() -> NSPredicate {
		return NSPredicate(format: "%K.length > 0", restrictedAttribute.variableName!)
	}

	// MARK: - Attributed Functions

	public final override func value(of attribute: Attribute) throws -> Any? {
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final override func set(attribute: Attribute, to value: Any?) throws {
		throw UnknownAttributeError(attribute: attribute, for: self)
	}
}
