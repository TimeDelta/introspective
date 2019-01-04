//
//  AverageInformation.swift
//  Introspective
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class AverageInformation: AnyInformation {

	// MARK: - Instance Variables

	public final override var name: String { return "Average" }
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

		if attribute is NumericAttribute {
			return String(DependencyInjector.util.numericSample.average(for: attribute, over: filteredSamples))
		}
		if attribute is DosageAttribute {
			return averageDosage(filteredSamples)
		}
		if attribute is DurationAttribute {
			return averageDuration(filteredSamples).description
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

		if attribute is NumericAttribute {
			return String(DependencyInjector.util.numericSample.average(for: attribute, over: filteredSamples))
		}
		if attribute is DosageAttribute {
			return averageDosage(filteredSamples)
		}
		if attribute is DurationAttribute {
			return String(averageDuration(filteredSamples).inUnit(.hour))
		}

		log.error(
			"Unknown attribute type (%@) for attribute named '%@' of sample type '%@'",
			String(describing: type(of: attribute)),
			attribute.name,
			String(describing: type(of: samples[0])))
		return ""
	}

	public final override func equalTo(_ other: ExtraInformation) -> Bool {
		return other is AverageInformation && attribute.equalTo(other.attribute)
	}

	// MARK: - Helper Functions

	private final func averageDosage(_ filteredSamples: [Sample]) -> String {
		let sumString = SumInformation(attribute).compute(forSamples: filteredSamples)
		if let totalDosage = Dosage(sumString) {
			let averageDosage = Dosage(totalDosage.amount / numberOfSamplesWithNonNilDosage(filteredSamples), totalDosage.unit)
			return averageDosage.description
		} else {
			return "0"
		}
	}

	private final func numberOfSamplesWithNonNilDosage(_ samples: [Sample]) -> Double {
		return Double(samples.filter({ (try? $0.value(of: attribute)) as? Dosage != nil }).count)
	}

	private final func averageDuration(_ filteredSamples: [Sample]) -> Duration {
		var totalDuration = Duration(0)
		var totalNonNilSamples = 0
		for sample in filteredSamples {
			if let duration = getDuration(from: sample) {
				totalDuration += duration
				totalNonNilSamples += 1
			}
		}
		return totalDuration / totalNonNilSamples
	}

	private final func getDuration(from sample: Sample) -> Duration? {
		do {
			return try sample.value(of: attribute) as? Duration
		} catch {
			log.error(
				"Failed to retrieve duration attribute named '$@' of $@ sample while calculating average information: $@",
				attribute.name,
				sample.attributedName,
				errorInfo(error))
			return nil
		}
	}
}
