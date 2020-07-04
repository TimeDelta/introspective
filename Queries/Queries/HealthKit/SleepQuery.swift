//
//  SleepQuery.swift
//  Introspective
//
//  Created by Bryan Nova on 9/25/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

import Samples

// sourcery: AutoMockable
public protocol SleepQuery: Query {}

public final class SleepQueryImpl: HealthKitQuery<Sleep>, SleepQuery {
	override final func initFromHKSample(_ hkSample: HKSample) -> Sleep {
		precondition(hkSample is HKCategorySample, "Wrong type of health kit sample for sleep")
		return Sleep(hkSample as! HKCategorySample)
	}
}
