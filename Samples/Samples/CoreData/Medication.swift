//
//  Medication.swift
//  Introspective
//
//  Created by Bryan Nova on 10/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import CoreData
import CSV
import Foundation

import Attributes
import Common
import DataExport
import DependencyInjection
import Persistence

public final class Medication: NSManagedObject, CoreDataObject, Attributed, Exportable {
	private typealias Me = Medication

	// MARK: - CoreData Stuff

	public static let entityName = "Medication"

	// MARK: - Attributes

	public static let nameAttribute = TextAttribute(name: "Name", pluralName: "Names", variableName: "name")
	public static let dosage = DosageAttribute(
		description: "You can set this if you have a common dosage that you usually take for this medication. When marking this medication as taken, this will be used as the default value for dosage but can still be overriden. Changing this value will not affect the dosage of any existing records.",
		optional: true
	)
	public static let frequency =
		FrequencyAttribute(description: "How frequently you are supposed to take this medication.")
	public static let startedOn = DateOnlyAttribute(
		name: "Started On",
		description: "When did you start this medication?",
		variableName: "startedOn",
		optional: true
	)
	public static let notes = TextAttribute(name: "Notes", variableName: "notes", optional: true)
	public static let sourceAttribute = TypedEquatableSelectOneAttribute<String>(
		name: "Source",
		typeName: "Medication Source",
		pluralName: "Sources",
		possibleValues: Sources.MedicationSourceNum.values.map { $0.description },
		possibleValueToString: { $0 }
	)
	public static let attributes: [Attribute] = [nameAttribute, dosage, frequency, startedOn, notes, sourceAttribute]
	public final let attributes: [Attribute] = Me.attributes

	// MARK: - Instance Variables

	public final let attributedName: String = "Medication"
	override public final var description: String {
		"A substance used for medical treatment, especially a medicine or drug."
	}

	public final var startedOn: Date? {
		get {
			if let storedStartedOn = storedStartedOn {
				return DependencyInjector.get(CoreDataSampleUtil.self).convertTimeZoneIfApplicable(
					for: storedStartedOn,
					timeZoneId: startedOnTimeZoneId
				)
			}
			return nil
		}
		set {
			storedStartedOn = newValue
			if source == Sources.MedicationSourceNum.introspective.rawValue && startedOnTimeZoneId == nil {
				startedOnTimeZoneId = DependencyInjector.get(CalendarUtil.self).currentTimeZone().identifier
			}
		}
	}

	public final var startedOnTimeZone: TimeZone? {
		get {
			if let timeZoneId = startedOnTimeZoneId {
				return TimeZone(identifier: timeZoneId)
			}
			return nil
		}
		set { startedOnTimeZoneId = newValue?.identifier }
	}

	// MARK: - Export

	public static let exportFileDescription: String = "Medications"

	public static let nameColumn = "Name"
	public static let dosageColumn = "Normal Dosage"
	public static let frequencyColumn = "Frequency"
	public static let startedOnColumn = "Started On"
	public static let startedOnTimeZoneColumn = "Started On Time Zone"
	public static let notesColumn = "Notes"
	public static let sourceColumn = "Definition Source"
	public static let recordScreenIndexColumn = "Record Screen Index"

	public static let exportColumns = [
		nameColumn,
		dosageColumn,
		frequencyColumn,
		startedOnColumn,
		startedOnTimeZoneColumn,
		notesColumn,
		sourceColumn,
		recordScreenIndexColumn,
	]

	public static func exportHeaderRow(to csv: CSVWriter) throws {
		try csv.write(row: exportColumns, quotedAtIndex: { _ in true })
	}

