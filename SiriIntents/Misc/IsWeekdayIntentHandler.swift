//
//  IsWeekdayIntentHandler.swift
//  Introspective
//
//  Created by Bryan Nova on 6/28/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation
import Intents
import SwiftDate

import Common
import DependencyInjection

public final class IsWeekdayIntentHandler: NSObject, IsWeekdayIntentHandling {

	public func resolveDate(for intent: IsWeekdayIntent, with completion: @escaping (INDateComponentsResolutionResult) -> Void) {
		guard let date = intent.date else {
			completion(INDateComponentsResolutionResult.needsValue())
			return
		}
		completion(INDateComponentsResolutionResult.success(with: date))
	}

	public func handle(intent: IsWeekdayIntent, completion: @escaping (IsWeekdayIntentResponse) -> Void) {
		guard let date = intent.date?.date else {
			completion(IsWeekdayIntentResponse(code: .unspecified, userActivity: nil))
			return
		}
		completion(IsWeekdayIntentResponse.success(result: !date.isInWeekend as NSNumber))
	}
}
