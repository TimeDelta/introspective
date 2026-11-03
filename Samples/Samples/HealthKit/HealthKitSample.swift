//
//  HealthKitSample.swift
//  Introspective
//
//  Created by Bryan Nova on 9/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public protocol HealthKitSample: Sample {
	static var readPermissions: Set<HKObjectType> { get }
	static var writePermissions: Set<HKSampleType> { get }

	static var sampleType: HKSampleType { get }

	/// This is needed to enable on-demand fetching of user's preferred units from HealthKit
	/// There is some weird bug with HealthKit where it won't return from a call for a user's
	/// preferred units under certain conditions. This is a workaround.
	static func initUnits()

	/// Identity of the original Health record; nil for a locally constructed sample.
	/// Exporting with hkSample() may create a new record with a different UUID.
	var sourceIdentifier: UUID? { get }

	func hkSample() -> HKSample
}

public extension HealthKitSample {
	/// Existing custom sample implementations have no guaranteed read identity.
	var sourceIdentifier: UUID? { nil }
}
