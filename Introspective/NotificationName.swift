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

	// MARK: - General UI

	case presentView

	// MARK: - Mood Updates

	case moodUpdated
	case moodTimestampUpdated
	case moodRatingUpdated
	case moodMinRatingUpdated
	case moodMaxRatingUpdated
	case moodNoteUpdated

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

			// general UI
			case .presentView: return "presentView"

			// mood updates
			case .moodUpdated: return "moodUpdated"
			case .moodTimestampUpdated: return "moodTimestampUpdated"
			case .moodRatingUpdated: return "moodRatingUpdated"
			case .moodMinRatingUpdated: return "moodMinRatingUpdated"
			case .moodMaxRatingUpdated: return "moodMaxRatingUpdated"
			case .moodNoteUpdated: return "moodNoteUpdated"
		}
	}
}
