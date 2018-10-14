//
//  MedicationDose+CoreDataProperties.swift
//  Introspective
//
//  Created by Bryan Nova on 10/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import Foundation
import CoreData


extension MedicationDose {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<MedicationDose> {
		return NSFetchRequest<MedicationDose>(entityName: "MedicationDose")
	}

	@NSManaged public var timestamp: Date
	@NSManaged public var dosage: Dosage?
	@NSManaged public var medication: Medication
}
