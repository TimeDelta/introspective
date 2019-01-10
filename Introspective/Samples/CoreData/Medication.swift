//
//  Medication.swift
//  Introspective
//
//  Created by Bryan Nova on 10/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import Foundation
import CoreData

public final class Medication: Importable, CoreDataObject, Attributed {

	private typealias Me = Medication

	// MARK: - CoreData Stuff

	public static let entityName = "Medication"

	// MARK: - Attributes

	public static let nameAttribute = TextAttribute(name: "Name", pluralName: "Names", variableName: "name")
	public static let dosage = DosageAttribute(description: "You can set this if you have a common dosage that you usually take for this medication. When marking this medication as taken, this will be used as the default value for dosage but can still be overriden. Changing this value will not affect the dosage of any existing records.", optional: true)
	public static let frequency = FrequencyAttribute(description: "How frequently you are supposed to take this medication.")
	public static let startedOn = DateOnlyAttribute(name: "Started On", description: "When did you start this medication?", variableName: "startedOn", optional: true)
	public static let notes = TextAttribute(name: "Notes", variableName: "notes", optional: true)
	public static let sourceAttribute = TypedEquatableSelectOneAttribute<String>(
		name: "Source",
		pluralName: "Sources",
		possibleValues: Sources.medicationSources,
		possibleValueToString: { $0 })
	public static let attributes: [Attribute] = [nameAttribute, dosage, frequency, startedOn, notes, sourceAttribute]
	public final let attributes: [Attribute] = Me.attributes

	// MARK: - Instance Variables

	public final let attributedName: String = "Medication"
	public final override var description: String {
		return "A substance used for medical treatment, especially a medicine or drug."
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
		if attribute.equalTo(Me.sourceAttribute) {
			return Sources.resolveMedicationSource(source)
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
			startedOn = castedValue
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
		return doses.sortedArray(using: [NSSortDescriptor(key: "timestamp", ascending: ascending)]) as! [MedicationDose]
	}

	public final func setSource(_ source: Sources.MedicationSourceNum) {
		self.source = source.rawValue
	}

	// MARK: - Equatable

	public static func ==(lhs: Medication, rhs: Medication) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is Medication) { return false }
		let other = otherAttributed as! Medication
		return equalTo(other)
	}

	public final func equalTo(_ otherSample: Sample) -> Bool {
		if !(otherSample is Medication) { return false }
		let other = otherSample as! Medication
		return equalTo(other)
	}

	public final func equalTo(_ other: Medication) -> Bool {
		return name == other.name &&
			dosage == other.dosage &&
			frequency == other.frequency &&
			startedOn == other.startedOn &&
			notes == other.notes
	}

	// MARK: - Debug

	public final override var debugDescription: String {
		let dosageText = dosage?.description ?? "nil"
		let frequencyText = frequency?.description ?? "As needed"
		let startedOnText = startedOn == nil ? "nil" : try! Me.startedOn.convertToDisplayableString(from: startedOn!)
		let notesText = notes ?? "nil"
		return "Medication named '\(name)' with dosage of '\(dosageText)', taking '\(frequencyText)' starting on '\(startedOnText)' with notes '\(notesText)'"
	}
}
