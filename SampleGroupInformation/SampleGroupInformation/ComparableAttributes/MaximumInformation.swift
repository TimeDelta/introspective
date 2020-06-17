//
//  MaximumInformation.swift
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

public final class MaximumInformation<AttributeType: Comparable>: AnyInformation {

	// MARK: - Display Information

	public final override var name: String { return "Maximum" }
	public final override var description: String { return name + " " + attribute.name.localizedLowercase }

	// MARK: - Initializers

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	// MARK: - Information Functions

	public final override func compute(forSamples samples: [Sample]) throws -> String {
		let filteredSamples = try filterSamples(samples, as: AttributeType.self)
		if filteredSamples.count == 0 { return "No samples matching filter" }
		let value = try DependencyInjector.get(NumericSampleUtil.self).max(for: attribute, over: filteredSamples, as: AttributeType.self)
		return String(describing: value)
	}

	public final override func computeGraphable(forSamples samples: [Sample]) throws -> String {
		let filteredSamples = try filterSamples(samples, as: AttributeType.self)
		if filteredSamples.count == 0 { throw GenericDisplayableError(title: "No samples matching filter") }
		let value = try DependencyInjector.get(NumericSampleUtil.self).max(for: attribute, over: filteredSamples, as: AttributeType.self)
		if value is Duration {
			return String((value as! Duration).inUnit(.hour))
		}
		return String(describing: value)
	}

	// MARK: - Equality

	public final override func equalTo(_ other: SampleGroupInformation) -> Bool {
		return other is MaximumInformation<AttributeType> && attribute.equalTo(other.attribute)
	}
}
