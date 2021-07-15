//
//  HasOneOfTagAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 11/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import BooleanAlgebra
import Common
import Persistence
import Samples

public class HasOneOfTagAttributeRestriction: AnyAttributeRestriction, Equatable {
	private typealias Me = HasOneOfTagAttributeRestriction

	// MARK: - Attributes

	public static let tagsAttribute = TagsAttribute(id: 0, name: "Tags", pluralName: "Tags")
	public static let attributes: [Attribute] = [tagsAttribute]

	// MARK: - Display Information

	public override var attributedName: String { "Tagged with one of" }
	public override var description: String {
		if tags.isEmpty {
			return "Tagged with one of:"
		}
		let tagsText = try! Me.tagsAttribute.convertToDisplayableString(from: tags)
		return "Tagged with one of: \(tagsText)"
	}

	// MARK: - Instance Variables

	public final var tags: [Tag]
	final fileprivate let log = Log()

	// MARK: - Initializers

	public init(tags: [Tag], restrictedAttribute: Attribute) {
		self.tags = tags
		super.init(restrictedAttribute: restrictedAttribute)
	}

	public required init(restrictedAttribute: Attribute) {
		tags = []
		super.init(restrictedAttribute: restrictedAttribute, attributes: Me.attributes)
	}

	// MARK: - Attribute Restriction Functions

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		if restrictedAttribute is TagAttribute {
			if let sampleTag = try sample.value(of: restrictedAttribute) as? Tag {
				return tags.contains(where: { $0.equalTo(sampleTag) })
			} else if !restrictedAttribute.optional {
				throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: value))
			}
			return false
		} else if restrictedAttribute is TagsAttribute {
			if let sampleTags = try sample.value(of: restrictedAttribute) as? [Tag] {
				return !sampleTags.filter { sampleTag in
					tags.contains(where: { $0.equalTo(sampleTag) })
				}.isEmpty
			} else if !restrictedAttribute.optional {
				throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: value))
			}
			return false
		}
		log.error("Unsupported restricted attribute type")
		return false
	}

	public override func copy() -> AttributeRestriction {
		HasOneOfTagAttributeRestriction(tags: tags, restrictedAttribute: restrictedAttribute)
	}

	// MARK: - Boolean Expression Functions

	public override func predicate() -> NSPredicate? {
		guard let variableName = restrictedAttribute.variableName else { return nil }
		if restrictedAttribute is TagAttribute {
			let predicates = tags.map {
				NSPredicate(format: "%K.name == %@", variableName, $0.name)
			}
			return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
		}
		if restrictedAttribute is TagsAttribute {
			let predicates = tags.map {
				NSPredicate(format: "SUBQUERY(%K, $tag, $tag.name ==[cd] %@) .@count > 0", variableName, $0.name)
			}
			return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
		}
		log.debug("Unsupported restricted attribute type for predicate")
		return nil
	}

	public override func stored(
		for sampleType: Sample.Type,
		using transaction: Transaction?
	) throws -> StoredBooleanExpression {
		throw GenericDisplayableError(
			title: "Not yet supported",
			description: "the attribute restriction for 'has one of _,_,...,_ tags' cannot yet be saved. As a workaround, use 'or' statements with 'has tag _' restrictions."
		)
	}

	// MARK: - Attributed Functions

	public final override func value(of attribute: Attribute) throws -> Any? {
		if !attribute.equalTo(Me.tagsAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		return tags
	}

	public final override func set(attribute: Attribute, to value: Any?) throws {
		if !attribute.equalTo(Me.tagsAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		if let castedValue = value as? [Tag] {
			tags = castedValue
			return
		} else if let castedValue = value as? Set<Tag> {
			tags = castedValue.map { $0 }
			return
		}
		throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
	}

	// MARK: - Equality

	public static func == (lhs: HasOneOfTagAttributeRestriction, rhs: HasOneOfTagAttributeRestriction) -> Bool {
		lhs.equalTo(rhs)
	}

	public final func equalTo(_ attributed: Attributed) -> Bool {
		guard let other = attributed as? AttributeRestriction else {
			return false
		}
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		guard let other = otherRestriction as? HasOneOfTagAttributeRestriction else {
			return false
		}
		return equalTo(other)
	}

	public final func equalTo(_ other: HasOneOfTagAttributeRestriction) -> Bool {
		restrictedAttribute.equalTo(other.restrictedAttribute) && tagsAreEqual(other)
	}

	/// - Note: This is necessary because == operator cannot be overriden for any subclass
	///         of NSManagedObject and just checks memory address.
	private final func tagsAreEqual(_ other: HasOneOfTagAttributeRestriction) -> Bool {
		guard tags.count == other.tags.count else { return false }
		for tag in tags {
			if !other.tags.contains(where: { $0.equalTo(tag) }) {
				return false
			}
		}
		return true
	}
}

public final class ActivityHasOneOfTagAttributeRestriction: HasOneOfTagAttributeRestriction {
	public override func predicate() -> NSPredicate? {
		guard let variableName = restrictedAttribute.variableName else { return nil }
		var activityPredicates = tags.map {
			NSPredicate(format: "SUBQUERY(definition.tags, $tag, $tag.name ==[cd] %@) .@count > 0", $0.name)
		}
		if restrictedAttribute is TagAttribute {
			let regularPredicates = tags.map {
				NSPredicate(format: "%K.name == %@", variableName, $0.name)
			}
			activityPredicates.append(contentsOf: regularPredicates)
			return NSCompoundPredicate(orPredicateWithSubpredicates: activityPredicates)
		}
		if restrictedAttribute is TagsAttribute {
			let regularPredicates = tags.map {
				NSPredicate(format: "SUBQUERY(%K, $tag, $tag.name ==[cd] %@) .@count > 0", variableName, $0.name)
			}
			activityPredicates.append(contentsOf: regularPredicates)
			return NSCompoundPredicate(orPredicateWithSubpredicates: activityPredicates)
		}
		log.debug("Unsupported restricted attribute type for predicate")
		return nil
	}
}
