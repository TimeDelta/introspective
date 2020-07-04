//
//  EasyPillMedicationImporter+CoreDataProperties.swift
//  Introspective
//
//  Created by Bryan Nova on 10/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import CoreData
import Foundation

public extension EasyPillMedicationImporterImpl {
	@nonobjc class func fetchRequest() -> NSFetchRequest<EasyPillMedicationImporterImpl> {
		NSFetchRequest<EasyPillMedicationImporterImpl>(entityName: "EasyPillMedicationImporter")
	}

	@NSManaged var lastImport: Date?
}
