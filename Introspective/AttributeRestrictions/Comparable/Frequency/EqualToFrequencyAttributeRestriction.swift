//
//  EqualToFrequencyAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 10/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class EqualToFrequencyAttributeRestriction: TypedEqualToAttributeRestrictionBase<Frequency> {

	private typealias Me = EqualToFrequencyAttributeRestriction
	public static let valueAttribute = FrequencyAttribute(name: "Target Frequency", pluralName: "Target Frequencys")

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, value: Frequency(0, .day)!)
	}

	public init(restrictedAttribute: Attribute, value: Frequency = Frequency(0, .day)!) {
		super.init(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: Me.valueAttribute)
	}

	public override func copy() -> AttributeRestriction {
		return EqualToFrequencyAttributeRestriction(restrictedAttribute: restrictedAttribute, value: value as! Frequency)
	}

	public override func predicate() -> NSPredicate? { return nil }
}
