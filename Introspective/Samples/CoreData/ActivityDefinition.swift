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

public class ActivityDefinition: Importable, CoreDataObject {

	private typealias Me = ActivityDefinition

	// MARK: - CoreData Stuff

	public static let entityName = "ActivityDefinition"

	// MARK: - Other

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
			if !tagToAdd.isFault {
				addToTags(tagToAdd)
			} else if !tag.isFault {
				addToTags(tag)
			}
		}
		try DependencyInjector.db.save()
	}

	// MARK: - Equatable

	public static func ==(lhs: ActivityDefinition, rhs: ActivityDefinition) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is ActivityDefinition) { return false }
		let other = otherAttributed as! ActivityDefinition
		return equalTo(other)
	}

	public final func equalTo(_ otherSample: Sample) -> Bool {
		if !(otherSample is ActivityDefinition) { return false }
		let other = otherSample as! ActivityDefinition
		return equalTo(other)
	}

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
