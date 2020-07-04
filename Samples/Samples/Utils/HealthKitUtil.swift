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
	func getSamples(
		for type: HealthKitSample.Type,
		from startDate: Date? = nil,
		to endDate: Date? = nil,
		predicate: NSPredicate? = nil,
		callback: @escaping ([HKSample]?, Error?) -> Void
	)
		-> (() -> Void) {
		return getSamples(for: type, from: startDate, to: endDate, predicate: predicate, callback: callback)
	}
}

public final class HealthKitUtilImpl: HealthKitUtil {
	private typealias Me = HealthKitUtilImpl
	private static let readPermissions: Set<HKObjectType> = {
		var allPermissions = Set<HKObjectType>()
		for permissions in DependencyInjector.get(SampleFactory.self).healthKitTypes().map({ $0.readPermissions }) {
			allPermissions = allPermissions.union(permissions)
		}
		return allPermissions
	}()

	private static let writePermissions: Set<HKSampleType> = {
		var allPermissions = Set<HKSampleType>()
		for permissions in DependencyInjector.get(SampleFactory.self).healthKitTypes().map({ $0.writePermissions }) {
			allPermissions = allPermissions.union(permissions)
		}
		return allPermissions
	}()

	private let log = Log()
	private let healthStore = HKHealthStore()

	/// This will convert the given date from the time zone in the given `HKSample` to the current time zone
	/// if the time zone was recorded and the user has convert time zones enabled.
	public func setTimeZoneIfApplicable(for date: inout Date, from sample: HKSample) {
		guard DependencyInjector.get(Settings.self).convertTimeZones else { return }
		if let timeZoneId = sample.metadata?[HKMetadataKeyTimeZone] as? String {
			if let timeZone = TimeZone(identifier: timeZoneId) {
				date = DependencyInjector.get(CalendarUtil.self)
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
		let query = HKStatisticsQuery(
			quantityType: type.quantityType,
			quantitySamplePredicate: predicate,
			options: calculation
		) { _, result, error in
			var value: Double?
			if calculation == .cumulativeSum {
				value = result?.sumQuantity()?.doubleValue(for: type.unit)
			} else if calculation == .discreteAverage {
				value = result?.averageQuantity()?.doubleValue(for: type.unit)
			} else if calculation == .discreteMax {
				value = result?.maximumQuantity()?.doubleValue(for: type.unit)
			} else if calculation == .discreteMin {
				value = result?.minimumQuantity()?.doubleValue(for: type.unit)
			} else if calculation == .discreteMostRecent {
				value = result?.mostRecentQuantity()?.doubleValue(for: type.unit)
			} else {
				self.log.error("Unsupported calculation parameter passed")
			}

			callback(value, error)
		}
		healthStore.execute(query)
	}

	/// - Returns: A method that can be called to stop the query
	public func getSamples(
		for type: HealthKitSample.Type,
		from _: Date?,
		to _: Date?,
		predicate: NSPredicate?,
		callback: @escaping ([HKSample]?, Error?) -> Void
	)
		-> (() -> Void) {
		let query = HKSampleQuery(
			sampleType: type.sampleType,
			predicate: predicate,
			limit: Int(HKObjectQueryNoLimit),
			sortDescriptors: nil,
			resultsHandler: { callback($1, $2) }
		)
		healthStore.execute(query)
		return { self.healthStore.stop(query) }
	}

	public func preferredUnitFor(_ typeId: HKQuantityTypeIdentifier) -> HKUnit? {
		let group = DispatchGroup()
		group.enter()
		var unit: HKUnit?
		// according to Apple documentation, if authorization has not been determined, calling preferredUnits() will throw an error
		getAuthorization { error in
			if let error = error {
				self.log.error("Failed to check for authorization while getting preferred units: %@", errorInfo(error))
				group.leave()
				return
			}
			guard let quantityType = HKQuantityType.quantityType(forIdentifier: typeId) else {
				self.log.error("Unable to determine quantity type for type id: %s", typeId.rawValue)
				return
			}
			self.healthStore.preferredUnits(for: Set([quantityType])) { units, error in
				if let error = error {
					self.log.error(
						"Failed to determine preferred unit for %@: %@",
						String(describing: typeId),
						errorInfo(error)
					)
				}
				unit = units[quantityType]
				group.leave()
			}
		}
		group.wait()
		return unit
	}

	public func getAuthorization(callback: @escaping (Error?) -> Void) {
		var requesting = false
		for objectType in Me.readPermissions {
			log.info("Checking authorization to read %@ data", objectType.identifier)
			let status = healthStore.authorizationStatus(for: objectType)
			log.info("Finished checking authorization to read %@ data", objectType.identifier)
			if status == .notDetermined {
				requesting = true
				log.info("Requesting authorization to HealthKit data")
				let writePermissions: Set<HKSampleType>? = Globals.testing ? Me.writePermissions : nil
				healthStore
					.requestAuthorization(toShare: writePermissions, read: Me.readPermissions) { success, error in
						self.log.info(
							"Finished requesting access to HealthKit data: %@",
							success ? "Success" : "Failure"
						)
						if let error = error {
							self.log.error(
								"Error occurred while trying to request access to HealthKit data: %@",
								errorInfo(error)
							)
						}
						callback(error)
					}
				break
			}
		}
		if !requesting {
			callback(nil)
		}
	}
}
