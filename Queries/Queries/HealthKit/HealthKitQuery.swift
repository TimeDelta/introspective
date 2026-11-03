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
		guard readContext?.isCancelled != true else { return }
		cancellationLock.lock()
		cancellationRequested = false
		finishedQuery = false
		stopFunction = nil
		cancellationLock.unlock()
		injected(HealthKitUtil.self).getAuthorization { [weak self] error in
			guard let self = self else { return }
			self.performRead { [weak self] in self?.beginQuery(afterAuthorization: error) }
		}
	}

	private func performRead(_ action: @escaping () -> Void) {
		if let readContext = readContext { readContext.perform(action) }
		else { action() }
	}

	private func beginQuery(afterAuthorization error: Error?) {
		cancellationLock.lock()
		let cancelled = cancellationRequested
		cancellationLock.unlock()
		guard !cancelled, readContext?.isCancelled != true else { return }
		if let error = error { finish(nil, error); return }
		SampleType.initUnits()
		if let error = QueryReadScope.readFailure { finish(nil, error); return }
		guard readContext?.isCancelled != true else { return }
		let stop = injected(HealthKitUtil.self).getSamples(for: SampleType.self, predicate: nil) { [weak self] samples, error in
			guard let self = self else { return }
			self.performRead { [weak self] in
				self?.processQueryResults(originalSamples: samples, error: error)
			}
		}
		cancellationLock.lock()
		let shouldStop = cancellationRequested
		if !shouldStop && !finishedQuery { stopFunction = stop }
		cancellationLock.unlock()
		if shouldStop { stop() }
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
		guard !stopped, readContext?.isCancelled != true else { return false }
		guard let expression = expression else {
			return true
		}
		// predicate not relevant until there's a HealthKit-specific way of building predicates
		return try expression.evaluate([.sample: sample])
	}

	private final func processQueryResults(originalSamples: [HKSample]?, error: Error?) {
		if readContext != nil && (stopped || readContext?.isCancelled == true) { return }
		if error != nil {
			finish(nil, error)
			return
		}
		guard let originalSamples = originalSamples else {
			finish(nil, NoHealthKitSamplesFoundQueryError(sampleType: SampleType.self))
			return
		}

		var mappedSamples: [SampleType] = []
		mappedSamples.reserveCapacity(originalSamples.count)
		for sample in originalSamples {
			guard readContext?.isCancelled != true else { return }
			mappedSamples.append(initFromHKSample(sample))
		}
		do {
			let filteredSamples = try mappedSamples.filter(samplePassesFilters)

			if !stopped && readContext?.isCancelled != true {
				let result = SampleQueryResult<SampleType>(filteredSamples)
				finish(result, nil)
			}
		} catch {
			finish(nil, error)
		}
	}
}
