//
//  StoredDurationAttributeRestriction.swift
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

public final class StoredDurationComparisonAttributeRestriction: StoredBooleanExpression, CoreDataObject {
	private typealias Me = StoredDurationComparisonAttributeRestriction
	public static let entityName = "DurationComparisonAttributeRestriction"

	public override func convert() throws -> BooleanExpression {
		let sampleType: Sample.Type = injected(SampleFactory.self).sampleType(for: sampleTypeId)
		guard let attribute = sampleType.attributes.first(where: { $0.id == attributeId }) else {
			throw GenericError("Unable to determine attribute")
		}
		switch comparison {
		case Comparison.lessThan.rawValue:
			return LessThanDurationAttributeRestriction(restrictedAttribute: attribute, value: value)
		case Comparison.lessThanOrEqual.rawValue:
			return LessThanOrEqualToDurationAttributeRestriction(restrictedAttribute: attribute, value: value)
		case Comparison.equalTo.rawValue:
			return EqualToDurationAttributeRestriction(restrictedAttribute: attribute, value: value)
		case Comparison.notEqualTo.rawValue:
			return NotEqualToDurationAttributeRestriction(restrictedAttribute: attribute, value: value)
		case Comparison.greaterThanOrEqual.rawValue:
			return GreaterThanOrEqualToDurationAttributeRestriction(restrictedAttribute: attribute, value: value)
		case Comparison.greaterThan.rawValue:
			return GreaterThanDurationAttributeRestriction(restrictedAttribute: attribute, value: value)
		default:
			throw GenericError("Invalid comparison value for StoredDurationComparisonAttributeRestriction")
		}
	}

	public func populate(from other: DurationAttributeRestriction, for sampleType: Sample.Type) throws {
		sampleTypeId = injected(SampleFactory.self).sampleTypeId(for: sampleType)
		attributeId = other.restrictedAttribute.id
		switch other {
		case is LessThanDurationAttributeRestriction:
			comparison = Comparison.lessThan.rawValue
			break
		case is LessThanOrEqualToDurationAttributeRestriction:
			comparison = Comparison.lessThanOrEqual.rawValue
			break
		case is EqualToDurationAttributeRestriction:
			comparison = Comparison.equalTo.rawValue
			break
		case is NotEqualToDurationAttributeRestriction:
			comparison = Comparison.notEqualTo.rawValue
			break
		case is GreaterThanOrEqualToDurationAttributeRestriction:
			comparison = Comparison.greaterThanOrEqual.rawValue
			break
		case is GreaterThanDurationAttributeRestriction:
			comparison = Comparison.greaterThan.rawValue
			break
		default:
			throw GenericError("Forgot a type of DurationAttributeRestriction")
		}
		value = other.typedValue
	}
}

extension StoredDurationComparisonAttributeRestriction {
	@NSManaged private var sampleTypeId: Int16
	@NSManaged private var attributeId: Int16
	@NSManaged private var comparison: Int16
	@NSManaged private var value: TimeDuration
}
