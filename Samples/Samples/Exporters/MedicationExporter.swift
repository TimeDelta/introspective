//
//  MedicationExporter.swift
//  Introspective
//
//  Created by Bryan Nova on 4/18/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import CoreData
import CSV
import Foundation

import Common
import DataExport
import DependencyInjection
import Persistence

// sourcery: AutoMockable
public protocol MedicationExporter: Exporter {}

public final class MedicationExporterImpl: BaseExporter, MedicationExporter {
	// MARK: - Instance Variables

	private final var doses = [Exportable]()

	private final var csv: CSVWriter!

	private final var started = false
	private final var medicationsHeaderWritten = false
	private final var dosesHeaderWritten = false

	// MARK: - Initializers

	public init() throws {
		let directory = try FileManager.default.url(
			for: .documentDirectory,
			in: .userDomainMask,
			appropriateFor: nil,
			create: false
		)
		super.init(
			dataTypePluralName: "Medications",
			url: DependencyInjector.get(ExporterUtil.self).urlOfExportFile(for: MedicationDose.self, in: directory)
		)
	}

	// MARK: - Functions

	override public final func exportData() throws {
		guard !isCancelled else { return }
		guard !(started && isPaused) else {
			throw GenericError("Tried to start a new medications export with an exporter that is already in use.")
		}

		started = true

		try getDoses()

		guard !doses.isEmpty else {
			throw GenericDisplayableError(title: "Nothing to export")
		}

		totalRecordsToExport = doses.count

		csv = try DependencyInjector.get(IOUtil.self).csvWriter(url: url)

		guard !isPaused else { return }
		try exportRemaining()
	}

	override public final func cancel() {
		isCancelled = true
		doses = [] // release memory for doses
	}

	override public final func resume() throws {
		isPaused = false
		try exportRemaining()
	}

	// MARK: - Helper Functions

	private final func exportRemaining() throws {
		try export(objects: &doses, using: csv, headerWritten: &dosesHeaderWritten)

		if !isPaused {
			doses = [] // release memory for doses
		}
	}

	private final func getDoses() throws {
		let fetchRequest: NSFetchRequest<MedicationDose> = MedicationDose.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
		doses = try DependencyInjector.get(Database.self).query(fetchRequest)
	}
}
