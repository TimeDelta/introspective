//
//  HealthKitUtil.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit
import SwiftDate

import Common
import DependencyInjection
import Globals
import Settings

/// Read authorization does not reveal whether access was granted. A successful
/// request means the authorization interaction completed; an empty query result
/// can mean either that no records match or that the user did not share them.
public protocol HealthReadAuthorizationProviding {
	func requestReadAuthorization(for types: Set<HKObjectType>, predicate: NSPredicate?, callback: @escaping (Error?) -> Void)
}

/// Separate from HealthKitUtil's legacy mockable interface so existing query
/// clients can opt into selected-type authorization without changing old mocks.
public protocol HealthReadAuthorizationStore {
	var isHealthDataAvailable: Bool { get }
	var supportsHealthRecords: Bool { get }
	func requiresPerObjectAuthorization(for type: HKObjectType) -> Bool
	func requestReadAuthorization(for types: Set<HKObjectType>, completion: @escaping (Bool, Error?) -> Void)
	func requestPerObjectReadAuthorization(for type: HKObjectType, predicate: NSPredicate?, completion: @escaping (Bool, Error?) -> Void)
}

public enum HealthReadAuthorizationError: Error, LocalizedError, Equatable {
	case healthUnavailable, healthRecordsUnavailable, requestCanceled
	public var errorDescription: String? {
		switch self {
		case .healthUnavailable: return "Health data is unavailable on this device."
		case .healthRecordsUnavailable: return "Health records are unavailable on this device."
		case .requestCanceled: return "The Health access request did not complete. You can request access again."
		}
	}
}

private final class SystemHealthReadAuthorizationStore: HealthReadAuthorizationStore {
	let store: HKHealthStore
	init(_ store: HKHealthStore) { self.store = store }
	var isHealthDataAvailable: Bool { HKHealthStore.isHealthDataAvailable() }
	var supportsHealthRecords: Bool { store.supportsHealthRecords() }
	func requiresPerObjectAuthorization(for type: HKObjectType) -> Bool { type.requiresPerObjectAuthorization() }
	func requestReadAuthorization(for types: Set<HKObjectType>, completion: @escaping (Bool, Error?) -> Void) {
		// New Health catalog entries are read-only. Never request writing access as
		// an incidental side effect of exploring a data type.
		store.requestAuthorization(toShare: nil, read: types, completion: completion)
	}
	func requestPerObjectReadAuthorization(for type: HKObjectType, predicate: NSPredicate?, completion: @escaping (Bool, Error?) -> Void) {
		store.requestPerObjectReadAuthorization(for: type, predicate: predicate, completion: completion)
	}
}

/// Reusable by sample queries and the profile/document readers. Per-object types
/// such as vision prescriptions use Apple's object-selection authorization UI.
public final class HealthReadAuthorizationClient {
	private typealias Operation = (@escaping (Bool, Error?) -> Void) -> Void
	private let store: HealthReadAuthorizationStore

	public convenience init(store: HKHealthStore = HKHealthStore()) {
		self.init(authorizationStore: SystemHealthReadAuthorizationStore(store))
	}
	public init(authorizationStore: HealthReadAuthorizationStore) { store = authorizationStore }

	public func request(types: Set<HKObjectType>, predicate: NSPredicate? = nil, completion: @escaping (Error?) -> Void) {
		guard !types.isEmpty else { completion(nil); return }
		guard store.isHealthDataAvailable else { completion(HealthReadAuthorizationError.healthUnavailable); return }
		guard !types.contains(where: { $0 is HKClinicalType }) || store.supportsHealthRecords else {
			completion(HealthReadAuthorizationError.healthRecordsUnavailable); return
		}
		let ordered = types.sorted { $0.identifier < $1.identifier }
		var perObject: [HKObjectType] = []
		var standard = Set<HKObjectType>()
		for type in ordered {
			if store.requiresPerObjectAuthorization(for: type) { perObject.append(type) }
			else { standard.insert(type) }
		}
		var operations: [Operation] = []
		if !standard.isEmpty {
			operations.append { [store] callback in store.requestReadAuthorization(for: standard, completion: callback) }
		}
		for type in perObject {
			operations.append { [store] callback in
				store.requestPerObjectReadAuthorization(for: type, predicate: predicate, completion: callback)
			}
		}
		AuthorizationRequest(operations: operations, completion: completion).start()
	}

