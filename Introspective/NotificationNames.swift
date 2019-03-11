//
//  NotificationNames.swift
//  Introspective
//
//  Created by Bryan Nova on 3/11/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

public final class NotificationNames {

	// MARK: - Show Screens

	public static let showRecordActivitiesScreen = Notification.Name("showRecordActivitiesScreen")
	public static let showRecordMedicationsScreen = Notification.Name("showRecordMedicationsScreen")
	public static let showResultsScreen = Notification.Name("showResultsScreen")

	// MARK: - Background Tasks

	public static let extendBackgroundTaskTime = Notification.Name("extendBackgroundTaskTime")
	public static let cancelBackgroundTask = Notification.Name("cancelBackgroundTask")
}
