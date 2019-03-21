//
//  DoesNotHaveTagAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 11/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class DoesNotHaveTagAttributeRestriction: AnyAttributeRestriction, Equatable {

	private typealias Me = DoesNotHaveTagAttributeRestriction

	// MARK: - Attributes

	public static let tagAttribute = TagAttribute(name: "Tag", pluralName: "Tags")
	public static let attributes: [Attribute] = [tagAttribute]

	// MARK: - Display Information

	public override var attributedName: String { return "Not tagged with" }
	public override var description: String { return "Not tagged with '\(tag.name)'" }

	// MARK: - Instance Variables

	public final var tag: Tag!
	private final let log = Log()

	// MARK: - Initializers

	public init(tag: Tag, restrictedAttribute: Attribute) {
		self.tag = tag
		super.init(restrictedAttribute: restrictedAttribute)
	}

	public required init(restrictedAttribute: Attribute) {
		super.init(restrictedAttribute: restrictedAttribute, attributes: Me.attributes)
	}

	// MARK: - Attribute Restriction Functions

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		if restrictedAttribute is TagAttribute {
			if let sampleTag = try sample.value(of: restrictedAttribute) as? Tag {
				return !sampleTag.equalTo(tag)
			} else if !restrictedAttribute.optional {
				throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: value))
			}
			return true
		} else if restrictedAttribute is TagsAttribute {
			if let sampleTags = try sample.value(of: restrictedAttribute) as? [Tag] {
				return !sampleTags.contains(where: { $0.equalTo(tag) })
			} else if !restrictedAttribute.optional {
				throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: value))
			}
			return true
		}
		log.error("Unsupported restricted attribute type")
		return false
	}

	// MARK: - Attributed Functions

	public final override func value(of attribute: Attribute) throws -> Any? {
		if !attribute.equalTo(Me.tagAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		return tag
	}

	public final override func set(attribute: Attribute, to value: Any?) throws {
		if !attribute.equalTo(Me.tagAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		guard let castedValue = value as? Tag else {
			throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
		}
		tag = castedValue
	}

	// MARK: - Equality

	public static func ==(lhs: DoesNotHaveTagAttributeRestriction, rhs: DoesNotHaveTagAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final func equalTo(_ attributed: Attributed) -> Bool {
		guard let other = attributed as? AttributeRestriction else {
			return false
		}
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		guard let other = otherRestriction as? DoesNotHaveTagAttributeRestriction else {
			return false
		}
		return equalTo(other)
	}

	public final func equalTo(_ other: DoesNotHaveTagAttributeRestriction) -> Bool {
		return restrictedAttribute.equalTo(other.restrictedAttribute) && tag == other.tag
	}
}
