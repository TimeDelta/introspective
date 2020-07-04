//
//  WellnessMoodImporter+CoreDataProperties.swift
//  Introspective
//
//  Created by Bryan Nova on 10/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import CoreData
import Foundation

public extension WellnessMoodImporterImpl {
	@nonobjc class func fetchRequest() -> NSFetchRequest<WellnessMoodImporterImpl> {
		NSFetchRequest<WellnessMoodImporterImpl>(entityName: "WellnessMoodImporter")
	}

	@NSManaged var lastImport: Date?
}
