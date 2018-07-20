//
//  SumInformation.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class SumInformation<SampleType: DoubleValueSample>: SampleInformation<SampleType> {

	public override var informationType: InformationType { get { return .statistics } }
	public override var key: String { get { return "Sum" } }

	public override func compute(forSamples samples: [SampleType]) -> String {
		let filteredSamples = DependencyInjector.util.sampleUtil.getOnly(samples: samples, from: startDate, to: endDate)
		return String(DependencyInjector.util.numericSampleUtil.sum(over: filteredSamples))
	}
}
