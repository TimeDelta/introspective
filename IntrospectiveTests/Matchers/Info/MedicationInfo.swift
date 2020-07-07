//
//  MedicationInfo.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/7/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

@testable import Common
@testable import Samples

public final class MedicationInfo: Info {

	var name: String
	var dosage: Dosage?
	var frequency: Frequency?
	var startedOn: Date?
	var startedOnTimeZone: TimeZone?
	var notes: String?
	var source: Sources.MedicationSourceNum
	var recordScreenIndex: Int16

	public init(
		name: String,
		dosage: Dosage?,
		frequency: Frequency?,
		startedOn: Date?,
		startedOnTimeZone: TimeZone?,
		notes: String?,
		source: Sources.MedicationSourceNum,
		recordScreenIndex: Int16
	) {
		self.name = name
		self.dosage = dosage
		self.frequency = frequency
		self.startedOn = startedOn
		self.startedOnTimeZone = startedOnTimeZone
		self.notes = notes
		self.source = source
		self.recordScreenIndex = recordScreenIndex
	}

	public func getPredicates() -> [String: NSPredicate] {
		return [
			"name": NSPredicate(format: "name ==[cd] %@", name),
			"storedStartedOn": self.datePredicateFor(fieldName: "storedStartedOn", withinOneSecondOf: startedOn),
			"startedOnTimeZoneId": self.timeZonePredicate(for: startedOnTimeZone, field: "startedOnTimeZoneId"),
			"dosage": self.dosagePredicate(for: dosage, fieldName: "dosage"),
			"frequency": self.frequencyPredicate(for: frequency, fieldName: "frequency"),
			"notes": self.optionalStringPredicate(for: notes, fieldName: "notes"),
			"source": NSPredicate(format: "source == %i", source.rawValue),
			"recordScreenIndex": NSPredicate(format: "recordScreenIndex == %i", recordScreenIndex),
		]
	}

	public func copy() -> MedicationInfo {
		return MedicationInfo(
			name: name,
			dosage: dosage,
			frequency: frequency,
			startedOn: startedOn,
			startedOnTimeZone: startedOnTimeZone,
			notes: notes,
			source: source,
			recordScreenIndex: recordScreenIndex
		)
	}
}
