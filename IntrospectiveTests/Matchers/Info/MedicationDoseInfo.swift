//
//  MedicationDoseInfo.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/7/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

@testable import Common
@testable import Samples

public class MedicationDoseInfo: Info {

	var medication: MedicationInfo
	var dosage: Dosage?
	var timestamp: Date
	var timeZone: TimeZone?
	var source: Sources.MedicationSourceNum

	public init(
		medication: MedicationInfo,
		dosage: Dosage? = nil,
		timestamp: Date,
		timeZone: TimeZone? = nil,
		source: Sources.MedicationSourceNum
	) {
		self.medication = medication
		self.dosage = dosage
		self.timestamp = timestamp
		self.timeZone = timeZone
		self.source = source
	}

	public init(_ dose: MedicationDose) {
		medication = MedicationInfo(dose.medication)
		dosage = dose.dosage
		timestamp = dose.date
		timeZone = dose.timeZone
		source = dose.getSource()
	}

	public func getPredicates() -> [String: NSPredicate] {
		return [
			"medication.name": NSPredicate(format: "medication.name ==[cd] %@", medication.name),
			"medication.storedStartedOn": self.datePredicateFor(
				fieldName: "medication.storedStartedOn",
				withinOneSecondOf: medication.startedOn),
			"medication.startedOnTimeZoneId": self.timeZonePredicate(
				for: medication.startedOnTimeZone,
				field: "medication.startedOnTimeZoneId"),
			"medication.dosage": self.dosagePredicate(for: medication.dosage, fieldName: "medication.dosage"),
			"medication.frequency": self.frequencyPredicate(
				for: medication.frequency,
				fieldName: "medication.frequency"),
			"medication.notes": self.optionalStringPredicate(for: medication.notes, fieldName: "medication.notes"),
			"medication.source": NSPredicate(format: "medication.source == %i", medication.source.rawValue),
			"medication.recordScreenIndex": NSPredicate(
				format: "medication.recordScreenIndex == %i",
				medication.recordScreenIndex),
			"timestamp": self.datePredicateFor(fieldName: "timestamp", withinOneSecondOf: timestamp),
			"dosage": self.dosagePredicate(for: dosage, fieldName: "dosage"),
			"timestampTimeZoneId": self.timeZonePredicate(for: timeZone, field: "timestampTimeZoneId"),
			"source": NSPredicate(format: "source == %i", source.rawValue),
		]
	}

	public func copy() -> MedicationDoseInfo {
		return MedicationDoseInfo(
			medication: medication.copy(),
			dosage: dosage,
			timestamp: timestamp,
			timeZone: timeZone,
			source: source
		)
	}
}
