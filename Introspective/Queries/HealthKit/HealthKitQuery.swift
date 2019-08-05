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

	private final var stopFunction: (() -> ())?
	private final var finishedQuery: Bool = false
	private final let log = Log()

	func initFromHKSample(_ hkSample: HKSample) -> SampleType {
		fatalError("Must override")
	}

	final override func run() {
		let dateConstraints = DependencyInjector.util.attributeRestriction.getMostRestrictiveStartAndEndDates(from: attributeRestrictions)

		DependencyInjector.util.healthKit.getAuthorization() {
			(error: Error?) in

			if error != nil {
				self.queryDone(nil, error)
				return
			}

			SampleType.initUnits()
			self.stopFunction = DependencyInjector.util.healthKit.getSamples(
				for: SampleType.self,
				from: dateConstraints.start,
				to: dateConstraints.end,
				callback: self.processQueryResults)
		}
	}

	public final override func stop() {
		super.stop()
		DispatchQueue.global(qos: .background).async {
			while self.stopFunction == nil {}
			self.stopFunction!()
		}
	}

	final override func samplePassesFilters(_ sample: Sample) -> Bool {
		for attributeRestriction in attributeRestrictions {
			do {
				if try !attributeRestriction.samplePasses(sample) {
					return false
				}
			} catch {
				log.error("Failed to test for sample passing: %@", errorInfo(error))
				return false
			}
		}
		return true
	}

	private final func processQueryResults(originalSamples: Array<HKSample>?, error: Error?) {
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

		if !self.stopped {
			if filteredSamples.count == 0 {
				self.queryDone(nil, NoHealthKitSamplesFoundQueryError(sampleType: SampleType.self))
				return
			}

			let result = SampleQueryResult<SampleType>(filteredSamples)
			self.finishedQuery = true
			self.queryDone(result, nil)
		}
	}
}
