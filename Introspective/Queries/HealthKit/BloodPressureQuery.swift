//
//  BloodPressureQuery.swift
//  Introspective
//
//  Created by Bryan Nova on 9/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

//sourcery: AutoMockable
public protocol BloodPressureQuery: Query {}

public final class BloodPressureQueryImpl: HealthKitQuery<BloodPressure>, BloodPressureQuery {

	final override func initFromHKSample(_ hkSample: HKSample) -> BloodPressure {
		precondition(hkSample is HKCorrelation, "Wrong type of health kit sample for blood pressure")
		return BloodPressure(hkSample as! HKCorrelation)
	}
}
