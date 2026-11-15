//
//  ActivityIntentHandler.swift
//  Introspective
//
//  Created by Bryan Nova on 7/2/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation
import Intents

import Common
import DependencyInjection
import Persistence
import Samples

public class ActivityIntentHandler<IntentType: INIntent>: IntentHandler {
	private typealias Me = ActivityIntentHandler

	private let log = Log()

	/// Keep the extension alive for scheduling after a successful write. Reminder
	/// delivery errors do not change the result of an already-saved activity action.
	final func completeRecording<Response>(_ response: Response, completion: @escaping (Response) -> Void) {
		ActivityReminderService.refresh { _ in completion(response) }
	}

	public func provideActivityNameOptions(for _: IntentType, with completion: @escaping ([String]?, Error?) -> Void) {
		log.info("Providing valid activity names")
		do {
			let definitions = try getDefinitions()
			completion(definitions.map { definition in definition.name }, nil)
		} catch {
			completion(nil, error)
		}
	}

	@available(iOS 14.0, *)
	public func provideActivityNameOptionsCollection(
		for _: IntentType,
		with completion: @escaping (INObjectCollection<NSString>?, Error?) -> Swift.Void
	) {
		log.info("Providing valid activity names")
		do {
			let definitions = try getDefinitions()
			let definitionNames = definitions.map { definition in definition.name as NSString }
			completion(INObjectCollection<NSString>(items: definitionNames), nil)
		} catch {
			completion(nil, error)
		}
	}

	private func getDefinitions() throws -> [ActivityDefinition] {
		let fetchRequest: NSFetchRequest<ActivityDefinition> = ActivityDefinition.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "recordScreenIndex", ascending: true)]
		return try injected(Database.self).query(fetchRequest)
	}
}
