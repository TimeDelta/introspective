//
//  EasyPillMedicationDoseImporter+CoreDataProperties.swift
//  Introspective
//
//  Created by Bryan Nova on 10/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

public extension EasyPillMedicationDoseImporterImpl {
	@nonobjc class func fetchRequest() -> NSFetchRequest<EasyPillMedicationDoseImporterImpl> {
		NSFetchRequest<EasyPillMedicationDoseImporterImpl>(entityName: "EasyPillMedicationDoseImporter")
	}

	@NSManaged var lastImport: Date?
}
