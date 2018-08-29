//
//  HealthKitDataTestUtil.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/23/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit
import XCTest
@testable import DataIntegration

public class HealthKitDataTestUtil {

	fileprivate typealias Me = HealthKitDataTestUtil

	fileprivate static let healthStore = HKHealthStore()
	fileprivate static let readPermissions = Set(HealthManager.SampleType.allTypes.map({ return $0.objectType }))
	fileprivate static let sharePermissions = Set(HealthManager.SampleType.allTypes.map({ return $0.sampleType }))
	fileprivate static let weight = HealthManager.SampleType.weight
	fileprivate static let heartRate = HealthManager.SampleType.heartRate

	static func saveHeartRates(_ heartRates: HeartRate...) {
		var heartRateSamples = [HKQuantitySample]()
		for heartRate in heartRates {
			let date = heartRate.timestamp
			let quantity = HKQuantity(unit: HeartRate.beatsPerMinute, doubleValue: heartRate.heartRate)
			heartRateSamples.append(HKQuantitySample(type: Me.heartRate.objectType as! HKQuantityType, quantity: quantity, start: date, end: date))
		}
		save(.heartRate, heartRateSamples)
	}

	static func saveWeights(_ weights: Weight...) {
		var weightSamples = [HKQuantitySample]()
		for weight in weights {
			let date = weight.timestamp
			let quantity = HKQuantity(unit: Weight.pounds, doubleValue: weight.weight)
			weightSamples.append(HKQuantitySample(type: Me.weight.objectType as! HKQuantityType, quantity: quantity, start: date, end: date))
		}
		save(.weight, weightSamples)
	}

	static func ensureAuthorized() {
		let group = DispatchGroup()
		group.enter()
		Me.healthStore.requestAuthorization(toShare: Me.sharePermissions, read: Me.readPermissions) { (_, error) in
			if error != nil { fatalError("Failed to authorize HealthKit access: " + error!.localizedDescription) }
			group.leave()
		}
		group.wait()
	}

	static func deleteAll(_ type: HealthManager.SampleType) {
		var allSamples = [HKSample]()
		var group = DispatchGroup()
		group.enter()
		Me.healthStore.execute(HKSampleQuery(sampleType: type.sampleType, predicate: nil, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
			(_, results, error) in
			if error != nil { fatalError("Failed to fetch all " + type.name + ": " + error!.localizedDescription) }
			allSamples = results!
			group.leave()
		})
		group.wait()
		if allSamples.count > 0 {
			group = DispatchGroup()
			group.enter()
			Me.healthStore.delete(allSamples) { _, error in
				if error != nil { fatalError("Failed to delete " + type.name + ": " + error!.localizedDescription) }
				group.leave()
			}
			group.wait()
		}
	}

	fileprivate static func save(_ type: HealthManager.SampleType, _ samples: [HKSample]) {
		let group = DispatchGroup()
		group.enter()
		Me.healthStore.save(samples) { _, error in
			if error != nil { fatalError("Failed to save " + type.name + ": " + error!.localizedDescription) }
			group.leave()
		}
		group.wait()
	}
}
