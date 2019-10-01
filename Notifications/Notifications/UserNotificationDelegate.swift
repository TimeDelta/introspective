//
//  UserNotificationDelegate.swift
//  Introspective
//
//  Created by Bryan Nova on 3/10/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit
import UserNotifications
import NotificationBannerSwift

import Common
import DependencyInjection
import Queries

public final class UserNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {

	private typealias Me = UserNotificationDelegate

	public static let generalError = basicCategory(id: "error occurred")

	public static let extendTime = UNNotificationAction(identifier: "extendTime", title: "Continue")
	public static let cancelTask = UNNotificationAction(identifier: "cancelTask", title: "Cancel Task")
	public static let timeExpired = basicCategory(id: "time expired", actions: [extendTime, cancelTask])

	public static let showActivityHistory = UNNotificationAction(
		identifier: "showActivityHistory",
		title: "Show Activities",
		options: .foreground)
	public static let finishedImportingActivities = basicCategory(id: "finished importing activities", actions: [showActivityHistory])

	public static let showMedicationHistory = UNNotificationAction(
		identifier: "showMedicationHistory",
		title: "Show Medications",
		options: .foreground)
	public static let finishedImportingMedications = basicCategory(id: "finished importing medications", actions: [showMedicationHistory])

	public static let showMoodHistory = UNNotificationAction(
		identifier: "showMoodHistory",
		title: "Show Moods",
		options: .foreground)
	public static let finishedImportingMoods = basicCategory(id: "finished importing moods", actions: [showMoodHistory])

	public static let finishedExportingActivities = basicCategory(id: "finished exporting activities")
	public static let finishedExportingMedications = basicCategory(id: "finished exporting medications")
	public static let finishedExportingMoods = basicCategory(id: "finished exporting moods")

	public static let categories = Set([
		generalError,
		timeExpired,
		finishedImportingActivities,
		finishedImportingMedications,
		finishedImportingMoods,
	])

	// MARK: - Instance Variables

	private final let window: UIWindow?
	private final let log = Log()

	// MARK: - Initializers

	public init(_ window: UIWindow?) {
		self.window = window
	}

	// MARK: - Delegate Methods

	public final func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		willPresent notification: UNNotification,
		withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
	{
		let content = notification.request.content
		if content.categoryIdentifier != Me.timeExpired.identifier {
			let bannerStyle: BannerStyle = isSuccessfulNotification(notification) ? .success : .danger
			NotificationBanner(title: content.title, subtitle: content.body, style: bannerStyle).show()
			completionHandler([])
		} else {
			completionHandler([.alert, .sound])
		}
	}

	public final func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		didReceive response: UNNotificationResponse,
		withCompletionHandler completionHandler: @escaping () -> Void)
	{
		let actionIdentifier = response.actionIdentifier
		switch(actionIdentifier) {
			case UNNotificationDismissActionIdentifier:
				processDismissAction(response)
				break
			case UNNotificationDefaultActionIdentifier:
				processDefaultAction(response)
				break
			case Me.showActivityHistory.identifier:
				showActivityHistory()
				break
			case Me.showMedicationHistory.identifier:
				showMedicationHistory()
				break
			case Me.showMoodHistory.identifier:
				showMoodHistory()
				break
			case Me.extendTime.identifier:
				let content = response.notification.request.content
				sendNotificationForTimeExpiredAction(.extendBackgroundTaskTime, content)
				break
			case Me.cancelTask.identifier:
				let content = response.notification.request.content
				sendNotificationForTimeExpiredAction(.cancelBackgroundTask, content)
				break
			default:
				log.error("Unknown response action identifier: %@", actionIdentifier)
		}
		completionHandler()
	}

	// MARK: - Action Functions

	private final func processDismissAction(_ response: UNNotificationResponse) {
		let content = response.notification.request.content
		let category = content.categoryIdentifier
		switch(category) {
			case Me.timeExpired.identifier:
				sendNotificationForTimeExpiredAction(.cancelBackgroundTask, content)
				break
			default:
				log.debug("Unhandled dismiss action category: %@", category)
		}
	}

	private final func processDefaultAction(_ response: UNNotificationResponse) {
		let content = response.notification.request.content
		let category = content.categoryIdentifier
		switch(category) {
			case Me.timeExpired.identifier:
				sendNotificationForTimeExpiredAction(.extendBackgroundTaskTime, content)
				break
			default:
				log.debug("Unhandled default action category: %@", category)
		}
	}

	private final func showActivityHistory() {
		showRecordDataScreen()
		DependencyInjector.get(NotificationUtil.self).post(.showRecordActivitiesScreen, object: self)
	}

	private final func showMedicationHistory() {
		showRecordDataScreen()
		DependencyInjector.get(NotificationUtil.self).post(.showRecordMedicationsScreen, object: self)
	}

	private final func showMoodHistory() {
		showResultsScreenWith(forQuery: MoodQueryImpl())
	}

	// MARK: - Helper Functions

	private final func sendNotificationForTimeExpiredAction(_ name: NotificationName, _ content: UNNotificationContent) {
		guard let taskId = content.userInfo[UserInfoKey.backgroundTaskId.description] else {
			log.error(
				"Missing background task id on time expired user notification. Title: %@. Body: %@",
				content.title,
				content.body)
			return
		}
		DependencyInjector.get(NotificationUtil.self).post(name, object: self, userInfo: [.backgroundTaskId: taskId])
	}

	private final func showRecordDataScreen() {
		setTabBarIndex(0)
	}

	private final func showResultsScreenWith(forQuery query: Query) {
		setTabBarIndex(1)
		DependencyInjector.get(NotificationUtil.self).post(.showResultsScreen, object: self, userInfo: [.query: query])
	}

	private final func setTabBarIndex(_ index: Int) {
		if let tabController = window?.rootViewController as? UITabBarController {
			tabController.selectedIndex = index
		} else {
			log.error("unable to find tab bar")
		}
	}

	private final func isSuccessfulNotification(_ notification: UNNotification) -> Bool {
		let id = notification.request.identifier
		return id != Me.generalError.identifier
	}

	private static func basicCategory(id: String, actions: [UNNotificationAction] = []) -> UNNotificationCategory {
		return UNNotificationCategory(
			identifier: id,
			actions: actions,
			intentIdentifiers: [],
			options: [
				.hiddenPreviewsShowTitle,
				.hiddenPreviewsShowSubtitle,
			])
	}
}
