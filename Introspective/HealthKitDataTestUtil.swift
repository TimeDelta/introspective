//
//  HealthKitDataTestUtil.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/23/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//  Leave this file in the main module so that it can be used by the hidden "Generate Test Data" button in settings

import Foundation
import HealthKit

import Common
import DependencyInjection
import Samples

public class HealthKitDataTestUtil {
	private typealias Me = HealthKitDataTestUtil

	private static let healthStore = HKHealthStore()

	private static let log = Log()
	public typealias AuthorizationRequest = (Set<HKSampleType>, Set<HKObjectType>, @escaping (Bool, Error?) -> Void) -> Void
	public struct FixturePermissions {
		public let write: Set<HKSampleType>
		public let read: Set<HKObjectType>
	}

	/// Computing fixture permissions never creates a Health store. Catalog types
	/// are read-only and must not add clinical or per-object read permissions here.
	public static func fixturePermissions(for types: [Sample.Type], includingReadAccess: Bool = false) -> FixturePermissions {
		let writers = types.compactMap { $0 as? HealthKitSample.Type }.filter { !$0.writePermissions.isEmpty }
		return FixturePermissions(write: writers.reduce(into: Set<HKSampleType>()) { $0.formUnion($1.writePermissions) },
			read: includingReadAccess ? writers.reduce(into: Set<HKObjectType>()) { $0.formUnion($1.readPermissions) } : [])
	}

	/// The developer generator writes only the selected fixture types. It does
	/// not need read access, and local-only selections need no Health prompt.
	public static func requestGenerationAuthorization(for types: [Sample.Type],
		authorizationRequest: AuthorizationRequest? = nil, completion: @escaping (Error?) -> Void) {
		let permissions = fixturePermissions(for: types)
		guard !permissions.write.isEmpty else { completion(nil); return }
		let request = authorizationRequest ?? { write, read, finish in
			Me.healthStore.requestAuthorization(toShare: write, read: read, completion: finish)
		}
		request(permissions.write, permissions.read) { success, error in
			completion(error ?? (success ? nil : HealthReadAuthorizationError.requestCanceled))
		}
	}

	public static func ensureAuthorized() {
		// Legacy functional tests read back their fixtures. Retain those reads,
		// while excluding the expanded catalog's read-only types.
		let types = injected(SampleFactory.self).healthKitTypes().map { $0 as Sample.Type }
		let permissions = fixturePermissions(for: types, includingReadAccess: true)
		let group = DispatchGroup()
		group.enter()
		Me.healthStore.requestAuthorization(toShare: permissions.write, read: permissions.read) { _, error in
			if error != nil { fatalError("Failed to authorize HealthKit access: " + error!.localizedDescription) }
			group.leave()
		}
		group.wait()
	}

	public static func save<SampleType: HealthKitSample>(_ samples: [SampleType]) {
		do { try saveGeneratedSamples(samples) }
		catch { fatalError("Failed to save samples: " + error.localizedDescription) }
	}

	/// The interactive generator reports denied writes instead of terminating
	/// the app. Keep the legacy save entry point for existing functional tests.
	public static func saveGeneratedSamples<SampleType: HealthKitSample>(_ samples: [SampleType]) throws {
		guard !samples.isEmpty else {
			log.error("Tried to save empty array of %@", SampleType.name)
			return
		}
		let allSamples = samples.map { $0.hkSample() }
		let group = DispatchGroup()
		var failure: Error?
		group.enter()
		Me.healthStore.save(allSamples) { success, error in
			failure = error ?? (success ? nil : GenericError("Health did not save the generated samples."))
			group.leave()
		}
		group.wait()
		if let failure = failure { throw failure }
	}

	public static func deleteAll(_ type: HealthKitSample.Type) {
		var allSamples = [HKSample]()
		var group = DispatchGroup()
		group.enter()
		let queryCallback = { (_: HKSampleQuery, results: [HKSample]?, error: Error?) in
			if error != nil {
				fatalError("Failed to fetch all " + type.name + ": " + error!.localizedDescription)
			}
			allSamples = results!
			group.leave()
		}
		Me.healthStore.execute(
			HKSampleQuery(
				sampleType: type.sampleType,
				predicate: nil,
				limit: Int(HKObjectQueryNoLimit),
				sortDescriptors: nil,
				resultsHandler: queryCallback
			)
		)
		group.wait()
		if !allSamples.isEmpty {
			group = DispatchGroup()
			group.enter()
			Me.healthStore.delete(allSamples) { _, error in
				// if this happens, check to make sure that there is only data from Introspective
				if error != nil { fatalError("Failed to delete " + type.name + ": " + error!.localizedDescription) }
				group.leave()
			}
			group.wait()
		}
	}
}
