//
//  DietarySugarQuery.swift
//  Queries
//
//  Created by Bryan Nova on 6/18/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

import Samples

// sourcery: AutoMockable
public protocol DietarySugarQuery: Query {}

public final class DietarySugarQueryImpl: HealthKitQuery<DietarySugar>, DietarySugarQuery {
	final override func initFromHKSample(_ hkSample: HKSample) -> DietarySugar {
		precondition(hkSample is HKQuantitySample, "Wrong type of health kit sample for dietary sugar")
		return DietarySugar(hkSample as! HKQuantitySample)
	}
}
