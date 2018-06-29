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

	fileprivate let HEALTH_STORE = HKHealthStore()
	fileprivate let HEART_RATE = HKObjectType.quantityType(forIdentifier: .heartRate)!
	fileprivate let SAMPLE_TYPE = HKSampleType.quantityType(forIdentifier: .heartRate)!
	fileprivate let READ_PERMISSIONS: Set<HKObjectType>

	public override init() {
		READ_PERMISSIONS = Set<HKObjectType>([HEART_RATE])
	}

	public func getHeartRates(predicate: NSPredicate, callback:@escaping (Array<HKQuantitySample>?, Error?)->()) {
		let query = HKSampleQuery(sampleType: SAMPLE_TYPE, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
			query, results, error in

			callback(results as? [HKQuantitySample], error)
		}

		HEALTH_STORE.execute(query)
	}

	public func getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback:@escaping (HKStatistics?, Error?)->()) {
		let query = HKStatisticsQuery(quantityType: SAMPLE_TYPE, quantitySamplePredicate: predicate, options: statsOptions) {
			query, result, error in

			callback(result, error)
		}

		HEALTH_STORE.execute(query)
	}

	/// Returns true if authorized or false if unauthorized.
	public func getAuthorization(callback: @escaping (Error?) -> ()) {
		os_log("Checking authorization to read heart rate data", type: .info)

		HEALTH_STORE.getRequestStatusForAuthorization(toShare: [], read: READ_PERMISSIONS) {
			(status: HKAuthorizationRequestStatus, error: Error?) in

			if error != nil {
				callback(error)
			}

			switch (status) {
				case HKAuthorizationRequestStatus.shouldRequest:
					os_log("Requesting authorization to read heart rate data", type: .info)
					self.HEALTH_STORE.requestAuthorization(toShare: nil, read: self.READ_PERMISSIONS) { (result: Bool, error: Error?) in
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
