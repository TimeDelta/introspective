//
//  BaseExporter.swift
//  Introspective
//
//  Created by Bryan Nova on 4/19/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import CSV

public class BaseExporter: Exporter {

	// MARK: - Instance Variables

	public let dataTypePluralName: String
	public var isPaused: Bool = false
	public var isCancelled: Bool = false
	public var url: URL

	/// Pause before importing the nth record
	/// - Note: Indexes start at 0 and does not reset between exporting definitions and activities
	/// - Important: For testing purposes only
	public final var pauseOnRecord: Int?

	final var totalRecordsToExport = 0
	final var recordsCompleted = 0

	private final let log = Log()

	// MARK: - Initializers

	public init(dataTypePluralName: String, url: URL) {
		self.dataTypePluralName = dataTypePluralName
		self.url = url
	}

	// MARK: - Functions

	public func exportData() throws {
		let className = String(describing: type(of: self))
		throw GenericError("Did not override exportData() for \(className)")
	}

	public func percentComplete() -> Double {
		if totalRecordsToExport == 0 { return 1 } // avoid division by 0
		if isCancelled { return 1 }
		return Double(recordsCompleted) / Double(totalRecordsToExport)
	}

	public func cancel() {
		let className = String(describing: type(of: self))
		log.error("Did not override cancel() for %@", className)
		isCancelled = true
	}

	public func pause() {
		isPaused = true
	}

	public func resume() throws {
		let className = String(describing: type(of: self))
		throw GenericError("Did not override resume() for \(className)")
	}

	// MARK: - Helper Functions

	final func export(objects: inout [Exportable], using csv: CSVWriter, headerWritten: inout Bool) throws {
		try writeHeader(for: objects, using: csv, headerWritten: &headerWritten)

		while objects.count > 0 {
			guard !isPaused && !isCancelled else { return }
			if pauseOnRecord == recordsCompleted {
				pause()
				pauseOnRecord = nil
				return
			}
			let object = objects.removeFirst()
			try object.export(to: csv)
			csv.beginNewRow()
			recordsCompleted += 1
		}
	}

	final func writeHeader(for objects: [Exportable], using csv: CSVWriter, headerWritten: inout Bool) throws {
		if !headerWritten && !isPaused && objects.count > 0 {
			try type(of: objects[0]).exportHeaderRow(to: csv)
			csv.beginNewRow()
			headerWritten = true
		}
	}
}
