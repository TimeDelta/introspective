//
//  AverageInformation.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class AverageInformation<SampleType: DoubleValueSample>: SampleInformation {

	public var informationType: InformationType { get { return .statistics } }

	public var key: String { get { return "Average" } }

	public var startDate: Date?
	public var endDate: Date?

	public func compute(forSamples samples: [SampleType]) -> String {
		let filteredSamples = DependencyInjector.util.sampleUtil.getOnly(samples: samples, from: startDate, to: endDate)
		return String(DependencyInjector.util.numericSampleUtil.average(over: filteredSamples))
	}
}
