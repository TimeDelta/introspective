//
//  SumInformation.swift
//  Introspective
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class SumInformation: AnyInformation {

	// MARK: - Instance Variables

	public final override var name: String { get { return "Total" } }
	public final override var description: String { return name + " " + attribute.name.localizedLowercase }

	private final let log = Log()

	// MARK: - Initializers

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	// MARK: - Functions

	public final override func compute(forSamples samples: [Sample]) -> String {
		let filteredSamples = DependencyInjector.util.sample.getOnly(samples: samples, from: startDate, to: endDate)
		if filteredSamples.count == 0 { return "0" }

		if attribute is DoubleAttribute {
			return String(DependencyInjector.util.numericSample.sum(for: attribute, over: filteredSamples) as Double)
		}
		if attribute is IntegerAttribute {
			return String(DependencyInjector.util.numericSample.sum(for: attribute, over: filteredSamples) as Int)
		}
		if attribute is DosageAttribute {
			return getSumOfDosageAttribute(filteredSamples)
		}
		if attribute is DurationAttribute {
			return getSumOfDurationAttribute(filteredSamples).description
		}

		log.error(
			"Unknown attribute type (%@) for attribute named '%@' of sample type '%@'",
			String(describing: type(of: attribute)),
			attribute.name,
			String(describing: type(of: samples[0])))
		return ""
	}

	public final override func computeGraphable(forSamples samples: [Sample]) -> String {
		let filteredSamples = DependencyInjector.util.sample.getOnly(samples: samples, from: startDate, to: endDate)
		if filteredSamples.count == 0 { return "0" }

		if attribute is DoubleAttribute {
			return String(DependencyInjector.util.numericSample.sum(for: attribute, over: filteredSamples) as Double)
		}
		if attribute is IntegerAttribute {
			return String(DependencyInjector.util.numericSample.sum(for: attribute, over: filteredSamples) as Int)
		}
		if attribute is DosageAttribute {
			return getSumOfDosageAttribute(filteredSamples)
		}
		if attribute is DurationAttribute {
			return String(getSumOfDurationAttribute(filteredSamples).inUnit(.hour))
		}

		log.error(
			"Unknown attribute type (%@) for attribute named '%@' of sample type '%@'",
			String(describing: type(of: attribute)),
			attribute.name,
			String(describing: type(of: samples[0])))
		return ""
	}

	public final override func equalTo(_ other: ExtraInformation) -> Bool {
		return other is SumInformation && attribute.equalTo(other.attribute)
	}

	// MARK: - Dosage Helper Functions

	private final func getSumOfDosageAttribute(_ filteredSamples: [Sample]) -> String {
		let dosage: Dosage? = getFirstNonNilDosage(from: filteredSamples)
		if let unit = dosage?.unit {
			return Dosage(dosageSum(over: filteredSamples, in: unit), unit).description
		} else {
			return "0"
		}
	}

	private final func getFirstNonNilDosage(from filteredSamples: [Sample]) -> Dosage? {
		var dosage: Dosage? = nil
		for sample in filteredSamples {
			dosage = try! sample.value(of: attribute) as? Dosage
			if dosage != nil { break }
			else if !attribute.optional {
				log.error("Non-optional dosage returned nil value for %@ sample", sample.attributedName)
			}
		}
		return dosage
	}

	private final func dosageSum(over filteredSamples: [Sample], in unit: String) -> Double {
		var totalDosage = 0.0
		for sample in filteredSamples {
			if let dosage = getDosage(from: sample) {
				totalDosage += dosage.inUnits(unit)
			}
		}
		return totalDosage
	}

	private final func getDosage(from sample: Sample) -> Dosage? {
		do {
			return try sample.value(of: attribute) as? Dosage
		} catch {
			log.error(
				"Failed to retrieve dosage attribute named '$@' of $@ sample while calculating sum information: $@",
				attribute.name,
				sample.attributedName,
				errorInfo(error))
			return nil
		}
	}

	// MARK: - Duration Helper Functions

	private final func getSumOfDurationAttribute(_ filteredSamples: [Sample]) -> Duration {
		var totalDuration = Duration(0)
		for sample in filteredSamples {
			if let duration = getDuration(from: sample) {
				totalDuration += duration
			}
		}
		return totalDuration
	}

	private final func getDuration(from sample: Sample) -> Duration? {
		do {
			return try sample.value(of: attribute) as? Duration
		} catch {
			log.error(
				"Failed to retrieve dosage attribute named '$@' of $@ sample while calculating sum information: $@",
				attribute.name,
				sample.attributedName,
				errorInfo(error))
			return nil
		}
	}
}
