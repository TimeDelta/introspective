//
//  HeartRateQuerier.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit
import os

public final class HealthManager {

	private typealias Me = HealthManager
	private static let healthStore = HKHealthStore()
	private static let readPermissions: Set<HKObjectType> = Set<HKObjectType>(DependencyInjector.sample.healthKitTypes().map({ return $0.objectType }))

	static public func getSamples(for type: HealthKitSample.Type, startDate: Date?, endDate: Date?, callback:@escaping (Array<HKQuantitySample>?, Error?)->()) {
		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
		let query = HKSampleQuery(sampleType: type.sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
			query, results, error in
			callback(results as? [HKQuantitySample], error)
		}
		Me.healthStore.execute(query)
	}

	static public func preferredUnitFor(_ typeId: HKQuantityTypeIdentifier) -> HKUnit? {
		let group = DispatchGroup()
		group.enter()
		let quantityType = HKQuantityType.quantityType(forIdentifier: typeId)!
		var unit: HKUnit? = nil
		Me.healthStore.preferredUnits(for: Set([quantityType])) { (units, error) in
			if error != nil {
				os_log("Failed to determine preferred unit for %@: %@", type: .error, String(describing: typeId), error!.localizedDescription)
			}
			unit = units[quantityType]
			group.leave()
		}
		group.wait()
		return unit
	}

	static public func getAuthorization(for type: HealthKitSample.Type, callback: @escaping (Error?) -> ()) {
		os_log("Checking authorization to read %@ data", type: .info, String(describing: type))

		let status = Me.healthStore.authorizationStatus(for: type.objectType)

		if status == .notDetermined {
			os_log("Requesting authorization to read %@ data", type: .info, type.name)
			var writePermissions: Set<HKSampleType>? = nil
			if testing {
				writePermissions = Set(DependencyInjector.sample.healthKitTypes().map({ return $0.sampleType }))
			}
			Me.healthStore.requestAuthorization(toShare: writePermissions, read: Me.readPermissions) { (result: Bool, error: Error?) in
				callback(error)
			}
		} else {
			callback(nil)
		}
	}
}
