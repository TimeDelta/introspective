//
//  CountInformation.swift
//  Introspective
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class CountInformation: AnyInformation {

	public final override var name: String { return "Count" }
	public final override var description: String { return name }

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	public final override func compute(forSamples samples: [Sample]) -> String {
		let filteredSamples = DependencyInjector.util.sampleUtil.getOnly(samples: samples, from: startDate, to: endDate)
		return String(filteredSamples.count)
	}

	public final override func equalTo(_ other: ExtraInformation) -> Bool {
		return other is CountInformation && attribute.equalTo(other.attribute)
	}
}
