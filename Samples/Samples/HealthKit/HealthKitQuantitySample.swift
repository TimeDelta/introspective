//
//  HealthKitQuantitySample.swift
//  Introspective
//
//  Created by Bryan Nova on 8/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public protocol HealthKitQuantitySample: HealthKitSample {

	static var quantityType: HKQuantityType { get }
	static var unit: HKUnit { get }

	var unitString: String { get }

	init(_ sample: HKQuantitySample)

	func quantityValue() -> Double
}
