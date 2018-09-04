//
//  HealthKitQuantitySample.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public protocol HealthKitQuantitySample: HealthKitSample {

	static var quantityType: HKQuantityType { get }

	init(_ sample: HKQuantitySample)

	func quantityUnit() -> HKUnit
	func quantityValue() -> Double
	func startDate() -> Date
	func endDate() -> Date
}

extension HealthKitQuantitySample {

	public func startDate() -> Date {
		return dates()[.start]!
	}

	public func endDate() -> Date {
		return dates()[.end] ?? dates()[.start]!
	}
}
