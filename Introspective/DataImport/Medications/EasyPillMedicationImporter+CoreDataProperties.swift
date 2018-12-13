//
//  EasyPillMedicationImporter+CoreDataProperties.swift
//  Introspective
//
//  Created by Bryan Nova on 10/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import Foundation
import CoreData

extension EasyPillMedicationImporterImpl {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<EasyPillMedicationImporterImpl> {
		return NSFetchRequest<EasyPillMedicationImporterImpl>(entityName: "EasyPillMedicationImporter")
	}

	@NSManaged public var lastImport: Date?
}
