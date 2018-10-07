//
//  AppDelegate.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import CoreData

public var testing = true // TODO - change this to false before each release

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

	final var window: UIWindow?

	final func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		if CommandLine.arguments.contains("--uitesting") {
			resetState()
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

	private final func resetState() {
		let defaultsName = Bundle.main.bundleIdentifier!
		UserDefaults.standard.removePersistentDomain(forName: defaultsName)
	}
}
