//
//  Tag.swift
//  Introspective
//
//  Created by Bryan Nova on 11/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import CoreData
import Foundation

import Persistence

public class Tag: NSManagedObject, CoreDataObject {
	// MARK: CoreDataObject stuff

	public static let entityName = "Tag"

	// MARK: - Equality

	public final func equalTo(_ other: Tag) -> Bool {
		name.localizedLowercase == other.name.localizedLowercase
	}

	// MARK: - Other

	override public final var description: String {
		"Tag named '\(name)'"
	}
}

// MARK: - CoreData

public extension Tag {
	@nonobjc class func fetchRequest() -> NSFetchRequest<Tag> {
		NSFetchRequest<Tag>(entityName: "Tag")
	}

	@NSManaged var name: String
	@NSManaged var activityDefinitions: NSSet
}

// MARK: Generated accessors for activityDefinitions

public extension Tag {
	@objc(addActivityDefinitionsObject:)
	@NSManaged func addToActivityDefinitions(_ value: ActivityDefinition)

	@objc(removeActivityDefinitionsObject:)
	@NSManaged func removeFromActivityDefinitions(_ value: ActivityDefinition)

	@objc(addActivityDefinitions:)
	@NSManaged func addToActivityDefinitions(_ values: NSSet)

	@objc(removeActivityDefinitions:)
	@NSManaged func removeFromActivityDefinitions(_ values: NSSet)
}
