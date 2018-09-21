//
//  AverageInformation.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class AverageInformation: AnyInformation {

	public final override var name: String { return "Average" }
	public final override var description: String { return name + " " + attribute.name }

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	public final override func compute(forSamples samples: [Sample]) -> String {
		let filteredSamples = DependencyInjector.util.sampleUtil.getOnly(samples: samples, from: startDate, to: endDate)
		return String(DependencyInjector.util.numericSampleUtil.average(for: attribute, over: filteredSamples))
	}

	public final override func equalTo(_ other: ExtraInformation) -> Bool {
		return other is AverageInformation && attribute.equalTo(other.attribute)
	}
}
