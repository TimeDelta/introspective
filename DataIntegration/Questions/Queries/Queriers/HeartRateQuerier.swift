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

	typealias Me = HeartRateQuerier

	fileprivate static let HEALTH_STORE = HKHealthStore()
	fileprivate static let HEART_RATE = HKObjectType.quantityType(forIdentifier: .heartRate)!
	fileprivate static let SAMPLE_TYPE = HKSampleType.quantityType(forIdentifier: .heartRate)!
	fileprivate static let READ_PERMISSIONS: Set<HKObjectType> = Set<HKObjectType>([HEART_RATE])

	public func getHeartRates(predicate: NSPredicate, callback:@escaping (Array<HKQuantitySample>?, Error?)->()) {
		let query = HKSampleQuery(sampleType: Me.SAMPLE_TYPE, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
			query, results, error in

			callback(results as? [HKQuantitySample], error)
		}

		Me.HEALTH_STORE.execute(query)
	}

	public func getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback:@escaping (HKStatistics?, Error?)->()) {
		let query = HKStatisticsQuery(quantityType: Me.SAMPLE_TYPE, quantitySamplePredicate: predicate, options: statsOptions) {
			query, result, error in

			callback(result, error)
		}

		Me.HEALTH_STORE.execute(query)
	}

	/// Returns true if authorized or false if unauthorized.
	public func getAuthorization(callback: @escaping (Error?) -> ()) {
		os_log("Checking authorization to read heart rate data", type: .info)

		Me.HEALTH_STORE.getRequestStatusForAuthorization(toShare: [], read: Me.READ_PERMISSIONS) {
			(status: HKAuthorizationRequestStatus, error: Error?) in

			if error != nil {
				callback(error)
			}

			switch (status) {
				case HKAuthorizationRequestStatus.shouldRequest:
					os_log("Requesting authorization to read heart rate data", type: .info)
					Me.HEALTH_STORE.requestAuthorization(toShare: nil, read: Me.READ_PERMISSIONS) { (result: Bool, error: Error?) in
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
