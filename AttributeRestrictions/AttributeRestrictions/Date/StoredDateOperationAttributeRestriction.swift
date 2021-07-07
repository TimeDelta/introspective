//
//  StoredDateAttributeRestriction.swift
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

public final class StoredDateOperationAttributeRestriction: StoredBooleanExpression, CoreDataObject {
	private typealias Me = StoredDateOperationAttributeRestriction
	public static let entityName = "DateOperationAttributeRestriction"

	public override func convert() throws -> BooleanExpression {
		let sampleType: Sample.Type = injected(SampleFactory.self).sampleType(for: sampleTypeId)
		guard let attribute = sampleType.attributes.first(where: { $0.id == attributeId }) else {
			throw GenericError("Unable to determine attribute")
		}
		switch operation {
		case DateOperation.onDate.rawValue:
			return OnDateAttributeRestriction(restrictedAttribute: attribute, date: value)
		case DateOperation.beforeDate.rawValue:
			return BeforeDateAttributeRestriction(restrictedAttribute: attribute, date: value)
		case DateOperation.afterDate.rawValue:
			return AfterDateAttributeRestriction(restrictedAttribute: attribute, date: value)
		case DateOperation.beforeDateAndTime.rawValue:
			return BeforeDateAndTimeAttributeRestriction(restrictedAttribute: attribute, date: value)
		case DateOperation.afterDateAndTime.rawValue:
			return AfterDateAndTimeAttributeRestriction(restrictedAttribute: attribute, date: value)
		default:
			throw GenericError("Invalid operation value for StoredDateOperationAttributeRestriction")
		}
	}

	public func populate(from other: DateAttributeRestriction, for sampleType: Sample.Type) throws {
		sampleTypeId = injected(SampleFactory.self).sampleTypeId(for: sampleType)
		attributeId = other.restrictedAttribute.id
		switch other {
		case is OnDateAttributeRestriction:
			operation = DateOperation.onDate.rawValue
			break
		case is BeforeDateAttributeRestriction:
			operation = DateOperation.beforeDate.rawValue
			break
		case is AfterDateAttributeRestriction:
			operation = DateOperation.afterDate.rawValue
			break
		case is BeforeDateAndTimeAttributeRestriction:
			operation = DateOperation.beforeDateAndTime.rawValue
			break
		case is AfterDateAndTimeAttributeRestriction:
			operation = DateOperation.afterDateAndTime.rawValue
			break
		default:
			throw GenericError("Forgot a type of DateAttributeRestriction")
		}
		value = other.typedValue!
	}
}

extension StoredDateOperationAttributeRestriction {
	@NSManaged private var sampleTypeId: Int16
	@NSManaged private var attributeId: Int16
	@NSManaged private var operation: Int16
	@NSManaged private var value: Date
}
