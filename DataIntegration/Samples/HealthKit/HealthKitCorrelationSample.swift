//
//  HealthKitCorrelationSample.swift
//  DataIntegration
//
//  Created by Bryan Nova on 9/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public protocol HealthKitCorrelationSample: HealthKitSample {

	static var correlationType: HKCorrelationType { get }
}
