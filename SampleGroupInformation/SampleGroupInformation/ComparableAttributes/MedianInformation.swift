//
//  MedianInformation.swift
//  Introspective
//
//  Created by Bryan Nova on 3/14/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common
import Samples

public final class MedianInformation<AttributeType: Comparable>: AnyInformation {
	// MARK: - Display Information

	public final override var name: String { "Median" }
	public final override var description: String { name + " " + attribute.name.localizedLowercase }

	// MARK: - Instance Variables

	final let noSamplesMessage = "No samples between given start and end dates"

	// MARK: - Initializers

	internal required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	// MARK: Information Functions

	public final override func compute(forSamples samples: [Sample]) throws -> String {
		try compute(samples, shouldThrowOnEmptyFilter: false)
	}

	public final override func computeGraphable(forSamples samples: [Sample]) throws -> String {
		try compute(samples, shouldThrowOnEmptyFilter: true)
	}

	// MARK: - Equality

	public final override func equalTo(_ other: SampleGroupInformation) -> Bool {
		other is MedianInformation < AttributeType> && attribute.equalTo(other.attribute)
	}

	// MARK: - Helper Functions

	private final func compute(_ samples: [Sample], shouldThrowOnEmptyFilter: Bool) throws -> String {
		let filteredSamples = try filterSamples(samples, as: AttributeType.self)
		if filteredSamples.isEmpty {
			if shouldThrowOnEmptyFilter {
				throw GenericDisplayableError(title: noSamplesMessage)
			}
			return noSamplesMessage
		}
		let sortedSamples = try filteredSamples.sorted(by: {
			if
				let value1 = try $0.value(of: attribute) as? AttributeType,
				let value2 = try $1.value(of: attribute) as? AttributeType {
				return value1 < value2
			}
			Log().error("Failed to compare %@ attribute of two %@ samples", attribute.name, $0.attributedName)
			return true
		})
		let value = try sortedSamples[sortedSamples.count / 2].value(of: attribute)
		if let value = value as? AttributeType {
			return String(describing: value)
		}
		return String(describing: value)
	}
}
