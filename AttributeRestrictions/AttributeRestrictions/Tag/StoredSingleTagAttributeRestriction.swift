//
//  StoredSingleTagAttributeRestriction.swift
//  AttributeRestrictions
//
//  Created by Bryan Nova on 7/3/21.
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

fileprivate enum SingleTagRestrictionType: Int16 {
	case hasTag = 0
	case doesNotHaveTag = 1
}

public final class StoredSingleTagAttributeRestriction: StoredBooleanExpression, CoreDataObject {
	private typealias Me = StoredSingleTagAttributeRestriction
	public static let entityName = "SingleTagAttributeRestriction"

	public override func convert() throws -> BooleanExpression {
		let sampleType: Sample.Type = injected(SampleFactory.self).sampleType(for: sampleTypeId)
		guard let attribute = sampleType.attributes.first(where: { $0.id == attributeId }) else {
			throw GenericError("Unable to determine attribute")
		}
		guard let tag = try injected(TagDAO.self).getTag(named: tagName) else {
			throw GenericDisplayableError(title: "Tag named '\(tagName)' does not exist")
		}
		switch operation {
		case SingleTagRestrictionType.hasTag.rawValue:
			return HasTagAttributeRestriction(restrictedAttribute: attribute, tag: tag)
		case SingleTagRestrictionType.doesNotHaveTag.rawValue:
			return DoesNotHaveTagAttributeRestriction(tag: tag, restrictedAttribute: attribute)
		default:
			throw GenericError("Invalid operation value for StoredSingleTagAttributeRestriction")
		}
	}

	public func populate(from other: SingleTagAttributeRestriction, for sampleType: Sample.Type) throws {
		sampleTypeId = injected(SampleFactory.self).sampleTypeId(for: sampleType)
		attributeId = other.restrictedAttribute.id
		switch other {
		case is HasTagAttributeRestriction:
			operation = SingleTagRestrictionType.hasTag.rawValue
			break
		case is DoesNotHaveTagAttributeRestriction:
			operation = SingleTagRestrictionType.doesNotHaveTag.rawValue
			break
		default:
			throw GenericError("Forgot a type of SingleTagAttributeRestriction")
		}
		tagName = other.tagName
	}
}

extension StoredSingleTagAttributeRestriction {
	@NSManaged private var sampleTypeId: Int16
	@NSManaged private var attributeId: Int16
	@NSManaged private var operation: Int16
	@NSManaged private var tagName: String
}
