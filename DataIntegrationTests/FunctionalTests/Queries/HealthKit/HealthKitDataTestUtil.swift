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

	private typealias Me = HealthKitDataTestUtil

	private static let healthStore = HKHealthStore()
	private static let readPermissions = Set(HealthManager.SampleType.allTypes.map({ return $0.objectType }))
	private static let sharePermissions = Set(HealthManager.SampleType.allTypes.map({ return $0.sampleType }))
	private static let weight = HealthManager.SampleType.weight
	private static let heartRate = HealthManager.SampleType.heartRate

	public static func saveHeartRates(_ heartRates: HeartRate...) {
		save(type: .heartRate, heartRates)
	}

	public static func saveWeights(_ weights: Weight...) {
		save(type: .weight, weights)
	}

	public static func saveBMIs(_ bmis: BodyMassIndex...) {
		save(type: .bmi, bmis)
	}

	public static func ensureAuthorized() {
		let group = DispatchGroup()
		group.enter()
		Me.healthStore.requestAuthorization(toShare: Me.sharePermissions, read: Me.readPermissions) { (_, error) in
			if error != nil { fatalError("Failed to authorize HealthKit access: " + error!.localizedDescription) }
			group.leave()
		}
		group.wait()
	}

	public static func deleteAll(_ type: HealthManager.SampleType) {
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

	private static func save<SampleType: HealthKitQuantitySample>(type: HealthManager.SampleType, _ samples: [SampleType]) {
		save(type: type, unit: samples[0].quantityUnit(), datesAndQuantity: { return ($0.startDate(), $0.endDate(), $0.quantityValue()) }, samples)
	}

	private static func save<SampleType: Sample>(
		type: HealthManager.SampleType,
		unit: HKUnit,
		datesAndQuantity: (SampleType) -> (Date, Date, Double),
		_ samples: [SampleType])
	{
		var allSamples = [HKQuantitySample]()
		for sample in samples {
			let (start, end, value) = datesAndQuantity(sample)
			let quantity = HKQuantity(unit: unit, doubleValue: value)
			allSamples.append(HKQuantitySample(type: type.objectType as! HKQuantityType, quantity: quantity, start: start, end: end))
		}
		let group = DispatchGroup()
		group.enter()
		Me.healthStore.save(allSamples) { _, error in
			if error != nil { fatalError("Failed to save " + type.name + ": " + error!.localizedDescription) }
			group.leave()
		}
		group.wait()
	}
}
