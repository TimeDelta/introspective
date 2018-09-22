//
//  HealthKitCategorySample.swift
//  Introspective
//
//  Created by Bryan Nova on 9/6/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public protocol HealthKitCategorySample: HealthKitSample {

	static var categoryType: HKCategoryType { get }
}
