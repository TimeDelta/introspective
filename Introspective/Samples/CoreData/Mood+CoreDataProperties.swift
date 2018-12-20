//
//  Mood+CoreDataProperties.swift
//  Introspective
//
//  Created by Bryan Nova on 8/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import Foundation
import CoreData


extension MoodImpl {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<MoodImpl> {
		return NSFetchRequest<MoodImpl>(entityName: "Mood")
	}

	@NSManaged public var note: String?
	@NSManaged public var rating: Double
	@NSManaged public var timestamp: Date
	@NSManaged public var maxRating: Double
	@NSManaged public var source: Int16
}
