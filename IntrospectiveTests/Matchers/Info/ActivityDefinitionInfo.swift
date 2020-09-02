//
//  ActivityDefinitionInfo.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 9/2/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

@testable import Samples

public final class ActivityDefinitionInfo: Info {
	var name: String
	var description: String?
	var tags: [String]
	var source: Sources.ActivitySourceNum
	var autoNote: Bool
	var recordScreenIndex: Int16

	public init(
		name: String,
		description: String?,
		tags: [String],
		source: Sources.ActivitySourceNum,
		autoNote: Bool,
		recordScreenIndex: Int16
	) {
		self.name = name
		self.description = description
		self.tags = tags
		self.source = source
		self.autoNote = autoNote
		self.recordScreenIndex = recordScreenIndex
	}

	public func getPredicates() -> [String : NSPredicate] {
		let descriptionKey = "activityDescription"
		return [
			"name": NSPredicate(format: "name ==[cd] %@", name),
			descriptionKey: self.optionalStringPredicate(for: description, fieldName: descriptionKey),
			"autoNote": NSPredicate(format: "autoNote = %d", autoNote),
			"tags": self.tagsPredicate(for: tags, fieldName: "tags"),
			"recordScreenIndex": NSPredicate(format: "recordScreenIndex == %i", recordScreenIndex),
			"source": NSPredicate(format: "source == %i", source.rawValue),
		]
	}

	public final func copy() -> ActivityDefinitionInfo {
		return ActivityDefinitionInfo(
			name: name,
			description: description,
			tags: tags,
			source: source,
			autoNote: autoNote,
			recordScreenIndex: recordScreenIndex)
	}
}
