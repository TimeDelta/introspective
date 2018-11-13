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
}
