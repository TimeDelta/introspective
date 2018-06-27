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

	enum ErrorTypes: Error {

	}

	fileprivate static let HEALTH_STORE = HKHealthStore()
	fileprivate static let HEART_RATE = HKObjectType.quantityType(forIdentifier: .heartRate)!
	fileprivate static let SAMPLE_TYPE = HKSampleType.quantityType(forIdentifier: .heartRate)!
	fileprivate static let READ_PERMISSIONS = Set<HKObjectType>([HEART_RATE])

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
	static func getAuthorization(callback: @escaping (Error?) -> ()) {
		os_log("Checking authorization to read heart rate data", type: .info)

		HEALTH_STORE.getRequestStatusForAuthorization(toShare: [], read: READ_PERMISSIONS) {
			(status: HKAuthorizationRequestStatus, error: Error?) in

			if error != nil {
				callback(error)
			}

			switch (status) {
				case HKAuthorizationRequestStatus.shouldRequest:
					os_log("Requesting authorization to read heart rate data", type: .info)
					HEALTH_STORE.requestAuthorization(toShare: nil, read: READ_PERMISSIONS) { (result: Bool, error: Error?) in
						callback(error)
					}
				case HKAuthorizationRequestStatus.unnecessary:
					callback(nil)
				case HKAuthorizationRequestStatus.unknown:
					callback(nil)
			}
		}
	}
}
