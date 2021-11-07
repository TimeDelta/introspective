//
//  StepsQuery.swift
//  Queries
//
//  Created by Bryan Nova on 11/6/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

import Samples

// sourcery: AutoMockable
public protocol StepsQuery: Query {}

public final class StepsQueryImpl: HealthKitQuery<Steps>, StepsQuery {
	final override func initFromHKSample(_ hkSample: HKSample) -> Steps {
		precondition(hkSample is HKQuantitySample, "Wrong type of health kit sample for steps")
		return Steps(hkSample as! HKQuantitySample)
	}
}
