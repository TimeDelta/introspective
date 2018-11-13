//
//  AverageInformation.swift
//  Introspective
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

public final class AverageInformation: AnyInformation {

	public final override var name: String { return "Average" }
	public final override var description: String { return name + " " + attribute.name.localizedLowercase }

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

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
			return averageDuration(filteredSamples)
		}

		os_log(
			"Unknown attribute type (%@) for attribute named '%@' of sample type '%@'",
			type: .error,
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

	private final func averageDuration(_ filteredSamples: [Sample]) -> String {
		var totalDuration = Duration(0)
		var totalNonNilSamples = 0
		for sample in filteredSamples {
			if let duration = getDuration(from: sample) {
				totalDuration += duration
				totalNonNilSamples += 1
			}
		}
		return (totalDuration / totalNonNilSamples).description
	}

	private final func getDuration(from sample: Sample) -> Duration? {
		do {
			return try sample.value(of: attribute) as? Duration
		} catch {
			os_log(
				"Failed to retrieve duration attribute named '$@' of $@ sample while calculating average information: $@",
				type: .error,
				attribute.name,
				sample.attributedName,
				error.localizedDescription)
			return nil
		}
	}
}
