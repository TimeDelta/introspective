import CoreData
import CSV
import Foundation

import Common
import DataExport
import DependencyInjection
import Persistence

public typealias MetricContextExporter = RecordCSVExporter<MetricContextEntry>
public typealias LostItemExporter = RecordCSVExporter<LostItemEvent>

/// Streams a pinned SQLite snapshot without retaining the complete set of managed records.
public final class RecordCSVExporter<Record: NSManagedObject & CoreDataSample>: Exporter {
	public let dataTypePluralName: String
	public let url: URL
	private var coordinator: NSPersistentStoreCoordinator?
	private let state = NSLock()
	private let execution = NSLock()
	private var paused = false
	private var cancelled = false
	private var completed = 0
	private var total = 0
	// Context/writer/start state use execution; completion flags and progress use state.
	// Core Data work stays on the context's queue.
	private var context: NSManagedObjectContext?
	private var csv: CSVWriter?
	private var started = false
	private var finished = false
	private var failed = false
	private static var batchSize: Int { 200 }

	public var isPaused: Bool { state.lock(); defer { state.unlock() }; return paused }
	public var isCancelled: Bool { state.lock(); defer { state.unlock() }; return cancelled }

	public convenience init() throws {
		guard Thread.isMainThread else { throw GenericError("Create record exporters on the main queue.") }
		let source = injected(Database.self).fetchedResultsController(
			type: Record.self, sortDescriptors: [NSSortDescriptor(key: "timestamp", ascending: true)]
		).managedObjectContext
		guard let coordinator = source.persistentStoreCoordinator else { throw GenericError("Missing export store.") }
		let directory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
			appropriateFor: nil, create: true)
		self.init(coordinator: coordinator, url: injected(ExporterUtil.self).urlOfExportFile(for: Record.self, in: directory))
	}

	public init(coordinator: NSPersistentStoreCoordinator, url: URL) {
		self.coordinator = coordinator
		self.url = url
		dataTypePluralName = Record.exportFileDescription.localizedCapitalized
	}

	public func exportData() throws { try run(resuming: false) }
	public func resume() throws { try run(resuming: true) }
	public func pause() {
		state.lock(); defer { state.unlock() }
		if !finished && !failed && !cancelled { paused = true }
	}
	public func cancel() {
		state.lock(); cancelled = true; paused = false; state.unlock()
		// A running writer owns cleanup until it observes cancellation.
		if execution.try() { discardPartialExport(); execution.unlock() }
	}
	public func percentComplete() -> Double {
		state.lock(); defer { state.unlock() }
		return total == 0 ? 0 : Double(completed) / Double(total)
	}
	public func equalTo(_ other: Exporter) -> Bool {
		guard let other = other as? RecordCSVExporter<Record> else { return false }
		return self === other
	}

	private func run(resuming: Bool) throws {
		guard execution.try() else { throw GenericError("This export is already running.") }
		defer { execution.unlock() }
		guard !isCancelled else { discardPartialExport(); return }
		state.lock(); let hasFailed = failed; let hasFinished = finished; state.unlock()
		guard !hasFailed else { throw GenericError("Start a new export after an export error.") }
		if hasFinished { return }
		if resuming {
			state.lock(); paused = false; state.unlock()
		} else if started {
			throw GenericError("This export has already started.")
		}
		do {
			if !started { try start() }
			guard let context = context else { return }
			while !isPaused && !isCancelled {
				var failure: Error?
				var exhausted = false
				context.performAndWait {
					do {
						try autoreleasepool {
							let request = NSFetchRequest<Record>(entityName: Record.entityName)
							request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
							request.fetchLimit = Self.batchSize
							state.lock(); request.fetchOffset = completed; state.unlock()
							let records = try context.fetch(request)
							exhausted = records.isEmpty
							guard let csv = csv else { throw GenericError("Missing CSV writer.") }
							for record in records {
								guard !isPaused && !isCancelled else { break }
								try record.export(to: csv)
								csv.beginNewRow()
								state.lock(); completed += 1; state.unlock()
							}
						}
					} catch { failure = error }
				}
				if let error = failure { throw error }
				state.lock()
				let allCompleted = completed == total
				if allCompleted { finished = true; paused = false }
				state.unlock()
				if exhausted && !allCompleted { throw GenericError("Unable to read all export records.") }
				if allCompleted {
					csv = nil
					self.context = nil
					break
				}
			}
			if isCancelled { discardPartialExport() }
		} catch {
			state.lock(); failed = true; paused = false; state.unlock()
			discardPartialExport()
			throw error
		}
	}

	private func start() throws {
		started = true
		guard let coordinator = coordinator else { throw GenericError("Missing export store.") }
		let reader = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		reader.persistentStoreCoordinator = coordinator
		self.coordinator = nil // The active reader owns the store until export finishes.
		reader.undoManager = nil
		context = reader
		var failure: Error?
		reader.performAndWait {
			do {
				// Keep offsets and values stable even if the user adds, edits, or deletes records.
				try reader.setQueryGenerationFrom(.current)
				let count = try reader.count(for: NSFetchRequest<Record>(entityName: Record.entityName))
				guard count > 0 else { throw GenericDisplayableError(title: "Nothing to export") }
				state.lock(); total = count; state.unlock()
				let writer = try injected(IOUtil.self).csvWriter(url: url)
				try Record.exportHeaderRow(to: writer)
				writer.beginNewRow()
				csv = writer
			} catch { failure = error }
		}
		if let error = failure { throw error }
	}

	private func discardPartialExport() {
		coordinator = nil
		csv = nil
		context = nil
		if started { try? FileManager.default.removeItem(at: url) }
	}
}
