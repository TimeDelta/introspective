//
//  PerTagSampleGrouper.swift
//  Introspective
//
//  Created by Bryan Nova on 7/28/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common
import Samples

public final class PerTagSampleGrouper: SampleGrouper {

	// MARK: - Display Information

	public static var userVisibleDescription: String = "Group By Tag"
	public let attributedName: String = "Group By Tag"
	public var description: String {
		guard let groupByAttribute = groupByAttribute else {
			return attributedName
		}
		return "Group by \(groupByAttribute.name.localizedLowercase)"
	}

	// MARK: - Attributes

	public final let attributes: [Attribute]
	public final let attributeSelectAttribute: AttributeSelectAttribute

	// MARK: - Instance Variables

	public final var groupByAttribute: Attribute?
	private final let log = Log()

	// MARK: - Initializers

	public required convenience init(sampleType: Sample.Type) {
		self.init(attributes: sampleType.attributes)
	}

	public required init(attributes: [Attribute]) {
		let applicableAttributes = attributes.filter{ $0 is TagAttribute || $0 is TagsAttribute }
		groupByAttribute = applicableAttributes.first
		if groupByAttribute == nil {
			log.error("No tag attributes provided to PerTagSampleGrouper")
		}
		attributeSelectAttribute = AttributeSelectAttribute(attributes: applicableAttributes)
		self.attributes = [attributeSelectAttribute]
	}

	private init(groupByAttribute: Attribute?, attributeSelectAttribute: AttributeSelectAttribute) {
		self.groupByAttribute = groupByAttribute
		self.attributeSelectAttribute = attributeSelectAttribute
		attributes = [attributeSelectAttribute]
	}

	// MARK: - Grouper Functions

	public final func group(samples: [Sample]) throws -> [(Any, [Sample])] {
		let groupByAttribute = try getGroupByAttribute(methodName: "group(samples:)")
		guard samples.count > 0 else { return [] }
		var groups = [(Any, [Sample])]()
		for sample in samples {
			let tags = try getTagsForSample(sample, forAttribute: groupByAttribute)
			for tag in tags {
				if let index = groups.firstIndex(where: { $0.0 as? String == tag.name }) {
					groups[index].1.append(sample)
				} else {
					groups.append((tag.name, [sample]))
				}
			}
		}
		return groups
	}

	public final func groupNameFor(value: Any) throws -> String {
		let groupByAttribute = try getGroupByAttribute(methodName: "groupNameFor(value:)")
		let tagName: String
		if let tag = value as? Tag {
			tagName = tag.name
		} else if let str = value as? String {
			tagName = str
		} else {
			let valueDescription = String(describing: value)
			throw GenericError("Unknown value type for tag group with value: \(valueDescription)")
		}
		if groupByAttribute is TagAttribute {
			return "\(groupByAttribute.name) = \(tagName)"
		} else if groupByAttribute is TagsAttribute {
			return "\(groupByAttribute.name) has \(tagName)"
		} else {
			throw GenericError("Unknown type of tag attribute for attribute named \(groupByAttribute.name)")
		}
	}

	public final func groupValuesAreEqual(_ first: Any, _ second: Any) throws -> Bool {
		if let tag1 = first as? Tag, let tag2 = second as? Tag {
			return tag1.equalTo(tag2)
		} else if let name1 = first as? String, let name2 = second as? String {
			return name1 == name2
		}
		let value1Description = String(describing: first)
		let value2Description = String(describing: second)
		throw GenericError("Unknown group value types: '\(value1Description)','\(value2Description)'")
	}

	public final func copy() -> SampleGrouper {
		return PerTagSampleGrouper(
			groupByAttribute: groupByAttribute,
			attributeSelectAttribute: attributeSelectAttribute)
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(attributeSelectAttribute) {
			return groupByAttribute
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(attributeSelectAttribute) {
			guard let castedValue = value as? Attribute else {
				throw TypeMismatchError(attribute: attributeSelectAttribute, of: self, wasA: type(of: value))
			}
			if let _ = attributeSelectAttribute.indexOf(possibleValue: castedValue) {
				groupByAttribute = castedValue
				return
			}
			throw GenericError("Provided attribute was not one of the allowed values: \(castedValue.name)")
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	// MARK: - Helper Functions

	private final func getTagsForSample(_ sample: Sample, forAttribute attribute: Attribute) throws -> [Tag] {
		if groupByAttribute is TagAttribute {
			let sampleValue = try sample.value(of: attribute)
			guard let tag = sampleValue as? Tag else {
				throw TypeMismatchError(attribute: attribute, of: sample, wasA: type(of: sampleValue))
			}
			return [tag]
		} else if groupByAttribute is TagsAttribute {
			let sampleValue = try sample.value(of: attribute)
			guard let tags = sampleValue as? [Tag] else {
				throw TypeMismatchError(attribute: attribute, of: sample, wasA: type(of: sampleValue))
			}
			return tags
		}
		let attributeType = String(describing: type(of: attribute))
		throw GenericError("Unknown type of tag attribute: \(attributeType)")
	}

	private final func getGroupByAttribute(methodName: String) throws -> Attribute {
		guard let groupByAttribute = groupByAttribute else {
			throw GenericError("Called \(methodName) before groupByAttribute was set")
		}
		return groupByAttribute
	}

	// MARK: - Equality

	public final func equalTo(_ otherGrouper: SampleGrouper) -> Bool {
		guard let sameValueGrouper = otherGrouper as? PerTagSampleGrouper else { return false }
		if groupByAttribute == nil && sameValueGrouper.groupByAttribute == nil {
			return true
		}
		if
			let groupByAttribute = groupByAttribute,
			let otherGroupByAttribute = sameValueGrouper.groupByAttribute
		{
			return groupByAttribute.equalTo(otherGroupByAttribute)
		}
		return false
	}
}
