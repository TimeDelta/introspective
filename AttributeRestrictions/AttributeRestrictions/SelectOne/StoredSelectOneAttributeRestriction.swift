//
//  StoredSelectOneAttributeRestriction.swift
//  AttributeRestrictions
//
//  Created by Bryan Nova on 7/1/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

import BooleanAlgebra
import Common
import DependencyInjection
import Persistence
import Samples

public final class StoredSelectOneAttributeRestriction: StoredBooleanExpression, CoreDataObject {

	private typealias Me = StoredSelectOneAttributeRestriction
	public static let entityName = "SelectOneAttributeRestriction"

	public override func convert() throws -> BooleanExpression {
		let sampleType: Sample.Type = injected(SampleFactory.self).sampleType(for: sampleTypeId)
		guard let attribute = sampleType.attributes.first(where: { $0.id == attributeId }) else {
			throw GenericError("Unable to determine attribute")
		}
		switch operation {
		case SelectOneRestriction.onDate.rawValue:
			return EqualToSelectOneAttributeRestriction(restrictedAttribute: attribute, )
		case SelectOneRestriction.beforeDate.rawValue:
			return NotEqualToSelectOneAttributeRestriction(restrictedAttribute: attribute, )
		default:
			throw GenericError("Invalid operation value for StoredSelectOneAttributeRestriction")
		}
	}

	public func populate(from other: DateAttributeRestriction, for sampleType: Sample.Type) throws {
		sampleTypeId = injected(SampleFactory.self).sampleTypeId(for: sampleType)
		attributeId = other.restrictedAttribute.id
		switch other {
		case is OnDateAttributeRestriction:
			operation = SelectOneRestriction.onDate.rawValue
			break
		case is BeforeDateAttributeRestriction:
			operation = SelectOneRestriction.beforeDate.rawValue
			break
		case is AfterDateAttributeRestriction:
			operation = SelectOneRestriction.afterDate.rawValue
			break
		case is BeforeDateAndTimeAttributeRestriction:
			operation = SelectOneRestriction.beforeDateAndTime.rawValue
			break
		case is AfterDateAndTimeAttributeRestriction:
			operation = SelectOneRestriction.afterDateAndTime.rawValue
			break
		default:
			fatalError("Forgot a type of DateAttributeRestriction")
		}
		value = other.typedValue!
	}
}

extension StoredSelectOneAttributeRestriction {

	@NSManaged private var sampleTypeId: Int16
	@NSManaged private var attributeId: Int16
	@NSManaged private var operation: Int16
	@NSManaged private var value: Date
}
