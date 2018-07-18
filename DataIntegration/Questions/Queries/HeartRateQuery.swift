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
		let (startDate, endDate) = DependencyInjector.util.timeConstraintUtil.getStartAndEndDatesFrom(timeConstraints: timeConstraints)

		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])

		DependencyInjector.querier.heartRateQuerier.getHeartRates(predicate: predicate) {
			(originalSamples: Array<HKQuantitySample>?, error: Error?) in

			if error != nil {
				self.queryDone(nil, error)
			}
			if originalSamples == nil || originalSamples!.count == 0 {
				self.queryDone(nil, ErrorTypes.NoSamplesFound)
			}

			let daysOfWeek = DependencyInjector.util.timeConstraintUtil.getDaysOfWeekFrom(timeConstraints: self.timeConstraints)
			let samples = originalSamples!.filter({ (sample: HKQuantitySample) in
				return self.matchesAttributeRestrictionCriteria(sample) && DependencyInjector.util.sampleUtil.sample(sample, occursOnOneOf: daysOfWeek)
			}).map({ (sample: HKQuantitySample) -> HeartRate in
				return HeartRate(sample)
			})

			let result = SampleQueryResult<HeartRate>(samples)
			result.addExtraInformation(AverageInformation<HeartRate>())
			result.addExtraInformation(CountInformation<HeartRate>())
			result.addExtraInformation(MaximumInformation<HeartRate>())
			result.addExtraInformation(MinimumInformation<HeartRate>())
			result.addExtraInformation(SumInformation<HeartRate>())

			self.queryDone(result, nil)
		}
	}

	fileprivate func matchesAttributeRestrictionCriteria(_ sample: HKQuantitySample) -> Bool {
		return true // TODO
	}
}
