//
//  StartActivityXAgoIntentHandler.swift
//  Introspective
//
//  Created by Bryan Nova on 6/30/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation
import Intents

import Common
import DependencyInjection
import Persistence
import Samples

public final class StartActivityXAgoIntentHandler: ActivityIntentHandler<StartActivityXAgoIntent>,
	StartActivityXAgoIntentHandling {
	private typealias Me = StartActivityXAgoIntentHandler

	private static let supportedTimeUnits: [Calendar.Component] = [
		.year,
		.month,
		.weekOfYear,
		.day,
		.hour,
		.minute,
		.second,
	]
	private static let log = Log()

	public func resolveActivityName(
		for intent: StartActivityXAgoIntent,
		with completion: @escaping (INStringResolutionResult) -> Void
	) {
		Me.log.info("Resolving activity name")
		guard let activityName = intent.activityName else {
			completion(INStringResolutionResult.needsValue())
			return
		}
		completion(INStringResolutionResult.success(with: activityName))
	}

	public func resolveNumTimeUnits(
		for intent: StartActivityXAgoIntent,
		with completion: @escaping (StartActivityXAgoNumTimeUnitsResolutionResult) -> Void
	) {
		Me.log.info("Resolving number of time units")
		guard let num = intent.numTimeUnits as? Int else {
			completion(StartActivityXAgoNumTimeUnitsResolutionResult.needsValue())
			return
		}
		completion(StartActivityXAgoNumTimeUnitsResolutionResult.success(with: num))
	}

	public func resolveTimeUnit(
		for intent: StartActivityXAgoIntent,
		with completion: @escaping (INStringResolutionResult) -> Void
	) {
		Me.log.info("Resolving time unit")
		guard let timeUnitString = intent.timeUnit else {
			completion(INStringResolutionResult.needsValue())
			return
		}
		guard let _ = try? Calendar.Component.from(string: timeUnitString) else {
			completion(INStringResolutionResult.needsValue())
			return
		}
		completion(INStringResolutionResult.success(with: timeUnitString))
	}

	public override func provideActivityNameOptions(
		for intent: StartActivityXAgoIntent,
		with completion: @escaping ([String]?, Error?) -> Void
	) {
		super.provideActivityNameOptions(for: intent, with: completion)
	}

	public func provideTimeUnitOptions(
		for _: StartActivityXAgoIntent,
		with completion: @escaping ([String]?, Error?) -> Void
	) {
		completion(Me.supportedTimeUnits.map { t in t.pluralDescription }, nil)
	}

	public func handle(
		intent: StartActivityXAgoIntent,
		completion: @escaping (StartActivityXAgoIntentResponse) -> Void
	) {
		Me.log.info("Handling StartActivityXAgoIntent")
		guard let activityName = intent.activityName else {
			completion(StartActivityXAgoIntentResponse.failure(error: "You must provide a valid activity name"))
			return
		}
		guard let numTimeUnits = intent.numTimeUnits else {
			completion(StartActivityXAgoIntentResponse.failure(error: "You must specify the number of time units"))
			return
		}
		guard let timeUnit = intent.timeUnit else {
			completion(StartActivityXAgoIntentResponse.failure(error: "You must specify the time unit"))
			return
		}

		do {
			guard let definition = try injected(ActivityDAO.self).getDefinitionWith(name: activityName)
			else {
				Me.log.error("Activity named %{private}@ does not exist.", activityName)
				completion(
					StartActivityXAgoIntentResponse
						.failure(error: "Activity named \"\(activityName)\" does not exist.")
				)
				return
			}
			let start = try injected(ActivityDAO.self).getMostRecentActivityEndDate() ?? Date()
			let activity = try injected(ActivityDAO.self)
				.createActivity(definition: definition, startDate: start)
			injected(Database.self).setModifiedExternally(true)
			completion(StartActivityXAgoIntentResponse.success(
				activity: ActivityIntentInfo(activity),
				numTimeUnits: numTimeUnits,
				timeUnit: timeUnit
			))
		} catch {
			Me.log.error("Failed StartActivityXAgoIntentResponse: %@", errorInfo(error))
			guard let error = error as? DisplayableError else {
				completion(StartActivityXAgoIntentResponse(code: .failure, userActivity: nil))
				return
			}
			completion(StartActivityXAgoIntentResponse.failure(error: errorDescription(error)))
		}
	}
}
