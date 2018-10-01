//
//  WellnessMoodImporterImpl+CoreDataProperties.swift
//  Introspective
//
//  Created by Bryan Nova on 10/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import Foundation
import CoreData


extension WellnessMoodImporterImpl {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<WellnessMoodImporterImpl> {
		return NSFetchRequest<WellnessMoodImporterImpl>(entityName: "WellnessMoodImporter")
	}

	@NSManaged public var lastImport: Date?
}
