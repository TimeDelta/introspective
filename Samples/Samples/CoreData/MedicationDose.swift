//
//  MedicationDose.swift
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
import DependencyInjection
import Persistence

public final class MedicationDose: NSManagedObject, CoreDataSample, SearchableSample {
	private typealias Me = MedicationDose

	// MARK: - CoreData Stuff

	public static let entityName = "MedicationDose"

	// MARK: - Display Information

	public static let name = "Medication Dose"
	public static let description = "A time at which a medication was taken."

	// MARK: - Attributes

	public static let nameAttribute = TextAttribute(name: "Name", pluralName: "Names", variableName: "medication.name")
	public static let dosage = DosageAttribute(optional: true)
	public static let sourceAttribute = TypedEquatableSelectOneAttribute<String>(
		name: "Source",
		typeName: "Medication Source",
		pluralName: "Sources",
		possibleValues: Sources.MedicationSourceNum.values.map { $0.description },
		possibleValueToString: { $0 }
	)
	public static let attributes: [Attribute] = [
		CommonSampleAttributes.timestamp,
		nameAttribute,
		dosage,
		sourceAttribute,
	]
	public static let defaultDependentAttribute: Attribute = dosage
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.timestamp
	public final let attributes: [Attribute] = Me.attributes
	public static var dateAttributes: [DateType: DateAttribute] = [
		.start: CommonSampleAttributes.timestamp,
	]

	// MARK: - Searching

	public func matchesSearchString(_ searchString: String) -> Bool {
		medication.name.localizedCaseInsensitiveContains(searchString) ||
			(medication.notes?.localizedCaseInsensitiveContains(searchString) ?? false)
	}

	// MARK: - Instance Variables

	public final let attributedName: String = Me.name
	public final override var description: String { Me.description }
	public final var date: Date {
		get {
			injected(CoreDataSampleUtil.self)
				.convertTimeZoneIfApplicable(for: timestamp, timeZoneId: timestampTimeZoneId)
		}
		set {
			timestamp = newValue
			if source == Sources.MedicationSourceNum.introspective.rawValue && timestampTimeZoneId == nil {
				timestampTimeZoneId = TimeZone.autoupdatingCurrent.identifier
			}
		}
	}

	public final var timeZone: TimeZone? {
		get {
			if let timeZoneId = timestampTimeZoneId {
				return TimeZone(identifier: timeZoneId)
			}
			return nil
		}
		set { timestampTimeZoneId = newValue?.identifier }
	}

	// MARK: - Sample Functions

	public final func dates() -> [DateType: Date] {
		[.start: date]
	}

	// MARK: - Export

	public static let exportFileDescription: String = "Medication Dosage History"

	public static let dosageColumn = "Dosage"
	public static let timestampColumn = "Timestamp"
	public static let timeZoneColumn = "Time Zone"
	public static let sourceColumn = "Instance Source"

	public static func exportHeaderRow(to csv: CSVWriter) throws {
		var columns = Medication.exportColumns
		columns.append(dosageColumn)
		columns.append(timestampColumn)
		columns.append(timeZoneColumn)
		columns.append(sourceColumn)
		try csv.write(row: columns, quotedAtIndex: { _ in true })
	}

	public func export(to csv: CSVWriter) throws {
		try medication.export(to: csv)

		let dose = dosage?.description ?? ""
		try csv.write(field: dose, quoted: true)

		let timestampText = injected(CalendarUtil.self)
			.string(for: timestamp, dateStyle: .full, timeStyle: .full)
		try csv.write(field: timestampText, quoted: true)

		let timeZone = timestampTimeZoneId ?? ""
		try csv.write(field: timeZone, quoted: true)

		let sourceText = Sources.resolveMedicationSource(source).description
		try csv.write(field: sourceText, quoted: true)
	}

	// MARK: - Other

	public final func getSource() -> Sources.MedicationSourceNum {
		Sources.resolveMedicationSource(source)
	}

	public final func setSource(_ source: Sources.MedicationSourceNum) {
		self.source = source.rawValue
		if source == Sources.MedicationSourceNum.introspective && timestampTimeZoneId == nil {
			timestampTimeZoneId = TimeZone.autoupdatingCurrent.identifier
		}
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
			return Sources.resolveMedicationSource(source).description
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		let transaction = injected(Database.self).transaction()

		if attribute.equalTo(Me.nameAttribute) {
			guard let castedValue = value as? String else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}

			let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
			fetchRequest.predicate = NSPredicate(
				format: "%K == %@",
				Medication.nameAttribute.variableName!,
				castedValue
			)
			let matchingMedications = try transaction.query(fetchRequest)
			if matchingMedications.isEmpty {
				throw UnsupportedValueError(attribute: attribute, of: self, is: value)
			}

			medication = try injected(Database.self)
				.pull(savedObject: matchingMedications[0], fromSameContextAs: self)
			return
		}
		if attribute.equalTo(Me.dosage) {
			guard let castedValue = value as? Dosage? else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}

			dosage = castedValue
			return
		}
		if attribute.equalTo(CommonSampleAttributes.timestamp) {
			guard let castedValue = value as? Date else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}

			timestamp = castedValue
			if source == Sources.MedicationSourceNum.introspective.rawValue && timestampTimeZoneId == nil {
				timestampTimeZoneId = TimeZone.autoupdatingCurrent.identifier
			}
			return
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	// MARK: - Equatable

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
		medication.equalTo(other.medication) &&
			dosage == other.dosage &&
			date == other.date
	}

	// MARK: - Debug

	public final override var debugDescription: String {
		let dosageText = dosage?.description ?? "nil"
		let timestampText = try! CommonSampleAttributes.timestamp.convertToDisplayableString(from: timestamp)
		return "Dose of '\(medication.name)' (\(dosageText)) taken on \(timestampText)"
	}
}

// MARK: - CoreData

public extension MedicationDose {
	@nonobjc class func fetchRequest() -> NSFetchRequest<MedicationDose> {
		NSFetchRequest<MedicationDose>(entityName: "MedicationDose")
	}

	@NSManaged fileprivate var timestamp: Date
	@NSManaged fileprivate var timestampTimeZoneId: String?
	@NSManaged var dosage: Dosage?
	@NSManaged var medication: Medication
	@NSManaged var source: Int16
}
