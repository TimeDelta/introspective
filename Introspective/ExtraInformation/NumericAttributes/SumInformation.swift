//
//  SumInformation.swift
//  Introspective
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class SumInformation: AnyInformation {

	// MARK: - Display Information

	public final override var name: String { get { return "Total" } }
	public final override var description: String { return name + " " + attribute.name.localizedLowercase }

	// MARK: - Instance Variables

	private final let log = Log()

	// MARK: - Initializers

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	// MARK: - Information Functions

	public final override func compute(forSamples samples: [Sample]) throws -> String {
		if attribute is DoubleAttribute {
			let filteredSamples = try filterSamples(samples, as: Double.self)
			if filteredSamples.count == 0 { return "0" }
			return String(try DependencyInjector.util.numericSample.sum(for: attribute, over: filteredSamples, as: Double.self))
		}
		if attribute is IntegerAttribute {
			let filteredSamples = try filterSamples(samples, as: Int.self)
			if filteredSamples.count == 0 { return "0" }
			return String(try DependencyInjector.util.numericSample.sum(for: attribute, over: filteredSamples, as: Int.self))
		}
		if attribute is DosageAttribute {
			let filteredSamples = try filterSamples(samples, as: Dosage.self)
			if filteredSamples.count == 0 { return "0" }
			return try getSumOfDosageAttribute(filteredSamples)
		}
		if attribute is DurationAttribute {
			let filteredSamples = try filterSamples(samples, as: Duration.self)
			if filteredSamples.count == 0 { return "0" }
			return try getSumOfDurationAttribute(filteredSamples).description
		}

		log.error(
			"Unknown attribute type (%@) for attribute named '%@' of sample type '%@'",
			String(describing: type(of: attribute)),
			attribute.name,
			String(describing: type(of: samples[0])))
		return ""
	}

	public final override func computeGraphable(forSamples samples: [Sample]) throws -> String {
		if attribute is DoubleAttribute {
			let filteredSamples = try filterSamples(samples, as: Double.self)
			if filteredSamples.count == 0 { return "0" }
			return String(try DependencyInjector.util.numericSample.sum(for: attribute, over: filteredSamples, as: Double.self))
		}
		if attribute is IntegerAttribute {
			let filteredSamples = try filterSamples(samples, as: Int.self)
			if filteredSamples.count == 0 { return "0" }
			return String(try DependencyInjector.util.numericSample.sum(for: attribute, over: filteredSamples, as: Int.self))
		}
		if attribute is DosageAttribute {
			let filteredSamples = try filterSamples(samples, as: Dosage.self)
			if filteredSamples.count == 0 { return "0" }
			return try getSumOfDosageAttribute(filteredSamples)
		}
		if attribute is DurationAttribute {
			let filteredSamples = try filterSamples(samples, as: Duration.self)
			if filteredSamples.count == 0 { return "0" }
			return String(try getSumOfDurationAttribute(filteredSamples).inUnit(.hour))
		}

		log.error(
			"Unknown attribute type (%@) for attribute named '%@' of sample type '%@'",
			String(describing: type(of: attribute)),
			attribute.name,
			String(describing: type(of: samples[0])))
		return ""
	}

	// MARK: - Equality

	public final override func equalTo(_ other: ExtraInformation) -> Bool {
		return other is SumInformation && attribute.equalTo(other.attribute)
	}

	// MARK: - Dosage Helper Functions

	private final func getSumOfDosageAttribute(_ filteredSamples: [Sample]) throws -> String {
		let dosage: Dosage? = try getFirstNonNilDosage(from: filteredSamples)
		if let unit = dosage?.unit {
			return Dosage(try dosageSum(over: filteredSamples, in: unit), unit).description
		} else {
			return "0"
		}
	}

	private final func getFirstNonNilDosage(from filteredSamples: [Sample]) throws -> Dosage? {
		var dosage: Dosage? = nil
		for sample in filteredSamples {
			dosage = try sample.value(of: attribute) as? Dosage
			if dosage != nil {
				break
			} else if !attribute.optional {
				log.error("Non-optional dosage returned nil value for %@ sample", sample.attributedName)
			}
		}
		return dosage
	}

	private final func dosageSum(over filteredSamples: [Sample], in unit: String) throws -> Double {
		var totalDosage = 0.0
		for sample in filteredSamples {
			if let dosage = try sample.value(of: attribute) as? Dosage {
				totalDosage += dosage.inUnits(unit)
			}
		}
		return totalDosage
	}

	// MARK: - Duration Helper Functions

	private final func getSumOfDurationAttribute(_ filteredSamples: [Sample]) throws -> Duration {
		var totalDuration = Duration(0)
		for sample in filteredSamples {
			if let duration = try sample.value(of: attribute) as? Duration {
				totalDuration += duration
			}
		}
		return totalDuration
	}
}
