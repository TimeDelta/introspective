//
//  MaximumInformation.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class MaximumInformation<SampleType: Sample, AttributeType: Comparable>: SampleInformation<SampleType> {

	public override var informationType: InformationType { get { return .statistics } }
	public override var key: String { get { return "Maximum" } }

	public init(_ attribute: Attribute) {
		super.init()
		self.attribute = attribute
	}

	public override func compute(forSamples samples: [SampleType]) -> String {
		let filteredSamples = DependencyInjector.util.sampleUtil.getOnly(samples: samples, from: startDate, to: endDate)
		let value = DependencyInjector.util.numericSampleUtil.max(for: attribute, over: filteredSamples) as AttributeType
		return String(describing: value)
	}
}
