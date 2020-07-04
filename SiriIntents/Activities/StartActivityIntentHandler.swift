//
//  StartActivityIntentHandler.swift
//  Introspective
//
//  Created by Bryan Nova on 6/28/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation
import Intents

import Common
import DependencyInjection
import Persistence
import Samples

public final class StartActivityIntentHandler: ActivityIntentHandler<StartActivityIntent>, StartActivityIntentHandling {
	private typealias Me = StartActivityIntentHandler

	private static let log = Log()

	public func resolveActivityName(
		for intent: StartActivityIntent,
		with completion: @escaping (INStringResolutionResult) -> Void
	) {
		Me.log.info("Resolving activity name")
		guard let activityName = intent.activityName else {
			completion(INStringResolutionResult.needsValue())
			return
		}
		completion(INStringResolutionResult.success(with: activityName))
	}

	override public func provideActivityNameOptions(
		for intent: StartActivityIntent,
		with completion: @escaping ([String]?, Error?) -> Void
	) {
		super.provideActivityNameOptions(for: intent, with: completion)
	}

	public func resolveStartDate(
		for intent: StartActivityIntent,
		with completion: @escaping (INDateComponentsResolutionResult) -> Swift.Void
	) {
		Me.log.info("Resolving start date")
		if let startDate = intent.startDate {
			completion(INDateComponentsResolutionResult.success(with: startDate))
		} else {
			completion(INDateComponentsResolutionResult.notRequired())
		}
	}

	public func resolveNote(
		for intent: StartActivityIntent,
		with completion: @escaping (INStringResolutionResult) -> Void
	) {
		Me.log.info("Resolving note")
		// note is optional
		guard let note = intent.note else {
			completion(INStringResolutionResult.notRequired())
			return
		}
		completion(INStringResolutionResult.success(with: note))
	}

	public func resolveExtraTags(
		for intent: StartActivityIntent,
		with completion: @escaping ([INStringResolutionResult]) -> Swift.Void
	) {
		Me.log.info("Resolving extra tags")
		if let extraTags = intent.extraTags {
			completion(extraTags.map { t in INStringResolutionResult.success(with: t) })
		} else {
			completion([INStringResolutionResult.notRequired()])
		}
	}

	public func handle(intent: StartActivityIntent, completion: @escaping (StartActivityIntentResponse) -> Void) {
		guard let activityName = intent.activityName else {
			Me.log.error("Activity name not provided for StartActivityIntentHandler")
			completion(StartActivityIntentResponse.failure(error: "Must provide activity name"))
			return
		}

		do {
			guard let definition = try DependencyInjector.get(ActivityDAO.self).getDefinitionWith(name: activityName)
			else {
				Me.log.error("Activity named %{private}@ does not exist.", activityName)
				completion(
					StartActivityIntentResponse
						.failure(error: "Activity named \"\(activityName)\" does not exist")
				)
				return
			}
			let startDate = intent.startDate?.date ?? Date()
			let activity = try DependencyInjector.get(ActivityDAO.self).createActivity(
				definition: definition,
				startDate: startDate,
				note: intent.note,
				extraTags: try parseTags(intent.extraTags ?? [])
			)
			completion(StartActivityIntentResponse.success(activity: ActivityIntentInfo(activity)))
		} catch {
			Me.log.error("Failed StartActivityIntent: %@", errorInfo(error))
			guard let error = error as? DisplayableError else {
				completion(StartActivityIntentResponse.failure(error: ""))
				return
			}
			completion(StartActivityIntentResponse.failure(error: errorDescription(error)))
		}
	}

	private func parseTags(_ tagNames: [String]) throws -> [Tag] {
		try tagNames.map { name in try DependencyInjector.get(TagDAO.self).getOrCreateTag(named: name) }
	}
}
