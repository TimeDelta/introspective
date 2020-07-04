//
//  SexualActivityQuery.swift
//  Introspective
//
//  Created by Bryan Nova on 9/6/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

import Samples

// sourcery: AutoMockable
public protocol SexualActivityQuery: Query {}

public final class SexualActivityQueryImpl: HealthKitQuery<SexualActivity>, SexualActivityQuery {
	override final func initFromHKSample(_ hkSample: HKSample) -> SexualActivity {
		precondition(hkSample is HKCategorySample, "Wrong type of health kit sample for sexual activity")
		return SexualActivity(hkSample as! HKCategorySample)
	}
}
