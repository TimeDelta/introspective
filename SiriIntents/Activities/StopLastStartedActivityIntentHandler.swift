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

public final class StopLastStartedActivityIntentHandler : NSObject, StopLastStartedActivityIntentHandling {

	private typealias Me = StopLastStartedActivityIntentHandler

	private static let log = Log()

	public func handle(intent: StopLastStartedActivityIntent, completion: @escaping (StopLastStartedActivityIntentResponse) -> Void) {
		do {
			try DependencyInjector.get(ActivityDAO.self).stopMostRecentlyStartedIncompleteActivity()
			completion(StopLastStartedActivityIntentResponse(code: .success, userActivity: nil))
		} catch {
			Me.log.error("Error during StopLastStartedActivityIntent: %@", errorInfo(error))
		}
	}
}
