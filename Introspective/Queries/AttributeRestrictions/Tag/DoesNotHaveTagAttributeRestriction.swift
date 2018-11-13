//
//  DoesNotHaveTagAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 11/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

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
				throw AttributeError.typeMismatch
			}
			return true
		} else if restrictedAttribute is TagsAttribute {
			if let sampleTags = try sample.value(of: restrictedAttribute) as? [Tag] {
				return !sampleTags.contains(where: { $0.equalTo(tag) })
			} else if !restrictedAttribute.optional {
				throw AttributeError.typeMismatch
			}
			return true
		}
		os_log("Unsupported restricted attribute type", type: .error)
		return false
	}

	// MARK: - Attributed Functions

	public final override func value(of attribute: Attribute) throws -> Any? {
		if !attribute.equalTo(Me.tagAttribute) {
			throw AttributeError.unknownAttribute
		}
		return tag
	}

	public final override func set(attribute: Attribute, to value: Any?) throws {
		if !attribute.equalTo(Me.tagAttribute) {
			throw AttributeError.unknownAttribute
		}
		guard let castedValue = value as? Tag else {
			throw AttributeError.typeMismatch
		}
		tag = castedValue
	}

	// MARK: - Equality

	public static func ==(lhs: DoesNotHaveTagAttributeRestriction, rhs: DoesNotHaveTagAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		guard let other = otherRestriction as? DoesNotHaveTagAttributeRestriction else {
			return false
		}
		return equalTo(other)
	}

	public final func equalTo(_ otherRestriction: DoesNotHaveTagAttributeRestriction) -> Bool {
		return tag == otherRestriction.tag
	}
}
