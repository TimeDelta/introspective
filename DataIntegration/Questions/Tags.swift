////
////  Tags.swift
////  Data Integration
////
////  Created by Bryan Nova on 6/26/18.
////  Copyright © 2018 Bryan Nova. All rights reserved.
////
//
//import Foundation
//import NaturalLanguage
//
//class Tags: NSObject {
//
//	/// need to pull something from activity data
//	public static let activityData = NLTag("ACTIVITY_DATA")
//	/// underlying token represents some attribute of a data type that will be required
//	public static let attribute = NLTag("ATTRIBUTE")
//	/// average operation needs to be applied before returning
//	public static let average = NLTag("AVERAGE")
//	/// question involves comparing things
//	public static let comparison = NLTag("COMPARISON")
//	/// count operation needs to be applied before returning
//	public static let count = NLTag("COUNT")
//	/// underlying token can be resolved to a specific date
//	public static let date = NLTag("DATE")
//	/// underlying token is a date
//	public static let dayOfMonth = NLTag("DAY_OF_MONTH")
//	/// underlying token is a day of the week (could be plural)
//	public static let dayOfWeek = NLTag("DAY_OF_WEEK")
//	/// nearby quantity is a restriction
//	public static let equal = NLTag("EQUAL")
//	/// frequency return type needed for at least part of the question
//	public static let frequency = NLTag("FREQUENCY")
//	/// nearby quantity is a restriction
//	public static let greaterThan = NLTag("GREATER_THAN")
//	/// nearby quantity is a restriction
//	public static let greaterThanOrEqual = NLTag("GREATER_THAN_OR_EQUAL")
//	/// need to pull something from heart rate data
//	public static let heartRateData = NLTag("HEART_RATE_DATA")
//	/// nearby quantity is a restriction
//	public static let lessThan = NLTag("LESS_THAN")
//	/// nearby quantity is a restriction
//	public static let lessThanOrEqual = NLTag("LESS_THAN_OR_EQUAL")
//	/// underlying token represents a location that can be resolved to a specific address
//	public static let location = NLTag("LOCATION")
//	/// need to pull something from location data
//	public static let locationData = NLTag("LOCATION_DATA")
//	/// question involves a restriction based on location
//	public static let locationRestriction = NLTag("LOCATION_RESTRICTION")
//	/// underlying token is a type of place (library, grocery store, etc.)
//	public static let locationType = NLTag("LOCATION_TYPE")
//	/// maximum operation needs to be applied before returning
//	public static let max = NLTag("MAXIMUM")
//	/// minimum operation needs to be applied before returning
//	public static let min = NLTag("MINIMUM")
//	/// need to pull something from mood data
//	public static let moodData = NLTag("MOOD_DATA")
//	/// negate condition for current constraint
//	public static let negation = NLTag("NEGATION")
//	/// underlying token is not important
//	public static let none = NLTag("NONE")
//	/// must use the context from the previous question in order to answer this question
//	public static let previousContext = NLTag("PREVIOUS_CONTEXT")
//	/// underlying token is a quantity
//	public static let quantity = NLTag("QUANTITY")
//	/// underlying token will determine what kind of question is being asked
//	public static let questionWord = NLTag("QUESTION_WORD")
//	/// need to pull something from sleep data
//	public static let sleepData = NLTag("SLEEP_DATA")
//	/// summation operation needs to be applied before returning
//	public static let sum = NLTag("SUM")
//	/// underlying token specifies a time unit that needs to be used as the basis for aggregation
//	public static let temporalAggregation = NLTag("TEMPORAL_AGGREGATION")
//	/// signifies that a time constraint exists - look at underlying token to determine type
//	public static let timeConstraint = NLTag("TIME_CONSTRAINT")
//	/// could be generic like morning or specific like 930
//	public static let timeOfDay = NLTag("TIME_OF_DAY")
//	/// underlying token is a unit of time
//	public static let timeUnit = NLTag("TIME_UNIT")
//	/// underlying token is a verb
//	public static let verb = NLTag("VERB")
//	/// underlying token determines which of something to use
//	public static let which = NLTag("WHICH")
//	/// use workout data in general
//	public static let workoutData = NLTag("WORKOUT_DATA")
//
//	public static func dataTypeTags() -> Set<NLTag> {
//		return Set([activityData, heartRateData, locationData, moodData, sleepData, workoutData])
//	}
//
//	public static func operationTags() -> Set<NLTag> {
//		return Set([average, count, max, min, sum])
//	}
//
//	public static func quantityRetrictionTags() -> Set<NLTag> {
//		return Set([greaterThan, greaterThanOrEqual, lessThan, lessThanOrEqual])
//	}
//
//	public static func restrictionTypeTags() -> Set<NLTag> {
//		return Set([locationRestriction, timeConstraint])
//	}
//
//	public static func returnTypeTags() -> Set<NLTag> {
//		return Set([attribute, comparison, frequency, ])
//	}
//}
