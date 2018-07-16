//
//  HeartRate.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public class HeartRate: DoubleValueSample {

	public override init(_ value: Double) {
		super.init(value)
	}

	public override init(_ value: Double, _ dateType: DateType, _ date: Date) {
		super.init(value, dateType, date)
	}

	public override init(_ value: Double, _ dates: [DateType: Date]) {
		super.init(value, dates)
	}

	public init(_ sample: HKQuantitySample) {
		super.init(sample.value, sample.dates)
	}
}
