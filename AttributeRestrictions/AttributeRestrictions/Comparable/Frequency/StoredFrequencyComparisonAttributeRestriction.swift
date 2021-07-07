//
//  StoredFrequencyComparisonAttributeRestriction.swift
//  AttributeRestrictions
//
//  Created by Bryan Nova on 6/30/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

import BooleanAlgebra
import Common
import DependencyInjection
import Persistence
import Samples

public final class StoredFrequencyComparisonAttributeRestriction: StoredBooleanExpression, CoreDataObject {
	private typealias Me = StoredFrequencyComparisonAttributeRestriction
	public static let entityName = "FrequencyComparisonAttributeRestriction"

	public override func convert() throws -> BooleanExpression {
		let sampleType: Sample.Type = injected(SampleFactory.self).sampleType(for: sampleTypeId)
		guard let attribute = sampleType.attributes.first(where: { $0.id == attributeId }) else {
			throw GenericError("Unable to determine attribute")
		}
		switch comparison {
		case Comparison.lessThan.rawValue:
			return LessThanFrequencyAttributeRestriction(restrictedAttribute: attribute, value: value)
		case Comparison.lessThanOrEqual.rawValue:
			return LessThanOrEqualToFrequencyAttributeRestriction(restrictedAttribute: attribute, value: value)
		case Comparison.equalTo.rawValue:
			return EqualToFrequencyAttributeRestriction(restrictedAttribute: attribute, value: value)
		case Comparison.notEqualTo.rawValue:
			return NotEqualToFrequencyAttributeRestriction(restrictedAttribute: attribute, value: value)
		case Comparison.greaterThanOrEqual.rawValue:
			return GreaterThanOrEqualToFrequencyAttributeRestriction(restrictedAttribute: attribute, value: value)
		case Comparison.greaterThan.rawValue:
			return GreaterThanFrequencyAttributeRestriction(restrictedAttribute: attribute, value: value)
		default:
			throw GenericError("Invalid comparison value for StoredFrequencyComparisonAttributeRestriction")
		}
	}

	public func populate(from other: FrequencyAttributeRestriction, for sampleType: Sample.Type) throws {
		sampleTypeId = injected(SampleFactory.self).sampleTypeId(for: sampleType)
		attributeId = other.restrictedAttribute.id
		switch other {
		case is LessThanFrequencyAttributeRestriction:
			comparison = Comparison.lessThan.rawValue
			break
		case is LessThanOrEqualToFrequencyAttributeRestriction:
			comparison = Comparison.lessThanOrEqual.rawValue
			break
		case is EqualToFrequencyAttributeRestriction:
			comparison = Comparison.equalTo.rawValue
			break
		case is NotEqualToFrequencyAttributeRestriction:
			comparison = Comparison.notEqualTo.rawValue
			break
		case is GreaterThanOrEqualToFrequencyAttributeRestriction:
			comparison = Comparison.greaterThanOrEqual.rawValue
			break
		case is GreaterThanFrequencyAttributeRestriction:
			comparison = Comparison.greaterThan.rawValue
			break
		default:
			throw GenericError("Forgot a type of FrequencyAttributeRestriction")
		}
		value = other.typedValue
	}
}

extension StoredFrequencyComparisonAttributeRestriction {
	@NSManaged private var sampleTypeId: Int16
	@NSManaged private var attributeId: Int16
	@NSManaged private var comparison: Int16
	@NSManaged private var value: Frequency
}
