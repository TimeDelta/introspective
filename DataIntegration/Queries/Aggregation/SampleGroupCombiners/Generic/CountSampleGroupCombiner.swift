//
//  CountSampleGroupCombiner.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class CountSampleGroupCombiner: SampleGroupCombiner {

	public static let name = "Count"

	public let descriptionIsPlural: Bool = true
	public var description: String {
		return "number of"
	}

	public required init() {}

	/// - Parameter groups: Must not pass empty sample array for a group
	public func combine(groups: [(Any, [Sample])], groupedBy groupAttribute: Attribute, combinationAttribute: Attribute) -> [Sample] {
		var combinedSamples = [Sample]()
		for (groupValue, samples) in groups {
			let name = samples[0].name
			let description = samples[0].description
			let combinationValue = samples.count
			let countAttribute: Attribute = IntegerAttribute(
				name: combinationAttribute.name,
				pluralName: combinationAttribute.pluralName,
				description: combinationAttribute.extendedDescription)
			let sample = AnySample(
				name: name,
				description: description,
				attributes: [groupAttribute, countAttribute],
				attributeValues: [
					groupAttribute.name: groupValue,
					combinationAttribute.name: combinationValue,
				])
			combinedSamples.append(sample)
		}
		return combinedSamples
	}
}
