//
//  MinimumInformation.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class MinimumInformation<SampleType: DoubleValueSample>: SampleInformation<SampleType> {

	public override var informationType: InformationType { get { return .statistics } }
	public override var key: String { get { return "Minimum" } }

	public override func compute(forSamples samples: [SampleType]) -> String {
		let filteredSamples = DependencyInjector.util.sampleUtil.getOnly(samples: samples, from: startDate, to: endDate)
		return String(DependencyInjector.util.numericSampleUtil.min(over: filteredSamples))
	}
}
