//
//  AverageInformation.swift
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

public final class AverageInformation: AnyInformation {
	// MARK: - Display Information

	override public final var name: String { "Average" }
	override public final var description: String { name + " " + attribute.name.localizedLowercase }

	// MARK: - Instance Variables

	private final let log = Log()

	// MARK: - Initializers

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	// MARK: - Information Functions

	override public final func compute(forSamples samples: [Sample]) throws -> String {
		if attribute is DoubleAttribute {
			let filteredSamples = try filterSamples(samples, as: Double.self)
			if filteredSamples.isEmpty { return "No samples matching filter" }
			return String(
				try DependencyInjector.get(NumericSampleUtil.self)
					.average(for: attribute, over: filteredSamples)
			)
		}
		if attribute is IntegerAttribute {
			let filteredSamples = try filterSamples(samples, as: Int.self)
			if filteredSamples.isEmpty { return "No samples matching filter" }
			return String(
				try DependencyInjector.get(NumericSampleUtil.self)
					.average(for: attribute, over: filteredSamples)
			)
		}
		if attribute is DosageAttribute {
			return try averageDosage(samples)
		}
		if attribute is DurationAttribute {
			return (try averageDuration(samples)).description
		}

		log.error(
			"Unknown attribute type (%@) for attribute named '%@' of sample type '%@'",
			String(describing: type(of: attribute)),
			attribute.name,
			String(describing: type(of: samples[0]))
		)
		return ""
	}

	override public final func computeGraphable(forSamples samples: [Sample]) throws -> String {
		if attribute is DoubleAttribute {
			let filteredSamples = try filterSamples(samples, as: Double.self)
			if filteredSamples.isEmpty { throw GenericDisplayableError(title: "No samples matching filter") }
			return String(
				try DependencyInjector.get(NumericSampleUtil.self)
					.average(for: attribute, over: filteredSamples)
			)
		}
		if attribute is IntegerAttribute {
			let filteredSamples = try filterSamples(samples, as: Int.self)
			if filteredSamples.isEmpty { throw GenericDisplayableError(title: "No samples matching filter") }
			return String(
				try DependencyInjector.get(NumericSampleUtil.self)
					.average(for: attribute, over: filteredSamples)
			)
		}
		if attribute is DosageAttribute {
			return try averageDosage(samples)
		}
		if attribute is DurationAttribute {
			return String(try averageDuration(samples).inUnit(.hour))
		}

		log.error(
			"Unknown attribute type (%@) for attribute named '%@' of sample type '%@'",
			String(describing: type(of: attribute)),
			attribute.name,
			String(describing: type(of: samples[0]))
		)
		return ""
	}

	// MARK: - Equality

	override public final func equalTo(_ other: SampleGroupInformation) -> Bool {
		other is AverageInformation && attribute.equalTo(other.attribute)
	}

	// MARK: - Helper Functions

	private final func averageDosage(_ samples: [Sample]) throws -> String {
		let filteredSamples = try filterSamples(samples, as: Dosage.self)
		if filteredSamples.isEmpty { return "0" }

		let sumString = try SumInformation(attribute).compute(forSamples: filteredSamples)
		if let totalDosage = Dosage(sumString) {
			let numberOfNonNilDosages = try numberOfSamplesWithNonNilDosage(filteredSamples)
			let averageDosage = Dosage(totalDosage.amount / numberOfNonNilDosages, totalDosage.unit)
			return averageDosage.description
		} else {
			return "0"
		}
	}

	private final func numberOfSamplesWithNonNilDosage(_ samples: [Sample]) throws -> Double {
		Double(try samples.filter { (try $0.value(of: attribute)) as? Dosage != nil }.count)
	}

	private final func averageDuration(_ samples: [Sample]) throws -> Duration {
		let filteredSamples = try filterSamples(samples, as: Duration.self)
		if filteredSamples.isEmpty { return Duration(0) }

		var totalDuration = Duration(0)
		var totalNonNilSamples = 0
		for sample in filteredSamples {
			if let duration = try sample.value(of: attribute) as? Duration {
				totalDuration += duration
				totalNonNilSamples += 1
			}
		}
		return totalDuration / totalNonNilSamples
	}
}
