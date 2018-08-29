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

public var testing = true // TODO

public class HealthManager {

	public enum SampleType {
		case heartRate
		case weight

		static var allTypes: [SampleType] {
			return [.heartRate, .weight]
		}

		var name: String {
			switch (self) {
				case .heartRate: return "heart rate"
				case .weight: return "weight"
			}
		}

		var objectType: HKObjectType {
			switch (self) {
				case .heartRate: return HKObjectType.quantityType(forIdentifier: .heartRate)!
				case .weight: return HKObjectType.quantityType(forIdentifier: .bodyMass)!
			}
		}

		var sampleType: HKSampleType {
			switch (self) {
				case .heartRate: return HKSampleType.quantityType(forIdentifier: .heartRate)!
				case .weight: return HKSampleType.quantityType(forIdentifier: .bodyMass)!
			}
		}
	}

	private typealias Me = HealthManager
	private static let healthStore = HKHealthStore()
	private static let readPermissions: Set<HKObjectType> = Set<HKObjectType>(SampleType.allTypes.map({ return $0.objectType }))

	static public func getSamples(for type: SampleType, startDate: Date?, endDate: Date?, callback:@escaping (Array<HKQuantitySample>?, Error?)->()) {
		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
		let query = HKSampleQuery(sampleType: type.sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
			query, results, error in
			callback(results as? [HKQuantitySample], error)
		}
		Me.healthStore.execute(query)
	}

	static public func getAuthorization(for type: SampleType, callback: @escaping (Error?) -> ()) {
		os_log("Checking authorization to read $@ data", type: .info, type.name)

		let status = Me.healthStore.authorizationStatus(for: type.objectType)

		if status == .notDetermined {
			os_log("Requesting authorization to read $@ data", type: .info, type.name)
			var writePermissions: Set<HKSampleType>? = nil
			if testing {
				writePermissions = Set(SampleType.allTypes.map({ return $0.sampleType }))
			}
			Me.healthStore.requestAuthorization(toShare: writePermissions, read: Me.readPermissions) { (result: Bool, error: Error?) in
				callback(error)
			}
		} else {
			callback(nil)
		}
	}
}
