//
//  AverageInformation.swift
//  Introspective
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class AverageInformation: AnyInformation {

	public final override var name: String { return "Average" }
	public final override var description: String { return name + " " + attribute.name }

	public required init(_ attribute: Attribute) {
		super.init(attribute)
	}

	public final override func compute(forSamples samples: [Sample]) -> String {
		let filteredSamples = DependencyInjector.util.sampleUtil.getOnly(samples: samples, from: startDate, to: endDate)
		if attribute is DosageAttribute {
			return averageDosage(filteredSamples)
		}
		return String(DependencyInjector.util.numericSampleUtil.average(for: attribute, over: filteredSamples))
	}

	public final override func equalTo(_ other: ExtraInformation) -> Bool {
		return other is AverageInformation && attribute.equalTo(other.attribute)
	}

	// MARK: - Helper Functions

	private final func averageDosage(_ filteredSamples: [Sample]) -> String {
		let sumString = SumInformation(attribute).compute(forSamples: filteredSamples)
		if let totalDosage = Dosage(sumString) {
			return String(totalDosage.amount / Double(numberOfSamplesWithNonNilDosage(filteredSamples))) + " " + totalDosage.unit
		} else {
			return "0"
		}
	}

	private final func numberOfSamplesWithNonNilDosage(_ samples: [Sample]) -> Int {
		return samples.filter({ (try? $0.value(of: attribute) as? Dosage) != nil }).count
	}
}
