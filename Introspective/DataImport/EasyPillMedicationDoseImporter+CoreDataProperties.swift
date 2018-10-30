//
//  EasyPillMedicationDoseImporter+CoreDataProperties.swift
//  Introspective
//
//  Created by Bryan Nova on 10/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData

extension EasyPillMedicationDoseImporterImpl {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<EasyPillMedicationDoseImporterImpl> {
		return NSFetchRequest<EasyPillMedicationDoseImporterImpl>(entityName: "EasyPillMedicationDoseImporter")
	}

	@NSManaged public var lastImport: Date?
}
