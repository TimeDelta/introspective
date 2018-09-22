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

	func hkSample() -> HKSample
}
