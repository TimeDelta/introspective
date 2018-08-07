//
//  MaximumInformation.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class MaximumInformation<AttributeType: Comparable>: AnyInformation {

	public override var key: String { get { return "Maximum" } }

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	public override func compute(forSamples samples: [Sample]) -> String {
		let filteredSamples = DependencyInjector.util.sampleUtil.getOnly(samples: samples, from: startDate, to: endDate)
		let value = DependencyInjector.util.numericSampleUtil.max(for: attribute, over: filteredSamples) as AttributeType
		return String(describing: value)
	}
}
