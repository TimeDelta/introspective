//
//  StartActivityWithNoteIntentHandler.swift
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

public final class StartActivityWithNoteIntentHandler: NSObject, StartActivityWithNoteIntentHandling {

	private typealias Me = StartActivityWithNoteIntentHandler

	private static let log = Log()

	public func resolveActivityName(for intent: StartActivityWithNoteIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
		Me.log.info("Resolving activity name")
		guard let activityName = intent.activityName else {
			completion(INStringResolutionResult.needsValue())
			return
		}
		completion(INStringResolutionResult.success(with: activityName))
	}

	public func provideActivityNameOptions(for intent: StartActivityWithNoteIntent, with completion: @escaping ([String]?, Error?) -> Void) {
		Me.log.info("Providing valid activity names")
		do {
			let definitions = try DependencyInjector.get(Database.self).query(ActivityDefinition.fetchRequest())
			completion(definitions.map{ definition in definition.name }, nil)
		} catch {
			completion(nil, error)
		}
	}

	public func resolveNote(for intent: StartActivityWithNoteIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
		// allow note to be empty or not provided
		completion(INStringResolutionResult.success(with: intent.note ?? ""))
	}

	public func handle(intent: StartActivityWithNoteIntent, completion: @escaping (StartActivityWithNoteIntentResponse) -> Void) {
		guard let activityName = intent.activityName else {
			completion(StartActivityWithNoteIntentResponse(code: .failure, userActivity: nil))
			return
		}

		do {
			guard let definition = try DependencyInjector.get(ActivityDAO.self).getDefinitionWith(name: activityName) else {
				Me.log.error("Activity named %{private}@ does not exist.", activityName)
				completion(StartActivityWithNoteIntentResponse(code: .failure, userActivity: nil))
				return
			}
			try DependencyInjector.get(ActivityDAO.self).startActivity(definition, withNote: intent.note ?? "")
			completion(StartActivityWithNoteIntentResponse(code: .success, userActivity: nil))
		} catch {
			Me.log.error("Failed StartActivityWithNoteIntent: %@", errorInfo(error))
		}
	}
}
