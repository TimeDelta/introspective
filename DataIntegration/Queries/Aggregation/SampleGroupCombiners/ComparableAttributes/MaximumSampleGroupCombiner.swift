//
//  MaximumSampleGroupCombiner.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class MaximumSampleGroupCombiner: SampleGroupCombiner {

	public static let name = "Maximum"

	public let descriptionIsPlural: Bool = false
	public var description: String {
		return "maximum"
	}

	public required init() {}

	public func combine(groups: [(Any, [Sample])], groupedBy groupAttribute: Attribute, combinationAttribute: Attribute) -> [Sample] {
		var combinedSamples = [Sample]()
		for (groupValue, samples) in groups {
			let sample = samples[0]

			try! sample.set(attribute: groupAttribute, to: groupValue)

			var combinationValue: Any
			if combinationAttribute is DoubleAttribute {
				combinationValue = DependencyInjector.util.numericSampleUtil.max(for: combinationAttribute, over: samples) as Double
			} else if combinationAttribute is IntegerAttribute {
				combinationValue = DependencyInjector.util.numericSampleUtil.max(for: combinationAttribute, over: samples) as Int
			} else if combinationAttribute is DateAttribute {
				combinationValue = DependencyInjector.util.numericSampleUtil.max(for: combinationAttribute, over: samples) as Date
			} else {
				fatalError("Forgot a comparable attribute type: \(type(of: combinationAttribute))")
			}
			try! sample.set(attribute: combinationAttribute, to: combinationValue)

			combinedSamples.append(sample)
		}
		return combinedSamples
	}
}
