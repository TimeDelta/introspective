//
//  StoredIntegerComparisonAttributeRestriction.swift
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

public final class StoredIntegerComparisonAttributeRestriction: StoredBooleanExpression, CoreDataObject {
	private typealias Me = StoredIntegerComparisonAttributeRestriction
	public static let entityName = "IntegerComparisonAttributeRestriction"

	public override func convert() throws -> BooleanExpression {
		let sampleType: Sample.Type = injected(SampleFactory.self).sampleType(for: sampleTypeId)
		guard let attribute = sampleType.attributes.first(where: { $0.id == attributeId }) else {
			throw GenericError("Unable to determine attribute")
		}
		switch comparison {
		case Comparison.lessThan.rawValue:
			return LessThanIntegerAttributeRestriction(restrictedAttribute: attribute, value: Int(value))
		case Comparison.lessThanOrEqual.rawValue:
			return LessThanOrEqualToIntegerAttributeRestriction(restrictedAttribute: attribute, value: Int(value))
		case Comparison.equalTo.rawValue:
			return EqualToIntegerAttributeRestriction(restrictedAttribute: attribute, value: Int(value))
		case Comparison.notEqualTo.rawValue:
			return NotEqualToIntegerAttributeRestriction(restrictedAttribute: attribute, value: Int(value))
		case Comparison.greaterThanOrEqual.rawValue:
			return GreaterThanOrEqualToIntegerAttributeRestriction(restrictedAttribute: attribute, value: Int(value))
		case Comparison.greaterThan.rawValue:
			return GreaterThanIntegerAttributeRestriction(restrictedAttribute: attribute, value: Int(value))
		default:
			throw GenericError("Invalid comparison value for StoredIntegerComparisonAttributeRestriction")
		}
	}

	public func populate(from other: IntegerAttributeRestriction, for sampleType: Sample.Type) throws {
		sampleTypeId = injected(SampleFactory.self).sampleTypeId(for: sampleType)
		attributeId = other.restrictedAttribute.id
		switch other {
		case is LessThanIntegerAttributeRestriction:
			comparison = Comparison.lessThan.rawValue
		case is LessThanOrEqualToIntegerAttributeRestriction:
			comparison = Comparison.lessThanOrEqual.rawValue
		case is EqualToIntegerAttributeRestriction:
			comparison = Comparison.equalTo.rawValue
		case is NotEqualToIntegerAttributeRestriction:
			comparison = Comparison.notEqualTo.rawValue
		case is GreaterThanOrEqualToIntegerAttributeRestriction:
			comparison = Comparison.greaterThanOrEqual.rawValue
		case is GreaterThanIntegerAttributeRestriction:
			comparison = Comparison.greaterThan.rawValue
		default:
			throw GenericError("Forgot a type of IntegerAttributeRestriction")
		}
		value = Int64(other.typedValue)
	}
}

extension StoredIntegerComparisonAttributeRestriction {
	@NSManaged private var sampleTypeId: Int16
	@NSManaged private var attributeId: Int16
	@NSManaged private var comparison: Int16
	@NSManaged private var value: Int64
}
