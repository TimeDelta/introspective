//
//  AdvancedSampleGrouper.swift
//  Introspective
//
//  Created by Bryan Nova on 4/26/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

public final class AdvancedSampleGrouper: SampleGrouper {

	// MARK: - Display Information

	public static var userVisibleDescription: String = "Advanced"
	public final let attributedName: String = "Advanced"
	public var description: String {
		return groupDefinitions.map{ $0.name }.joined(separator: ", ")
	}

	// MARK: - Attributes

	public final let attributes: [Attribute] = []

	// MARK: - Instance Variables

	public var groupDefinitions = [GroupDefinition]()

	// MARK: - Initializers

	public init() {}
	public required init(sampleType: Sample.Type) {}
	public required init(attributes: [Attribute]) {}

	// MARK: - Grouper Functions

	public final func group(samples: [Sample]) throws -> [(Any, [Sample])] {
		var groups = [(Any, [Sample])]()
		for definition in groupDefinitions {
			var groupSamples = [Sample]()
			for sample in samples {
				if try definition.sampleBelongsInGroup(sample) {
					groupSamples.append(sample)
				}
			}
			groups.append((definition.name, groupSamples))
		}
		return groups
	}

	public final func groupNameFor(value: Any) throws -> String {
		guard let definitionName = value as? String else {
			let valueType = String(describing: type(of: value))
			throw GenericError("Group value was expected to be group definition name but got a \(valueType)")
		}
		return definitionName
	}

	public final func groupValuesAreEqual(_ first: Any, _ second: Any) throws -> Bool {
		guard let name1 = first as? String else {
			let valueType = String(describing: type(of: value))
			let value = String(describing: first)
			throw GenericError("Group value was expected to be group definition name but got a \(valueType): \(value)")
		}
		guard let name2 = second as? String else {
			let valueType = String(describing: type(of: value))
			let value = String(describing: second)
			throw GenericError("Group value was expected to be group definition name but got a \(valueType): \(value)")
		}
		return name1 == name2
	}

	public final func attributeValuesAreValid() -> Bool {
		return true // has no attributes
	}

	public final func isValid() -> Bool {
		guard groupDefinitions.count > 0 else { return false}
		for definition in groupDefinitions {
			if !definition.isValid() {
				return false
			}
		}
		return true
	}

	public final func copy() -> SampleGrouper {
		let copy = AdvancedSampleGrouper()
		for definition in groupDefinitions {
			copy.groupDefinitions.append(definition.copy())
		}
		return copy
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	// MARK: - Equality

	public final func equalTo(_ otherGrouper: SampleGrouper) -> Bool {
		guard let advancedGrouper = otherGrouper as? AdvancedSampleGrouper else { return false }
		return groupDefinitions.elementsEqual(advancedGrouper.groupDefinitions, by: { $0.equalTo($1) })
	}
}
