//
//  SumInformation.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class SumInformation<SampleType: Sample>: SampleInformation<SampleType> {

	public override var informationType: InformationType { get { return .statistics } }
	public override var key: String { get { return "Sum" } }

	public init(_ attribute: Attribute) {
		super.init()
		self.attribute = attribute
	}

	public override func compute(forSamples samples: [SampleType]) -> String {
		let filteredSamples = DependencyInjector.util.sampleUtil.getOnly(samples: samples, from: startDate, to: endDate)
		return String(DependencyInjector.util.numericSampleUtil.sum(for: attribute, over: filteredSamples) as Double)
	}
}
