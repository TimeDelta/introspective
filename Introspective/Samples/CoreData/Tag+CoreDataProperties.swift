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


extension Tag {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
		return NSFetchRequest<Tag>(entityName: "Tag")
	}

	@NSManaged public var name: String
	@NSManaged public var activityDefinitions: NSSet
}

// MARK: Generated accessors for activityDefinitions
extension Tag {

	@objc(addActivityDefinitionsObject:)
	@NSManaged public func addToActivityDefinitions(_ value: ActivityDefinition)

	@objc(removeActivityDefinitionsObject:)
	@NSManaged public func removeFromActivityDefinitions(_ value: ActivityDefinition)

	@objc(addActivityDefinitions:)
	@NSManaged public func addToActivityDefinitions(_ values: NSSet)

	@objc(removeActivityDefinitions:)
	@NSManaged public func removeFromActivityDefinitions(_ values: NSSet)
}
