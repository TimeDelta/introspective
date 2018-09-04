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

	public enum SampleType {
		case bmi
		case heartRate
		case leanBodyMass
		case weight

		static var allTypes: [SampleType] {
			return [.bmi, .heartRate, .leanBodyMass, .weight]
		}

		var name: String {
			switch (self) {
				case .bmi: return "body mass index"
				case .heartRate: return "heart rate"
				case .leanBodyMass: return "lean body mass"
				case .weight: return "weight"
			}
		}

		var objectType: HKObjectType {
			switch (self) {
				case .bmi: return HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!
				case .heartRate: return HKObjectType.quantityType(forIdentifier: .heartRate)!
				case .leanBodyMass: return HKObjectType.quantityType(forIdentifier: .leanBodyMass)!
				case .weight: return HKObjectType.quantityType(forIdentifier: .bodyMass)!
			}
		}

		var sampleType: HKSampleType {
			switch (self) {
				case .bmi: return HKSampleType.quantityType(forIdentifier: .bodyMassIndex)!
				case .heartRate: return HKSampleType.quantityType(forIdentifier: .heartRate)!
				case .leanBodyMass: return HKSampleType.quantityType(forIdentifier: .leanBodyMass)!
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

	static public func preferredUnitFor(_ type: SampleType) -> HKUnit? {
		let group = DispatchGroup()
		group.enter()
		let quantityType = type.objectType as! HKQuantityType
		var unit: HKUnit? = nil
		Me.healthStore.preferredUnits(for: Set([quantityType])) { (units, error) in
			if error != nil {
				os_log("Failed to determine preferred unit for %@: %@", type: .error, String(describing: type), error!.localizedDescription)
			}
			unit = units[quantityType]
			group.leave()
		}
		group.wait()
		return unit
	}

	static public func getAuthorization(for type: SampleType, callback: @escaping (Error?) -> ()) {
		os_log("Checking authorization to read %@ data", type: .info, type.name)

		let status = Me.healthStore.authorizationStatus(for: type.objectType)

		if status == .notDetermined {
			os_log("Requesting authorization to read %@ data", type: .info, type.name)
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
