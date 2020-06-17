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

	public final override var name: String { return "Count" }
	public final override var description: String { return name }

	// MARK: - Initializers

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	// MARK: - Information Functions

	public final override func compute(forSamples samples: [Sample]) -> String {
		let filteredSamples = DependencyInjector.get(SampleUtil.self).getOnly(samples: samples, from: startDate, to: endDate)
		return String(filteredSamples.count)
	}

	public final override func computeGraphable(forSamples samples: [Sample]) -> String {
		return compute(forSamples: samples)
	}

	// MARK: - Equality

	public final override func equalTo(_ other: SampleGroupInformation) -> Bool {
		return other is CountInformation && attribute.equalTo(other.attribute)
	}
}
