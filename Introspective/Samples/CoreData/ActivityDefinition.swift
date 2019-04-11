//
//  ActivityDefinition.swift
//  Introspective
//
//  Created by Bryan Nova on 11/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import Foundation
import CoreData

public class ActivityDefinition: NSManagedObject, CoreDataObject {

	private typealias Me = ActivityDefinition

	// MARK: - CoreData Stuff

	public static let entityName = "ActivityDefinition"

	// MARK: - Other

	public final func getSource() -> Sources.ActivitySourceNum {
		return Sources.resolveActivitySource(source)
	}

	public final func setSource(_ source: Sources.ActivitySourceNum) {
		self.source = source.rawValue
	}

	public final func tagsArray() -> [Tag] {
		return tags.allObjects as! [Tag]
	}

	public final func setTags(_ newTags: [Tag]) throws {
		removeAllTags()
		for tag in newTags {
			let tagToAdd = try DependencyInjector.db.pull(savedObject: tag, fromSameContextAs: self)
			addToTags(tagToAdd)
		}
	}

	// MARK: - Equatable

	public final func equalTo(_ other: ActivityDefinition) -> Bool {
		return name == other.name &&
			activityDescription == other.activityDescription &&
			tagsArray().elementsEqual(other.tagsArray(), by: { $0.equalTo($1) })
	}

	// MARK: - Debug

	public final override var debugDescription: String {
		let descriptionText = activityDescription ?? "nil"
		var tagsText = ""
		for tag in tagsArray() {
			tagsText += tag.name + ", "
		}
		if !tagsText.isEmpty {
			tagsText.removeLast()
			tagsText.removeLast()
		}
		return "ActivityDefinition named '\(name)' with description '\(descriptionText)' and tags: \(tagsText)"
	}

	// MARK: - Helper Functions

	private final func removeAllTags() {
		for tag in tagsArray() {
			removeFromTags(tag)
		}
	}
}
