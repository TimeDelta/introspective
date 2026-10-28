//
//  HealthKitQuery.swift
//  Introspective
//
//  Created by Bryan Nova on 8/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

import Common
import DependencyInjection
import Samples

public class HealthKitQuery<SampleType: HealthKitSample>: SampleQueryImpl<SampleType> {
	private final var stopFunction: (() -> Void)?
	private final var finishedQuery: Bool = false
	private let cancellationLock = NSLock()
	private var cancellationRequested = false

	deinit { stopFunction?() }

	func initFromHKSample(_: HKSample) -> SampleType {
		fatalError("Must override")
	}

	final override func run() {
		cancellationLock.lock()
		cancellationRequested = false
		finishedQuery = false
		stopFunction = nil
		cancellationLock.unlock()
		injected(HealthKitUtil.self).getAuthorization { [weak self] error in
			guard let self = self else { return }
			self.cancellationLock.lock()
			let cancelled = self.cancellationRequested
			self.cancellationLock.unlock()
			guard !cancelled else { return }
			if let error = error { self.finish(nil, error); return }
			SampleType.initUnits()
			let stop = injected(HealthKitUtil.self).getSamples(for: SampleType.self, predicate: nil) { [weak self] samples, error in
				self?.processQueryResults(originalSamples: samples, error: error)
			}
			self.cancellationLock.lock()
			let shouldStop = self.cancellationRequested
			if !shouldStop && !self.finishedQuery { self.stopFunction = stop }
			self.cancellationLock.unlock()
			if shouldStop { stop() }
		}
	}

	public final override func stop() {
		super.stop()
		cancellationLock.lock()
		cancellationRequested = true
		let stop = stopFunction
		stopFunction = nil
		cancellationLock.unlock()
		stop?()
	}

	private func finish(_ result: SampleQueryResult<SampleType>?, _ error: Error?) {
		cancellationLock.lock()
		finishedQuery = true
		stopFunction = nil
		cancellationLock.unlock()
		queryDone(result, error)
	}

	override func samplePassesFilters(_ sample: Sample) throws -> Bool {
		guard !stopped else { return false }
		guard let expression = expression else {
			return true
		}
		// predicate not relevant until there's a HealthKit-specific way of building predicates
		return try expression.evaluate([.sample: sample])
	}

	private final func processQueryResults(originalSamples: [HKSample]?, error: Error?) {
		if error != nil {
			finish(nil, error)
			return
		}
		guard let originalSamples = originalSamples else {
			finish(nil, NoHealthKitSamplesFoundQueryError(sampleType: SampleType.self))
			return
		}

		let mappedSamples = originalSamples.map { self.initFromHKSample($0) }
		do {
			let filteredSamples = try mappedSamples.filter(samplePassesFilters)

			if !stopped {
				let result = SampleQueryResult<SampleType>(filteredSamples)
				finish(result, nil)
			}
		} catch {
			finish(nil, error)
		}
	}
}
