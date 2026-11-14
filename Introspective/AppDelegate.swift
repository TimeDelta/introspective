//
//  AppDelegate.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import CoreData
import UIKit
import UserNotifications

import AttributeRestrictions
import BooleanAlgebra
import Common
import DataExport
import DataImport
import DependencyInjection
import Globals
import Notifications
import Persistence
import Queries
import SampleFetchers
import SampleGroupers
import SampleGroupInformation
import Samples
import Settings

final class AppDelegate: UIResponder, UIApplicationDelegate {
	private typealias Me = AppDelegate

	private static var wasInBackground = false
	private static let log = Log()

	final var window: UIWindow?

	private final var userNotificationDelegate: UserNotificationDelegate!
	private let moodTracking = MoodTrackingCoordinator()
	private var activityNoteObserver: NSObjectProtocol?

	override init() {
		super.init()
		#if DEBUG
		UILaunchProfileRecorder.current?.record(.delegateInitialized)
		#endif
	}

	final func application(
		_: UIApplication,
		willFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
	) -> Bool {
		// Settings and persistence resolve dependencies during launch. Set test mode first.
		Globals.testing = CommandLine.arguments.contains("--testing")
		Globals.functionalTesting = CommandLine.arguments.contains("--functional-testing")
		Globals.uiTesting = CommandLine.arguments.contains("--ui-testing")
		#if DEBUG
		UILaunchProfileRecorder.current?.record(.willFinishBegin)
		#endif

		Me.registerDependencies()
		#if DEBUG
		UILaunchProfileRecorder.current?.record(.dependenciesReady)
		#endif
		if Globals.uiTesting {
			let dashboardSuite = "com.bnova.Introspective.dashboard-ui-tests"
			UserDefaults(suiteName: dashboardSuite)?.removePersistentDomain(forName: dashboardSuite)
			try? MoodTrackingPreferences.shared.save(presets: [])
			try? MoodTrackingPreferences.shared.save(reminders: MoodReminderSettings())
			try? StressReminderPreferences.shared.save(reminders: StressReminderSettings())
		}

		#if DEBUG
		UILaunchProfileRecorder.current?.record(.preferencesReady)
		// Seed only the UI runner's fresh database, before storyboard controllers fetch.
		do {
			try UITestFixtureLoader.load(environment: ProcessInfo.processInfo.environment, isUITesting: Globals.uiTesting)
		} catch {
			fatalError("Failed to prepare UI test fixtures: \(error)")
		}
		UILaunchProfileRecorder.current?.record(.fixturesReady)
		#endif

		userNotificationDelegate = UserNotificationDelegate(window)

		let center = UNUserNotificationCenter.current()
		center.setNotificationCategories(UserNotificationDelegate.categories)
		center.delegate = userNotificationDelegate
		#if DEBUG
		UILaunchProfileRecorder.current?.record(.willFinishEnd)
		#endif

		return true
	}

	final func application(
		_: UIApplication,
		didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
	) -> Bool {
		#if DEBUG
		UILaunchProfileRecorder.current?.record(.didFinishBegin)
		defer { UILaunchProfileRecorder.current?.record(.didFinishEnd) }
		#endif
		// The storyboard window is available here, including on notification launches.
		userNotificationDelegate = UserNotificationDelegate(window)
		UNUserNotificationCenter.current().delegate = userNotificationDelegate
		guard !Globals.testing && !Globals.uiTesting else { return true }
		moodTracking.start()
		activityNoteObserver = NotificationCenter.default.addObserver(
			forName: ActivityNoteRouting.notification, object: nil, queue: .main
		) { [weak self] _ in self?.openPendingActivityNote() }

		let options: UNAuthorizationOptions = [.alert, .sound, .badge]
		UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
			if let error = error {
				Me.log.error("Failed to request authorization for notifications: %@", errorInfo(error))
			}
			if !granted {
				Me.log.info("Notifications not authorized")
			}
		}

