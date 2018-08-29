//
//  WeightQuery.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

//sourcery: AutoMockable
public protocol WeightQuery: Query {}

public class WeightQueryImpl: HealthKitQuery<Weight>, WeightQuery {

	public init() {
		super.init(dataType: .weight, type: .weight)
	}

	override func initFromHKSample(_ hkSample: HKSample) -> Weight {
		precondition(hkSample is HKQuantitySample, "Wrong type of health kit sample for weight")
		return Weight(hkSample as! HKQuantitySample)
	}
}
