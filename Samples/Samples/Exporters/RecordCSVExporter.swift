import CoreData
import CSV
import Foundation

import Common
import DataExport
import DependencyInjection
import Persistence
import Settings

public typealias MetricContextExporter = RecordCSVExporter<MetricContextEntry>
public typealias LostItemExporter = RecordCSVExporter<LostItemEvent>

/// Streams a pinned SQLite snapshot without retaining the complete set of managed records.
public class RecordCSVExporter<Record: NSManagedObject & CoreDataSample>: Exporter {
	public var dataTypePluralName: String { Record.exportFileDescription.localizedCapitalized }
	public class var prefetchedRelationships: [String] { [] }
	internal class var usesConvertedDates: Bool { false }
	internal private(set) var dateConversion: ExportDateConversion?
	private static var sortKey: String { Record.dateAttributes[.start]?.variableName ?? "timestamp" }
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
	internal private(set) var context: NSManagedObjectContext?
	private var csv: CSVWriter?
	private var started = false
	private var finished = false
	private var failed = false
	private var pauseBeforeRecord: Int?
	private static var batchSize: Int { 200 }

	/// Deterministic pause control used by the export functional regressions.
	public final var pauseOnRecord: Int? {
		get { state.lock(); defer { state.unlock() }; return pauseBeforeRecord }
		set { state.lock(); pauseBeforeRecord = newValue; state.unlock() }
	}

	public var isPaused: Bool { state.lock(); defer { state.unlock() }; return paused }
	public var isCancelled: Bool { state.lock(); defer { state.unlock() }; return cancelled }

	public convenience init() throws {
		guard Thread.isMainThread else { throw GenericError("Create record exporters on the main queue.") }
		let source = injected(Database.self).fetchedResultsController(
			type: Record.self, sortDescriptors: [NSSortDescriptor(key: Self.sortKey, ascending: true)]
		).managedObjectContext
		guard let coordinator = source.persistentStoreCoordinator else { throw GenericError("Missing export store.") }
		let directory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
			appropriateFor: nil, create: true)
		let convertTimeZones = Self.usesConvertedDates ? injected(Settings.self).convertTimeZones : false
		self.init(coordinator: coordinator, url: injected(ExporterUtil.self).urlOfExportFile(for: Record.self, in: directory),
			convertTimeZones: convertTimeZones)
	}

	public init(coordinator: NSPersistentStoreCoordinator, url: URL, convertTimeZones: Bool = false) {
		self.coordinator = coordinator
		self.url = url
		if type(of: self).usesConvertedDates {
			dateConversion = ExportDateConversion(enabled: convertTimeZones)
		}
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
		return cancelled || total == 0 ? 1 : Double(completed) / Double(total)
	}
	public func equalTo(_ other: Exporter) -> Bool {
		guard let other = other as? RecordCSVExporter<Record> else { return false }
		return self === other
	}

	internal func export(_ record: Record, to csv: CSVWriter) throws { try record.export(to: csv) }

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
				try prepareWriter()
				var failure: Error?
				var exhausted = false
				context.performAndWait {
					do {
						try autoreleasepool {
							// Fault relationships as well as root records to break inverse-reference cycles.
							defer {
								for object in context.registeredObjects where !object.isFault {
									context.refresh(object, mergeChanges: false)
								}
							}
							let request = NSFetchRequest<Record>(entityName: Record.entityName)
							request.sortDescriptors = [NSSortDescriptor(key: Self.sortKey, ascending: true)]
							request.fetchLimit = Self.batchSize
							request.returnsObjectsAsFaults = false
							request.relationshipKeyPathsForPrefetching = type(of: self).prefetchedRelationships
							state.lock(); request.fetchOffset = completed; state.unlock()
							let records = try context.fetch(request)
							exhausted = records.isEmpty
							guard let csv = csv else { throw GenericError("Missing CSV writer.") }
							for record in records {
								guard shouldWriteNextRecord() else { break }
								try export(record, to: csv)
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
				// Query generations are a SQLite feature. In-memory functional fixtures
				// still use a private reader, but cannot pin a persistent generation.
				if !coordinator.persistentStores.allSatisfy({ $0.type == NSInMemoryStoreType }) {
					try reader.setQueryGenerationFrom(.current)
				}
				let count = try reader.count(for: NSFetchRequest<Record>(entityName: Record.entityName))
				guard count > 0 else { throw GenericDisplayableError(title: "Nothing to export") }
				state.lock(); total = count; state.unlock()
			} catch { failure = error }
		}
		if let error = failure { throw error }
	}

	private func prepareWriter() throws {
		guard csv == nil else { return }
		let writer = try injected(IOUtil.self).csvWriter(url: url)
		try Record.exportHeaderRow(to: writer)
		writer.beginNewRow()
		csv = writer
	}

	private func shouldWriteNextRecord() -> Bool {
		state.lock(); defer { state.unlock() }
		if pauseBeforeRecord == completed {
			paused = true
			pauseBeforeRecord = nil
		}
		return !paused && !cancelled
	}

	private func discardPartialExport() {
		coordinator = nil
		csv = nil
		context = nil
		if started { try? FileManager.default.removeItem(at: url) }
	}
}

/// The user preference is captured on main; explicit-store callers supply it as a value.
internal struct ExportDateConversion {
	let enabled: Bool
	let calendar = injected(CalendarUtil.self)
	let currentZone = injected(CalendarUtil.self).currentTimeZone()
	func convert(_ date: Date, zone: String?) -> Date {
		guard enabled, let zone = zone, let originalZone = TimeZone(identifier: zone) else { return date }
		return calendar.convert(date, from: currentZone, to: originalZone)
	}
}