	public func export(to csv: CSVWriter) throws {
		try csv.write(field: name, quoted: true)

		let dosageText = dosage?.description ?? ""
		try csv.write(field: dosageText, quoted: true)

		let frequencyText = frequency?.description ?? ""
		try csv.write(field: frequencyText, quoted: true)

		if let startedOn = startedOn {
			let timestampText = DependencyInjector.get(CalendarUtil.self)
				.string(for: startedOn, dateStyle: .full, timeStyle: .full)
			try csv.write(field: timestampText, quoted: true)
		} else {
			try csv.write(field: "", quoted: true)
		}

		let timeZone = startedOnTimeZoneId ?? ""
		try csv.write(field: timeZone, quoted: true)

		try csv.write(field: notes ?? "", quoted: true)

		let sourceText = Sources.resolveMedicationSource(source).description
		try csv.write(field: sourceText, quoted: true)
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.nameAttribute) {
			return name
		}
		if attribute.equalTo(Me.dosage) {
			return dosage
		}
		if attribute.equalTo(Me.frequency) {
			return frequency
		}
		if attribute.equalTo(Me.startedOn) {
			return startedOn
		}
		if attribute.equalTo(Me.notes) {
			return notes
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(Me.nameAttribute) {
			guard let castedValue = value as? String else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			name = castedValue
			return
		}
		if attribute.equalTo(Me.dosage) {
			if !(value is Dosage?) {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			let castedValue = value as! Dosage?
			dosage = castedValue
			return
		}
		if attribute.equalTo(Me.frequency) {
			guard let castedValue = value as? Frequency else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			frequency = castedValue
			return
		}
		if attribute.equalTo(Me.startedOn) {
			if !(value is Date?) {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			let castedValue = value as! Date?
			storedStartedOn = castedValue
			if source == Sources.MedicationSourceNum.introspective.rawValue && startedOnTimeZoneId == nil {
				startedOnTimeZoneId = DependencyInjector.get(CalendarUtil.self).currentTimeZone().identifier
			}
			return
		}
		if attribute.equalTo(Me.notes) {
			if !(value is String?) {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			let castedValue = value as! String?
			notes = castedValue
			return
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	// MARK: - Other

	public final func sortedDoses(ascending: Bool) -> [MedicationDose] {
		doses.sortedArray(using: [NSSortDescriptor(key: "timestamp", ascending: ascending)]) as! [MedicationDose]
	}

	public final func getSource() -> Sources.MedicationSourceNum {
		Sources.resolveMedicationSource(source)
	}

	public final func setSource(_ source: Sources.MedicationSourceNum) {
		self.source = source.rawValue
		if source == Sources.MedicationSourceNum.introspective && startedOnTimeZoneId == nil {
			startedOnTimeZoneId = DependencyInjector.get(CalendarUtil.self).currentTimeZone().identifier
		}
	}

	public final func getStartedOnTimeZone() -> TimeZone? {
		if let timeZoneId = startedOnTimeZoneId {
			return TimeZone(identifier: timeZoneId)
		}
		return nil
	}

	// MARK: - Equatable

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is Medication) { return false }
		let other = otherAttributed as! Medication
		return equalTo(other)
	}

	public final func equalTo(_ other: Medication) -> Bool {
		name == other.name &&
			dosage == other.dosage &&
			frequency == other.frequency &&
			startedOn == other.startedOn &&
			notes == other.notes
	}

	// MARK: - Debug

	override public final var debugDescription: String {
		let dosageText = dosage?.description ?? "nil"
		let frequencyText = frequency?.description ?? "As needed"
		let startedOnText = startedOn == nil ? "nil" : try! Me.startedOn.convertToDisplayableString(from: startedOn!)
		let notesText = notes ?? "nil"
		return "Medication named '\(name)' with dosage of '\(dosageText)', taking '\(frequencyText)' starting on '\(startedOnText)' with notes '\(notesText)'"
	}
}

// MARK: - CoreData stored properties

public extension Medication {
	@nonobjc class func fetchRequest() -> NSFetchRequest<Medication> {
		NSFetchRequest<Medication>(entityName: "Medication")
	}

	@NSManaged var name: String
	@NSManaged var frequency: Frequency?
	@NSManaged var storedStartedOn: Date?
	@NSManaged fileprivate var startedOnTimeZoneId: String?
	@NSManaged var notes: String?
	@NSManaged var dosage: Dosage?
	@NSManaged var recordScreenIndex: Int16
	@NSManaged var doses: NSOrderedSet
	@NSManaged var source: Int16
}

// MARK: - Generated accessors for doses

public extension Medication {
	@objc(insertObject:inDosesAtIndex:)
	@NSManaged func insertIntoDoses(_ value: MedicationDose, at idx: Int)

	@objc(removeObjectFromDosesAtIndex:)
	@NSManaged func removeFromDoses(at idx: Int)

	@objc(insertDoses:atIndexes:)
	@NSManaged func insertIntoDoses(_ values: [MedicationDose], at indexes: NSIndexSet)

	@objc(removeDosesAtIndexes:)
	@NSManaged func removeFromDoses(at indexes: NSIndexSet)

	@objc(replaceObjectInDosesAtIndex:withObject:)
	@NSManaged func replaceDoses(at idx: Int, with value: MedicationDose)

	@objc(replaceDosesAtIndexes:withDoses:)
	@NSManaged func replaceDoses(at indexes: NSIndexSet, with values: [MedicationDose])

	@objc(addDosesObject:)
	@NSManaged func addToDoses(_ value: MedicationDose)

	@objc(removeDosesObject:)
	@NSManaged func removeFromDoses(_ value: MedicationDose)

	@objc(addDoses:)
	@NSManaged func addToDoses(_ values: NSOrderedSet)

	@objc(removeDoses:)
	@NSManaged func removeFromDoses(_ values: NSOrderedSet)
}
