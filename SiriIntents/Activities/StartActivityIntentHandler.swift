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

public final class StartActivityIntentHandler : NSObject, StartActivityIntentHandling {

	private typealias Me = StartActivityIntentHandler

	private static let log = Log()

	public func resolveActivityNames(for intent: StartActivityIntent, with completion: @escaping ([INStringResolutionResult]) -> Void) {
		Me.log.info("Resolving activity names")
		guard let activityNames = intent.activityNames else {
			completion([INStringResolutionResult.needsValue()])
			return
		}
		completion(activityNames.map{ n in INStringResolutionResult.success(with: n) })
	}

	public func provideActivityNamesOptions(for intent: StartActivityIntent, with completion: @escaping ([String]?, Error?) -> Void) {
		Me.log.info("Providing valid activity names")
		do {
			let definitions = try DependencyInjector.get(Database.self).query(ActivityDefinition.fetchRequest())
			completion(definitions.map{ definition in definition.name }, nil)
		} catch {
			completion(nil, error)
		}
	}

	public func handle(intent: StartActivityIntent, completion: @escaping (StartActivityIntentResponse) -> Void) {
		Me.log.info("Handling StartActivityIntent")
		guard let activityNames = intent.activityNames else {
			Me.log.error("Activity names were not provided for StartActivityIntentHandler")
			return
		}

		do {
			for name in activityNames {
				guard let definition = try DependencyInjector.get(ActivityDAO.self).getDefinitionWith(name: name) else {
					Me.log.error("Activity named %{private}@ does not exist.", name)
					completion(StartActivityIntentResponse(code: .failure, userActivity: nil))
					return
				}
				try DependencyInjector.get(ActivityDAO.self).startActivity(definition)
			}
			completion(StartActivityIntentResponse.success(activityNames: activityNames))
		} catch {
			Me.log.error("Failed StartActivityIntent: %@", errorInfo(error))
		}
	}
}
