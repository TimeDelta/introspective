//
//  HKQuantitySampleExtension.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit
import os

extension HKQuantitySample: NumericSample {

	fileprivate typealias Me = HKQuantitySample

	fileprivate static let healthStore = HKHealthStore()

	public var value: Double {
		return quantityValue()
	}

	public var dates: [DateType: Date] {
		return [.start: startDate, .end: endDate]
	}

	fileprivate func quantityValue() -> Double {
		var unit: HKUnit? = nil

		let dispatchGroup = DispatchGroup()
		dispatchGroup.enter()
		DispatchQueue.global(qos: .default).async {
			Me.healthStore.preferredUnits(for: Set<HKQuantityType>([self.quantityType])) {
				(result: [HKQuantityType : HKUnit], error: Error?) in

				if error != nil {
					os_log("Could not get preferred unit for $@", type: .error, self.quantityType.description)
					return
				}

				unit = result[self.quantityType]

				dispatchGroup.leave()
			}
		}
		dispatchGroup.wait()

		if unit == nil {
			return Double.nan
		}

		return quantity.doubleValue(for: unit!)
	}
}
