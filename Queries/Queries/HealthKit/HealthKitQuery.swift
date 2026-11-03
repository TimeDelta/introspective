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
	private var capturedQuantityUnit: HKUnit?
	private var capturedPressureUnits: (systolic: HKUnit, diastolic: HKUnit)?

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
		capturedQuantityUnit = nil
		capturedPressureUnits = nil
		if let context = readContext, !context.beginHealthRead(for: SampleType.self, completion: { [weak self] result in
			self?.processReadResult(result)
		}) { return }
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
		if let error = error { completeRead(.failure(error)); return }
		SampleType.initUnits()
		if let error = QueryReadScope.readFailure { completeRead(.failure(error)); return }
		guard readContext?.isCancelled != true else { return }
		if readContext?.cachesHealthResults == true, let quantity = SampleType.self as? HealthKitQuantitySample.Type {
			let unit = quantity.unit
			capturedQuantityUnit = unit
			readContext?.recordCapturedHealthUnit(unit.unitString, for: SampleType.self)
		}
		if readContext?.cachesHealthResults == true, ObjectIdentifier(SampleType.self) == ObjectIdentifier(BloodPressure.self) {
			let units = (systolic: BloodPressure.systolicUnit, diastolic: BloodPressure.diastolicUnit)
			capturedPressureUnits = units
			readContext?.recordCapturedHealthUnit(units.systolic.unitString, for: SampleType.self, attributeID: BloodPressure.systolic.id)
			readContext?.recordCapturedHealthUnit(units.diastolic.unitString, for: SampleType.self, attributeID: BloodPressure.diastolic.id)
		}
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
		if let error = error {
			completeRead(.failure(error))
			return
		}
		guard let originalSamples = originalSamples else {
			completeRead(.failure(NoHealthKitSamplesFoundQueryError(sampleType: SampleType.self)))
			return
		}

		var mappedSamples: [SampleType] = []
		mappedSamples.reserveCapacity(originalSamples.count)
		for sample in originalSamples {
			guard readContext?.isCancelled != true else { return }
			if let units = capturedPressureUnits {
				guard let correlation = sample as? HKCorrelation,
					correlation.objects(for: BloodPressure.systolicQuantityType).first as? HKQuantitySample != nil,
					correlation.objects(for: BloodPressure.diastolicQuantityType).first as? HKQuantitySample != nil else {
					completeRead(.failure(GenericError("The captured blood pressure record is missing a pressure measurement."))); return
				}
				guard let mapped = BloodPressure(correlation, systolicUnit: units.systolic, diastolicUnit: units.diastolic) as? SampleType else {
					completeRead(.failure(GenericError("The captured blood pressure record has an unexpected type."))); return
				}
				mappedSamples.append(mapped)
			} else if let unit = capturedQuantityUnit {
				guard let quantity = sample as? HKQuantitySample,
					let type = SampleType.self as? HealthKitQuantitySample.Type,
					quantity.quantityType == type.quantityType,
					let mapped = type.init(quantity, unit: unit) as? SampleType else {
					completeRead(.failure(GenericError("The captured Health quantity has an unexpected type."))); return
				}
				mappedSamples.append(mapped)
			} else { mappedSamples.append(initFromHKSample(sample)) }
		}
		completeRead(.samples(mappedSamples))
	}

	private func completeRead(_ result: QueryReadContext.HealthReadResult) {
		guard readContext?.isCancelled != true, !stopped else { return }
		if readContext?.completeHealthRead(for: SampleType.self, with: result) == true { return }
		processReadResult(result)
	}

	private func processReadResult(_ result: QueryReadContext.HealthReadResult) {
		guard readContext?.isCancelled != true, !stopped else { return }
		switch result {
		case let .failure(error): finish(nil, error)
		case let .samples(samples):
			guard let typed = samples as? [SampleType] else {
				finish(nil, GenericError("The captured Health data has an unexpected type.")); return
			}
			filterCapturedSamples(typed)
		}
	}

	private func filterCapturedSamples(_ mappedSamples: [SampleType]) {
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
