//
//  FatigueExporter.swift
//  Samples
//
//  Created by Bryan Nova on 3/25/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import CoreData
import CSV
import Foundation

import Common
import DataExport
import DependencyInjection
import Persistence

public protocol FatigueExporter: Exporter {}

public final class FatigueExporterImpl: BaseExporter, FatigueExporter {
	// MARK: - Instance Variables

	private final var fatigues = [Exportable]()
	private final var csv: CSVWriter!

	private final var started = false
	private final var headerWritten = false

	// MARK: - Initializers

	public init() throws {
		let directory = try FileManager.default.url(
			for: .documentDirectory,
			in: .userDomainMask,
			appropriateFor: nil,
			create: false
		)
		super.init(
			dataTypePluralName: "Fatigues",
			url: injected(ExporterUtil.self).urlOfExportFile(for: FatigueImpl.self, in: directory)
		)
	}

	// MARK: - Functions

	public final override func exportData() throws {
		guard !isCancelled else { return }
		guard !(started && isPaused) else {
			throw GenericError("Tried to start a new fatigues export with an exporter that is already in use.")
		}

		started = true

		try getFatigues()

		guard !fatigues.isEmpty else {
			throw GenericDisplayableError(title: "Nothing to export")
		}

		totalRecordsToExport = fatigues.count

		csv = try injected(IOUtil.self).csvWriter(url: url)

		guard !isPaused else { return }
		try exportRemaining()
	}

	public final override func cancel() {
		isCancelled = true
		// release memory for fatigues
		fatigues = []
	}

	public final override func resume() throws {
		isPaused = false
		try exportRemaining()
	}

	// MARK: - Helper Functions

	private final func exportRemaining() throws {
		try export(objects: &fatigues, using: csv, headerWritten: &headerWritten)

		if !isPaused {
			fatigues = []
		}
	}

	private final func getFatigues() throws {
		let fetchRequest: NSFetchRequest<FatigueImpl> = FatigueImpl.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
		fatigues = try injected(Database.self).query(fetchRequest)
	}
}
