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

	public static func createActivityDefinition(name: String = "", description: String? = nil, tags: [Tag] = []) -> ActivityDefinition {
		let definition = try! DependencyInjector.db.new(ActivityDefinition.self)
		definition.name = name
		definition.activityDescription = description
		for tag in tags {
			definition.addToTags(try! DependencyInjector.db.pull(savedObject: tag, fromSameContextAs: definition))
		}
		definition.recordScreenIndex = 0
		try! DependencyInjector.db.save()
		return definition
	}

	public static func createActivity(
		definition: ActivityDefinition = createActivityDefinition(),
		startDate: Date = Date(),
		endDate: Date? = nil,
		note: String? = nil,
		tags: [Tag] = [])
	-> Activity {
		let activity = try! DependencyInjector.db.new(Activity.self)
		activity.definition = try! DependencyInjector.db.pull(savedObject: definition, fromSameContextAs: activity)
		activity.startDate = startDate
		activity.endDate = endDate
		activity.note = note
		for tag in tags {
			activity.addToTags(try! DependencyInjector.db.pull(savedObject: tag, fromSameContextAs: activity))
		}
		try! DependencyInjector.db.save()
		return activity
	}

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
