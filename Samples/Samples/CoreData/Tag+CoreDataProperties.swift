//
//  Tag+CoreDataProperties.swift
//  Introspective
//
//  Created by Bryan Nova on 11/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import Foundation
import CoreData

public extension Tag {

	@nonobjc class func fetchRequest() -> NSFetchRequest<Tag> {
		return NSFetchRequest<Tag>(entityName: "Tag")
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
