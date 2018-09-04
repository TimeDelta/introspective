//
//  BodyMassIndexQuery.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

//sourcery: AutoMockable
public protocol BodyMassIndexQuery: Query {}

public final class BodyMassIndexQueryImpl: HealthKitQuery<BodyMassIndex>, BodyMassIndexQuery {

	final override func initFromHKSample(_ hkSample: HKSample) -> BodyMassIndex {
		precondition(hkSample is HKQuantitySample, "Wrong type of health kit sample for BMI")
		return BodyMassIndex(hkSample as! HKQuantitySample)
	}
}
