//
//  StoredTimeOfDayAttributeRestriction.swift
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

public final class StoredTimeOfDayComparisonAttributeRestriction: StoredBooleanExpression, CoreDataObject {
	private typealias Me = StoredTimeOfDayComparisonAttributeRestriction
	public static let entityName = "TimeOfDayComparisonAttributeRestriction"

	private enum Comparison: Int16 {
		case lessThan = 0
		case greaterThan = 1
	}

	public override func convert() throws -> BooleanExpression {
		let sampleType: Sample.Type = injected(SampleFactory.self).sampleType(for: sampleTypeId)
		guard let attribute = sampleType.attributes.first(where: { $0.id == attributeId }) else {
			throw GenericError("Unable to determine attribute")
		}
		switch comparison {
		case Comparison.lessThan.rawValue:
			return BeforeTimeOfDayAttributeRestriction(restrictedAttribute: attribute, timeOfDay: value)
		case Comparison.greaterThan.rawValue:
			return AfterTimeOfDayAttributeRestriction(restrictedAttribute: attribute, timeOfDay: value)
		default:
			throw GenericError("Invalid comparison value for StoredTimeOfDayComparisonAttributeRestriction")
		}
	}

	public func populate(from other: TimeOfDayAttributeRestriction, for sampleType: Sample.Type) throws {
		sampleTypeId = injected(SampleFactory.self).sampleTypeId(for: sampleType)
		attributeId = other.restrictedAttribute.id
		switch other {
		case is BeforeTimeOfDayAttributeRestriction:
			comparison = Comparison.lessThan.rawValue
			break
		case is AfterTimeOfDayAttributeRestriction:
			comparison = Comparison.greaterThan.rawValue
			break
		default:
			throw GenericError("Forgot a type of DateAttributeRestriction")
		}
		value = other.timeOfDay
	}
}

extension StoredTimeOfDayComparisonAttributeRestriction {
	@NSManaged private var sampleTypeId: Int16
	@NSManaged private var attributeId: Int16
	@NSManaged private var comparison: Int16
	@NSManaged private var value: TimeOfDay
}
