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

	override public final var name: String { "Count" }
	override public final var description: String { name }

	// MARK: - Initializers

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	// MARK: - Information Functions

	override public final func compute(forSamples samples: [Sample]) -> String {
		let filteredSamples = DependencyInjector.get(SampleUtil.self)
			.getOnly(samples: samples, from: startDate, to: endDate)
		return String(filteredSamples.count)
	}

	override public final func computeGraphable(forSamples samples: [Sample]) -> String {
		compute(forSamples: samples)
	}

	// MARK: - Equality

	override public final func equalTo(_ other: SampleGroupInformation) -> Bool {
		other is CountInformation && attribute.equalTo(other.attribute)
	}
}
