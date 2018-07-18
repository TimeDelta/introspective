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
	func activity() -> Activity
	func activityInstance(activity: Activity) -> ActivityInstance
	func heartRate(value: Double) -> HeartRate
	func heartRate(_ value: Double, _ dateType: DateType, _ date: Date) -> HeartRate
	func heartRate(_ value: Double, _ dates: [DateType: Date]) -> HeartRate
	func heartRate(_ sample: HKQuantitySample) -> HeartRate
	func mood() -> Mood
	func mood(rating: Double) -> Mood
	func mood(timestamp: Date) -> Mood
}

public class DataTypeFactoryImpl: DataTypeFactory {

	public func activity() -> Activity {
		return Activity()
	}

	public func activityInstance(activity: Activity) -> ActivityInstance {
		return ActivityInstance(activity: activity)
	}

	public func heartRate(value: Double) -> HeartRate {
		return HeartRate(value)
	}

	public func heartRate(_ value: Double, _ dateType: DateType, _ date: Date) -> HeartRate {
		return HeartRate(value, dateType, date)
	}

	public func heartRate(_ value: Double, _ dates: [DateType: Date]) -> HeartRate {
		return HeartRate(value, dates)
	}

	public func heartRate(_ sample: HKQuantitySample) -> HeartRate {
		return HeartRate(sample)
	}

	public func mood() -> Mood {
		return Mood()
	}

	public func mood(rating: Double) -> Mood {
		return Mood(rating: rating)
	}

	public func mood(timestamp: Date) -> Mood {
		return Mood(timestamp: timestamp)
	}
}