		return true
	}

	final func application(_ application: UIApplication, open url: URL,
		options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
		guard url.scheme == "introspective", ["mood-check-in", "activities"].contains(url.host ?? ""),
			let tabs = window?.rootViewController as? UITabBarController,
			let navigation = tabs.viewControllers?.first as? UINavigationController else { return false }
		tabs.selectedIndex = 0
		if url.host == "activities" {
			if !(navigation.topViewController is RecordActivityTableViewController) {
				let storyboard = UIStoryboard(name: "RecordData", bundle: nil)
				navigation.pushViewController(storyboard.instantiateViewController(withIdentifier: "activitiesTable"), animated: false)
			}
			return true
		}
		if !(navigation.topViewController is MoodPresetsViewController) {
			navigation.pushViewController(MoodPresetsViewController(style: .grouped), animated: false)
		}
		return true
	}

	final func applicationWillResignActive(_: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	final func applicationDidEnterBackground(_: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
		Me.wasInBackground = true
	}

	final func applicationWillEnterForeground(_: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	final func applicationDidBecomeActive(_: UIApplication) {
		#if DEBUG
		UILaunchProfileRecorder.current?.record(.appActive)
		#endif
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		if Me.wasInBackground {
			// not necessary on startup because context is always pulled fresh on app start. this allows faster startup
			// essentially this is needed in case persisted objects were modified by app extension (SiriIntent / widget)
			injected(AsyncUtil.self).run(qos: .userInteractive) {
				injected(Database.self).refreshContext()
			}
		}
		Me.wasInBackground = false
		if !Globals.testing && !Globals.uiTesting { openPendingActivityNote() }
	}

	private func openPendingActivityNote() {
		guard let tabs = window?.rootViewController as? UITabBarController,
			let navigation = tabs.viewControllers?.first as? UINavigationController,
			let identifier = ActivityNoteRouting.takePending() else { return }
		// The intent may have stopped the activity in a separate process.
		injected(Database.self).refreshContext()
		let context = injected(Database.self).fetchedResultsController(type: Activity.self,
			sortDescriptors: [NSSortDescriptor(key: "startDate", ascending: false)]).managedObjectContext
		guard let url = URL(string: identifier), url.scheme == "x-coredata", url.host?.isEmpty == false,
			url.path.split(separator: "/").count == 2, url.path.split(separator: "/").first == Substring(Activity.entityName),
			url.user == nil, url.password == nil, url.port == nil, url.query == nil, url.fragment == nil,
			let objectID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url),
			objectID.entity.name == Activity.entityName, !objectID.isTemporaryID,
			objectID.uriRepresentation().absoluteString == identifier,
			let activity = try? context.existingObject(with: objectID) as? Activity,
			!activity.isDeleted else { return }
		let storyboard = UIStoryboard(name: "RecordData", bundle: nil)
		guard let editor = storyboard.instantiateViewController(withIdentifier: "editActivity") as? EditActivityTableViewController else { return }
		tabs.selectedIndex = 0
		editor.activity = activity
		editor.autoFocusNote = true
		navigation.pushViewController(editor, animated: false)
	}

	final func applicationWillTerminate(_: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

	static func registerDependencies() {
		DependencyInjector.register([
			AttributeRestrictionsInjectionProvider(),
			BooleanAlgebraInjectionProvider(),
			CommonInjectionProvider(),
			DataExportInjectionProvider(),
			DataImportInjectionProvider(),
			IntrospectiveInjectionProvider(),
			PersistenceInjectionProvider(ObjectModelContainer.objectModel),
			QueriesInjectionProvider(),
			SamplesInjectionProvider(),
			SampleFetchersInjectionProvider(),
			SampleGroupersInjectionProvider(),
			SampleGroupInformationInjectionProvider(),
			SettingsInjectionProvider(),
		])
	}
}
