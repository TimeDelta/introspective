//
//  NotEqualToFrequencyAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 10/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import BooleanAlgebra
import Common
import DependencyInjection
import Persistence
import Samples

public final class NotEqualToFrequencyAttributeRestriction: TypedNotEqualToAttributeRestrictionBase<Frequency>, FrequencyAttributeRestriction {
	private typealias Me = NotEqualToFrequencyAttributeRestriction
	public static let valueAttribute = FrequencyAttribute(id: 0, name: "Target Frequency", pluralName: "Target Frequencys")

	public var typedValue: Frequency {
		return value as! Frequency
	}

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, value: Frequency(0, .day)!)
	}

	public init(restrictedAttribute: Attribute, value: Frequency = Frequency(0, .day)!) {
		super.init(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: Me.valueAttribute)
	}

	public override func copy() -> AttributeRestriction {
		NotEqualToFrequencyAttributeRestriction(restrictedAttribute: restrictedAttribute, value: value as! Frequency)
	}

	public override func predicate() -> NSPredicate? { nil }

	public override func stored(for sampleType: Sample.Type) throws -> StoredBooleanExpression {
		let transaction = injected(Database.self).transaction()
		let stored = try transaction.new(StoredFrequencyComparisonAttributeRestriction.self)
		try stored.populate(from: self, for: sampleType)
		try transaction.commit()
		return stored
	}
}
