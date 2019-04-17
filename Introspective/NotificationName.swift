//
//  NotificationName.swift
//  Introspective
//
//  Created by Bryan Nova on 3/11/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

public enum NotificationName {

	// MARK: - Show Screens

	case showRecordActivitiesScreen
	case showRecordMedicationsScreen
	case showResultsScreen

	// MARK: - Background Tasks

	case extendBackgroundTaskTime
	case cancelBackgroundTask

	// MARK: - Export
	case backgroundExportFinished
	case shareExportFile

	// MARK: - Mood Value Changes

	case moodRatingChanged

	// MARK: - General UI

	case presentView

	// MARK: - Functions

	public func toName() -> Notification.Name {
		return Notification.Name(nameText)
	}

	private var nameText: String {
		switch(self) {
			// show screens
			case .showRecordActivitiesScreen: return "showRecordActivitiesScreen"
			case .showRecordMedicationsScreen: return "showRecordMedicationsScreen"
			case .showResultsScreen: return "showResultsScreen"

			// background tasks
			case .extendBackgroundTaskTime: return "extendBackgroundTaskTime"
			case .cancelBackgroundTask: return "cancelBackgroundTask"

			// export
			case .backgroundExportFinished: return "backgroundExportFinished"
			case .shareExportFile: return "shareExportFile"

			// mood value changes
			case .moodRatingChanged: return "moodRatingChanged"

			// general UI
			case .presentView: return "presentView"
		}
	}
}
