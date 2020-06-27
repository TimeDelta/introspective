//
//  StopActivityIntentHandler.swift
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

public final class StopActivityIntentHandler : NSObject, StopActivityIntentHandling {

	private typealias Me = StopActivityIntentHandler

	private static let log = Log()

	public func resolveActivityNames(for intent: StopActivityIntent, with completion: @escaping ([INStringResolutionResult]) -> Void) {
		Me.log.info("Resolving activity names")
		guard let activityNames = intent.activityNames else {
			completion([INStringResolutionResult.needsValue()])
			return
		}
		completion(activityNames.map{ n in INStringResolutionResult.success(with: n) })
	}

	public func provideActivityNamesOptions(for intent: StopActivityIntent, with completion: @escaping ([String]?, Error?) -> Void) {
		Me.log.info("Providing valid activity names")
		do {
			let definitions = try DependencyInjector.get(Database.self).query(ActivityDefinition.fetchRequest())
			completion(definitions.map{ definition in definition.name }, nil)
		} catch {
			completion(nil, error)
		}
	}

	public func handle(intent: StopActivityIntent, completion: @escaping (StopActivityIntentResponse) -> Void) {
		Me.log.info("Handling StopActivityIntent")
		guard let activityNames = intent.activityNames else {
			Me.log.error("Activity names were not provided for StopActivityIntentHandler")
			return
		}

		do {
			for name in activityNames {
				guard let definition = try DependencyInjector.get(ActivityDAO.self).getDefinitionWith(name: name) else {
					Me.log.error("Activity named %{private}@ does not exist.", name)
					completion(StopActivityIntentResponse(code: .failure, userActivity: nil))
					return
				}
				try DependencyInjector.get(ActivityDAO.self).stopMostRecentlyStartedIncompleteActivity(for: definition)
			}
			completion(StopActivityIntentResponse.success(activityNames: activityNames))
		} catch {
			Me.log.error("Failed StopActivityIntent: %@", errorInfo(error))
		}
	}
}
