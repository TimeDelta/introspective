//
//  MedicationDose.swift
//  Introspective
//
//  Created by Bryan Nova on 10/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import Foundation
import CoreData

public final class MedicationDose: NSManagedObject, CoreDataSample {

	private typealias Me = MedicationDose

	// MARK: - CoreData Stuff

	public static let entityName = "MedicationDose"

	// MARK: - Display Information

	public static let name = "Medication Dose"
	public static let description = "A time at which a medication was taken."

	// MARK: - Attributes

	public static let nameAttribute = TextAttribute(name: "Name", pluralName: "Names")
	public static let dosage = DosageAttribute(optional: true)
	public static let sourceAttribute = TypedEquatableSelectOneAttribute<String>(
		name: "Source",
		pluralName: "Sources",
		possibleValues: Sources.medicationSources,
		possibleValueToString: { $0 })
	public static let attributes: [Attribute] = [CommonSampleAttributes.timestamp, nameAttribute, dosage, sourceAttribute]
	public static let defaultDependentAttribute: Attribute = dosage
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.timestamp
	public final let attributes: [Attribute] = Me.attributes

	// MARK: - Instance Variables

	public final let attributedName: String = Me.name
	public final override var description: String { return Me.description }

	// MARK: - Sample Functions

	public final func dates() -> [DateType: Date] {
		return [.start: timestamp]
	}

	// MARK: - Other

	public final func setSource(_ source: Sources.MedicationSourceNum) {
		self.source = source.rawValue
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.nameAttribute) {
			return medication.name
		}
		if attribute.equalTo(Me.dosage) {
			return dosage
		}
		if attribute.equalTo(CommonSampleAttributes.timestamp) {
			return timestamp
		}
		if attribute.equalTo(Me.sourceAttribute) {
			return Sources.resolveMedicationSource(source)
		}
		throw AttributeError.unknownAttribute
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(Me.nameAttribute) {
			guard let castedValue = value as? String else { throw AttributeError.typeMismatch }
			let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
			fetchRequest.predicate = NSPredicate(format: "%K == %@", Medication.nameAttribute.variableName!, castedValue)
			let matchingMedications = try DependencyInjector.db.query(fetchRequest)
			if matchingMedications.count == 0 {
				throw AttributeError.unsupportedValue
			}
			medication = matchingMedications[0]
			try DependencyInjector.db.save()
			return
		}
		if attribute.equalTo(Me.dosage) {
			guard let castedValue = value as? Dosage? else { throw AttributeError.typeMismatch }
			dosage = castedValue
			try DependencyInjector.db.save()
			return
		}
		if attribute.equalTo(CommonSampleAttributes.timestamp) {
			guard let castedValue = value as? Date else { throw AttributeError.typeMismatch }
			timestamp = castedValue
			try DependencyInjector.db.save()
			return
		}
		throw AttributeError.unknownAttribute
	}

	// MARK: - Equatable

	public static func ==(lhs: MedicationDose, rhs: MedicationDose) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is MedicationDose) { return false }
		let other = otherAttributed as! MedicationDose
		return equalTo(other)
	}

	public final func equalTo(_ otherSample: Sample) -> Bool {
		if !(otherSample is MedicationDose) { return false }
		let other = otherSample as! MedicationDose
		return equalTo(other)
	}

	public final func equalTo(_ other: MedicationDose) -> Bool {
		return medication == other.medication && dosage == other.dosage && timestamp == other.timestamp
	}

	// MARK: - Debug

	public final override var debugDescription: String {
		let dosageText = dosage?.description ?? "nil"
		let timestampText = try! CommonSampleAttributes.timestamp.convertToDisplayableString(from: timestamp)
		return "Dose of '\(medication.name)' (\(dosageText)) taken on \(timestampText)"
	}
}
