//
//  SumInformation.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class SumInformation: AnyInformation {

	public override var key: String { get { return "Sum" } }

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	public override func compute(forSamples samples: [Sample]) -> String {
		let filteredSamples = DependencyInjector.util.sampleUtil.getOnly(samples: samples, from: startDate, to: endDate)
		return String(DependencyInjector.util.numericSampleUtil.sum(for: attribute, over: filteredSamples) as Double)
	}
}
