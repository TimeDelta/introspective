//
//  UserInfoKey.swift
//  Introspective
//
//  Created by Bryan Nova on 12/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public enum UserInfoKey: Hashable, CustomStringConvertible {

	case activity
	case activityDefinition
	case activityDefinitionAutoNote
	case attribute
	case attributed
	case attributeRestriction
	case attributes
	case attributeValue
	case autoIgnoreEnabled
	case autoIgnoreSeconds
	case backgroundTaskId
	case calendarComponent
	case comparisonResult
	case controller
	case date
	case dosage
	case dose
	case error
	case frequency
	case fromDate
	case graphType
	case information
	case medication
	case message
	case mood
	case notificationName
	case number
	case presenter
	case query
	case sample
	case sampleType
	case shouldGenerate
	case subQueryMatcher
	case tagNames
	case text
	case title
	case toDate

	public var description: String {
		switch (self) {
			case .activity: return "activity"
			case .activityDefinition: return "activityDefinition"
			case .activityDefinitionAutoNote: return "activityDefinitionAutoNote"
			case .attribute: return "attribute"
			case .attributed: return "attributed"
			case .attributeRestriction: return "attributeRestriction"
			case .attributes: return "attributes"
			case .attributeValue: return "attributeValue"
			case .autoIgnoreEnabled: return "autoIgnoreEnabled"
			case .autoIgnoreSeconds: return "autoIgnoreSeconds"
			case .backgroundTaskId: return "backgroundTaskId"
			case .calendarComponent: return "calendarComponent"
			case .comparisonResult: return "comparisonResult"
			case .controller: return "controller"
			case .date: return "date"
			case .dosage: return "dosage"
			case .dose: return "dose"
			case .error: return "error"
			case .frequency: return "frequency"
			case .fromDate: return "fromDate"
			case .graphType: return "graphType"
			case .information: return "information"
			case .medication: return "medication"
			case .message: return "message"
			case .mood: return "mood"
			case .notificationName: return "notificationName"
			case .number: return "number"
			case .presenter: return "presenter"
			case .query: return "query"
			case .sample: return "sample"
			case .sampleType: return "sampleType"
			case .shouldGenerate: return "shouldGenerate"
			case .subQueryMatcher: return "subQueryMatcher"
			case .tagNames: return "tagNames"
			case .text: return "text"
			case .title: return "title"
			case .toDate: return "toDate"
		}
	}
}
