//
//  WeightQuery.swift
//  Introspective
//
//  Created by Bryan Nova on 8/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

import Samples

// sourcery: AutoMockable
public protocol WeightQuery: Query {}

public final class WeightQueryImpl: HealthKitQuery<Weight>, WeightQuery {
	final override func initFromHKSample(_ hkSample: HKSample) -> Weight {
		precondition(hkSample is HKQuantitySample, "Wrong type of health kit sample for weight")
		// Isolated reads are already on their owning queue and must retain its
		// captured clock/settings. Keep the existing path for other callers.
		if readContext != nil { return Weight(hkSample as! HKQuantitySample) }
		var weight = Weight()
		DispatchQueue.global(qos: .userInitiated).sync {
			weight = Weight(hkSample as! HKQuantitySample)
		}
		return weight
	}
}
