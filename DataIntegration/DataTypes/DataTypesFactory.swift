//
//  DataTypesFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public class DataTypesFactory: NSObject {

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
