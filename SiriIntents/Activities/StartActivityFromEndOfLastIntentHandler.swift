//
//  StartActivityFromEndOfLastIntentHandler.swift
//  SiriIntents
//
//  Created by Bryan Nova on 6/30/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation
import Intents
import SwiftDate

import Common
import DependencyInjection
import Persistence
import Samples

public final class StartActivityFromEndOfLastIntentHandler: ActivityIntentHandler<StartActivityFromEndOfLastIntent>,
	StartActivityFromEndOfLastIntentHandling {
	private typealias Me = StartActivityFromEndOfLastIntentHandler

	private static let log = Log()

	public func resolveActivityName(
		for intent: StartActivityFromEndOfLastIntent,
		with completion: @escaping (INStringResolutionResult) -> Void
	) {
		Me.log.info("Resolving activity name")
		guard let activityName = intent.activityName else {
			completion(INStringResolutionResult.needsValue())
			return
		}
		completion(INStringResolutionResult.success(with: activityName))
	}

	public override func provideActivityNameOptions(
		for intent: StartActivityFromEndOfLastIntent,
		with completion: @escaping ([String]?, Error?) -> Void
	) {
		super.provideActivityNameOptions(for: intent, with: completion)
	}

	@available(iOS 14.0, *)
	public override func provideActivityNameOptionsCollection(
		for intent: StartActivityFromEndOfLastIntent,
		with completion: @escaping (INObjectCollection<NSString>?, Error?) -> Swift.Void
	) {
		super.provideActivityNameOptionsCollection(for: intent, with: completion)
	}

	public func handle(
		intent: StartActivityFromEndOfLastIntent,
		completion: @escaping (StartActivityFromEndOfLastIntentResponse) -> Void
	) {
		guard let activityName = intent.activityName else {
			completion(StartActivityFromEndOfLastIntentResponse(code: .failure, userActivity: nil))
			return
		}

		do {
			guard let definition = try injected(ActivityDAO.self).getDefinitionWith(name: activityName)
			else {
				Me.log.error("Activity named %{private}@ does not exist.", activityName)
				completion(
					StartActivityFromEndOfLastIntentResponse
						.failure(error: "Activity named \"\(activityName)\" does not exist.")
				)
				return
			}
			let now = Date()
			let start = try injected(ActivityDAO.self).getMostRecentActivityEndDate() ?? now
			let activity = try injected(ActivityDAO.self).createActivity(
				definition: definition,
				startDate: start,
				startDateSetAt: now
			)
			injected(Database.self).setModifiedExternally(true)
			completion(StartActivityFromEndOfLastIntentResponse.success(activity: ActivityIntentInfo(activity)))
		} catch {
			Me.log.error("Failed StartActivityFromEndOfLastIntent: %@", errorInfo(error))
			guard let error = error as? DisplayableError else {
				completion(StartActivityFromEndOfLastIntentResponse(code: .failure, userActivity: nil))
				return
			}
			completion(StartActivityFromEndOfLastIntentResponse.failure(error: errorDescription(error)))
		}
	}

	private func getStartDateText(_ start: Date) -> String {
		var dateStyle: DateFormatter.Style = .none
		if start < Date() - 1.days {
			dateStyle = .short
		}
		return injected(CalendarUtil.self).string(
			for: start,
			dateStyle: dateStyle,
			timeStyle: .medium
		)
	}
}
