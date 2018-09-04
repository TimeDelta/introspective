//
//  LeanBodyMassQuery.swift
//  DataIntegration
//
//  Created by Bryan Nova on 9/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

//sourcery: AutoMockable
public protocol LeanBodyMassQuery: Query {}

public final class LeanBodyMassQueryImpl: HealthKitQuery<LeanBodyMass>, LeanBodyMassQuery {

	public init() {
		super.init(dataType: .leanBodyMass, type: .leanBodyMass)
	}

	final override func initFromHKSample(_ hkSample: HKSample) -> LeanBodyMass {
		precondition(hkSample is HKQuantitySample, "Wrong type of health kit sample for BMI")
		return LeanBodyMass(hkSample as! HKQuantitySample)
	}
}