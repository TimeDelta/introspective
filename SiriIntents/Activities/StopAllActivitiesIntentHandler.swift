//
//  StopAllActivitiesIntentHandler.swift
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

public final class StopAllActivitiesIntentHandler: ActivityIntentHandler<StopAllActivitiesIntent>,
	StopAllActivitiesIntentHandling {
	private typealias Me = StopAllActivitiesIntentHandler

	private static let log = Log()

	public func handle(
		intent _: StopAllActivitiesIntent,
		completion: @escaping (StopAllActivitiesIntentResponse) -> Void
	) {
		do {
			try injected(ActivityDAO.self).stopAllActivities()
			completion(StopAllActivitiesIntentResponse(code: .success, userActivity: nil))
		} catch {
			Me.log.error("Failed to retrieve ActivityDefinition for StopAllActivitiesIntent: %@", errorInfo(error))
			guard let error = error as? DisplayableError else {
				completion(StopAllActivitiesIntentResponse(code: .failure, userActivity: nil))
				return
			}
			completion(StopAllActivitiesIntentResponse.failure(error: errorDescription(error)))
		}
	}
}
