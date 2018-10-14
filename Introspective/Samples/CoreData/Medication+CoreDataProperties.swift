//
//  Medication+CoreDataProperties.swift
//  Introspective
//
//  Created by Bryan Nova on 10/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import Foundation
import CoreData


extension Medication {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<Medication> {
		return NSFetchRequest<Medication>(entityName: "Medication")
	}

	@NSManaged public var name: String
	@NSManaged public var frequency: Frequency?
	@NSManaged public var startedOn: Date?
	@NSManaged public var notes: String?
	@NSManaged public var dosage: Dosage?
	@NSManaged public var recordScreenIndex: Int16
	@NSManaged public var doses: NSOrderedSet
}

// MARK: Generated accessors for doses
extension Medication {

	@objc(insertObject:inDosesAtIndex:)
	@NSManaged public func insertIntoDoses(_ value: MedicationDose, at idx: Int)

	@objc(removeObjectFromDosesAtIndex:)
	@NSManaged public func removeFromDoses(at idx: Int)

	@objc(insertDoses:atIndexes:)
	@NSManaged public func insertIntoDoses(_ values: [MedicationDose], at indexes: NSIndexSet)

	@objc(removeDosesAtIndexes:)
	@NSManaged public func removeFromDoses(at indexes: NSIndexSet)

	@objc(replaceObjectInDosesAtIndex:withObject:)
	@NSManaged public func replaceDoses(at idx: Int, with value: MedicationDose)

	@objc(replaceDosesAtIndexes:withDoses:)
	@NSManaged public func replaceDoses(at indexes: NSIndexSet, with values: [MedicationDose])

	@objc(addDosesObject:)
	@NSManaged public func addToDoses(_ value: MedicationDose)

	@objc(removeDosesObject:)
	@NSManaged public func removeFromDoses(_ value: MedicationDose)

	@objc(addDoses:)
	@NSManaged public func addToDoses(_ values: NSOrderedSet)

	@objc(removeDoses:)
	@NSManaged public func removeFromDoses(_ values: NSOrderedSet)
}
