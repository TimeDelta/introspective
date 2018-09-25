//
//  CustomSample+CoreDataProperties.swift
//  Introspective
//
//  Created by Bryan Nova on 9/25/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import Foundation
import CoreData


extension CustomSample {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<CustomSample> {
		return NSFetchRequest<CustomSample>(entityName: "CustomSample")
	}

	@NSManaged public final var definition: CoreDataSampleDefinition
	@NSManaged public final var values: NSObject
}
