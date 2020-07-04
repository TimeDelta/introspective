//
//  ATrackerActivityImporter+CoreDataProperties.swift
//  Introspective
//
//  Created by Bryan Nova on 12/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

public extension ATrackerActivityImporterImpl {
	@nonobjc class func fetchRequest() -> NSFetchRequest<ATrackerActivityImporterImpl> {
		NSFetchRequest<ATrackerActivityImporterImpl>(entityName: "ATrackerActivityImporter")
	}

	@NSManaged var lastImport: Date?
}
