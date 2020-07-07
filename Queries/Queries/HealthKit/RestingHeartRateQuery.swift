//
//  RestingHeartRateQuery.swift
//  Introspective
//
//  Created by Bryan Nova on 10/5/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

import Samples

// sourcery: AutoMockable
public protocol RestingHeartRateQuery: Query {}

public class RestingHeartRateQueryImpl: HealthKitQuery<RestingHeartRate>, RestingHeartRateQuery {
	final override func initFromHKSample(_ hkSample: HKSample) -> RestingHeartRate {
		precondition(hkSample is HKQuantitySample, "Wrong type of health kit sample for resting heart rate")
		return RestingHeartRate(hkSample as! HKQuantitySample)
	}
}
