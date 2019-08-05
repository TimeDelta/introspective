//
//  SameValueSampleGrouper.swift
//  Introspective
//
//  Created by Bryan Nova on 4/26/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

public final class SameValueSampleGrouper: SampleGrouper {

	// MARK: - Display Information

	public static var userVisibleDescription: String = "Group By Same Value"
	public let attributedName: String = "Group By Same Value"
	public var description: String {
		guard let groupByAttribute = groupByAttribute else {
			return attributedName
		}
		return "Group by same \(groupByAttribute.name.localizedLowercase)"
	}

	// MARK: - Attributes

	public final let attributes: [Attribute]
	public final let attributeSelectAttribute: AttributeSelectAttribute

	// MARK: - Instance Variables

	public final var groupByAttribute: Attribute?

	// MARK: - Initializers

	public required convenience init(sampleType: Sample.Type) {
		self.init(attributes: sampleType.attributes)
	}

	public required init(attributes: [Attribute]) {
		groupByAttribute = attributes.first
		attributeSelectAttribute = AttributeSelectAttribute(attributes: attributes)
		self.attributes = [
			attributeSelectAttribute,
		]
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
		// grouping by hashable value is better time complexity
		if try samples[0].value(of: groupByAttribute) is Hashable {
			return try getGroupsForHashableValues(samples)
		}
		return try getGroupsForNonHashableValues(samples)
	}

	public final func groupNameFor(value: Any) throws -> String {
		let groupByAttribute = try getGroupByAttribute(methodName: "groupNameFor(value:)")
		let valueString = try groupByAttribute.convertToDisplayableString(from: value)
		return "\(groupByAttribute.name) = \(valueString)"
	}

	public final func groupValuesAreEqual(_ first: Any, _ second: Any) throws -> Bool {
		let groupByAttribute = try getGroupByAttribute(methodName: "groupValuesAreEqual()")
		return try groupByAttribute.valuesAreEqual(first, second)
	}

	public final func copy() -> SampleGrouper {
		return SameValueSampleGrouper(
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
			groupByAttribute = castedValue
			return
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	// MARK: - Helper Functions

	private final func getGroupsForHashableValues(_ samples: [Sample]) throws -> [(Any, [Sample])] {
		let groupByAttribute = try getGroupByAttribute(methodName: "getGroupsForHashableValues()")
		let groupsByValue = try Dictionary(grouping: samples, by: { (sample: Sample) -> AnyHashable in
			guard let value = try sample.value(of: groupByAttribute) else { return "No Value" }
			guard let hashableValue = value as? AnyHashable else {
				throw TypeMismatchError(attribute: groupByAttribute, of: sample, wasA: type(of: value))
			}
			return hashableValue
		})
		return groupsByValue.map{ (key, value) in return (key, value) }
	}

	private final func getGroupsForNonHashableValues(_ samples: [Sample]) throws -> [(Any, [Sample])] {
		let groupByAttribute = try getGroupByAttribute(methodName: "getGroupsForNonHashableValues()")
		var groups = [(Any, [Sample])]()
		for sample in samples {
			let sampleValue = try sample.value(of: groupByAttribute)
			if let index = try groups.firstIndex(where: { try groupByAttribute.valuesAreEqual($0.0, sampleValue) }) {
				groups[index].1.append(sample)
			} else {
				if let sampleValue = sampleValue {
					groups.append((sampleValue, [sample]))
				} else {
					groups.append(("No Value", [sample]))
				}
			}
		}
		return groups
	}

	private final func getGroupByAttribute(methodName: String) throws -> Attribute {
		guard let groupByAttribute = groupByAttribute else {
			throw GenericError("Called \(methodName) before groupByAttribute was set")
		}
		return groupByAttribute
	}

	// MARK: - Equality

	public final func equalTo(_ otherGrouper: SampleGrouper) -> Bool {
		guard let sameValueGrouper = otherGrouper as? SameValueSampleGrouper else { return false }
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
