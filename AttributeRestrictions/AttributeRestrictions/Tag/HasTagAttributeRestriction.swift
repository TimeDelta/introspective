//
//  HasTagAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 11/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common
import Samples

public class HasTagAttributeRestriction: AnyAttributeRestriction, Equatable {
	private typealias Me = HasTagAttributeRestriction

	// MARK: - Attributes

	public static let tagAttribute = TagAttribute(name: "Tag", pluralName: "Tags")
	public static let attributes: [Attribute] = [tagAttribute]

	// MARK: - Display Information

	override public var attributedName: String { "Tagged with" }
	override public var description: String { "Tagged with '\(tag.name)'" }

	// MARK: - Instance Variables

	public final var tag: Tag!
	fileprivate final let log = Log()

	// MARK: - Initializers

	public init(restrictedAttribute: Attribute, tag: Tag) {
		self.tag = tag
		super.init(restrictedAttribute: restrictedAttribute)
	}

	public required init(restrictedAttribute: Attribute) {
		super.init(restrictedAttribute: restrictedAttribute, attributes: Me.attributes)
	}

	// MARK: - Attribute Restriction Functions

	override public final func samplePasses(_ sample: Sample) throws -> Bool {
		if restrictedAttribute is TagAttribute {
			if let sampleTag = try sample.value(of: restrictedAttribute) as? Tag {
				return sampleTag.equalTo(tag)
			} else if !restrictedAttribute.optional {
				throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: value))
			}
			return false
		} else if restrictedAttribute is TagsAttribute {
			if let sampleTags = try sample.value(of: restrictedAttribute) as? [Tag] {
				return sampleTags.contains(where: { $0.equalTo(tag) })
			} else if !restrictedAttribute.optional {
				throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: value))
			}
			return false
		}
		log.error("Unsupported restricted attribute type")
		return false
	}

	override public func copy() -> AttributeRestriction {
		HasTagAttributeRestriction(restrictedAttribute: restrictedAttribute, tag: tag)
	}

	// MARK: - Boolean Expression Functions

	override public func predicate() -> NSPredicate? {
		guard let variableName = restrictedAttribute.variableName else { return nil }
		if restrictedAttribute is TagAttribute {
			return NSPredicate(format: "%K.name ==[cd] %@", variableName, tag.name)
		}
		if restrictedAttribute is TagsAttribute {
			return NSPredicate(
				format: "SUBQUERY(%K, $tag, $tag.name ==[cd] %@) .@count > 0",
				variableName,
				tag.name
			)
		}
		log.debug("Unsupported restricted attribute type for predicate")
		return nil
	}

	// MARK: - Attributed Functions

	override public final func value(of attribute: Attribute) throws -> Any? {
		if !attribute.equalTo(Me.tagAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		return tag
	}

	override public final func set(attribute: Attribute, to value: Any?) throws {
		if !attribute.equalTo(Me.tagAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		guard let castedValue = value as? Tag else {
			throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
		}
		tag = castedValue
	}

	// MARK: - Equality

	public static func == (lhs: HasTagAttributeRestriction, rhs: HasTagAttributeRestriction) -> Bool {
		lhs.equalTo(rhs)
	}

	public final func equalTo(_ attributed: Attributed) -> Bool {
		guard let other = attributed as? AttributeRestriction else {
			return false
		}
		return equalTo(other)
	}

	override public final func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		guard let other = otherRestriction as? HasTagAttributeRestriction else {
			return false
		}
		return equalTo(other)
	}

	public final func equalTo(_ other: HasTagAttributeRestriction) -> Bool {
		restrictedAttribute.equalTo(other.restrictedAttribute) && tag.equalTo(other.tag)
	}
}

public final class ActivityHasTagAttributeRestriction: HasTagAttributeRestriction {
	override public func predicate() -> NSPredicate? {
		guard let variableName = restrictedAttribute.variableName else { return nil }
		let activityPredicate = NSPredicate(
			format: "SUBQUERY(definition.tags, $tag, $tag.name ==[cd] %@) .@count > 0",
			tag.name
		)
		if restrictedAttribute is TagAttribute {
			let regularPredicate = NSPredicate(format: "%K.name ==[cd] %@", variableName, tag.name)
			return NSCompoundPredicate(orPredicateWithSubpredicates: [regularPredicate, activityPredicate])
		}
		if restrictedAttribute is TagsAttribute {
			let regularPredicate = NSPredicate(
				format: "SUBQUERY(%K, $tag, $tag.name ==[cd] %@) .@count > 0",
				variableName,
				tag.name
			)
			return NSCompoundPredicate(orPredicateWithSubpredicates: [regularPredicate, activityPredicate])
		}
		log.debug("Unsupported restricted attribute type for predicate")
		return nil
	}
}
