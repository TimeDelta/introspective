import CoreData
import Foundation

import Attributes
import BooleanAlgebra
import Common
import DependencyInjection
import Persistence
import Samples

fileprivate enum TagsRestrictionType: Int16 {
    case hasOneOf = 0
    case doesNotHaveOneOf = 1
}

public final class StoredTagsAttributeRestriction: StoredBooleanExpression, CoreDataObject {
    private typealias Me = StoredTagsAttributeRestriction
    public static let entityName = "TagsAttributeRestriction"

    public override func convert() throws -> BooleanExpression {
        let sampleType: Sample.Type = try injected(SampleFactory.self).sampleType(for: sampleTypeId)
        guard let attribute = sampleType.attributes.first(where: { $0.id == attributeId }) else {
            throw GenericError("Unable to determine attribute")
        }
        let names = tagNames.split(separator: ";").map { String($0) }.filter { !$0.isEmpty }
        var tags = [Tag]()
        if let data = tagReferencesData {
            tags = try StoredTagReference.resolve(data)
        } else {
            for name in names {
                guard let tag = try injected(TagDAO.self).getTag(named: name) else {
                    throw GenericDisplayableError(title: "Tag named '\(name)' does not exist")
                }
                tags.append(tag)
            }
        }
        let activity = includesDefinitionTags || (tagReferencesData == nil && attribute is ActivityTagsAttribute)
        switch operation {
        case TagsRestrictionType.hasOneOf.rawValue:
            if activity { return ActivityHasOneOfTagAttributeRestriction(tags: tags, restrictedAttribute: attribute) }
            return HasOneOfTagAttributeRestriction(tags: tags, restrictedAttribute: attribute)
        case TagsRestrictionType.doesNotHaveOneOf.rawValue:
            if activity { return ActivityDoesNotHaveOneOfTagAttributeRestriction(tags: tags, restrictedAttribute: attribute) }
            return DoesNotHaveOneOfTagAttributeRestriction(tags: tags, restrictedAttribute: attribute)
        default:
            throw GenericError("Invalid operation value for StoredTagsAttributeRestriction")
        }
    }

    public func populate(from other: AttributeRestriction, for sampleType: Sample.Type) throws {
        sampleTypeId = injected(SampleFactory.self).sampleTypeId(for: sampleType)
        attributeId = other.restrictedAttribute.id
        includesDefinitionTags = other is ActivityHasOneOfTagAttributeRestriction || other is ActivityDoesNotHaveOneOfTagAttributeRestriction
        if let restriction = other as? HasOneOfTagAttributeRestriction {
            operation = TagsRestrictionType.hasOneOf.rawValue
            tagNames = restriction.tags.map { $0.name }.joined(separator: ";")
            tagReferencesData = try StoredTagReference.encode(restriction.tags)
        } else if let restriction = other as? DoesNotHaveOneOfTagAttributeRestriction {
            operation = TagsRestrictionType.doesNotHaveOneOf.rawValue
            tagNames = restriction.tags.map { $0.name }.joined(separator: ";")
            tagReferencesData = try StoredTagReference.encode(restriction.tags)
        } else {
            throw GenericError("Forgot a type of TagsAttributeRestriction")
        }
    }
}

extension StoredTagsAttributeRestriction {
    @NSManaged private var sampleTypeId: Int16
    @NSManaged private var attributeId: Int16
    @NSManaged private var operation: Int16
    @NSManaged private var tagNames: String
    @NSManaged private var tagReferencesData: Data?
    @NSManaged private var includesDefinitionTags: Bool
}
