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

	public enum ErrorTypes: Error {
		case Unauthorized
		case NoSamplesFound
	}

	override func run() {
		let predicate = HKQuery.predicateForSamples(withStart: nil, end: nil, options: [])

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
					self.queryDone(nil, ErrorTypes.NoSamplesFound)
					return
				}

				let samples = originalSamples!.map({ (sample: HKQuantitySample) -> HeartRate in
					return HeartRate(sample)
				}).filter({ (sample: HeartRate) in
					return self.matchesAttributeRestrictionCriteria(sample) && DependencyInjector.util.timeConstraintUtil.sample(sample, meets: self.timeConstraints)
				})

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

	fileprivate func matchesAttributeRestrictionCriteria(_ sample: HeartRate) -> Bool {
		return true // TODO
	}
}
