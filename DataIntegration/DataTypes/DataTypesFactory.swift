//
//  DataTypesFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

class DataTypesFactory: NSObject {

	func activity() -> Activity {
		return Activity()
	}

	func activityInstance(activity: Activity) -> ActivityInstance {
		return ActivityInstance(activity: activity)
	}

	func heartRate(value: Double) -> HeartRate {
		return HeartRate(value: value)
	}

	func heartRate(value: Double, timestamp: Date) -> HeartRate {
		return HeartRate(value: value, timestamp: timestamp)
	}

	func mood() -> Mood {
		return Mood()
	}

	func mood(rating: Double) -> Mood {
		return Mood(rating: rating)
	}

	func mood(timestamp: Date) -> Mood {
		return Mood(timestamp: timestamp)
	}
}
