//
//  SumInformation.swift
//  Introspective
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

public final class SumInformation: AnyInformation {

	public final override var name: String { get { return "Total" } }
	public final override var description: String { return name + " " + attribute.name.localizedLowercase }

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	public final override func compute(forSamples samples: [Sample]) -> String {
		let filteredSamples = DependencyInjector.util.sampleUtil.getOnly(samples: samples, from: startDate, to: endDate)
		if filteredSamples.count == 0 { return "0" }
		if attribute is DoubleAttribute {
			return String(DependencyInjector.util.numericSampleUtil.sum(for: attribute, over: filteredSamples) as Double)
		}
		if attribute is IntegerAttribute {
			return String(DependencyInjector.util.numericSampleUtil.sum(for: attribute, over: filteredSamples) as Int)
		}
		if attribute is DosageAttribute {
			return getSumOfDosageAttribute(filteredSamples)
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
		return other is SumInformation && attribute.equalTo(other.attribute)
	}

	// MARK: - Helper Functions

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
				os_log("Non-optional dosage returned nil value for %@ sample", type: .error, sample.attributedName)
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
			os_log(
				"Failed to retrieve dosage attribute named '$@' of $@ sample while calculating sum information: $@",
				type: .error,
				attribute.name,
				sample.attributedName,
				error.localizedDescription)
			return nil
		}
	}
}
