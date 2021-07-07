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

	public final var groupByAttribute: TextAttribute?

	// MARK: - Initializers

	public required convenience init(sampleType: Sample.Type) {
		self.init(attributes: sampleType.attributes)
	}

	public required init(attributes: [Attribute]) {
		attributeSelectAttribute = AttributeSelectAttribute(
			id: 0,
			attributes: attributes.filter { a in a is TextAttribute }
		)
		groupByAttribute = attributeSelectAttribute.typedPossibleValues.first as? TextAttribute
		self.attributes = [
			attributeSelectAttribute,
		]
	}

	private init(groupByAttribute: TextAttribute?, attributeSelectAttribute: AttributeSelectAttribute) {
		self.groupByAttribute = groupByAttribute
		self.attributeSelectAttribute = attributeSelectAttribute
		attributes = [attributeSelectAttribute]
	}

	// MARK: - Grouper Functions

	public final func group(samples: [Sample]) throws -> [(Any, [Sample])] {
		let groupByAttribute = try getGroupByAttribute(methodName: "group(samples:)")
		guard !samples.isEmpty else { return [] }

		var groups = [(Any, [Sample])]()
		for sample in samples {
			guard let uncastValue = try sample.value(of: groupByAttribute) else { continue }
			guard let stringValue = uncastValue as? String else { continue }
			let listElements = splitIntoListElements(stringValue).map { str in str.localizedLowercase }
			for value in listElements {
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

	public final func groupNameFor(value: Any) throws -> String {
		let groupByAttribute = try getGroupByAttribute(methodName: "groupNameFor(value:)")
		let valueString = try groupByAttribute.convertToDisplayableString(from: value)
		return "\(groupByAttribute.name) has \(valueString)"
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
			guard let castedValue = value as? TextAttribute else {
				throw TypeMismatchError(attribute: attributeSelectAttribute, of: self, wasA: type(of: value))
			}
			groupByAttribute = castedValue
			return
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	// MARK: - Helper Functions

	private final func getGroupByAttribute(methodName: String) throws -> TextAttribute {
		guard let groupByAttribute = groupByAttribute else {
			throw GenericError("Called \(methodName) before groupByAttribute was set")
		}
		return groupByAttribute
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

	private final func splitIntoListElements(_ stringValue: String) -> [String] {
		stringValue.replacingOccurrences(of: " and ", with: ",").split { ch in
			ch == "," || ch == "\n"
		}.map { str in String(str).trimmingCharacters(in: CharacterSet.whitespaces) }
	}
}
