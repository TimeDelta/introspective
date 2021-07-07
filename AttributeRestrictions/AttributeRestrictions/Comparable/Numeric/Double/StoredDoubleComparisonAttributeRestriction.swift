//
//  StoredDoubleComparisonAttributeRestriction.swift
//  AttributeRestrictions
//
//  Created by Bryan Nova on 6/29/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

import BooleanAlgebra
import Common
import DependencyInjection
import Persistence
import Samples

public final class StoredDoubleComparisonAttributeRestriction: StoredBooleanExpression, CoreDataObject {
	private typealias Me = StoredDoubleComparisonAttributeRestriction
	public static let entityName = "DoubleComparisonAttributeRestriction"

	public override func convert() throws -> BooleanExpression {
		let sampleType: Sample.Type = injected(SampleFactory.self).sampleType(for: sampleTypeId)
		guard let attribute = sampleType.attributes.first(where: { $0.id == attributeId }) else {
			throw GenericError("Unable to determine attribute")
		}
		switch comparison {
		case Comparison.lessThan.rawValue:
			return LessThanDoubleAttributeRestriction(restrictedAttribute: attribute, value: value)
		case Comparison.lessThanOrEqual.rawValue:
			return LessThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: attribute, value: value)
		case Comparison.equalTo.rawValue:
			return EqualToDoubleAttributeRestriction(restrictedAttribute: attribute, value: value)
		case Comparison.notEqualTo.rawValue:
			return NotEqualToDoubleAttributeRestriction(restrictedAttribute: attribute, value: value)
		case Comparison.greaterThanOrEqual.rawValue:
			return GreaterThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: attribute, value: value)
		case Comparison.greaterThan.rawValue:
			return GreaterThanDoubleAttributeRestriction(restrictedAttribute: attribute, value: value)
		default:
			throw GenericError("Invalid comparison value for StoredDoubleComparisonAttributeRestriction")
		}
	}

	public func populate(from other: DoubleAttributeRestriction, for sampleType: Sample.Type) throws {
		sampleTypeId = injected(SampleFactory.self).sampleTypeId(for: sampleType)
		attributeId = other.restrictedAttribute.id
		switch other {
		case is LessThanDoubleAttributeRestriction:
			comparison = Comparison.lessThan.rawValue
		case is LessThanOrEqualToDoubleAttributeRestriction:
			comparison = Comparison.lessThanOrEqual.rawValue
		case is EqualToDoubleAttributeRestriction:
			comparison = Comparison.equalTo.rawValue
		case is NotEqualToDoubleAttributeRestriction:
			comparison = Comparison.notEqualTo.rawValue
		case is GreaterThanOrEqualToDoubleAttributeRestriction:
			comparison = Comparison.greaterThanOrEqual.rawValue
		case is GreaterThanDoubleAttributeRestriction:
			comparison = Comparison.greaterThan.rawValue
		default:
			throw GenericError("Forgot a type of DoubleAttributeRestriction")
		}
		value = other.typedValue
	}
}

extension StoredDoubleComparisonAttributeRestriction {
	@NSManaged private var sampleTypeId: Int16
	@NSManaged private var attributeId: Int16
	@NSManaged private var comparison: Int16
	@NSManaged private var value: Double
}
