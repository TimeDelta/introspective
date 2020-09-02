//
//  ActivityInfo.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 9/2/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

@testable import Samples

public final class ActivityInfo: Info {
	var definition: ActivityDefinitionInfo
	var startDate: Date
	var startTimeZone: TimeZone?
	var endDate: Date?
	var endTimeZone: TimeZone?
	var note: String?
	var tags: [String]?
	var source: Sources.ActivitySourceNum

	public init(
		definition: ActivityDefinitionInfo,
		startDate: Date,
		startTimeZone: TimeZone? = nil,
		endDate: Date? = nil,
		endTimeZone: TimeZone? = nil,
		note: String? = nil,
		tags: [String]? = nil,
		source: Sources.ActivitySourceNum = .introspective
	) {
		self.definition = definition
		self.startDate = startDate
		self.startTimeZone = startTimeZone
		self.endDate = endDate
		self.endTimeZone = endTimeZone
		self.note = note
		self.tags = tags
		self.source = source
	}

	public func getPredicates() -> [String : NSPredicate] {
		let descriptionKey = "definition.activityDescription"
		return [
			"definition.name": NSPredicate(format: "definition.name ==[cd] %@", definition.name),
			descriptionKey: self.optionalStringPredicate(for: definition.description, fieldName: descriptionKey),
			"definition.tags": self.tagsPredicate(for: definition.tags, fieldName: "definition.tags"),
			"definition.source": NSPredicate(format: "definition.source == %i", definition.source.rawValue),
			"definition.autoNote": NSPredicate(format: "definition.autoNote = %d", definition.autoNote),
			"definition.recordScreenIndex": NSPredicate(format: "definition.recordScreenIndex == %i", definition.recordScreenIndex),
			"startDate": self.datePredicateFor(fieldName: "startDate", withinOneSecondOf: startDate),
			"startDateTimeZoneId": self.timeZonePredicate(for: startTimeZone, field: "startDateTimeZoneId"),
			"endDate": self.datePredicateFor(fieldName: "endDate", withinOneSecondOf: endDate),
			"endDateTimeZoneId": self.timeZonePredicate(for: endTimeZone, field: "endDateTimeZoneId"),
			"note": self.optionalStringPredicate(for: note, fieldName: "note"),
			"tags": self.tagsPredicate(for: tags, fieldName: "tags"),
			"source": NSPredicate(format: "source == %i", source.rawValue),
		]
	}

	public final func copy() -> ActivityInfo {
		return ActivityInfo(
			definition: definition.copy(),
			startDate: startDate,
			startTimeZone: startTimeZone,
			endDate: endDate,
			endTimeZone: endTimeZone,
			note: note,
			tags: tags,
			source: source)
	}
}
