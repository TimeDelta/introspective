//
//  ActivityExporter.swift
//  Introspective
//
//  Created by Bryan Nova on 4/17/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

import Common
import DataExport
import DependencyInjection
import Persistence

import CSV

// sourcery: AutoMockable
public protocol ActivityExporter: Exporter {}

public final class ActivityExporterImpl: BaseExporter, ActivityExporter {
	// MARK: - Instance Variables

	private final var activities = [Exportable]()

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
			dataTypePluralName: "Activities",
			url: injected(ExporterUtil.self).urlOfExportFile(for: Activity.self, in: directory)
		)
	}

	// MARK: - Functions

	public final override func exportData() throws {
		guard !isCancelled else { return }
		guard !(started && isPaused) else {
			throw GenericError("Tried to start a new activities export with an exporter that is already in use.")
		}

		started = true

		try getActivities()

		guard !activities.isEmpty else {
			throw GenericDisplayableError(title: "Nothing to export")
		}

		totalRecordsToExport = activities.count

		csv = try injected(IOUtil.self).csvWriter(url: url)

		guard !isPaused else { return }
		try exportRemaining()
	}

	public final override func cancel() {
		isCancelled = true
		// release memory for activities
		activities = []
	}

	public final override func resume() throws {
		isPaused = false
		try exportRemaining()
	}

	// MARK: - Helper Functions

	private final func exportRemaining() throws {
		try export(objects: &activities, using: csv, headerWritten: &headerWritten)

		if !isPaused {
			activities = []
		}
	}

	private final func getActivities() throws {
		let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
		activities = try injected(Database.self).query(fetchRequest)
	}
}
