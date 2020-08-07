//
//  MostRecentDateInformation.swift
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

public final class MostRecentDateInformation: AnyInformation {
	// MARK: - Static Variables

	private typealias Me = MostRecentDateInformation

	static let noSamplesMessage = "No samples between given start and end dates"

	private static let log = Log()

	// MARK: - Display Information

	public final override var name: String { "Most Recent" }
	public final override var description: String { name + " " + attribute.name.localizedLowercase }

	// MARK: - Initializers

	public required init(_ attribute: Attribute) {
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
		other is MostRecentDateInformation && attribute.equalTo(other.attribute)
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
		guard var mostRecentDate = firstSampleValue as? Date else {
			Me.log.error("Failed to get initial date when computing most recent")
			throw TypeMismatchError(attribute: attribute, of: filteredSamples[0], wasA: type(of: firstSampleValue))
		}
		for sample in filteredSamples {
			let value = try sample.value(of: attribute)
			if let date = value as? Date {
				if date.isAfterDate(mostRecentDate, granularity: .nanosecond) {
					mostRecentDate = date
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
			.string(for: mostRecentDate, dateStyle: .short, timeStyle: .short)
	}
}
