//
//  UserInfoKey.swift
//  Introspective
//
//  Created by Bryan Nova on 12/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public enum UserInfoKey: StringLiteralType, Hashable, CustomStringConvertible {

	case activity = "activity"
	case activityDefinition = "activityDefinition"
	case activityDefinitionAutoNote = "activityDefinitionAutoNote"
	case attribute = "attribute"
	case attributed = "attributed"
	case attributeRestriction = "attributeRestriction"
	case attributes = "attributes"
	case attributeValue = "attributeValue"
	case autoIgnoreEnabled = "autoIgnoreEnabled"
	case autoIgnoreSeconds = "autoIgnoreSeconds"
	case backgroundTaskId = "backgroundTaskId"
	case calendarComponent = "calendarComponent"
	case comparisonResult = "comparisonResult"
	case controller = "controller"
	case date = "date"
	case dosage = "dosage"
	case dose = "dose"
	case error = "error"
	case frequency = "frequency"
	case fromDate = "fromDate"
	case graphType = "graphType"
	case groupDefinition = "groupDefinition"
	case information = "information"
	case medication = "medication"
	case message = "message"
	case mood = "mood"
	case notificationName = "notificationName"
	case number = "number"
	case presenter = "presenter"
	case query = "query"
	case sample = "sample"
	case sampleGrouper = "sampleGrouper"
	case sampleType = "sampleType"
	case shouldGenerate = "shouldGenerate"
	case subQueryMatcher = "subQueryMatcher"
	case tagNames = "tagNames"
	case text = "text"
	case title = "title"
	case toDate = "toDate"
	case x = "x"
	case y = "y"

	public var description: String {
		return rawValue
	}
}
