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

public class BodyMassIndexQueryImpl: HealthKitQuery<BodyMassIndex>, BodyMassIndexQuery {

	public init() {
		super.init(dataType: .bmi, type: .bmi)
	}

	override func initFromHKSample(_ hkSample: HKSample) -> BodyMassIndex {
		precondition(hkSample is HKQuantitySample, "Wrong type of health kit sample for BMI")
		return BodyMassIndex(hkSample as! HKQuantitySample)
	}
}
