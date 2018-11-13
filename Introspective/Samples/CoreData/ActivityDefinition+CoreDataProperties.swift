//
//  ActivityDefinition+CoreDataProperties.swift
//  Introspective
//
//  Created by Bryan Nova on 11/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import Foundation
import CoreData


extension ActivityDefinition {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<ActivityDefinition> {
		return NSFetchRequest<ActivityDefinition>(entityName: "ActivityDefinition")
	}

	@NSManaged public var name: String
	@NSManaged public var activityDescription: String?
	@NSManaged public var tags: NSSet
	@NSManaged public var activities: NSSet
	@NSManaged public var recordScreenIndex: Int16
}

// MARK: Generated accessors for tags
extension ActivityDefinition {

	@objc(addTagsObject:)
	@NSManaged public func addToTags(_ value: Tag)

	@objc(removeTagsObject:)
	@NSManaged public func removeFromTags(_ value: Tag)

	@objc(addTags:)
	@NSManaged public func addToTags(_ values: NSSet)

	@objc(removeTags:)
	@NSManaged public func removeFromTags(_ values: NSSet)
}

// MARK: Generated accessors for activities
extension ActivityDefinition {

	@objc(addActivitiesObject:)
	@NSManaged public func addToActivities(_ value: Activity)

	@objc(removeActivitiesObject:)
	@NSManaged public func removeFromActivities(_ value: Activity)

	@objc(addActivities:)
	@NSManaged public func addToActivities(_ values: NSSet)

	@objc(removeActivities:)
	@NSManaged public func removeFromActivities(_ values: NSSet)
}
