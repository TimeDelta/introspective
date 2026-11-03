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
	/// Map a read using its captured preferred unit, even if global preferences change.
	init(_ sample: HKQuantitySample, unit: HKUnit)

	func quantityValue() -> Double
}

public extension HealthKitQuantitySample {
	/// Backward compatibility for custom implementations. Production wrappers
	/// override this initializer to honor the supplied read unit.
	init(_ sample: HKQuantitySample, unit: HKUnit) { self.init(sample) }
}
