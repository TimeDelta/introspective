//
//  StartActivitiesIntentHandler.swift
//  SiriIntents
//
//  Created by Bryan Nova on 6/24/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation
import Intents

import Common
import DependencyInjection
import Persistence
import Samples

public final class StartActivitiesIntentHandler: ActivityIntentHandler<StartActivitiesIntent>, StartActivitiesIntentHandling {

	private typealias Me = StartActivitiesIntentHandler

	private static let log = Log()

	public func resolveActivityNames(for intent: StartActivitiesIntent, with completion: @escaping ([INStringResolutionResult]) -> Void) {
		Me.log.info("Resolving activity names")
		guard let activityNames = intent.activityNames else {
			completion([INStringResolutionResult.needsValue()])
			return
		}
		completion(activityNames.map{ n in INStringResolutionResult.success(with: n) })
	}

	public func provideActivityNamesOptions(for intent: StartActivitiesIntent, with completion: @escaping ([String]?, Error?) -> Void) {
		provideActivityNameOptions(for: intent, with: completion)
	}

	public func handle(intent: StartActivitiesIntent, completion: @escaping (StartActivitiesIntentResponse) -> Void) {
		Me.log.info("Handling StartActivitiesIntent")
		guard let activityNames = intent.activityNames else {
			Me.log.error("Activity names were not provided for StartActivitiesIntentHandler")
			return
		}

		do {
			for name in activityNames {
				guard let definition = try DependencyInjector.get(ActivityDAO.self).getDefinitionWith(name: name) else {
					Me.log.error("Activity named %{private}@ does not exist.", name)
					completion(StartActivitiesIntentResponse.failure(activityNames: activityNames))
					return
				}
				try DependencyInjector.get(ActivityDAO.self).startActivity(definition)
			}
			completion(StartActivitiesIntentResponse.success(activityNames: activityNames))
		} catch {
			Me.log.error("Failed StartActivitiesIntent: %@", errorInfo(error))
			completion(StartActivitiesIntentResponse.failure(activityNames: activityNames))
		}
	}
}
