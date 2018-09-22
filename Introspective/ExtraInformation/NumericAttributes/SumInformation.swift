//
//  SumInformation.swift
//  Introspective
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class SumInformation: AnyInformation {

	public final override var name: String { get { return "Total" } }
	public final override var description: String { return name + " " + attribute.name }

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	public final override func compute(forSamples samples: [Sample]) -> String {
		let filteredSamples = DependencyInjector.util.sampleUtil.getOnly(samples: samples, from: startDate, to: endDate)
		return String(DependencyInjector.util.numericSampleUtil.sum(for: attribute, over: filteredSamples) as Double)
	}

	public final override func equalTo(_ other: ExtraInformation) -> Bool {
		return other is SumInformation && attribute.equalTo(other.attribute)
	}
}
