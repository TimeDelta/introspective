//
//  StoredDosageComparisonAttributeRestriction.swift
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

public final class StoredDosageComparisonAttributeRestriction: StoredBooleanExpression, CoreDataObject {
	private typealias Me = StoredDosageComparisonAttributeRestriction
	public static let entityName = "DosageComparisonAttributeRestriction"

	public override func convert() throws -> BooleanExpression {
		let sampleType: Sample.Type = injected(SampleFactory.self).sampleType(for: sampleTypeId)
		guard let attribute = sampleType.attributes.first(where: { $0.id == attributeId }) else {
			throw GenericError("Unable to determine attribute")
		}
		switch comparison {
		case Comparison.lessThan.rawValue:
			return LessThanDosageAttributeRestriction(restrictedAttribute: attribute, value: value)
		case Comparison.lessThanOrEqual.rawValue:
			return LessThanOrEqualToDosageAttributeRestriction(restrictedAttribute: attribute, value: value)
		case Comparison.equalTo.rawValue:
			return EqualToDosageAttributeRestriction(restrictedAttribute: attribute, value: value)
		case Comparison.notEqualTo.rawValue:
			return NotEqualToDosageAttributeRestriction(restrictedAttribute: attribute, value: value)
		case Comparison.greaterThanOrEqual.rawValue:
			return GreaterThanOrEqualToDosageAttributeRestriction(restrictedAttribute: attribute, value: value)
		case Comparison.greaterThan.rawValue:
			return GreaterThanDosageAttributeRestriction(restrictedAttribute: attribute, value: value)
		default:
			throw GenericError("Invalid comparison value for StoredDosageComparisonAttributeRestriction")
		}
	}

	public func populate(from other: DosageAttributeRestriction, for sampleType: Sample.Type) throws {
		sampleTypeId = injected(SampleFactory.self).sampleTypeId(for: sampleType)
		attributeId = other.restrictedAttribute.id
		switch other {
		case is LessThanDosageAttributeRestriction:
			comparison = Comparison.lessThan.rawValue
			break
		case is LessThanOrEqualToDosageAttributeRestriction:
			comparison = Comparison.lessThanOrEqual.rawValue
			break
		case is EqualToDosageAttributeRestriction:
			comparison = Comparison.equalTo.rawValue
			break
		case is NotEqualToDosageAttributeRestriction:
			comparison = Comparison.notEqualTo.rawValue
			break
		case is GreaterThanOrEqualToDosageAttributeRestriction:
			comparison = Comparison.greaterThanOrEqual.rawValue
			break
		case is GreaterThanDosageAttributeRestriction:
			comparison = Comparison.greaterThan.rawValue
			break
		default:
			throw GenericError("Forgot a type of DosageAttributeRestriction")
		}
		value = other.typedValue
	}
}

extension StoredDosageComparisonAttributeRestriction {
	@NSManaged private var sampleTypeId: Int16
	@NSManaged private var attributeId: Int16
	@NSManaged private var comparison: Int16
	@NSManaged private var value: Dosage
}
