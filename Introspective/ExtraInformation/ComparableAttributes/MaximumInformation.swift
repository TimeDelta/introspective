//
//  MaximumInformation.swift
//  Introspective
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class MaximumInformation<AttributeType: Comparable>: AnyInformation {

	public final override var name: String { return "Maximum" }
	public final override var description: String { return name + " " + attribute.name.localizedLowercase }

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	public final override func compute(forSamples samples: [Sample]) -> String {
		let filteredSamples = DependencyInjector.util.sampleUtil.getOnly(samples: samples, from: startDate, to: endDate)
		let value = DependencyInjector.util.numericSampleUtil.max(for: attribute, over: filteredSamples) as AttributeType
		return String(describing: value)
	}

	public final override func equalTo(_ other: ExtraInformation) -> Bool {
		return other is MaximumInformation && attribute.equalTo(other.attribute)
	}
}
