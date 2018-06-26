//
//  Tags.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import NaturalLanguage

class Tags: NSObject {

	/// need to pull something from activity data
	static let activityData = NLTag("ACTIVITY_DATA")
	/// underlying token represents some attribute of a data type that will be required
	static let attribute = NLTag("ATTRIBUTE")
	/// average operation needs to be applied before returning
	static let average = NLTag("AVERAGE")
	/// question involves comparing things
	static let comparison = NLTag("COMPARISON")
	/// count operation needs to be applied before returning
	static let count = NLTag("COUNT")
	/// underlying token can be resolved to a specific date
	static let date = NLTag("DATE")
	/// underlying token is a date
	static let dayOfMonth = NLTag("DAY_OF_MONTH")
	/// underlying token is a day of the week (could be plural)
	static let dayOfWeek = NLTag("DAY_OF_WEEK")
	/// frequency return type needed for at least part of the question
	static let frequency = NLTag("FREQUENCY")
	/// nearby quantity is a restriction
	static let greaterThan = NLTag("GREATER_THAN")
	/// nearby quantity is a restriction
	static let greaterThanOrEqual = NLTag("GREATER_THAN_OR_EQUAL")
	/// need to pull something from heart rate data
	static let heartRateData = NLTag("HEART_RATE_DATA")
	/// nearby quantity is a restriction
	static let lessThan = NLTag("LESS_THAN")
	/// nearby quantity is a restriction
	static let lessThanOrEqual = NLTag("LESS_THAN_OR_EQUAL")
	/// underlying token represents a location that can be resolved to a specific address
	static let location = NLTag("LOCATION")
	/// need to pull something from location data
	static let locationData = NLTag("LOCATION_DATA")
	/// question involves a restriction based on location
	static let locationRestriction = NLTag("LOCATION_RESTRICTION")
	/// underlying token is a type of place (library, grocery store, etc.)
	static let locationType = NLTag("LOCATION_TYPE")
	/// minimum operation needs to be applied before returning
	static let minimum = NLTag("MINIMUM")
	/// need to pull something from mood data
	static let moodData = NLTag("MOOD_DATA")
	/// negate condition for current constraint
	static let negation = NLTag("NEGATION")
	/// underlying token is not important
	static let noneToken = NLTag("NONE")
	/// underlying token is a quantity
	static let quantity = NLTag("QUANTITY")
	/// underlying token will determine what kind of question is being asked
	static let questionWord = NLTag("QUESTION_WORD")
	/// need to pull something from sleep data
	static let sleepData = NLTag("SLEEP_DATA")
	/// summation operation needs to be applied before returning
	static let sum = NLTag("SUM")
	/// underlying token specifies a time unit that needs to be used as the basis for aggregation
	static let temporalAggregation = NLTag("TEMPORAL_AGGREGATION")
	/// signifies that a time constraint exists - look at underlying token to determine type
	static let timeConstraint = NLTag("TIME_CONSTRAINT")
	/// could be generic like morning or specific like 930
	static let timeOfDay = NLTag("TIME_OF_DAY")
	/// underlying token is a unit of time
	static let timeUnit = NLTag("TIME_UNIT")
	/// underlying token determines which of something to use
	static let which = NLTag("WHICH")
	/// use workout data in general
	static let workoutData = NLTag("WORKOUT_DATA")

	static func dataTypeTags() -> Set<NLTag> {
		return Set([activityData, heartRateData, locationData, moodData, sleepData, workoutData])
	}

	static func operationTags() -> Set<NLTag> {
		return Set([average, count, minimum, sum])
	}

	static func quantityRetrictionTags() -> Set<NLTag> {
		return Set([greaterThan, greaterThanOrEqual, lessThan, lessThanOrEqual])
	}

	static func restrictionTypeTags() -> Set<NLTag> {
		return Set([locationRestriction, timeConstraint])
	}
}
