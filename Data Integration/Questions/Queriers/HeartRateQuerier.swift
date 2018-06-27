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

class HeartRateQuerier: NSObject {

	static let HEALTH_STORE = HKHealthStore()
	static let HEART_RATE = HKObjectType.quantityType(forIdentifier: .heartRate)!
	static let SAMPLE_TYPE = HKSampleType.quantityType(forIdentifier: .heartRate)!

	static func getHeartRates(predicate: NSPredicate, callback:@escaping (Array<HKQuantitySample>?, Error?)->()) {
		let query = HKSampleQuery(sampleType: SAMPLE_TYPE, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
			query, results, error in

			callback(results as? [HKQuantitySample], error)
		}

		HEALTH_STORE.execute(query)
	}

	static func getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback:@escaping (HKStatistics?, Error?)->()) {
		let query = HKStatisticsQuery(quantityType: SAMPLE_TYPE, quantitySamplePredicate: predicate, options: statsOptions) {
			query, result, error in

			callback(result, error)
		}

		HEALTH_STORE.execute(query)
	}

	/// Returns true if authorized or false if unauthorized.
	static func getAuthorization() throws -> Bool {
		os_log("Checking authorization to read heart rate data", type: .info)

		let authStatus = HEALTH_STORE.authorizationStatus(for: HEART_RATE)
		var authorized = Bool()
		var errorDuringAuthorization: Error? = nil

		switch (authStatus) {
			case HKAuthorizationStatus.notDetermined:
				os_log("Requesting authorization to read heart rate data", type: .info)

				let READ_PERMISSIONS = Set<HKObjectType>([HEART_RATE])
				HEALTH_STORE.requestAuthorization(toShare: nil, read: READ_PERMISSIONS) { (result: Bool, error: Error?) in

					authorized = result
					errorDuringAuthorization = error
				}
				if errorDuringAuthorization != nil {
					throw errorDuringAuthorization!
				}
				return authorized
			case HKAuthorizationStatus.sharingDenied:
				return false
			case HKAuthorizationStatus.sharingAuthorized:
				return true
		}
	}
}
