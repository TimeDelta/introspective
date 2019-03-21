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

	// MARK: - Functions

	public func toName() -> Notification.Name {
		return Notification.Name(nameText)
	}

	private var nameText: String {
		switch(self) {
			case .showRecordActivitiesScreen: return "showRecordActivitiesScreen"
			case .showRecordMedicationsScreen: return "showRecordMedicationsScreen"
			case .showResultsScreen: return "showResultsScreen"

			case .extendBackgroundTaskTime: return "extendBackgroundTaskTime"
			case .cancelBackgroundTask: return "cancelBackgroundTask"
		}
	}
}