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

public final class StartActivityFromEndOfLastIntentHandler: NSObject, StartActivityFromEndOfLastIntentHandling {

	private typealias Me = StartActivityFromEndOfLastIntentHandler

	private static let log = Log()

	public func resolveActivityName(for intent: StartActivityFromEndOfLastIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
		Me.log.info("Resolving activity name")
		guard let activityName = intent.activityName else {
			completion(INStringResolutionResult.needsValue())
			return
		}
		completion(INStringResolutionResult.success(with: activityName))
	}

	public func provideActivityNameOptions(for intent: StartActivityFromEndOfLastIntent, with completion: @escaping ([String]?, Error?) -> Void) {
		Me.log.info("Providing valid activity names")
		do {
			let definitions = try DependencyInjector.get(Database.self).query(ActivityDefinition.fetchRequest())
			completion(definitions.map{ definition in definition.name }, nil)
		} catch {
			completion(nil, error)
		}
	}

	public func handle(intent: StartActivityFromEndOfLastIntent, completion: @escaping (StartActivityFromEndOfLastIntentResponse) -> Void) {
		guard let activityName = intent.activityName else {
			completion(StartActivityFromEndOfLastIntentResponse(code: .failure, userActivity: nil))
			return
		}

		do {
			guard let definition = try DependencyInjector.get(ActivityDAO.self).getDefinitionWith(name: activityName) else {
				Me.log.error("Activity named %{private}@ does not exist.", activityName)
				completion(StartActivityFromEndOfLastIntentResponse(code: .failure, userActivity: nil))
				return
			}
			let start = try DependencyInjector.get(ActivityDAO.self).getMostRecentActivityEndDate() ?? Date()
			try DependencyInjector.get(ActivityDAO.self).createActivity(definition: definition, startDate: start)
			completion(StartActivityFromEndOfLastIntentResponse.success(
				activityName: activityName,
				start: getStartDateText(start)
			))
		} catch {
			Me.log.error("Failed StartActivityFromEndOfLastIntent: %@", errorInfo(error))
		}
	}

	private func getStartDateText(_ start: Date) -> String {
		var dateStyle: DateFormatter.Style = .none
		if start < Date() - 1.days {
			dateStyle = .short
		}
		return DependencyInjector.get(CalendarUtil.self).string(
			for: start,
			dateStyle: dateStyle,
			timeStyle: .medium)
	}
}
