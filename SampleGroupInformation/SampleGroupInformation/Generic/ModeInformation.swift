//
//  ModeInformation.swift
//  Introspective
//
//  Created by Bryan Nova on 3/15/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common
import Samples

public final class ModeInformation: AnyInformation {
	// MARK: - Static Variables

	private typealias Me = ModeInformation

	private static let log = Log()

	// MARK: - Display Information

	public final override var name: String { "Mode" }
	public final override var description: String { attribute.name.localizedLowercase + " " + name }

	// MARK: - Instance Variables

	final let noSamplesMessage = "No samples between given start and end dates"

	// MARK: - Initializers

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	// MARK: Information Functions

	public final override func compute(forSamples samples: [Sample]) throws -> String {
		try compute(samples, graphable: false)
	}

	public final override func computeGraphable(forSamples samples: [Sample]) throws -> String {
		try compute(samples, graphable: true)
	}

	// MARK: - Equality

	public final override func equalTo(_ other: SampleGroupInformation) -> Bool {
		other is ModeInformation && attribute.equalTo(other.attribute)
	}

	// MARK: - Helper Functions

	private final func compute(_ samples: [Sample], graphable: Bool) throws -> String {
		let filteredSamples = try filterSamples(samples, as: Any?.self)
		if filteredSamples.isEmpty {
			if graphable {
				throw GenericDisplayableError(title: noSamplesMessage)
			}
			return noSamplesMessage
		}

		var valueCounts = try getValueCounts(filteredSamples)

		var modeValue: String = ""
		var modeCount: Int = 0
		while !valueCounts.isEmpty {
			if let (value, count) = valueCounts.popFirst() {
				if count > modeCount {
					modeValue = value
					modeCount = count
				}
			} else {
				Me.log.error("Unable to retrieve value count")
			}
		}

		return createReturnValue(graphable, modeValue, modeCount)
	}

	private final func getValueCounts(_ samples: [Sample]) throws -> [String: Int] {
		var valueCounts = [String: Int]()
		for sample in samples {
			let value = try getValueForSample(sample)
			var count: Int = 0
			if let valueCount = valueCounts[value] {
				count = valueCount
			}
			valueCounts[value] = count + 1
		}
		return valueCounts
	}

	private final func getValueForSample(_ sample: Sample) throws -> String {
		let value = try sample.value(of: attribute)
		if let value = value {
			return String(describing: value)
		}
		return ""
	}

	private final func createReturnValue(_ graphable: Bool, _ modeValue: String, _ modeCount: Int) -> String {
		if graphable {
			return modeValue
		}
		var result = modeValue + " (\(modeCount) time"
		if modeCount != 1 {
			result += "s"
		}
		return result + ")"
	}
}