	/// Serializes sheets and rejects duplicate/late callbacks without keeping a
	/// completed request's store/operation closures alive.
	private final class AuthorizationRequest {
		private let lock = NSLock()
		private var operations: [Operation]
		private var completion: ((Error?) -> Void)?
		private var index = 0
		init(operations: [Operation], completion: @escaping (Error?) -> Void) {
			self.operations = operations; self.completion = completion
		}
		func start() { perform(index: 0) }
		private func perform(index expected: Int) {
			lock.lock()
			guard completion != nil, index == expected else { lock.unlock(); return }
			guard operations.indices.contains(expected) else {
				let done = completion; completion = nil; operations = []; lock.unlock(); done?(nil); return
			}
			let operation = operations[expected]
			lock.unlock()
			operation { success, error in
				self.lock.lock()
				guard self.completion != nil, self.index == expected else { self.lock.unlock(); return }
				if let failure = error ?? (success ? nil : HealthReadAuthorizationError.requestCanceled) {
					let done = self.completion; self.completion = nil; self.operations = []
					self.lock.unlock(); done?(failure); return
				}
				self.index += 1
				let next = self.index
				self.lock.unlock()
				self.perform(index: next)
			}
		}
	}
}

// sourcery: AutoMockable
public protocol HealthKitUtil {
	/// This will convert the given date from the time zone in the given `HKSample` to the current time zone
	/// if the time zone was recorded and the user has convert time zones enabled.
	func setTimeZoneIfApplicable(for date: inout Date, from sample: HKSample)
	func calculate(
		_ calculation: HKStatisticsOptions,
		_ type: HealthKitQuantitySample.Type,
		from startDate: Date,
		to endDate: Date,
		callback: @escaping (Double?, Error?) -> Void
	)
	/// - Returns: A method that can be called to stop the query
	func getSamples(
		for type: HealthKitSample.Type,
		from startDate: Date?,
		to endDate: Date?,
		predicate: NSPredicate?,
		callback: @escaping ([HKSample]?, Error?) -> Void
	) -> (() -> Void)
	func preferredUnitFor(_ typeId: HKQuantityTypeIdentifier) -> HKUnit?
	func getAuthorization(callback: @escaping (Error?) -> Void)
}

public extension HealthKitUtil {
	func requestReadAuthorization(for types: Set<HKObjectType>, predicate: NSPredicate? = nil, callback: @escaping (Error?) -> Void) {
		if let provider = self as? HealthReadAuthorizationProviding {
			provider.requestReadAuthorization(for: types, predicate: predicate, callback: callback)
		} else {
			// Compatibility for application extensions and existing injected mocks.
			getAuthorization(callback: callback)
		}
	}

	func getSamples(
		for type: HealthKitSample.Type,
		from startDate: Date? = nil,
		to endDate: Date? = nil,
		predicate: NSPredicate? = nil,
		callback: @escaping ([HKSample]?, Error?) -> Void
	) -> (() -> Void) {
		return getSamples(for: type, from: startDate, to: endDate, predicate: predicate, callback: callback)
	}
}

