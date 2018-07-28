//
//  HeartRateQuery.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public class HeartRateQuery: SampleQuery<HeartRate> {

	override func run() {
		let dateConstraints = DependencyInjector.util.timeConstraintUtil.getMostRestrictiveStartAndEndDates(from: timeConstraints)
		let predicate = HKQuery.predicateForSamples(withStart: dateConstraints.start, end: dateConstraints.end, options: [])

		DependencyInjector.querier.heartRateQuerier.getAuthorization {
			(error: Error?) in

			if error != nil {
				self.queryDone(nil, error)
				return
			}

			DependencyInjector.querier.heartRateQuerier.getHeartRates(predicate: predicate) {
				(originalSamples: Array<HKQuantitySample>?, error: Error?) in

				if error != nil {
					self.queryDone(nil, error)
					return
				}
				if originalSamples == nil || originalSamples!.count == 0 {
					self.queryDone(nil, NoSamplesFoundQueryError(dataType: .heartRate))
					return
				}

				let samples = originalSamples!.map({ (sample: HKQuantitySample) -> HeartRate in
					return HeartRate(sample)
				}).filter(self.samplePassesFilters)

				let result = SampleQueryResult<HeartRate>(samples)
				result.addExtraInformation(AverageInformation<HeartRate>(.heartRate))
				result.addExtraInformation(CountInformation<HeartRate>(.heartRate))
				result.addExtraInformation(MaximumInformation<HeartRate, Double>(.heartRate))
				result.addExtraInformation(MinimumInformation<HeartRate, Double>(.heartRate))
				result.addExtraInformation(SumInformation<HeartRate>(.heartRate))

				self.queryDone(result, nil)
			}
		}
	}

	fileprivate func samplePassesFilters(_ heartRate: HeartRate) -> Bool {
		if !self.matchesAttributeRestrictionCriteria(heartRate) {
			return false
		}

		for timeConstraint in self.timeConstraints {
			if !timeConstraint.sampleAdheres(heartRate) {
				return false
			}
		}

		return true
	}

	fileprivate func matchesAttributeRestrictionCriteria(_ sample: HeartRate) -> Bool {
		return true // TODO
	}
}
