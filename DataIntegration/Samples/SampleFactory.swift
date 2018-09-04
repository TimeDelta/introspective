//
//  SampleFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

//sourcery: AutoMockable
public protocol SampleFactory {

	func allTypes() -> [Sample.Type]
	func healthKitTypes() -> [HealthKitSample.Type]

	func heartRate(_ value: Double, _ date: Date) -> HeartRate
	func heartRate(value: Double) -> HeartRate
	func heartRate(_ sample: HKQuantitySample) -> HeartRate
	func mood() -> Mood
}

public final class SampleFactoryImpl: SampleFactory {

	public final func allTypes() -> [Sample.Type] {
		return [
			BodyMassIndex.self,
			HeartRate.self,
			LeanBodyMass.self,
			MoodImpl.self,
			Weight.self,
		]
	}

	public final func healthKitTypes() -> [HealthKitSample.Type] {
		return [
			BodyMassIndex.self,
			HeartRate.self,
			LeanBodyMass.self,
			Weight.self,
		]
	}

	public final func heartRate(_ value: Double, _ date: Date) -> HeartRate {
		return HeartRate(value, date)
	}

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
