//
//  EasyPillMedicationDoseImporter+CoreDataProperties.swift
//  Introspective
//
//  Created by Bryan Nova on 10/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData

public extension EasyPillMedicationDoseImporterImpl {

	@nonobjc class func fetchRequest() -> NSFetchRequest<EasyPillMedicationDoseImporterImpl> {
		return NSFetchRequest<EasyPillMedicationDoseImporterImpl>(entityName: "EasyPillMedicationDoseImporter")
	}

	@NSManaged var lastImport: Date?
}
