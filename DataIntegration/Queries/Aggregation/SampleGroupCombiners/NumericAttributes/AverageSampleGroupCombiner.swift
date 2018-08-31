//
//  AverageSampleGroupCombiner.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class AverageSampleGroupCombiner: SampleGroupCombiner {

	public static let name = "Average"

	public final let descriptionIsPlural: Bool = false
	public final var description: String {
		return "average"
	}

	public required init() {}

	public final func combine(groups: [(Any, [Sample])], groupedBy groupAttribute: Attribute, combinationAttribute: Attribute) -> [Sample] {
		var combinedSamples = [Sample]()
		for (groupValue, samples) in groups {
			let sample = samples[0]

			try! sample.set(attribute: groupAttribute, to: groupValue)

			var combinationValue: Any = DependencyInjector.util.numericSampleUtil.average(for: combinationAttribute, over: samples)
			if combinationAttribute is IntegerAttribute {
				combinationValue = Int(combinationValue as! Double)
			}
			try! sample.set(attribute: combinationAttribute, to: combinationValue)

			combinedSamples.append(sample)
		}
		return combinedSamples
	}
}
