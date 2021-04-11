//
//  SumInformation.swift
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

public final class SumInformation: AnyInformation {
	// MARK: - Static Variables

	private typealias Me = SumInformation

	private static let log = Log()

	// MARK: - Display Information

	public final override var name: String { "Total" }
	public final override var description: String { name + " " + attribute.name.localizedLowercase }

	// MARK: - Initializers

	internal required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	// MARK: - Information Functions

	public final override func compute(forSamples samples: [Sample]) throws -> String {
		if attribute is DoubleAttribute {
			let filteredSamples = try filterSamples(samples, as: Double.self)
			if filteredSamples.isEmpty { return "No samples match filter" }
			return String(
				try injected(NumericSampleUtil.self)
					.sum(for: attribute, over: filteredSamples, as: Double.self)
			)
		}
		if attribute is IntegerAttribute {
			let filteredSamples = try filterSamples(samples, as: Int.self)
			if filteredSamples.isEmpty { return "No samples match filter" }
			return String(
				try injected(NumericSampleUtil.self)
					.sum(for: attribute, over: filteredSamples, as: Int.self)
			)
		}
		if attribute is DosageAttribute {
			let filteredSamples = try filterSamples(samples, as: Dosage.self)
			if filteredSamples.isEmpty { return "No samples match filter" }
			return try getSumOfDosageAttribute(filteredSamples)
		}
		if attribute is DurationAttribute {
			let filteredSamples = try filterSamples(samples, as: TimeDuration.self)
			if filteredSamples.isEmpty { return "No samples match filter" }
			let total = try getSumOfDurationAttribute(filteredSamples)
			let numHours = total.inUnit(.hour)
			var additionalText = ""
			if numHours > 24 {
				let numFormatter = NumberFormatter()
				numFormatter.numberStyle = .decimal
				numFormatter.maximumFractionDigits = 1
				let hoursString = numFormatter.string(from: NSNumber(value: numHours))!
				additionalText = " (\(hoursString)h)"
			}
			return total.description + additionalText
		}

		if samples.isEmpty {
			throw GenericDisplayableError(title: "No samples found")
		}
		throw UnknownAttributeError(attribute: attribute, for: samples[0])
	}

	public final override func computeGraphable(forSamples samples: [Sample]) throws -> String {
		if attribute is DoubleAttribute {
			let filteredSamples = try filterSamples(samples, as: Double.self)
			if filteredSamples.isEmpty { throw GenericDisplayableError(title: "No samples match filter") }
			return String(
				try injected(NumericSampleUtil.self)
					.sum(for: attribute, over: filteredSamples, as: Double.self)
			)
		}
		if attribute is IntegerAttribute {
			let filteredSamples = try filterSamples(samples, as: Int.self)
			if filteredSamples.isEmpty { throw GenericDisplayableError(title: "No samples match filter") }
			return String(
				try injected(NumericSampleUtil.self)
					.sum(for: attribute, over: filteredSamples, as: Int.self)
			)
		}
		if attribute is DosageAttribute {
			let filteredSamples = try filterSamples(samples, as: Dosage.self)
			if filteredSamples.isEmpty { throw GenericDisplayableError(title: "No samples match filter") }
			return try getGraphableSumOfDosageAttribute(filteredSamples)
		}
		if attribute is DurationAttribute {
			let filteredSamples = try filterSamples(samples, as: TimeDuration.self)
			if filteredSamples.isEmpty { throw GenericDisplayableError(title: "No samples match filter") }
			return String(try getSumOfDurationAttribute(filteredSamples).inUnit(.hour))
		}

		if samples.isEmpty {
			throw GenericDisplayableError(title: "No samples found")
		}
		throw UnknownAttributeError(attribute: attribute, for: samples[0])
	}

	// MARK: - Equality

	public final override func equalTo(_ other: SampleGroupInformation) -> Bool {
		other is SumInformation && attribute.equalTo(other.attribute)
	}

	// MARK: - Dosage Helper Functions

	private final func getSumOfDosageAttribute(_ filteredSamples: [Sample]) throws -> String {
		let dosage: Dosage? = try getFirstNonNilDosage(from: filteredSamples)
		if let unit = dosage?.unit {
			return Dosage(try dosageSumWithUnits(over: filteredSamples, in: unit), unit).description
		} else {
			return String(try dosageSumWithoutUnits(over: filteredSamples))
		}
	}

	private final func getGraphableSumOfDosageAttribute(_ filteredSamples: [Sample]) throws -> String {
		let dosage: Dosage? = try getFirstNonNilDosage(from: filteredSamples)
		if let unit = dosage?.unit {
			return String(try dosageSumWithUnits(over: filteredSamples, in: unit))
		} else {
			return String(try dosageSumWithoutUnits(over: filteredSamples))
		}
	}

	private final func getFirstNonNilDosage(from filteredSamples: [Sample]) throws -> Dosage? {
		var dosage: Dosage?
		for sample in filteredSamples {
			dosage = try sample.value(of: attribute) as? Dosage
			if dosage != nil {
				break
			} else if !attribute.optional {
				Me.log.error("Non-optional dosage returned nil value for %@ sample", sample.attributedName)
			}
		}
		return dosage
	}

	private final func dosageSumWithUnits(over filteredSamples: [Sample], in unit: String) throws -> Double {
		var totalDosage = 0.0
		for sample in filteredSamples {
			if let dosage = try sample.value(of: attribute) as? Dosage {
				totalDosage += dosage.inUnits(unit)
			}
		}
		return totalDosage
	}

	private final func dosageSumWithoutUnits(over filteredSamples: [Sample]) throws -> Double {
		var totalDosage = 0.0
		for sample in filteredSamples {
			if let dosage = try sample.value(of: attribute) as? Dosage {
				totalDosage += dosage.amount
			}
		}
		return totalDosage
	}

	// MARK: - TimeDuration Helper Functions

	private final func getSumOfDurationAttribute(_ filteredSamples: [Sample]) throws -> TimeDuration {
		var totalDuration = TimeDuration(0)
		for sample in filteredSamples {
			if let duration = try sample.value(of: attribute) as? TimeDuration {
				totalDuration += duration
			}
		}
		return totalDuration
	}
}
