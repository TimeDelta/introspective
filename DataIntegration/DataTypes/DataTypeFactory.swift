//
//  DataTypeFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

//sourcery: AutoMockable
public protocol DataTypeFactory {
	func heartRate(value: Double) -> HeartRate
	func heartRate(_ sample: HKQuantitySample) -> HeartRate
	func mood() -> Mood
}

public final class DataTypeFactoryImpl: DataTypeFactory {

	public final func heartRate(value: Double) -> HeartRate {
		return HeartRate(value)
	}

	public final func heartRate(_ sample: HKQuantitySample) -> HeartRate {
		return HeartRate(sample)
	}

	public final func mood() -> Mood {
		return try! DependencyInjector.db.new(objectType: MoodImpl.self)
	}
}
