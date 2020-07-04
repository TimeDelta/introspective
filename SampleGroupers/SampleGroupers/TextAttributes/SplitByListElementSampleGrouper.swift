//
//  SplitByListElementSampleGrouper.swift
//  SampleGroupers
//
//  Created by Bryan Nova on 7/3/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Attributes
import Common
import Foundation
import Samples

public final class SplitByListElementSampleGrouper: SampleGrouper {
	// MARK: - Display Information

	public static var userVisibleDescription: String = "Group by same list element"
	public let attributedName: String = "Group by same list element"
	public var description: String {
		guard let groupByAttribute = groupByAttribute else {
			return attributedName
		}
		return "Group by same \(groupByAttribute.name.localizedLowercase) (each list element separately)"
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
		groupByAttribute = attributes.first
		attributeSelectAttribute = AttributeSelectAttribute(attributes: attributes.filter { a in a is TextAttribute })
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
		guard !samples.isEmpty else { return [] }

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
		SplitByListElementSampleGrouper(
			groupByAttribute: groupByAttribute,
			attributeSelectAttribute: attributeSelectAttribute
		)
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

	private final func getGroupsForNonHashableValues(_ samples: [Sample]) throws -> [(Any, [Sample])] {
		let groupByAttribute = try getGroupByAttribute(methodName: "getGroupsForNonHashableValues()")
		var groups = [(Any, [Sample])]()
		for sample in samples {
			guard let uncastValue = try sample.value(of: groupByAttribute) else { continue }
			guard let stringValue = uncastValue as? String else { continue }
			for value in splitIntoListElements(stringValue) {
				guard !value.isEmpty else { continue }
				if let index = try groups.firstIndex(where: { try groupByAttribute.valuesAreEqual($0.0, value) }) {
					groups[index].1.append(sample)
				} else {
					groups.append((value, [sample]))
				}
			}
		}
		return groups
	}

	private final func getGroupByAttribute(methodName: String) throws -> TextAttribute {
		guard let groupByAttribute = groupByAttribute else {
			throw GenericError("Called \(methodName) before groupByAttribute was set")
		}
		guard let groupByTextAttribute = groupByAttribute as? TextAttribute else {
			log.error("User tried to select non-text attribute for SplitByListElementSampleGrouper")
			throw GenericError("You must select a text attribute")
		}
		return groupByTextAttribute
	}

	// MARK: - Equality

	public final func equalTo(_ otherGrouper: SampleGrouper) -> Bool {
		guard let sameTypeGrouper = otherGrouper as? SplitByListElementSampleGrouper else { return false }
		if groupByAttribute == nil && sameTypeGrouper.groupByAttribute == nil {
			return true
		}
		if
			let groupByAttribute = groupByAttribute,
			let otherGroupByAttribute = sameTypeGrouper.groupByAttribute {
			return groupByAttribute.equalTo(otherGroupByAttribute)
		}
		return false
	}

	// MARK: - Helper Functions

	private final func splitIntoListElements(_ stringValue: String) -> [Substring] {
		var previousChars = ""
		return stringValue.split { ch in
			previousChars += String(ch)
			if previousChars.count > 4 {
				previousChars.removeFirst()
			}
			return ch == "," || ch == "\n" || String(previousChars) == " and"
		}
	}
}
