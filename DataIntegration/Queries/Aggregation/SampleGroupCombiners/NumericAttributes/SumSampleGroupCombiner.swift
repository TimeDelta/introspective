//
//  SumSampleGroupCombiner.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class SumSampleGroupCombiner: SampleGroupCombiner {

	public static let name = "Sum"

	public let descriptionIsPlural: Bool = true
	public var description: String {
		return "sum of all"
	}

	public required init() {}

	public func combine(groups: [(Any, [Sample])], groupedBy groupAttribute: Attribute, combinationAttribute: Attribute) -> [Sample] {
		var combinedSamples = [Sample]()
		for (groupValue, samples) in groups {
			let sample = samples[0]

			try! sample.set(attribute: groupAttribute, to: groupValue)

			var combinationValue: Any
			if combinationAttribute is DoubleAttribute {
				combinationValue = DependencyInjector.util.numericSampleUtil.sum(for: combinationAttribute, over: samples) as Double
			} else if combinationAttribute is IntegerAttribute {
				combinationValue = DependencyInjector.util.numericSampleUtil.sum(for: combinationAttribute, over: samples) as Int
			} else {
				fatalError("Forgot a numeric attribute type: \(type(of: combinationAttribute))")
			}
			try! sample.set(attribute: combinationAttribute, to: combinationValue)

			combinedSamples.append(sample)
		}
		return combinedSamples
	}
}
