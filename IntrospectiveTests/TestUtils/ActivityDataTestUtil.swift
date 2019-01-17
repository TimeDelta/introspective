//
//  ActivityDataTestUtil.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 11/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
@testable import Introspective

public final class ActivityDataTestUtil {

	@discardableResult
	public static func createActivityDefinition(name: String = "", description: String? = nil, tags: [Tag] = []) -> ActivityDefinition {
		let transaction = DependencyInjector.db.transaction()
		let definition = try! transaction.new(ActivityDefinition.self)
		definition.name = name
		definition.activityDescription = description
		for tag in tags {
			definition.addToTags(try! transaction.pull(savedObject: tag))
		}
		definition.recordScreenIndex = 0
		try! transaction.commit()
		return try! DependencyInjector.db.pull(savedObject: definition)
	}

	@discardableResult
	public static func createActivity(
		definition: ActivityDefinition = createActivityDefinition(),
		startDate: Date = Date(),
		endDate: Date? = nil,
		note: String? = nil,
		tags: [Tag] = [])
	-> Activity {
		let transaction = DependencyInjector.db.transaction()
		let activity = try! transaction.new(Activity.self)
		activity.definition = try! transaction.pull(savedObject: definition)
		activity.startDate = startDate
		activity.endDate = endDate
		activity.note = note
		for tag in tags {
			activity.addToTags(try! transaction.pull(savedObject: tag))
		}
		try! transaction.commit()
		return try! DependencyInjector.db.pull(savedObject: activity)
	}

	@discardableResult
	public static func createActivity(
		name: String,
		startDate: Date = Date(),
		endDate: Date? = nil,
		note: String? = nil,
		tags: [Tag] = [])
	-> Activity {
		return createActivity(
			definition: createActivityDefinition(name: name),
			startDate: startDate,
			endDate: endDate,
			note: note,
			tags: tags)
	}
}
