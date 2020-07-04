//
//  StopActivitiesIntentHandler.swift
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

public final class StopActivitiesIntentHandler: ActivityIntentHandler<StopActivitiesIntent>,
	StopActivitiesIntentHandling {
	private typealias Me = StopActivitiesIntentHandler

	private static let log = Log()

	public func resolveActivityNames(
		for intent: StopActivitiesIntent,
		with completion: @escaping ([INStringResolutionResult]) -> Void
	) {
		Me.log.info("Resolving activity names")
		guard let activityNames = intent.activityNames else {
			completion([INStringResolutionResult.needsValue()])
			return
		}
		completion(activityNames.map { n in INStringResolutionResult.success(with: n) })
	}

	public func provideActivityNamesOptions(
		for intent: StopActivitiesIntent,
		with completion: @escaping ([String]?, Error?) -> Void
	) {
		super.provideActivityNameOptions(for: intent, with: completion)
	}

	public func handle(intent: StopActivitiesIntent, completion: @escaping (StopActivitiesIntentResponse) -> Void) {
		Me.log.info("Handling StopActivitiesIntent")
		guard let activityNames = intent.activityNames else {
			Me.log.error("Activity names were not provided for StopActivitiesIntentHandler")
			return
		}

		do {
			var stoppedActivities = [Activity]()
			for name in activityNames {
				guard let definition = try DependencyInjector.get(ActivityDAO.self).getDefinitionWith(name: name) else {
					Me.log.error("Activity named %{private}@ does not exist.", name)
					completion(
						StopActivitiesIntentResponse
							.failure(error: "Activity named \"\(name)\" does not exist.")
					)
					return
				}
				let activity = try DependencyInjector.get(ActivityDAO.self)
					.stopMostRecentlyStartedIncompleteActivity(for: definition)
				stoppedActivities.append(activity)
			}
			let activitiesInfo = stoppedActivities.map { a in ActivityIntentInfo(a) }
			completion(StopActivitiesIntentResponse.success(activities: activitiesInfo))
		} catch {
			Me.log.error("Failed StopActivitiesIntent: %@", errorInfo(error))
			guard let error = error as? DisplayableError else {
				completion(StopActivitiesIntentResponse(code: .failure, userActivity: nil))
				return
			}
			completion(StopActivitiesIntentResponse.failure(error: errorDescription(error)))
		}
	}
}
