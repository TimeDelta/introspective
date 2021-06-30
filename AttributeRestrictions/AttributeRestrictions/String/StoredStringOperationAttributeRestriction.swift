//
//  StoredStringOperationAttributeRestriction.swift
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

public final class StoredStringOperationAttributeRestriction: StoredBooleanExpression, CoreDataObject {

	private typealias Me = StoredStringOperationAttributeRestriction
	public static let entityName = "StringOperationAttributeRestriction"

	public override func convert() throws -> BooleanExpression {
		let sampleType: Sample.Type = injected(SampleFactory.self).sampleType(for: sampleTypeId)
		guard let attribute = sampleType.attributes.first(where: { $0.id == attributeId }) else {
			throw GenericError("Unable to determine attribute")
		}
		switch operation {
		case StringOperation.contains.rawValue:
			guard let value = value else {
				throw GenericError("Required value is null for StoredStringOperationAttributeRestriction")
			}
			return ContainsStringAttributeRestriction(restrictedAttribute: attribute, substring: value)
		case StringOperation.startsWith.rawValue:
			guard let value = value else {
				throw GenericError("Required value is null for StoredStringOperationAttributeRestriction")
			}
			return StartsWithStringAttributeRestriction(restrictedAttribute: attribute, prefix: value)
		case StringOperation.endsWith.rawValue:
			guard let value = value else {
				throw GenericError("Required value is null for StoredStringOperationAttributeRestriction")
			}
			return EndsWithStringAttributeRestriction(restrictedAttribute: attribute, suffix: value)
		case StringOperation.equalTo.rawValue:
			guard let value = value else {
				throw GenericError("Required value is null for StoredStringOperationAttributeRestriction")
			}
			return EqualToStringAttributeRestriction(restrictedAttribute: attribute, value: value)
		case StringOperation.notEqualTo.rawValue:
			guard let value = value else {
				throw GenericError("Required value is null for StoredStringOperationAttributeRestriction")
			}
			return NotEqualToStringAttributeRestriction(restrictedAttribute: attribute, value: value)
		case StringOperation.isEmpty.rawValue:
			return EmptyStringAttributeRestriction(restrictedAttribute: attribute)
		case StringOperation.isNotEmpty.rawValue:
			return NotEmptyStringAttributeRestriction(restrictedAttribute: attribute)
		default:
			throw GenericError("Invalid operation value for StoredStringOperationAttributeRestriction")
		}
	}
}

extension StoredStringOperationAttributeRestriction {

	@NSManaged private var sampleTypeId: Int16
	@NSManaged private var attributeId: Int16
	@NSManaged private var operation: Int16
	@NSManaged private var value: String?
}
