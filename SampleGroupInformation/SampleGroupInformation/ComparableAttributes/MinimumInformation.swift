//
//  MinimumInformation.swift
//  Introspective
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common
import DependencyInjection
import Samples

public final class MinimumInformation<AttributeType: Comparable>: AnyInformation {
	// MARK: - Display Information

	override public final var name: String { "Minimum" }
	override public final var description: String { name + " " + attribute.name.localizedLowercase }

	// MARK: - Initializers

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	// MARK: Information Functions

	override public final func compute(forSamples samples: [Sample]) throws -> String {
		let filteredSamples = try filterSamples(samples, as: AttributeType.self)
		if filteredSamples.isEmpty { return "No samples matching filter" }
		let value = try DependencyInjector.get(NumericSampleUtil.self)
			.min(for: attribute, over: filteredSamples, as: AttributeType.self)
		return String(describing: value)
	}

	override public final func computeGraphable(forSamples samples: [Sample]) throws -> String {
		let filteredSamples = try filterSamples(samples, as: AttributeType.self)
		if filteredSamples.isEmpty { throw GenericDisplayableError(title: "No samples matching filter") }
		let value = try DependencyInjector.get(NumericSampleUtil.self)
			.min(for: attribute, over: filteredSamples, as: AttributeType.self)
		if value is Duration {
			return String((value as! Duration).inUnit(.hour))
		}
		return String(describing: value)
	}

	// MARK: - Equality

	override public final func equalTo(_ other: SampleGroupInformation) -> Bool {
		other is MinimumInformation < AttributeType> && attribute.equalTo(other.attribute)
	}
}
