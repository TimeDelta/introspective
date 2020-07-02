//
//  IntentHandler.swift
//  SiriIntents
//
//  Created by Bryan Nova on 6/24/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Intents

import Common
import DependencyInjection
import Persistence
import Samples
import Settings

class IntentHandler: INExtension {

	private typealias Me = IntentHandler

	private static let log = Log()
	private static var dependenciesRegistered = false

	override func handler(for intent: INIntent) -> Any {
		if !Me.dependenciesRegistered {
			Me.registerDependencies()
		}
		switch intent {
			case is IsWeekdayIntent:
				return IsWeekdayIntentHandler()
			case is RecordDecimalMoodIntent:
				return RecordDecimalMoodIntentHandler()
			case is RecordIntegerMoodIntent:
				return RecordIntegerMoodIntentHandler()
			case is StartActivityFromEndOfLastIntent:
				return StartActivityFromEndOfLastIntentHandler()
			case is StartActivitiesIntent:
				return StartActivitiesIntentHandler()
			case is StartActivityIntent:
				return StartActivityIntentHandler()
			case is StartActivityXAgoIntent:
				return StartActivityXAgoIntentHandler()
			case is StopActivitiesIntent:
				return StopActivitiesIntentHandler()
			case is StopAllActivitiesIntent:
				return StopAllActivitiesIntentHandler()
			case is StopLastStartedActivityIntent:
				return StopLastStartedActivityIntentHandler()
			case is TakeMedicationIntent:
				return TakeMedicationIntentHandler()
			case is TakeMedicationWithDosageIntent:
				return TakeMedicationWithDosageIntentHandler()
			default:
				Me.log.error("Received unknown intent: %@ (%@)", intent.identifier ?? "no name", intent.intentDescription ?? "no description")
				return self
		}
	}

	static func registerDependencies() {
		DependencyInjector.register(CommonInjectionProvider())
		DependencyInjector.register(PersistenceInjectionProvider(ObjectModelContainer.objectModel))
		DependencyInjector.register(SamplesInjectionProvider())
		DependencyInjector.register(SettingsInjectionProvider())
		Me.dependenciesRegistered = true
	}
}
