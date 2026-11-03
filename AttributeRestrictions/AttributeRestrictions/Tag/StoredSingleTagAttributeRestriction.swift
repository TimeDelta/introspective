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
			guard let resolved = try StoredTagReference.resolve(data, in: managedObjectContext).first else { throw GenericError("Missing saved tag.") }
			tag = resolved
		} else {
			guard let resolved = try StoredTagReference.resolveLegacyName(tagName, in: managedObjectContext) else {
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

	static func resolve(_ data: Data, in context: NSManagedObjectContext?) throws -> [Tag] {
		let references = try JSONDecoder().decode([StoredTagReference].self, from: data)
		if let context = context {
			guard !references.isEmpty else { return [] }
			var owner: NSManagedObjectContext? = context
			while owner?.persistentStoreCoordinator == nil, let parent = owner?.parent { owner = parent }
			if let coordinator = owner?.persistentStoreCoordinator, !coordinator.persistentStores.isEmpty,
				coordinator.persistentStores.allSatisfy({ $0.type == NSSQLiteStoreType }) {
				// URI lookup alone can normalize a spelling or identify another entity.
				// Match exactly what the former tag-array search accepted.
				let ids = references.compactMap { reference -> NSManagedObjectID? in
					guard let url = URL(string: reference.id), url.scheme == "x-coredata", url.host?.isEmpty == false,
						url.path.split(separator: "/").count == 2, url.path.split(separator: "/").first == Substring(Tag.entityName),
						url.user == nil, url.password == nil, url.port == nil, url.query == nil, url.fragment == nil,
						let id = coordinator.managedObjectID(forURIRepresentation: url),
						!id.isTemporaryID, id.entity.name == Tag.entityName,
						id.uriRepresentation().absoluteString == reference.id else { return nil }
					return id
				}
				var tagsByURI = [String: Tag]()
				if !ids.isEmpty {
					let request = Tag.fetchRequest()
					request.predicate = NSPredicate(format: "SELF IN %@", Array(Set(ids)) as NSArray)
					for tag in try context.fetch(request) { tagsByURI[tag.objectID.uriRepresentation().absoluteString] = tag }
				}
				// Preserve duplicates, order, and the first missing-reference error.
				return try references.map { reference in
					guard let tag = tagsByURI[reference.id] else {
						throw GenericDisplayableError(title: "The saved query's tag '\(reference.name)' no longer exists.")
					}
					return tag
				}
			}
		}
		let tags: [Tag]
		if let context = context { tags = try context.fetch(Tag.fetchRequest()) }
		else { tags = try injected(Database.self).query(Tag.fetchRequest()) }
		return try references.map { reference in
			guard let tag = tags.first(where: { $0.objectID.uriRepresentation().absoluteString == reference.id }) else {
				throw GenericDisplayableError(title: "The saved query's tag '\(reference.name)' no longer exists.")
			}
			return tag
		}
	}

	static func resolveLegacyName(_ name: String, in context: NSManagedObjectContext?) throws -> Tag? {
		guard let context = context else { return try injected(TagDAO.self).getTag(named: name) }
		let request = Tag.fetchRequest()
		request.predicate = NSPredicate(format: "name ==[cd] %@", name)
		return try context.fetch(request).first
	}
}
