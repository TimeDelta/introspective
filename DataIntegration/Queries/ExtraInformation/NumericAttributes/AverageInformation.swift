//
//  AverageInformation.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class AverageInformation: AnyInformation {

	public override var key: String { get { return "Average" } }

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	public override func compute(forSamples samples: [Sample]) -> String {
		let filteredSamples = DependencyInjector.util.sampleUtil.getOnly(samples: samples, from: startDate, to: endDate)
		return String(DependencyInjector.util.numericSampleUtil.average(for: attribute, over: filteredSamples))
	}
}
