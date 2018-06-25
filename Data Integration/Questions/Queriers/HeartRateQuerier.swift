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

	static func getHeartRates(
		from start: Date,
		to end: Date,
		predicateOptions: HKQueryOptions,
		callback:@escaping (Array<HKQuantitySample>?, Error?)->())
	{
		let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: predicateOptions)

		let query = HKSampleQuery(sampleType: SAMPLE_TYPE, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
			query, results, error in

			let samples = results as? [HKQuantitySample]
//			os_log("Could not fetch heart rates from %@ to %@: %@", type: .error, start.description, end.description, (error?.localizedDescription)!)

			callback(samples, error)
		}

		HEALTH_STORE.execute(query)
	}

	static func getStatisticsFromHeartRates(
		from start: Date,
		to end: Date,
		predicateOptions: HKQueryOptions,
		statsOptions: HKStatisticsOptions,
		callback:@escaping (HKStatistics?, Error?)->())
	{
		let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: [])

		let query = HKStatisticsQuery(quantityType: SAMPLE_TYPE, quantitySamplePredicate: predicate, options: statsOptions) {
			query, result, error in
//			os_log("Could not fetch average heart rate from %@ to %@: %@", type: .error, start.description, end.description, (error?.localizedDescription)!)

			callback(result, error)
		}

		HEALTH_STORE.execute(query)
	}

	static func ensureAuthorization(callback: @escaping (Bool, Error?) -> ()) {
		let authStatus = HEALTH_STORE.authorizationStatus(for: HEART_RATE)

		switch (authStatus) {
			case HKAuthorizationStatus.notDetermined:
				let READ_PERMISSIONS = Set<HKObjectType>([HEART_RATE])
				HEALTH_STORE.requestAuthorization(toShare: nil, read: READ_PERMISSIONS) { (result: Bool, error: Error?) in
					callback(result, error)
				}
				break
			case HKAuthorizationStatus.sharingDenied:
				callback(false, nil)
				break
			case HKAuthorizationStatus.sharingAuthorized:
				callback(true, nil)
				break
		}
	}
}
