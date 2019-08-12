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
		DependencyInjector.util.healthKit.getAuthorization() {
			(error: Error?) in

			if error != nil {
				self.queryDone(nil, error)
				return
			}

			SampleType.initUnits()
			// need a way of building HealthKit-specific predicates to avoid failures like
			// "Expected constant value of class HKQuantity, received 83.699996948242188"
			self.stopFunction = DependencyInjector.util.healthKit.getSamples(
				for: SampleType.self,
				predicate: nil,
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

	override func samplePassesFilters(_ sample: Sample) throws -> Bool {
		guard !stopped else { return false }
		guard let expression = expression else {
			return true
		}
		// predicate not relevant until there's a HealthKit-specific way of building predicates
		return try expression.evaluate([.sample: sample])
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
		do {
			let filteredSamples = try mappedSamples.filter(self.samplePassesFilters)

			if !self.stopped {
				if filteredSamples.count == 0 {
					self.queryDone(nil, NoHealthKitSamplesFoundQueryError(sampleType: SampleType.self))
					return
				}

				let result = SampleQueryResult<SampleType>(filteredSamples)
				self.finishedQuery = true
				self.queryDone(result, nil)
			}
		} catch {
			self.queryDone(nil, error)
		}
	}
}
