//
//  CountInformation.swift
//  Introspective
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import DependencyInjection
import Samples

public final class CountInformation: AnyInformation {
	// MARK: - Display Information

	public final override var name: String { "Count" }
	public final override var description: String { name }

	// MARK: - Initializers

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	// MARK: - Information Functions

	public final override func compute(forSamples samples: [Sample]) -> String {
		let filteredSamples = injected(SampleUtil.self)
			.getOnly(samples: samples, from: startDate, to: endDate)
		return String(filteredSamples.count)
	}

	public final override func computeGraphable(forSamples samples: [Sample]) -> String {
		compute(forSamples: samples)
	}

	// MARK: - Equality

	public final override func equalTo(_ other: SampleGroupInformation) -> Bool {
		other is CountInformation && attribute.equalTo(other.attribute)
	}
}
