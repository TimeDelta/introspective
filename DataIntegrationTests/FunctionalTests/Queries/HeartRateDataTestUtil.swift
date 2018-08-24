//
//  HeartRateDataTestUtil.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/23/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit
import XCTest
@testable import DataIntegration

public class HeartRateDataTestUtil {

	fileprivate typealias Me = HeartRateDataTestUtil

	fileprivate static let healthStore = HKHealthStore()
	fileprivate static let quantityType = HKObjectType.quantityType(forIdentifier: .heartRate)!
	fileprivate static let sampleType = HKSampleType.quantityType(forIdentifier: .heartRate)!
	fileprivate static let permissionTypes: Set<HKObjectType> = Set<HKObjectType>([quantityType])
	fileprivate static let unit = HKUnit.count().unitDivided(by: HKUnit.minute())

	static func saveHeartRates(_ heartRates: HeartRate...) {
		var heartRateSamples = [HKQuantitySample]()
		for heartRate in heartRates {
			let date = heartRate.timestamp
			let quantity = HKQuantity(unit: Me.unit, doubleValue: heartRate.heartRate)
			heartRateSamples.append(HKQuantitySample(type: Me.quantityType, quantity: quantity, start: date, end: date))
		}
		let group = DispatchGroup()
		group.enter()
		Me.healthStore.save(heartRateSamples) { _, error in
			if error != nil { fatalError("Failed to save heart rates: " + error!.localizedDescription) }
			group.leave()
		}
		group.wait()
	}

	static func deleteAllHeartRates() {
		var allHeartRates = [HKSample]()
		var group = DispatchGroup()
		group.enter()
		Me.healthStore.execute(HKSampleQuery(sampleType: Me.sampleType, predicate: nil, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
			(_, results, error) in
			if error != nil { fatalError("Failed to fetch all heart rates: " + error!.localizedDescription) }
			allHeartRates = results!
			group.leave()
		})
		group.wait()
		group = DispatchGroup()
		if allHeartRates.count > 0 {
			group.enter()
			Me.healthStore.delete(allHeartRates) { _, error in
				if error != nil { fatalError("Failed to delete heart rates: " + error!.localizedDescription) }
				group.leave()
			}
			group.wait()
		}
	}

	static func ensureAuthorized() {
		let group = DispatchGroup()
		group.enter()
		Me.healthStore.requestAuthorization(toShare: Set([Me.sampleType]), read: Me.permissionTypes) { (_, error) in
			if error != nil { fatalError("Failed to authorize HealthKit access: " + error!.localizedDescription) }
			group.leave()
		}
		group.wait()
	}
}
