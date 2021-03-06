//
//  EarliestDateInformation.swift
//  Introspective
//
//  Created by Bryan Nova on 8/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common
import DependencyInjection
import Samples

public final class OldestDateInformation: AnyInformation {
	// MARK: - Static Variables

	private typealias Me = OldestDateInformation

	static let noSamplesMessage = "No samples between given start and end dates"

	private static let log = Log()

	// MARK: Display Information

	public final override var name: String { "Oldest" }
	public final override var description: String { name + " " + attribute.name.localizedLowercase }

	// MARK: - Initializers

	internal required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	// MARK: - Information Functions

	public final override func compute(forSamples samples: [Sample]) throws -> String {
		try compute(samples, shouldThrowOnEmptyFilter: false)
	}

	public final override func computeGraphable(forSamples samples: [Sample]) throws -> String {
		try compute(samples, shouldThrowOnEmptyFilter: true)
	}

	// MARK: - Equality

	public final override func equalTo(_ other: SampleGroupInformation) -> Bool {
		other is OldestDateInformation && attribute.equalTo(other.attribute)
	}

	// MARK: - Helper Functions

	private final func compute(_ samples: [Sample], shouldThrowOnEmptyFilter: Bool) throws -> String {
		let filteredSamples = try filterSamples(samples, as: Date.self)
		if filteredSamples.isEmpty {
			if shouldThrowOnEmptyFilter {
				throw GenericDisplayableError(title: Me.noSamplesMessage)
			}
			return Me.noSamplesMessage
		}

		let firstSampleValue = try filteredSamples[0].value(of: attribute)
		guard var oldestSampleDate = firstSampleValue as? Date else {
			Me.log.error("Failed to get initial date when computing oldest")
			throw TypeMismatchError(attribute: attribute, of: filteredSamples[0], wasA: type(of: firstSampleValue))
		}
		for sample in filteredSamples {
			let value = try sample.value(of: attribute)
			if let date = value as? Date {
				if date.isBeforeDate(oldestSampleDate, granularity: .nanosecond) {
					oldestSampleDate = date
				}
			} else if !attribute.optional || value != nil {
				Me.log.error(
					"non-optional attribute (%@) of sample (%@) returned %@",
					attribute.name,
					sample.attributedName,
					String(describing: value)
				)
			}
		}
		return injected(CalendarUtil.self)
			.string(for: oldestSampleDate, dateStyle: .short, timeStyle: .short)
	}
}
