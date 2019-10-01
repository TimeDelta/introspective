//
//  AppDelegate.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

import AttributeRestrictions
import BooleanAlgebra
import Common
import DependencyInjection
import DataExport
import DataImport
import Globals
import Notifications
import Persistence
import Queries
import Samples
import SampleGroupers
import SampleGroupInformation
import Settings

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

	private typealias Me = AppDelegate

	final var window: UIWindow?

	private final var userNotificationDelegate: UserNotificationDelegate!

	private final let log = Log()

	final func application(
		_ application: UIApplication,
		willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil)
	-> Bool {
		Me.registerDependencies()

		userNotificationDelegate = UserNotificationDelegate(window)

		let center = UNUserNotificationCenter.current()
		center.setNotificationCategories(UserNotificationDelegate.categories)
		center.delegate = userNotificationDelegate

		return true
	}

	final func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		Globals.testing = CommandLine.arguments.contains("--testing")
		Globals.functionalTesting = CommandLine.arguments.contains("--functional-testing")
		Globals.uiTesting = CommandLine.arguments.contains("--ui-testing")

		let options: UNAuthorizationOptions = [.alert, .sound, .badge]
		UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
			if let error = error {
				self.log.error("Failed to request authorization for notifications: %@", errorInfo(error))
			}
			if !granted {
				self.log.info("Notifications not authorized")
			}
		}

		return true
	}

	final func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	final func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	final func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	final func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	final func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

	static func registerDependencies() {
		DependencyInjector.register(AttributeRestrictionsInjectionProvider())
		DependencyInjector.register(BooleanAlgebraInjectionProvider())
		DependencyInjector.register(CommonInjectionProvider())
		DependencyInjector.register(DataExportInjectionProvider())
		DependencyInjector.register(DataImportInjectionProvider())
		DependencyInjector.register(IntrospectiveInjectionProvider())
		DependencyInjector.register(PersistenceInjectionProvider(ObjectModelContainer.objectModel))
		DependencyInjector.register(QueriesInjectionProvider())
		DependencyInjector.register(SamplesInjectionProvider())
		DependencyInjector.register(SampleGroupersInjectionProvider())
		DependencyInjector.register(SampleGroupInformationInjectionProvider())
		DependencyInjector.register(SettingsInjectionProvider())
	}
}