public final class HealthKitUtilImpl: HealthKitUtil, HealthReadAuthorizationProviding {
	private typealias Me = HealthKitUtilImpl
	private final class PreferredUnitResult {
		let group = DispatchGroup()
		private let lock = NSLock()
		private var unit: HKUnit?
		private var failure: Error?
		private var completed = false
		init() { group.enter() }
		@discardableResult
		func complete(unit: HKUnit?, failure: Error?) -> Bool {
			lock.lock()
			guard !completed else { lock.unlock(); return false }
			self.unit = unit; self.failure = failure; completed = true
			lock.unlock(); group.leave(); return true
		}
		func snapshot() -> (unit: HKUnit?, failure: Error?) {
			lock.lock(); defer { lock.unlock() }; return (unit, failure)
		}
	}
	public typealias PreferredUnitsLookup = (Set<HKQuantityType>, @escaping ([HKQuantityType: HKUnit], Error?) -> Void) -> Void
	private let log = Log()
	private let healthStore: HKHealthStore
	private let authorizationClient: HealthReadAuthorizationClient
	private let preferredUnitsLookup: PreferredUnitsLookup
	private let preferredUnitsLock = NSLock()
	private var cachedPreferredUnits: [String: HKUnit] = [:]
	private var preferredUnitRequests: [String: PreferredUnitResult] = [:]

	public init(healthStore: HKHealthStore = HKHealthStore(),
		authorizationClient: HealthReadAuthorizationClient? = nil,
		preferredUnitsLookup: PreferredUnitsLookup? = nil) {
		self.healthStore = healthStore
		self.authorizationClient = authorizationClient ?? HealthReadAuthorizationClient(store: healthStore)
		self.preferredUnitsLookup = preferredUnitsLookup ?? { types, completion in
			healthStore.preferredUnits(for: types, completion: completion)
		}
	}

	public func requestReadAuthorization(for types: Set<HKObjectType>, predicate: NSPredicate?, callback: @escaping (Error?) -> Void) {
		authorizationClient.request(types: types, predicate: predicate, completion: callback)
	}

	/// This will convert the given date from the time zone in the given `HKSample` to the current time zone
	/// if the time zone was recorded and the user has convert time zones enabled.
	public func setTimeZoneIfApplicable(for date: inout Date, from sample: HKSample) {
		guard QueryReadScope.convertTimeZones ?? injected(Settings.self).convertTimeZones else { return }
		if let timeZoneId = sample.metadata?[HKMetadataKeyTimeZone] as? String {
			if let timeZone = TimeZone(identifier: timeZoneId) {
				date = injected(CalendarUtil.self)
					.convert(date, from: timeZone, to: TimeZone.autoupdatingCurrent)
			}
		}
	}

	public func calculate(
		_ calculation: HKStatisticsOptions,
		_ type: HealthKitQuantitySample.Type,
		from startDate: Date,
		to endDate: Date,
		callback: @escaping (Double?, Error?) -> Void
	) {
		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
		requestReadAuthorization(for: type.readPermissions, predicate: predicate) { error in
			guard error == nil else { callback(nil, error); return }
			// Another read may update a legacy type's preferred unit before this
			// callback arrives. Convert this calculation with its captured unit.
			let unit = type.unit
			let query = HKStatisticsQuery(
				quantityType: type.quantityType,
				quantitySamplePredicate: predicate,
				options: calculation
			) { _, result, error in
				var value: Double?
				if calculation == .cumulativeSum {
					value = result?.sumQuantity()?.doubleValue(for: unit)
				} else if calculation == .discreteAverage {
					value = result?.averageQuantity()?.doubleValue(for: unit)
				} else if calculation == .discreteMax {
					value = result?.maximumQuantity()?.doubleValue(for: unit)
				} else if calculation == .discreteMin {
					value = result?.minimumQuantity()?.doubleValue(for: unit)
				} else if calculation == .discreteMostRecent {
					value = result?.mostRecentQuantity()?.doubleValue(for: unit)
				} else {
					self.log.error("Unsupported calculation parameter passed")
				}

				callback(value, error)
			}
			self.healthStore.execute(query)
		}
	}

