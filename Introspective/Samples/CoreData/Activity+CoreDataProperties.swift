//
//  Activity+CoreDataProperties.swift
//  Introspective
//
//  Created by Bryan Nova on 11/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import Foundation
import CoreData


extension Activity {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
		return NSFetchRequest<Activity>(entityName: "Activity")
	}

	@NSManaged public var startDate: Date
	@NSManaged public var endDate: Date?
	@NSManaged public var note: String?
	@NSManaged public var definition: ActivityDefinition
	@NSManaged public var tags: NSSet
	@NSManaged public var source: Int16
	@NSManaged public var partOfCurrentImport: Bool
}

// MARK: Generated accessors for tags
extension Activity {

	@objc(addTagsObject:)
	@NSManaged public func addToTags(_ value: Tag)

	@objc(removeTagsObject:)
	@NSManaged public func removeFromTags(_ value: Tag)

	@objc(addTags:)
	@NSManaged public func addToTags(_ values: NSSet)

	@objc(removeTags:)
	@NSManaged public func removeFromTags(_ values: NSSet)
}
