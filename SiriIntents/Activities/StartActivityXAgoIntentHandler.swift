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

public final class StartActivityXAgoIntentHandler: NSObject, StartActivityXAgoIntentHandling {

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

	public func resolveActivityName(for intent: StartActivityXAgoIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
		Me.log.info("Resolving activity name")
		guard let activityName = intent.activityName else {
			completion(INStringResolutionResult.needsValue())
			return
		}
		completion(INStringResolutionResult.success(with: activityName))
	}

	public func resolveNumTimeUnits(for intent: StartActivityXAgoIntent, with completion: @escaping (StartActivityXAgoNumTimeUnitsResolutionResult) -> Void) {
		Me.log.info("Resolving number of time units")
		guard let num = intent.numTimeUnits as? Int else {
			completion(StartActivityXAgoNumTimeUnitsResolutionResult.needsValue())
			return
		}
		completion(StartActivityXAgoNumTimeUnitsResolutionResult.success(with: num))
	}

	public func resolveTimeUnit(for intent: StartActivityXAgoIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
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

	public func provideActivityNameOptions(for intent: StartActivityXAgoIntent, with completion: @escaping ([String]?, Error?) -> Void) {
		Me.log.info("Providing valid activity names")
		do {
			let definitions = try DependencyInjector.get(Database.self).query(ActivityDefinition.fetchRequest())
			completion(definitions.map{ definition in definition.name }, nil)
		} catch {
			completion(nil, error)
		}
	}

	public func provideTimeUnitOptions(for intent: StartActivityXAgoIntent, with completion: @escaping ([String]?, Error?) -> Void) {
		completion(Me.supportedTimeUnits.map{ t in t.pluralDescription }, nil)
	}

	public func handle(intent: StartActivityXAgoIntent, completion: @escaping (StartActivityXAgoIntentResponse) -> Void) {
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
			guard let definition = try DependencyInjector.get(ActivityDAO.self).getDefinitionWith(name: activityName) else {
				Me.log.error("Activity named %{private}@ does not exist.", activityName)
				completion(StartActivityXAgoIntentResponse(code: .failure, userActivity: nil))
				return
			}
			let start = try DependencyInjector.get(ActivityDAO.self).getMostRecentActivityEndDate() ?? Date()
			try DependencyInjector.get(ActivityDAO.self).createActivity(definition: definition, startDate: start)
			completion(StartActivityXAgoIntentResponse.success(
				activityName: activityName,
				numTimeUnits: numTimeUnits,
				timeUnit: timeUnit))
		} catch {
			Me.log.error("Failed StartActivityFromEndOfLastIntent: %@", errorInfo(error))
		}
	}
}
