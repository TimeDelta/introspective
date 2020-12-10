//
//  NotificationName.swift
//  Introspective
//
//  Created by Bryan Nova on 3/11/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

public enum NotificationName: StringLiteralType {
	// MARK: - Show Screens

	case showRecordActivitiesScreen = "showRecordActivitiesScreen"
	case showRecordMedicationsScreen = "showRecordMedicationsScreen"
	case showResultsScreen = "showResultsScreen"

	// MARK: - Persistence

	/// This is sent when `Database.refreshContext()` had to refresh every object in the persistence layer because external changes have been made
	case persistenceLayerDidRefresh = "persistenceLayerDidRefresh"
	/// This is sent when `Database.refreshContext()` is about to refresh every object in the persistence layer because external changes have been made
	case persistenceLayerWillRefresh = "persistenceLayerWillRefresh"

	// MARK: - Background Tasks

	case extendBackgroundTaskTime = "extendBackgroundTaskTime"
	case cancelBackgroundTask = "cancelBackgroundTask"

	// MARK: - Export

	case backgroundExportFinished = "backgroundExportFinished"
	case shareExportFile = "shareExportFile"

	// MARK: - Mood Value Changes

	case moodRatingChanged = "moodRatingChanged"

	// MARK: - Fatigue Value Changes

	case fatigueRatingChanged = "fatigueeRatingChanged"

	// MARK: - General UI

	case presentView = "presentView"
	case showError = "showError"

	// MARK: - Attributes

	case attributeChosen = "attributeChosen"
	case attributeTypeEdited = "attributeTypeEdited"

	// MARK: - Attribute Restrictions

	case attributeRestrictionEdited = "attributeRestrictionEdited"

	// MARK: - Sample Groupers

	case grouperAttributesSet = "grouperAttributesSet"
	case grouperEdited = "grouperEdited"
	case pointGrouperEdited = "pointGrouperEdited"
	case seriesGrouperEdited = "seriesGrouperEdited"
	case xGrouperEdited = "xGrouperEdited"
	case yGrouperEdited = "yGrouperEdited"
	case groupersEdited = "groupersEdited"
	case grouperTypeChanged = "grouperTypeChanged"

	// MARK: - Group Definitions

	case groupDefinitionEdited = "groupDefinitionEdited"
	case groupNameEdited = "groupNameEdited"

	// MARK: - Graphing

	case xAxisInformationChanged = "xAxisInformationChanged"
	case yAxisInformationChanged = "yAxisInformationChanged"
	case xAxisSampleTypeChanged = "xAxisSampleTypeChanged"
	case yAxisSampleTypeChanged = "yAxisSampleTypeChanged"
	case xAxisQueryChanged = "xAxisQueryChanged"
	case yAxisQueryChanged = "yAxisQueryChanged"

	// MARK: - Sample Types

	case sampleTypeEdited = "sampleTypeEdited"

	// MARK: - Queries

	case runQuery = "runQuery"
	case queryChanged = "queryChanged"

	// MARK: - Information

	case editedInformation = "editedInformation"

	// MARK: - Other

	case timePeriodChosen = "timePeriodChosen"

	// MARK: - Functions

	public func toName() -> Notification.Name {
		Notification.Name(rawValue)
	}
}
