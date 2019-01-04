//
//  DoesNotHaveOneOfTagAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 11/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class DoesNotHaveOneOfTagAttributeRestriction: AnyAttributeRestriction, Equatable {

	private typealias Me = DoesNotHaveOneOfTagAttributeRestriction

	// MARK: - Attributes

	public static let tagsAttribute = TagsAttribute(name: "Tags", pluralName: "Tags")
	public static let attributes: [Attribute] = [tagsAttribute]

	// MARK: - Display Information

	public override var attributedName: String { return "Not tagged with one of" }
	public override var description: String {
		var tagText = "'"
		for tag in tags {
			tagText += tag.name + "', '"
		}
		tagText.removeLast()
		tagText.removeLast()
		tagText.removeLast()
		return "Not tagged with one of: \(tagText)"
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
				return !tags.contains(where: { $0.equalTo(sampleTag) })
			} else if !restrictedAttribute.optional {
				throw AttributeError.typeMismatch
			}
			return true
		} else if restrictedAttribute is TagsAttribute {
			if let sampleTags = try sample.value(of: restrictedAttribute) as? [Tag] {
				return sampleTags.filter() { sampleTag in
					return tags.contains(where: { $0.equalTo(sampleTag) })
				}.count == 0
			} else if !restrictedAttribute.optional {
				throw AttributeError.typeMismatch
			}
			return true
		}
		log.error("Unsupported restricted attribute type")
		return false
	}

	// MARK: - Attributed Functions

	public final override func value(of attribute: Attribute) throws -> Any? {
		if !attribute.equalTo(Me.tagsAttribute) {
			throw AttributeError.unknownAttribute
		}
		return tags
	}

	public final override func set(attribute: Attribute, to value: Any?) throws {
		if !attribute.equalTo(Me.tagsAttribute) {
			throw AttributeError.unknownAttribute
		}
		if let castedValue = value as? [Tag] {
			tags = castedValue
			return
		} else if let castedValue = value as? Set<Tag> {
			tags = castedValue.map{ $0 }
			return
		}
		throw AttributeError.typeMismatch
	}

	// MARK: - Equality

	public static func ==(lhs: DoesNotHaveOneOfTagAttributeRestriction, rhs: DoesNotHaveOneOfTagAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		guard let other = otherRestriction as? DoesNotHaveOneOfTagAttributeRestriction else {
			return false
		}
		return equalTo(other)
	}

	public final func equalTo(_ otherRestriction: DoesNotHaveOneOfTagAttributeRestriction) -> Bool {
		return tags == otherRestriction.tags
	}
}

