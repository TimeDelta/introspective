//
//  HealthKitDataTestUtil.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/23/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//  Leave this file in the main module so that it can be used by the hidden "Generate Test Data" button in settings

import Foundation
import HealthKit

public class HealthKitDataTestUtil {

	private typealias Me = HealthKitDataTestUtil

	private static let healthStore = HKHealthStore()
	private static let readPermissions: Set<HKObjectType> = {
		var allPermissions = Set<HKObjectType>()
		for permissions in DependencyInjector.sample.healthKitTypes().map({ return $0.readPermissions }) {
			allPermissions = allPermissions.union(permissions)
		}
		return allPermissions
	}()
	private static let writePermissions: Set<HKSampleType> = {
		var allPermissions = Set<HKSampleType>()
		for permissions in DependencyInjector.sample.healthKitTypes().map({ return $0.writePermissions }) {
			allPermissions = allPermissions.union(permissions)
		}
		return allPermissions
	}()

	public static func ensureAuthorized() {
		let group = DispatchGroup()
		group.enter()
		Me.healthStore.requestAuthorization(toShare: Me.writePermissions, read: Me.readPermissions) { (_, error) in
			if error != nil { fatalError("Failed to authorize HealthKit access: " + error!.localizedDescription) }
			group.leave()
		}
		group.wait()
	}

	public static func save<SampleType: HealthKitSample>(_ samples: [SampleType]) {
		let allSamples = samples.map({ $0.hkSample() })
		let group = DispatchGroup()
		group.enter()
		Me.healthStore.save(allSamples) { _, error in
			if error != nil { fatalError("Failed to save samples: " + error!.localizedDescription) }
			group.leave()
		}
		group.wait()
	}

	public static func deleteAll(_ type: HealthKitSample.Type) {
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
}
