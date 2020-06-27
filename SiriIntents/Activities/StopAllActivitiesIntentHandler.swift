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

public final class StopAllActivitiesIntentHandler : NSObject, StopAllActivitiesIntentHandling {

	private typealias Me = StopAllActivitiesIntentHandler

	private static let log = Log()

	public func handle(intent: StopAllActivitiesIntent, completion: @escaping (StopAllActivitiesIntentResponse) -> Void) {
		do {
			try DependencyInjector.get(ActivityDAO.self).stopAllActivities()
			completion(StopAllActivitiesIntentResponse(code: .success, userActivity: nil))
		} catch {
			Me.log.error("Failed to retrieve ActivityDefinition for StopAllActivitiesIntent: %@", errorInfo(error))
		}
	}
}

