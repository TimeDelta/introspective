//
//  ActivityExporter.swift
//  Introspective
//
//  Created by Bryan Nova on 4/17/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import CSV
import Common
import DataExport

// sourcery: AutoMockable
public protocol ActivityExporter: Exporter {}

public final class ActivityExporterImpl: RecordCSVExporter<Activity>, ActivityExporter {
	public override class var prefetchedRelationships: [String] { ["definition", "definition.tags", "tags"] }
	internal override class var usesConvertedDates: Bool { true }
	internal override func export(_ record: Activity, to csv: CSVWriter) throws {
		guard let conversion = dateConversion else { throw GenericError("Missing export date settings.") }
		try record.export(to: csv, convertingDatesWith: conversion.convert)
	}
}
