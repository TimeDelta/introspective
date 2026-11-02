//
//  MedicationExporter.swift
//  Introspective
//
//  Created by Bryan Nova on 4/18/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import CSV
import Common
import DataExport

// sourcery: AutoMockable
public protocol MedicationExporter: Exporter {}

public final class MedicationExporterImpl: RecordCSVExporter<MedicationDose>, MedicationExporter {
	public override var dataTypePluralName: String { "Medications" }
	public override class var prefetchedRelationships: [String] { ["medication"] }
	internal override class var usesConvertedDates: Bool { true }
	internal override func export(_ record: MedicationDose, to csv: CSVWriter) throws {
		guard let conversion = dateConversion else { throw GenericError("Missing export date settings.") }
		try record.export(to: csv, convertingDatesWith: conversion.convert)
	}
}
