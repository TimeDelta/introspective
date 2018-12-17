//
//  MinimumInformation.swift
//  Introspective
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class MinimumInformation<AttributeType: Comparable>: AnyInformation {

	public final override var name: String { return "Minimum" }
	public final override var description: String { return name + " " + attribute.name.localizedLowercase }

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	public final override func compute(forSamples samples: [Sample]) -> String {
		let filteredSamples = DependencyInjector.util.sample.getOnly(samples: samples, from: startDate, to: endDate)
		let value = DependencyInjector.util.numericSample.min(for: attribute, over: filteredSamples) as AttributeType
		return String(describing: value)
	}

	public final override func computeGraphable(forSamples samples: [Sample]) -> String {
		let filteredSamples = DependencyInjector.util.sample.getOnly(samples: samples, from: startDate, to: endDate)
		let value = DependencyInjector.util.numericSample.min(for: attribute, over: filteredSamples) as AttributeType
		if value is Duration {
			return String((value as! Duration).inUnit(.hour))
		}
		return String(describing: value)
	}

	public final override func equalTo(_ other: ExtraInformation) -> Bool {
		return other is MinimumInformation && attribute.equalTo(other.attribute)
	}
}
