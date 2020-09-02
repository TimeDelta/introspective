//
//  ActivityDataTestUtil.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 11/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
@testable import Introspective
@testable import DependencyInjection
@testable import Persistence
@testable import Samples

public final class ActivityDataTestUtil {

	@discardableResult
	public static func createActivityDefinition(_ info: ActivityDefinitionInfo) -> ActivityDefinition {
		let tags = TagDataTestUtil.createTags(names: info.tags)
		return createActivityDefinition(
			name: info.name,
			description: info.description,
			tags: tags,
			source: info.source,
			recordScreenIndex: info.recordScreenIndex,
			autoNote: info.autoNote
		)
	}

	@discardableResult
	public static func createActivityDefinition(
		name: String = "",
		description: String? = nil,
		tags: [Tag] = [],
		source: Sources.ActivitySourceNum = .introspective,
		recordScreenIndex: Int16 = 0,
		autoNote: Bool = false)
	-> ActivityDefinition {
		let transaction = injected(Database.self).transaction()
		let definition = try! transaction.new(ActivityDefinition.self)
		definition.name = name
		definition.activityDescription = description
		for tag in tags {
			definition.addToTags(try! transaction.pull(savedObject: tag))
		}
		definition.recordScreenIndex = recordScreenIndex
		definition.autoNote = autoNote
		try! transaction.commit()
		return try! injected(Database.self).pull(savedObject: definition)
	}

	@discardableResult
	public static func createActivity(_ info: ActivityInfo) -> Activity {
		let definition = createActivityDefinition(info.definition)
		var tags = [Tag]()
		if let tagNames = info.tags {
			tags = TagDataTestUtil.createTags(names: tagNames)
		}
		return createActivity(
			definition: definition,
			startDate: info.startDate,
			startTimeZone: info.startTimeZone,
			endDate: info.endDate,
			endTimeZone: info.endTimeZone,
			note: info.note,
			source: info.source,
			tags: tags
		)
	}

	@discardableResult
	public static func createActivity(
		definition: ActivityDefinition = createActivityDefinition(),
		startDate: Date = Date(),
		startTimeZone: TimeZone? = nil,
		endDate: Date? = nil,
		endTimeZone: TimeZone? = nil,
		note: String? = nil,
		source: Sources.ActivitySourceNum = .introspective,
		tags: [Tag] = [])
	-> Activity {
		let transaction = injected(Database.self).transaction()
		let activity = try! transaction.new(Activity.self)
		activity.definition = try! transaction.pull(savedObject: definition)
		activity.start = startDate
		activity.setStartTimeZone(startTimeZone)
		activity.end = endDate
		activity.setEndTimeZone(endTimeZone)
		activity.note = note
		for tag in tags {
			activity.addToTags(try! transaction.pull(savedObject: tag))
		}
		activity.setSource(source)
		try! transaction.commit()
		return try! injected(Database.self).pull(savedObject: activity)
	}

	@discardableResult
	public static func createActivity(
		name: String,
		startDate: Date = Date(),
		endDate: Date? = nil,
		note: String? = nil,
		source: Sources.ActivitySourceNum = .introspective,
		tags: [Tag] = [])
	-> Activity {
		return createActivity(
			definition: createActivityDefinition(name: name, source: source),
			startDate: startDate,
			endDate: endDate,
			note: note,
			source: source,
			tags: tags)
	}
}
