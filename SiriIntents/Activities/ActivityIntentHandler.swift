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

	public func provideActivityNameOptions(for _: IntentType, with completion: @escaping ([String]?, Error?) -> Void) {
		log.info("Providing valid activity names")
		do {
			let fetchRequest: NSFetchRequest<ActivityDefinition> = ActivityDefinition.fetchRequest()
			fetchRequest.sortDescriptors = [NSSortDescriptor(key: "recordScreenIndex", ascending: true)]
			let definitions = try injected(Database.self).query(fetchRequest)
			completion(definitions.map { definition in definition.name }, nil)
		} catch {
			completion(nil, error)
		}
	}
}
