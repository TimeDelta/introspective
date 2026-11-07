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
	private var generation = UUID()
	private var authorizationReceived = false
	private var receivedResult = false

	deinit { stopFunction?() }

	func initFromHKSample(_: HKSample) throws -> SampleType {
		fatalError("Must override")
	}

	final override func run() {
		guard readContext?.isCancelled != true else { return }
		cancellationLock.lock()
		let previousStop = stopFunction
		let token = UUID()
		generation = token
		cancellationRequested = false
		finishedQuery = false
		authorizationReceived = false
		receivedResult = false
		stopFunction = nil
		cancellationLock.unlock()
		previousStop?()
		if let catalogType = SampleType.self as? HealthCatalogSample.Type,
			!catalogType.catalogEntry.isAvailableOnCurrentOS {
			finish(nil, HealthCatalogError.unavailable(catalogType.catalogEntry.name), token: token)
			return
		}
		if let context = readContext, !context.beginHealthRead(for: SampleType.self, completion: { [weak self] result in
			self?.processReadResult(result, token: token)
		}) { return }
		injected(HealthKitUtil.self).requestReadAuthorization(for: SampleType.readPermissions) { [weak self] error in
			guard let self = self else { return }
			self.performRead { [weak self] in self?.beginQuery(afterAuthorization: error, token: token) }
		}
	}

	private func isCurrent(_ token: UUID) -> Bool {
		cancellationLock.lock(); defer { cancellationLock.unlock() }
		return generation == token && !cancellationRequested && !finishedQuery
	}

	private func claimResult(_ token: UUID) -> Bool {
		cancellationLock.lock(); defer { cancellationLock.unlock() }
		guard generation == token, !cancellationRequested, !finishedQuery, !receivedResult else { return false }
		receivedResult = true
		return true
	}

	private func claimAuthorization(_ token: UUID) -> Bool {
		cancellationLock.lock(); defer { cancellationLock.unlock() }
		guard generation == token, !cancellationRequested, !finishedQuery, !authorizationReceived else { return false }
		authorizationReceived = true
		return true
	}

	private func performRead(_ action: @escaping () -> Void) {
		if let readContext = readContext { readContext.perform(action) }
		else { action() }
	}

	private func beginQuery(afterAuthorization error: Error?, token: UUID) {
		guard claimAuthorization(token), readContext?.isCancelled != true else { return }
		if let error = error {
			if claimResult(token) { completeRead(.failure(error), token: token) }
			return
		}
		SampleType.initUnits()
		if let error = QueryReadScope.readFailure {
			if claimResult(token) { completeRead(.failure(error), token: token) }
			return
		}
		guard isCurrent(token), readContext?.isCancelled != true else { return }
		let capturedQuantityUnit: HKUnit?
		if let quantity = SampleType.self as? HealthKitQuantitySample.Type {
			let unit = quantity.unit
			capturedQuantityUnit = unit
			if readContext?.cachesHealthResults == true {
				readContext?.recordCapturedHealthUnit(unit.unitString, for: SampleType.self)
			}
		} else { capturedQuantityUnit = nil }
		let capturedPressureUnits: (systolic: HKUnit, diastolic: HKUnit)?
		if ObjectIdentifier(SampleType.self) == ObjectIdentifier(BloodPressure.self) {
			let units = (systolic: BloodPressure.systolicUnit, diastolic: BloodPressure.diastolicUnit)
			capturedPressureUnits = units
			if readContext?.cachesHealthResults == true {
				readContext?.recordCapturedHealthUnit(units.systolic.unitString, for: SampleType.self, attributeID: BloodPressure.systolic.id)
				readContext?.recordCapturedHealthUnit(units.diastolic.unitString, for: SampleType.self, attributeID: BloodPressure.diastolic.id)
			}
		} else { capturedPressureUnits = nil }
		// A shared read context caches one complete record set for each type.
		// A leaf's date filter must not truncate data needed by another leaf.
		let stop = injected(HealthKitUtil.self).getSamples(for: SampleType.self, predicate: nil) { [weak self] samples, error in
			guard let self = self else { return }
			self.performRead { [weak self] in
				self?.processQueryResults(originalSamples: samples, error: error, token: token,
					quantityUnit: capturedQuantityUnit, pressureUnits: capturedPressureUnits)
			}
		}
		cancellationLock.lock()
		let shouldStop = generation != token || cancellationRequested
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

	private func finish(_ result: SampleQueryResult<SampleType>?, _ error: Error?, token: UUID) {
		cancellationLock.lock()
		guard generation == token, !cancellationRequested, !finishedQuery else { cancellationLock.unlock(); return }
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

	private final func processQueryResults(originalSamples: [HKSample]?, error: Error?, token: UUID,
		quantityUnit: HKUnit?, pressureUnits: (systolic: HKUnit, diastolic: HKUnit)?) {
		guard claimResult(token), !stopped, readContext?.isCancelled != true else { return }
		if let error = error {
			completeRead(.failure(error), token: token)
			return
		}
		guard let originalSamples = originalSamples else {
			completeRead(.failure(NoHealthKitSamplesFoundQueryError(sampleType: SampleType.self)), token: token)
			return
		}

		var mappedSamples: [SampleType] = []
		mappedSamples.reserveCapacity(originalSamples.count)
		for sample in originalSamples {
			guard isCurrent(token), readContext?.isCancelled != true else { return }
			guard sample.sampleType == SampleType.sampleType else {
				completeRead(.failure(GenericError("Health returned a record for a different data type.")), token: token); return
			}
			if let units = pressureUnits {
				guard let correlation = sample as? HKCorrelation,
					let systolic = correlation.objects(for: BloodPressure.systolicQuantityType).first as? HKQuantitySample,
					let diastolic = correlation.objects(for: BloodPressure.diastolicQuantityType).first as? HKQuantitySample,
					systolic.quantity.is(compatibleWith: units.systolic), diastolic.quantity.is(compatibleWith: units.diastolic) else {
					completeRead(.failure(GenericError("The captured blood pressure record is missing a compatible pressure measurement.")), token: token); return
				}
				guard let mapped = BloodPressure(correlation, systolicUnit: units.systolic, diastolicUnit: units.diastolic) as? SampleType else {
					completeRead(.failure(GenericError("The captured blood pressure record has an unexpected type.")), token: token); return
				}
				mappedSamples.append(mapped)
			} else if SampleType.self is HealthCatalogSample.Type {
				// Catalog decoders validate the exact record and canonical unit.
				// Keep their throwing contract even for quantity conformers; the
				// legacy quantity initializer below cannot report decoding errors.
				do { mappedSamples.append(try initFromHKSample(sample)) }
				catch { completeRead(.failure(error), token: token); return }
			} else if let unit = quantityUnit {
				guard let quantity = sample as? HKQuantitySample,
					let type = SampleType.self as? HealthKitQuantitySample.Type,
					quantity.quantityType == type.quantityType,
					quantity.quantity.is(compatibleWith: unit),
					let mapped = type.init(quantity, unit: unit) as? SampleType else {
					completeRead(.failure(GenericError("The captured Health quantity has an unexpected type or unit.")), token: token); return
				}
				mappedSamples.append(mapped)
			} else {
				do { mappedSamples.append(try initFromHKSample(sample)) }
				catch { completeRead(.failure(error), token: token); return }
			}
		}
		completeRead(.samples(mappedSamples), token: token)
	}

	private func completeRead(_ result: QueryReadContext.HealthReadResult, token: UUID) {
		guard isCurrent(token), readContext?.isCancelled != true, !stopped else { return }
		if readContext?.completeHealthRead(for: SampleType.self, with: result) == true { return }
		processReadResult(result, token: token)
	}

	private func processReadResult(_ result: QueryReadContext.HealthReadResult, token: UUID) {
		guard isCurrent(token), readContext?.isCancelled != true, !stopped else { return }
		switch result {
		case let .failure(error): finish(nil, error, token: token)
		case let .samples(samples):
			guard let typed = samples as? [SampleType] else {
				finish(nil, GenericError("The captured Health data has an unexpected type."), token: token); return
			}
			filterCapturedSamples(typed, token: token)
		}
	}

	private func filterCapturedSamples(_ mappedSamples: [SampleType], token: UUID) {
		do {
			let filteredSamples = try mappedSamples.filter(samplePassesFilters)

			if isCurrent(token), !stopped, readContext?.isCancelled != true {
				let result = SampleQueryResult<SampleType>(filteredSamples)
				finish(result, nil, token: token)
			}
		} catch {
			finish(nil, error, token: token)
		}
	}
}
