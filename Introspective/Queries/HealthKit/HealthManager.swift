//
//  HeartRateQuerier.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public final class HealthManager {

	private typealias Me = HealthManager
	private static let log = Log()
	private static let healthStore = HKHealthStore()
	private static let readPermissions: Set<HKObjectType> = {
		var allPermissions = Set<HKObjectType>()
		for permissions in DependencyInjector.sample.healthKitTypes().map({ return $0.readPermissions }) {
			allPermissions = allPermissions.union(permissions)
		}
		return allPermissions
	}()
	private static let writePermissions: Set<HKSampleType> = {
		var allPermissions = Set<HKSampleType>()
		for permissions in DependencyInjector.sample.healthKitTypes().map({ return $0.writePermissions }) {
			allPermissions = allPermissions.union(permissions)
		}
		return allPermissions
	}()

	static public func calculate(_ calculation: HKStatisticsOptions, _ type: HealthKitQuantitySample.Type, from startDate: Date, to endDate: Date, callback:@escaping (Double?, Error?) -> ()) {
		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
		let query = HKStatisticsQuery(quantityType: type.quantityType, quantitySamplePredicate: predicate, options: calculation) { _, result, error in
			var value: Double?
			if calculation == .cumulativeSum {
				value = result?.sumQuantity()?.doubleValue(for: type.unit)
			} else if calculation == .discreteAverage {
				value = result?.averageQuantity()?.doubleValue(for: type.unit)
			} else if calculation == .discreteMax {
				value = result?.maximumQuantity()?.doubleValue(for: type.unit)
			} else if calculation == .discreteMin {
				value = result?.minimumQuantity()?.doubleValue(for: type.unit)
			} else if #available(iOS 12.0, *), calculation == .discreteMostRecent {
				value = result?.mostRecentQuantity()?.doubleValue(for: type.unit)
			} else {
				Me.log.error("Unsupported calculation parameter passed")
			}

			callback(value, error)
		}
		Me.healthStore.execute(query)
	}

	/// - Returns: A method that can be called to stop the query
	static public func getSamples(
		for type: HealthKitSample.Type,
		startDate: Date? = nil,
		endDate: Date? = nil,
		predicate: NSPredicate? = nil,
		callback:@escaping (Array<HKSample>?, Error?) -> ())
	-> (() -> ()) {
		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
		let query = HKSampleQuery(sampleType: type.sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) { callback($1, $2) }
		Me.healthStore.execute(query)
		return { Me.healthStore.stop(query) }
	}

	static public func preferredUnitFor(_ typeId: HKQuantityTypeIdentifier) -> HKUnit? {
		let group = DispatchGroup()
		group.enter()
		let quantityType = HKQuantityType.quantityType(forIdentifier: typeId)!
		var unit: HKUnit? = nil
		Me.healthStore.preferredUnits(for: Set([quantityType])) { (units, error) in
			if let error = error {
				Me.log.error("Failed to determine preferred unit for %@: %@", String(describing: typeId), errorInfo(error))
			}
			unit = units[quantityType]
			group.leave()
		}
		group.wait()
		return unit
	}

	static public func getAuthorization(callback: @escaping (Error?) -> ()) {
		var requesting = false
		for objectType in readPermissions {
			Me.log.info("Checking authorization to read %@ data", objectType.identifier)
			let status = Me.healthStore.authorizationStatus(for: objectType)
			Me.log.info("Finished checking authorization to read %@ data", objectType.identifier)
			if status == .notDetermined {
				requesting = true
				Me.log.info("Requesting authorization to HealthKit data")
				let writePermissions: Set<HKSampleType>? = testing ? Me.writePermissions : nil
				Me.healthStore.requestAuthorization(toShare: writePermissions, read: Me.readPermissions) { (success, error) in
					Me.log.info("Finished requesting access to HealthKit data: %@", success ? "Success" : "Failure")
					if let error = error {
						Me.log.error("Error occurred while trying to request access to HealthKit data: %@", errorInfo(error))
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
