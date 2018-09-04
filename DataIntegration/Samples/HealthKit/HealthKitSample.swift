//
//  HealthKitSample.swift
//  DataIntegration
//
//  Created by Bryan Nova on 9/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public protocol HealthKitSample: Sample {

	static var objectType: HKObjectType { get }
	static var sampleType: HKSampleType { get } // TODO - this should be in a different protocol that objectType
}
