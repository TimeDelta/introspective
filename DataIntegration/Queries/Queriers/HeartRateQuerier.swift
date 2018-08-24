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

public var testingHeartRates = false

public class HeartRateQuerier {

	enum Errors: Error {
		case unauthorized
	}

	fileprivate typealias Me = HeartRateQuerier

	fileprivate static let healthStore = HKHealthStore()
	fileprivate static let quantityType = HKObjectType.quantityType(forIdentifier: .heartRate)!
	fileprivate static let sampleType = HKSampleType.quantityType(forIdentifier: .heartRate)!
	fileprivate static let readPermissions: Set<HKObjectType> = Set<HKObjectType>([quantityType])

	public func getHeartRates(predicate: NSPredicate, callback:@escaping (Array<HKQuantitySample>?, Error?)->()) {
		let query = HKSampleQuery(sampleType: Me.sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
			query, results, error in

			callback(results as? [HKQuantitySample], error)
		}

		Me.healthStore.execute(query)
	}

	public func getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback:@escaping (HKStatistics?, Error?)->()) {
		let query = HKStatisticsQuery(quantityType: Me.sampleType, quantitySamplePredicate: predicate, options: statsOptions) {
			query, result, error in

			callback(result, error)
		}

		Me.healthStore.execute(query)
	}

	/// Returns true if authorized or false if unauthorized.
	public func getAuthorization(callback: @escaping (Error?) -> ()) {
		os_log("Checking authorization to read heart rate data", type: .info)

		let status = Me.healthStore.authorizationStatus(for: Me.quantityType)

		if status == .notDetermined {
			os_log("Requesting authorization to read heart rate data", type: .info)
			var writePermissions: Set<HKSampleType>? = nil
			if testingHeartRates {
				writePermissions = Set([Me.sampleType])
			}
			Me.healthStore.requestAuthorization(toShare: writePermissions, read: Me.readPermissions) { (result: Bool, error: Error?) in
				callback(error)
			}
		} else {
			callback(nil)
		}
	}
}
