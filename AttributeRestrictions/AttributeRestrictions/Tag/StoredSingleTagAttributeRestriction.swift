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
		let sampleType: Sample.Type = try injected(SampleFactory.self).sampleType(for: sampleTypeId)
		guard let attribute = sampleType.attributes.first(where: { $0.id == attributeId }) else {
			throw GenericError("Unable to determine attribute")
		}
		let tag: Tag
		if let data = tagReferencesData {
			guard let resolved = try StoredTagReference.resolve(data).first else { throw GenericError("Missing saved tag.") }
			tag = resolved
		} else {
			guard let resolved = try injected(TagDAO.self).getTag(named: tagName) else {
				throw GenericDisplayableError(title: "Tag named '\(tagName)' does not exist")
			}
			tag = resolved
		}
		let activity = includesDefinitionTags || (tagReferencesData == nil && attribute is ActivityTagsAttribute)

		switch operation {
		case SingleTagRestrictionType.hasTag.rawValue:
			if activity { return ActivityHasTagAttributeRestriction(restrictedAttribute: attribute, tag: tag) }
			return HasTagAttributeRestriction(restrictedAttribute: attribute, tag: tag)
		case SingleTagRestrictionType.doesNotHaveTag.rawValue:
			if activity { return ActivityDoesNotHaveTagAttributeRestriction(tag: tag, restrictedAttribute: attribute) }
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
		includesDefinitionTags = other is ActivityHasTagAttributeRestriction || other is ActivityDoesNotHaveTagAttributeRestriction
		let tag = (other as? HasTagAttributeRestriction)?.tag ?? (other as? DoesNotHaveTagAttributeRestriction)?.tag
		guard let selected = tag else { throw GenericError("Select a tag before saving.") }
		tagReferencesData = try StoredTagReference.encode([selected])
	}
}

extension StoredSingleTagAttributeRestriction {
	@NSManaged private var sampleTypeId: Int16
	@NSManaged private var attributeId: Int16
	@NSManaged private var operation: Int16
	@NSManaged private var tagName: String
	@NSManaged private var tagReferencesData: Data?
	@NSManaged private var includesDefinitionTags: Bool
}


/// Use persistent identity so tag renames and delimiter characters preserve query meaning.
internal struct StoredTagReference: Codable {
	var id: String
	var name: String

	static func encode(_ tags: [Tag]) throws -> Data {
		let references = try tags.map { tag -> StoredTagReference in
			guard !tag.objectID.isTemporaryID else { throw GenericError("Save the tag before saving the query.") }
			return StoredTagReference(id: tag.objectID.uriRepresentation().absoluteString, name: tag.name)
		}
		return try JSONEncoder().encode(references)
	}

	static func resolve(_ data: Data) throws -> [Tag] {
		let references = try JSONDecoder().decode([StoredTagReference].self, from: data)
		let tags = try injected(Database.self).query(Tag.fetchRequest())
		return try references.map { reference in
			guard let tag = tags.first(where: { $0.objectID.uriRepresentation().absoluteString == reference.id }) else {
				throw GenericDisplayableError(title: "The saved query's tag '\(reference.name)' no longer exists.")
			}
			return tag
		}
	}
}
