//
//  Mood+CoreDataProperties.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import Foundation
import CoreData


extension MoodImpl {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<MoodImpl> {
		return NSFetchRequest<MoodImpl>(entityName: "Mood")
	}

	@NSManaged public var rating: Double
	@NSManaged public var note: String?
	@NSManaged public var timestamp: Date
}
