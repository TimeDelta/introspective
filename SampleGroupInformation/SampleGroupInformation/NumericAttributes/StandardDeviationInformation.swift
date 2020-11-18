//
//  StandardDeviationInformation.swift
//  SampleGroupInformation
//
//  Created by Bryan Nova on 10/23/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common
import DependencyInjection
import Samples

public class StandardDeviationInformation: AnyInformation {
	// MARK: - Static Variables

	private typealias Me = StandardDeviationInformation

	private static let log = Log()

	// MARK: - Display Information

	public final override var name: String { "Standard Deviation" }
	public final override var description: String { name + " " + attribute.name.localizedLowercase }

	// MARK: - Initializers

	internal required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	// MARK: - Information Functions

	public final override func compute(forSamples samples: [Sample]) throws -> String {
		let value = try computeGraphable(forSamples: samples)
		guard !value.isEmpty else { return "" }

		let numFormatter = NumberFormatter()
		numFormatter.numberStyle = .decimal
		let formattedValue = numFormatter.string(for: Double(value))!

		if attribute is DosageAttribute {
			let filteredSamples = try filterSamples(samples, as: Dosage.self)
			if filteredSamples.isEmpty { throw GenericDisplayableError(title: "No samples matching filter") }
			let first = filteredSamples
				.first(where: { !((try? $0.value(of: attribute) as? Dosage)?.unit.isEmpty ?? true) })
			let units = (try! first?.value(of: attribute) as! Dosage).unit
			return formattedValue + units
		}
		if attribute is DurationAttribute {
			return formattedValue + " hours"
		}
		return formattedValue
	}

	public final override func computeGraphable(forSamples samples: [Sample]) throws -> String {
		var filteredSamples: [Sample]
		var values = [Double]()
		if attribute is DoubleAttribute {
			filteredSamples = try filterSamples(samples, as: Double.self)
			if filteredSamples.isEmpty { throw GenericDisplayableError(title: "No samples matching filter") }
			for sample in filteredSamples {
				guard let sampleValue = try sample.value(of: attribute) as? Double else {
					throw GenericDisplayableError(title: "Failed to compute value")
				}
				values.append(sampleValue)
			}
		}
		if attribute is IntegerAttribute {
			filteredSamples = try filterSamples(samples, as: Int.self)
			if filteredSamples.isEmpty { throw GenericDisplayableError(title: "No samples matching filter") }
			for sample in filteredSamples {
				guard let sampleValue = try sample.value(of: attribute) as? Int else {
					throw GenericDisplayableError(title: "Failed to compute value")
				}
				values.append(Double(sampleValue))
			}
		}
		if attribute is DosageAttribute {
			filteredSamples = try filterSamples(samples, as: Dosage.self)
			if filteredSamples.isEmpty { throw GenericDisplayableError(title: "No samples matching filter") }
			let first = filteredSamples
				.first(where: { !((try? $0.value(of: attribute) as? Dosage)?.unit.isEmpty ?? true) })
			let units = (try! first?.value(of: attribute) as! Dosage).unit
			for sample in filteredSamples {
				guard let sampleValue = try sample.value(of: attribute) as? Dosage else {
					throw GenericDisplayableError(title: "Failed to compute value")
				}
				values.append(sampleValue.inUnits(units))
			}
		}
		if attribute is DurationAttribute {
			filteredSamples = try filterSamples(samples, as: TimeDuration.self)
			if filteredSamples.isEmpty { throw GenericDisplayableError(title: "No samples matching filter") }
			for sample in filteredSamples {
				guard let duration = try sample.value(of: attribute) as? TimeDuration else {
					throw GenericDisplayableError(title: "Failed to compute value")
				}
				values.append(duration.inUnit(.hour))
			}
		}

		if values.count > 0 {
			return String(stdDeviation(of: values))
		}

		Me.log.error(
			"Unknown attribute type (%@) for attribute named '%@' of sample type '%@'",
			String(describing: type(of: attribute)),
			attribute.name,
			samples.count > 0 ? type(of: samples[0]).name : "No samples available"
		)
		return ""
	}

	// MARK: - Equality

	public final override func equalTo(_ other: SampleGroupInformation) -> Bool {
		other is StandardDeviationInformation && attribute.equalTo(other.attribute)
	}

	// MARK: - Helper Functions

	private final func stdDeviation(of values: [Double]) -> Double {
		var mean = 0.0
		for value in values {
			mean += value
		}
		mean /= Double(values.count)

		var sumOfSquaredDifferenceFromMean = 0.0
		for value in values {
			sumOfSquaredDifferenceFromMean += pow(value - mean, 2)
		}
		return sqrt(sumOfSquaredDifferenceFromMean / Double(values.count))
	}
}
