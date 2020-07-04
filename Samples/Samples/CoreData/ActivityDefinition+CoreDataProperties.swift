//
//  ActivityDefinition+CoreDataProperties.swift
//  Introspective
//
//  Created by Bryan Nova on 11/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import CoreData
import Foundation

public extension ActivityDefinition {
	@nonobjc class func fetchRequest() -> NSFetchRequest<ActivityDefinition> {
		NSFetchRequest<ActivityDefinition>(entityName: "ActivityDefinition")
	}

	@NSManaged var name: String
	@NSManaged var autoNote: Bool
	@NSManaged var activityDescription: String?
	@NSManaged var tags: NSSet
	@NSManaged var activities: NSSet
	@NSManaged var recordScreenIndex: Int16
	@NSManaged var source: Int16
}

// MARK: Generated accessors for tags

public extension ActivityDefinition {
	@objc(addTagsObject:)
	@NSManaged func addToTags(_ value: Tag)

	@objc(removeTagsObject:)
	@NSManaged func removeFromTags(_ value: Tag)

	@objc(addTags:)
	@NSManaged func addToTags(_ values: NSSet)

	@objc(removeTags:)
	@NSManaged func removeFromTags(_ values: NSSet)
}

// MARK: Generated accessors for activities

public extension ActivityDefinition {
	@objc(addActivitiesObject:)
	@NSManaged func addToActivities(_ value: Activity)

	@objc(removeActivitiesObject:)
	@NSManaged func removeFromActivities(_ value: Activity)

	@objc(addActivities:)
	@NSManaged func addToActivities(_ values: NSSet)

	@objc(removeActivities:)
	@NSManaged func removeFromActivities(_ values: NSSet)
}
