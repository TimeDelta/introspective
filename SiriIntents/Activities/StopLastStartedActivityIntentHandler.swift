//
//  StopLastStartedActivityIntentHandler.swift
//  SiriIntents
//
//  Created by Bryan Nova on 6/26/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation
import Intents

import Common
import DependencyInjection
import Persistence
import Samples

public final class StopLastStartedActivityIntentHandler: ActivityIntentHandler<StopLastStartedActivityIntent>, StopLastStartedActivityIntentHandling {

	private typealias Me = StopLastStartedActivityIntentHandler

	private static let log = Log()

	public func handle(intent: StopLastStartedActivityIntent, completion: @escaping (StopLastStartedActivityIntentResponse) -> Void) {
		Me.log.info("Handling StopLastStartedActivityIntent")
		do {
			let activity = try DependencyInjector.get(ActivityDAO.self).stopMostRecentlyStartedIncompleteActivity()
			let definition = try DependencyInjector.get(Database.self).pull(savedObject: activity.definition)
			Me.log.debug("Found last started activity: %{private}@", definition.name)
			completion(StopLastStartedActivityIntentResponse.success(activityName: definition.name))
		} catch {
			Me.log.error("Error during StopLastStartedActivityIntent: %@", errorInfo(error))
			guard let error = error as? DisplayableError else {
				completion(StopLastStartedActivityIntentResponse(code: .failure, userActivity: nil))
				return
			}
			completion(StopLastStartedActivityIntentResponse.failure(error: errorDescription(error)))
		}
	}

	private final func errorDescription(_ error: DisplayableError) -> String {
		var result = error.displayableTitle
		if let description = error.displayableDescription {
			result += ": " + description
		}
		return result
	}
}
