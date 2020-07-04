//
//  LeanBodyMassQuery.swift
//  Introspective
//
//  Created by Bryan Nova on 9/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

import Samples

// sourcery: AutoMockable
public protocol LeanBodyMassQuery: Query {}

public final class LeanBodyMassQueryImpl: HealthKitQuery<LeanBodyMass>, LeanBodyMassQuery {
	override final func initFromHKSample(_ hkSample: HKSample) -> LeanBodyMass {
		precondition(hkSample is HKQuantitySample, "Wrong type of health kit sample for lean body mass")
		return LeanBodyMass(hkSample as! HKQuantitySample)
	}
}
