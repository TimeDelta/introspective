//
//  HeartRateQuery.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

import Samples

// sourcery: AutoMockable
public protocol HeartRateQuery: Query {}

public final class HeartRateQueryImpl: HealthKitQuery<HeartRate>, HeartRateQuery {
	override final func initFromHKSample(_ hkSample: HKSample) -> HeartRate {
		precondition(hkSample is HKQuantitySample, "Wrong type of health kit sample for heart rate")
		return HeartRate(hkSample as! HKQuantitySample)
	}
}
