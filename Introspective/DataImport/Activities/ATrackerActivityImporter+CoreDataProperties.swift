//
//  ATrackerActivityImporter+CoreDataProperties.swift
//  Introspective
//
//  Created by Bryan Nova on 12/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData

extension ATrackerActivityImporterImpl {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<ATrackerActivityImporterImpl> {
		return NSFetchRequest<ATrackerActivityImporterImpl>(entityName: "ATrackerActivityImporter")
	}

	@NSManaged public var lastImport: Date?
}
