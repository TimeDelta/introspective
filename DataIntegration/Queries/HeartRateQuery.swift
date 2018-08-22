//
//  HeartRateQuery.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

//sourcery: AutoMockable
public protocol HeartRateQuery: Query {}

public class HeartRateQueryImpl: SampleQueryImpl<HeartRate>, HeartRateQuery {

	override func run() {
		let dateConstraints = DependencyInjector.util.attributeRestrictionUtil.getMostRestrictiveStartAndEndDates(from: attributeRestrictions)
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
					self.queryDone(nil, NoHealthKitSamplesFoundQueryError(dataType: .heartRate))
					return
				}

				let samples = originalSamples!.map({ (sample: HKQuantitySample) -> HeartRate in
					return HeartRate(sample)
				}).filter(self.samplePassesFilters)

				if samples.count == 0 {
					self.queryDone(nil, NoHealthKitSamplesFoundQueryError(dataType: .heartRate))
					return
				}

				let result = SampleQueryResult<HeartRate>(samples)
				self.queryDone(result, nil)
			}
		}
	}

	fileprivate func samplePassesFilters(_ heartRate: HeartRate) -> Bool {
		for attributeRestriction in attributeRestrictions {
			if try! !attributeRestriction.samplePasses(heartRate) {
				return false
			}
		}

		return true
	}
}
