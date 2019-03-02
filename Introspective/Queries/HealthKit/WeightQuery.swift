//
//  WeightQuery.swift
//  Introspective
//
//  Created by Bryan Nova on 8/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

//sourcery: AutoMockable
public protocol WeightQuery: Query {}

public final class WeightQueryImpl: HealthKitQuery<Weight>, WeightQuery {

	final override func initFromHKSample(_ hkSample: HKSample) -> Weight {
		precondition(hkSample is HKQuantitySample, "Wrong type of health kit sample for weight")
		var weight: Weight = Weight()
		DispatchQueue.global(qos: .userInitiated).sync {
			weight = Weight(hkSample as! HKQuantitySample)
		}
		return weight
	}
}
