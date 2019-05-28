//
//  HasOneOfTagAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 11/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class HasOneOfTagAttributeRestriction: AnyAttributeRestriction, Equatable {

	private typealias Me = HasOneOfTagAttributeRestriction

	// MARK: - Attributes

	public static let tagsAttribute = TagsAttribute(name: "Tags", pluralName: "Tags")
	public static let attributes: [Attribute] = [tagsAttribute]

	// MARK: - Display Information

	public override var attributedName: String { return "Tagged with one of" }
	public override var description: String {
		if tags.count == 0 {
			return "Tagged with one of:"
		}
		let tagsText = try! Me.tagsAttribute.convertToDisplayableString(from: tags)
		return "Tagged with one of: \(tagsText)"
	}

	// MARK: - Instance Variables

	public final var tags: [Tag]
	private final let log = Log()

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
				return sampleTags.filter() { sampleTag in
					return tags.contains(where: { $0.equalTo(sampleTag) })
				}.count > 0
			} else if !restrictedAttribute.optional {
				throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: value))
			}
			return false
		}
		log.error("Unsupported restricted attribute type")
		return false
	}

	public override func copy() -> AttributeRestriction {
		return HasOneOfTagAttributeRestriction(tags: tags, restrictedAttribute: restrictedAttribute)
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
			tags = castedValue.map{ $0 }
			return
		}
		throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
	}

	// MARK: - Equality

	public static func ==(lhs: HasOneOfTagAttributeRestriction, rhs: HasOneOfTagAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
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
		return restrictedAttribute.equalTo(other.restrictedAttribute) && tagsAreEqual(other)
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

