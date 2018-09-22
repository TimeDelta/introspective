//
//  EqualToSelectOneAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 9/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class EqualToSelectOneAttributeRestriction: EqualToAttributeRestriction {

	public static func ==(lhs: EqualToSelectOneAttributeRestriction, rhs: EqualToSelectOneAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	private final let selectOneAttribute: SelectOneAttribute

	public init(restrictedAttribute: Attribute, value: Any, valueAttribute: SelectOneAttribute) {
		selectOneAttribute = valueAttribute
		super.init(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: valueAttribute, areEqual: { valueAttribute.valuesAreEqual($0, $1) })
	}

	public required convenience init(restrictedAttribute: Attribute) {
		let selectAttribute = restrictedAttribute as! SelectOneAttribute
		let initialValue = selectAttribute.possibleValues[0]
		self.init(restrictedAttribute: restrictedAttribute, value: initialValue, valueAttribute: selectAttribute)
	}

	public final override func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is EqualToSelectOneAttributeRestriction) { return false }
		let other = otherAttributed as! EqualToSelectOneAttributeRestriction
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is EqualToSelectOneAttributeRestriction) { return false }
		let other = otherRestriction as! EqualToSelectOneAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: EqualToSelectOneAttributeRestriction) -> Bool {
		return restrictedAttribute.equalTo(other.restrictedAttribute) && selectOneAttribute.valuesAreEqual(value, other.value)
	}
}