	/// - Returns: A method that can be called to stop the query
	public func getSamples(
		for type: HealthKitSample.Type,
		from startDate: Date?,
		to endDate: Date?,
		predicate: NSPredicate?,
		callback: @escaping ([HKSample]?, Error?) -> Void
	) -> (() -> Void) {
		let datePredicate: NSPredicate? = (startDate != nil || endDate != nil)
			? HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: []) : nil
		let predicates = [predicate, datePredicate].compactMap { $0 }
		let combinedPredicate = predicates.isEmpty ? nil : NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		let query = HKSampleQuery(
			sampleType: type.sampleType,
			predicate: combinedPredicate,
			limit: Int(HKObjectQueryNoLimit),
			sortDescriptors: nil,
			resultsHandler: { callback($1, $2) }
		)
		healthStore.execute(query)
		return { self.healthStore.stop(query) }
	}

	public func preferredUnitFor(_ typeId: HKQuantityTypeIdentifier) -> HKUnit? {
		guard let quantityType = HKObjectType.quantityType(forIdentifier: typeId) else {
			recordUnitFailure("The selected Health data type is unavailable.")
			return nil
		}
		preferredUnitsLock.lock()
		let cached = cachedPreferredUnits[typeId.rawValue]
		preferredUnitsLock.unlock()
		// This legacy API is synchronous. Never block the main queue waiting for
		// a permission sheet or Health callback: warm the cache and let callers
		// use their explicit canonical-unit fallback until a background read.
		if Thread.isMainThread, let cached = cached { return cached }
		let result = beginPreferredUnitLookup(quantityType)
		if Thread.isMainThread {
			let ready = result.snapshot()
			if ready.failure != nil || ready.unit == nil {
				recordUnitFailure("Preferred units are still loading. Refresh to try again.")
			}
			return ready.unit
		}
		guard result.group.wait(timeout: .now() + 5) == .success else {
			preferredUnitsLock.lock()
			if preferredUnitRequests[typeId.rawValue] === result { preferredUnitRequests.removeValue(forKey: typeId.rawValue) }
			preferredUnitsLock.unlock()
			recordUnitFailure("Health did not return preferred units in time. Refresh to try again.")
			return nil
		}
		let completed = result.snapshot()
		if completed.failure != nil || completed.unit == nil {
			recordUnitFailure("Preferred units could not be read. Refresh after checking Health access.")
		}
		return completed.unit
	}

	private func beginPreferredUnitLookup(_ type: HKQuantityType) -> PreferredUnitResult {
		preferredUnitsLock.lock()
		if let current = preferredUnitRequests[type.identifier] { preferredUnitsLock.unlock(); return current }
		let result = PreferredUnitResult()
		preferredUnitRequests[type.identifier] = result
		preferredUnitsLock.unlock()
		requestReadAuthorization(for: [type], predicate: nil) { error in
			if let error = error { self.completePreferredUnitLookup(type, result: result, unit: nil, error: error); return }
			self.preferredUnitsLookup([type]) { units, failure in
				self.completePreferredUnitLookup(type, result: result, unit: units[type], error: failure)
			}
		}
		return result
	}

	private func completePreferredUnitLookup(_ type: HKQuantityType, result: PreferredUnitResult, unit: HKUnit?, error: Error?) {
		guard result.complete(unit: unit, failure: error) else { return }
		preferredUnitsLock.lock(); defer { preferredUnitsLock.unlock() }
		// A timed-out request cannot overwrite a newer read's captured preference.
		guard preferredUnitRequests[type.identifier] === result else { return }
		if let unit = unit, error == nil { cachedPreferredUnits[type.identifier] = unit }
		preferredUnitRequests.removeValue(forKey: type.identifier)
	}

	private func recordUnitFailure(_ description: String) {
		guard QueryReadScope.date != nil else { return }
		QueryReadScope.recordFailure(GenericDisplayableError(title: "Health units unavailable", description: description))
	}

	/// Compatibility for clients that have not selected a data type. A request
	/// without a selected type must not prompt for every type in the catalog.
	/// Production reads use requestReadAuthorization(for:predicate:callback:).
	public func getAuthorization(callback: @escaping (Error?) -> Void) { callback(nil) }
}
