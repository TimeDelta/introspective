//
//  StoredSelectOneAttributeRestriction.swift
//  AttributeRestrictions
//
//  Created by Bryan Nova on 7/1/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

import Attributes
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
		guard let selectOneAttribute = attribute as? SelectOneAttribute else {
			throw GenericError("Wrong attribute type for StoredSelectOneAttributeRestriction")
		}
		let value = selectOneAttribute.possibleValues[Int(valueIndex)]
		switch operation {
		case SelectOneRestrictionType.equalTo.rawValue:
			return EqualToSelectOneAttributeRestriction(
				restrictedAttribute: attribute,
				value: value,
				valueAttribute: selectOneAttribute
			)
		case SelectOneRestrictionType.notEqualTo.rawValue:
			return NotEqualToSelectOneAttributeRestriction(
				restrictedAttribute: attribute,
				value: value,
				valueAttribute: selectOneAttribute
			)
		default:
			throw GenericError("Invalid operation value for StoredSelectOneAttributeRestriction")
		}
	}

	public func populate(from other: SelectOneAttributeRestriction, for sampleType: Sample.Type) throws {
		sampleTypeId = injected(SampleFactory.self).sampleTypeId(for: sampleType)
		attributeId = other.restrictedAttribute.id
		switch other {
		case is EqualToSelectOneAttributeRestriction:
			operation = SelectOneRestrictionType.equalTo.rawValue
			break
		case is NotEqualToSelectOneAttributeRestriction:
			operation = SelectOneRestrictionType.notEqualTo.rawValue
			break
		default:
			throw GenericError("Forgot a type of SelectOneAttributeRestriction")
		}
		guard let value = other.value else {
			throw GenericError("No Value provided for populating StoredSelectOneAttributeRestriction")
		}
		guard let index = other.selectOneAttribute.indexOf(
			possibleValue: value,
			in: other.selectOneAttribute.possibleValues
		) else {
			throw GenericError("Invalid value found")
		}
		valueIndex = Int64(index)
	}
}

extension StoredSelectOneAttributeRestriction {
	@NSManaged private var sampleTypeId: Int16
	@NSManaged private var attributeId: Int16
	@NSManaged private var operation: Int16
	@NSManaged private var valueIndex: Int64
}
