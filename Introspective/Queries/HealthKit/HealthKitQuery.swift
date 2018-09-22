//
//  HealthKitQuery.swift
//  Introspective
//
//  Created by Bryan Nova on 8/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public class HealthKitQuery<SampleType: HealthKitSample>: SampleQueryImpl<SampleType> {

	func initFromHKSample(_ hkSample: HKSample) -> SampleType {
		fatalError("Must override")
	}

	final override func run() {
		let dateConstraints = DependencyInjector.util.attributeRestrictionUtil.getMostRestrictiveStartAndEndDates(from: attributeRestrictions)

		HealthManager.getAuthorization() {
			(error: Error?) in

			if error != nil {
				self.queryDone(nil, error)
				return
			}

			HealthManager.getSamples(for: SampleType.self, startDate: dateConstraints.start, endDate: dateConstraints.end) {
				(originalSamples: Array<HKSample>?, error: Error?) in

				if error != nil {
					self.queryDone(nil, error)
					return
				}
				if originalSamples == nil || originalSamples!.count == 0 {
					self.queryDone(nil, NoHealthKitSamplesFoundQueryError(sampleType: SampleType.self))
					return
				}

				let mappedSamples = originalSamples!.map({ self.initFromHKSample($0)})
				let filteredSamples = mappedSamples.filter(self.samplePassesFilters)

				if filteredSamples.count == 0 {
					self.queryDone(nil, NoHealthKitSamplesFoundQueryError(sampleType: SampleType.self))
					return
				}

				let result = SampleQueryResult<SampleType>(filteredSamples)
				self.queryDone(result, nil)
			}
		}
	}

	final override func samplePassesFilters(_ sample: Sample) -> Bool {
		for attributeRestriction in attributeRestrictions {
			if try! !attributeRestriction.samplePasses(sample) {
				return false
			}
		}
		return true
	}
}
