//
//  MoodExporter.swift
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

public protocol MoodExporter: Exporter {}

public final class MoodExporterImpl: BaseExporter, MoodExporter {
	// MARK: - Instance Variables

	private final var moods = [Exportable]()
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
			dataTypePluralName: "Moods",
			url: DependencyInjector.get(ExporterUtil.self).urlOfExportFile(for: MoodImpl.self, in: directory)
		)
	}

	// MARK: - Functions

	override public final func exportData() throws {
		guard !isCancelled else { return }
		guard !(started && isPaused) else {
			throw GenericError("Tried to start a new moods export with an exporter that is already in use.")
		}

		started = true

		try getMoods()

		guard !moods.isEmpty else {
			throw GenericDisplayableError(title: "Nothing to export")
		}

		totalRecordsToExport = moods.count

		csv = try DependencyInjector.get(IOUtil.self).csvWriter(url: url)

		guard !isPaused else { return }
		try exportRemaining()
	}

	override public final func cancel() {
		isCancelled = true
		// release memory for moods
		moods = []
	}

	override public final func resume() throws {
		isPaused = false
		try exportRemaining()
	}

	// MARK: - Helper Functions

	private final func exportRemaining() throws {
		try export(objects: &moods, using: csv, headerWritten: &headerWritten)

		if !isPaused {
			moods = []
		}
	}

	private final func getMoods() throws {
		let fetchRequest: NSFetchRequest<MoodImpl> = MoodImpl.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
		moods = try DependencyInjector.get(Database.self).query(fetchRequest)
	}
}
