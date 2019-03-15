//
//  MedianInformation.swift
//  Introspective
//
//  Created by Bryan Nova on 3/14/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

public final class MedianInformation<AttributeType: Comparable>: AnyInformation {

	// MARK: - Display Information

	public final override var name: String { return "Median" }
	public final override var description: String { return name + " " + attribute.name.localizedLowercase }

	// MARK: - Instance Variables

	final let noSamplesMessage = "No samples between given start and end dates"
	private final let log = Log()

	// MARK: - Initializers

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	// MARK: Information Functions

	public final override func compute(forSamples samples: [Sample]) throws -> String {
		return try compute(samples, shouldThrowOnEmptyFilter: false)
	}

	public final override func computeGraphable(forSamples samples: [Sample]) throws -> String {
		return try compute(samples, shouldThrowOnEmptyFilter: true)
	}

	// MARK: - Equality

	public final override func equalTo(_ other: ExtraInformation) -> Bool {
		return other is MedianInformation<AttributeType> && attribute.equalTo(other.attribute)
	}

	// MARK: - Helper Functions

	private final func compute(_ samples: [Sample], shouldThrowOnEmptyFilter: Bool) throws -> String {
		let filteredSamples = try filterSamples(samples, as: AttributeType.self)
		if filteredSamples.count == 0 {
			if shouldThrowOnEmptyFilter {
				throw GenericDisplayableError(title: noSamplesMessage)
			}
			return noSamplesMessage
		}
		let sortedSamples = try filteredSamples.sorted(by: {
			if
				let value1 = try $0.value(of: attribute) as? AttributeType,
				let value2 = try $1.value(of: attribute) as? AttributeType
			{
				return value1 < value2
			}
			self.log.error("Failed to compare %@ attribute of two %@ samples", attribute.name, $0.attributedName)
			return true
		})
		let value = try sortedSamples[sortedSamples.count / 2].value(of: attribute)
		if let value = value as? AttributeType {
			return String(describing: value)
		}
		return String(describing: value)
	}
}
