import CoreData
import Foundation
import HealthKit
import Common
import DependencyInjection
import Persistence
import Queries
import Samples
import Settings

enum PinnedQueryCardState {
	case loading
	case ready(PinnedQuerySummary)
	case unavailable(String)
}

struct PinnedQueryCard {
	let pin: PinnedQueryReference
	var sampleTypeName: String?
	var queryDescription: String?
	var state: PinnedQueryCardState
}

struct PinnedQueryDashboardRecords {
	let name: String
	let query: Query
	let samples: [Sample]
	let evaluatedAt: Date
}

/// The UI retains this handle. Cancellation never touches a managed object on
/// the caller's queue; the worker arranges cleanup on its own context.
final class PinnedQueryDashboardTask {
	private let lock = NSLock()
	private var cancelled = false
	private var cancellation: (() -> Void)?
	var isCancelled: Bool { lock.lock(); defer { lock.unlock() }; return cancelled }
	func cancel() {
		lock.lock(); cancelled = true; let action = cancellation; cancellation = nil; lock.unlock()
		action?()
	}
	func onCancel(_ action: @escaping () -> Void) {
		lock.lock()
		if cancelled { lock.unlock(); action() }
		else { cancellation = action; lock.unlock() }
	}
	func finish() { lock.lock(); cancellation = nil; lock.unlock() }
	deinit { cancel() }
}

protocol PinnedQueryDashboardLoading: AnyObject {
	@discardableResult func refresh(_ pins: [PinnedQueryReference], onCard: @escaping (PinnedQueryCard) -> Void,
		completion: @escaping () -> Void) -> PinnedQueryDashboardTask
	@discardableResult func openResults(_ pin: PinnedQueryReference,
		completion: @escaping (Result<PinnedQueryDashboardRecords, Error>) -> Void) -> PinnedQueryDashboardTask
	@discardableResult func observeHealthChanges(_ pins: [PinnedQueryReference], changed: @escaping () -> Void) -> PinnedQueryDashboardTask
}

extension PinnedQueryDashboardLoading {
	func observeHealthChanges(_ pins: [PinnedQueryReference], changed: @escaping () -> Void) -> PinnedQueryDashboardTask {
		PinnedQueryDashboardTask()
	}
}

protocol DashboardHealthObserving: AnyObject {
	func observe(_ types: Set<HKSampleType>, changed: @escaping () -> Void) -> (() -> Void)
}

private final class SystemDashboardHealthObserver: DashboardHealthObserving {
	private let store = HKHealthStore()
	func observe(_ types: Set<HKSampleType>, changed: @escaping () -> Void) -> (() -> Void) {
		let queries = types.map { type in
			HKObserverQuery(sampleType: type, predicate: nil) { _, completion, error in
				// HealthKit requires acknowledgment even after cancellation or errors.
				completion()
				if error == nil { changed() }
			}
		}
		for query in queries { store.execute(query) }
		return { [store] in for query in queries { store.stop(query) } }
	}
}

/// Each refresh evaluates cards serially against a pinned store generation.
/// Only value summaries and permanent identifiers leave the read context.
final class PinnedQueryDashboardService: PinnedQueryDashboardLoading {
	private let suppliedContext: NSManagedObjectContext?
	private let suppliedConversion: Bool?
	private let clock: () -> Date
	private let timeout: TimeInterval
	private lazy var healthObserver: DashboardHealthObserving = suppliedHealthObserver ?? SystemDashboardHealthObserver()
	private let suppliedHealthObserver: DashboardHealthObserving?
	init(context: NSManagedObjectContext? = nil, convertTimeZones: Bool? = nil,
		clock: @escaping () -> Date = Date.init, timeout: TimeInterval = 30, healthObserver: DashboardHealthObserving? = nil) {
		suppliedContext = context; suppliedConversion = convertTimeZones
		self.clock = clock; self.timeout = timeout; suppliedHealthObserver = healthObserver
	}

	func observeHealthChanges(_ pins: [PinnedQueryReference], changed: @escaping () -> Void) -> PinnedQueryDashboardTask {
		let task = PinnedQueryDashboardTask()
		// This API is called by the visible controller on main. Never construct
		// HealthKit services merely by opening a Core Data-only dashboard.
		let root = suppliedContext ?? injected(Database.self).fetchedResultsController(
			type: StoredQuery.self, sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]).managedObjectContext
		var types = Set<HKSampleType>()
		for pin in pins.prefix(PinnedQueryPreferences.maximumPins) {
			guard let url = URL(string: pin.id), let id = root.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url),
				let saved = try? root.existingObject(with: id) as? StoredQuery,
				!saved.isDeleted, saved.parentQuery == nil else { continue }
			var current: StoredQuery? = saved; var visited = Set<NSManagedObjectID>()
			while let query = current, visited.count < 32, visited.insert(query.objectID).inserted {
				if let type = try? injected(SampleFactory.self).sampleType(for: query.sampleTypeId),
					let health = type as? HealthKitSample.Type { types.insert(health.sampleType) }
				current = query.storedSubQuery
			}
		}
		if !types.isEmpty {
			let stop = healthObserver.observe(types) { [weak task] in
				DispatchQueue.main.async { guard task?.isCancelled == false else { return }; changed() }
			}
			task.onCancel(stop)
		}
		return task
	}

	func refresh(_ pins: [PinnedQueryReference], onCard: @escaping (PinnedQueryCard) -> Void,
		completion: @escaping () -> Void) -> PinnedQueryDashboardTask {
		begin(pins, onCard: onCard, records: nil, completion: completion)
	}

	func openResults(_ pin: PinnedQueryReference,
		completion: @escaping (Result<PinnedQueryDashboardRecords, Error>) -> Void) -> PinnedQueryDashboardTask {
		begin([pin], onCard: { _ in }, records: completion, completion: {})
	}

	private func begin(_ pins: [PinnedQueryReference], onCard: @escaping (PinnedQueryCard) -> Void,
		records: ((Result<PinnedQueryDashboardRecords, Error>) -> Void)?,
		completion: @escaping () -> Void) -> PinnedQueryDashboardTask {
		let task = PinnedQueryDashboardTask()
		let start = { [self, weak task] in
			guard let task = task, !task.isCancelled else { return }
			do {
				guard pins.count <= PinnedQueryPreferences.maximumPins, Set(pins.map { $0.id }).count == pins.count else {
					throw dashboardError("Choose up to \(PinnedQueryPreferences.maximumPins) distinct saved queries.")
				}
				let root = suppliedContext ?? injected(Database.self).fetchedResultsController(
					type: StoredQuery.self, sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]).managedObjectContext
				guard let coordinator = root.persistentStoreCoordinator else {
					throw dashboardError("Saved data is unavailable. Try again when the database is ready.")
				}
				let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
				context.persistentStoreCoordinator = coordinator; context.undoManager = nil
				let conversion = suppliedConversion ?? injected(Settings.self).convertTimeZones
				let evaluatedAt = clock()
				guard evaluatedAt.timeIntervalSinceReferenceDate.isFinite else { throw dashboardError("The refresh date is invalid.") }
				let worker = DashboardEvaluation(root: root, context: context, date: evaluatedAt,
					conversion: conversion, timeout: timeout, pins: pins, task: task,
					onCard: onCard, records: records, completion: completion)
				task.onCancel { worker.cancel() }
				worker.start()
			} catch {
				for pin in pins { onCard(PinnedQueryCard(pin: pin, state: .unavailable(error.localizedDescription))) }
				records?(.failure(error)); completion(); task.finish()
			}
		}
		if Thread.isMainThread { start() } else { DispatchQueue.main.async(execute: start) }
		return task
	}
}

private func dashboardError(_ message: String) -> Error {
	NSError(domain: "PinnedQueryDashboard", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
}

private final class DashboardEvaluation {
	private let root: NSManagedObjectContext
	private let environment: QueryReadContext
	private let date: Date
	private let timeout: TimeInterval
	private let pins: [PinnedQueryReference]
	private weak var task: PinnedQueryDashboardTask?
	private let onCard: (PinnedQueryCard) -> Void
	private let records: ((Result<PinnedQueryDashboardRecords, Error>) -> Void)?
	private let completion: () -> Void
	private var index = 0
	private var query: Query?
	private var attempt = UUID()
	private var currentCard: PinnedQueryCard?
	private var generation: NSQueryGenerationToken?

	init(root: NSManagedObjectContext, context: NSManagedObjectContext, date: Date, conversion: Bool,
		timeout: TimeInterval, pins: [PinnedQueryReference], task: PinnedQueryDashboardTask,
		onCard: @escaping (PinnedQueryCard) -> Void,
		records: ((Result<PinnedQueryDashboardRecords, Error>) -> Void)?, completion: @escaping () -> Void) {
		self.root = root; self.date = date; self.timeout = max(0.01, timeout); self.pins = pins
		self.task = task; self.onCard = onCard; self.records = records; self.completion = completion
		environment = QueryReadContext(context: context, date: date, convertTimeZones: conversion,
			isCancelled: { [weak task] in task?.isCancelled != false })
	}

	func start() {
		environment.perform { [self] in
			guard task?.isCancelled == false else { return }
			do {
				// Unsupported store types must not silently claim a consistent snapshot.
				try environment.context.setQueryGenerationFrom(.current)
				// .current resolves lazily on the first store read. Keep that concrete
				// token: reset() advances a context's generation as it clears objects.
				let initialRead = StoredQuery.fetchRequest()
				initialRead.fetchLimit = 1; initialRead.returnsObjectsAsFaults = false
				_ = try environment.context.fetch(initialRead)
				guard let captured = environment.context.queryGenerationToken,
					captured !== NSQueryGenerationToken.current else {
					throw dashboardError("Could not capture a consistent database snapshot.")
				}
				generation = captured
				next()
			} catch {
				for pin in pins { publish(PinnedQueryCard(pin: pin, state: .unavailable("Could not take a consistent database snapshot."))) }
				finishRecords(.failure(error)); finish()
			}
		}
	}

	func cancel() {
		environment.perform { [self] in query?.stop(); query = nil; environment.context.reset(); generation = nil }
	}

	private func next() {
		guard task?.isCancelled == false else { return }
		query = nil; currentCard = nil
		guard index < pins.count else { finish(); return }
		let pin = pins[index], token = UUID(); attempt = token
		currentCard = PinnedQueryCard(pin: pin, state: .loading)
		do {
			guard let generation = generation else { throw dashboardError("The database snapshot is unavailable.") }
			environment.context.reset()
			try environment.context.setQueryGenerationFrom(generation)
			let stored = try resolve(pin)
			let definition = try DashboardDefinitionSnapshot.capture(stored)
			let fresh = try stored.convert()
			guard fresh.expression?.isValid() != false else { throw dashboardError("This saved query has an invalid restriction. Edit it in the query builder.") }
			try configureReadContext(fresh, context: environment)
			let type = try injected(QueryFactory.self).sampleTypeFor(fresh)
			currentCard = PinnedQueryCard(pin: PinnedQueryReference(id: pin.id, lastKnownName: String(stored.name.prefix(200))),
				sampleTypeName: type.name, queryDescription: describe(fresh), state: .loading)
			query = fresh
			DispatchQueue.main.asyncAfter(deadline: .now() + timeout) { [weak self] in
				guard let self = self else { return }
				self.environment.perform { [weak self] in
					guard let self = self, self.attempt == token, self.query != nil, self.task?.isCancelled == false else { return }
					self.query?.stop()
					self.failed(dashboardError("This query took too long to refresh. Pull to refresh and try again."))
				}
			}
			fresh.runQuery { [weak self] (result: QueryResult?, error: Error?) in
				guard let self = self, self.attempt == token, self.task?.isCancelled == false else { return }
				self.query = nil
				if let error = error, !(error is NoSamplesFoundQueryError) { self.failed(error); return }
				let samples = result?.samples ?? []
				let ratings = type == MoodImpl.self || type == FatigueImpl.self || type == PainImpl.self
				let values = samples.map { sample -> PinnedQuerySummaryRecord in
					let dates = sample.dates()
					if ratings, let object = sample as? NSManagedObject {
						return PinnedQuerySummaryRecord(start: dates[.start], end: dates[.end],
							rating: object.value(forKey: "rating") as? Double,
							minimum: object.value(forKey: "minRating") as? Double,
							maximum: object.value(forKey: "maxRating") as? Double)
					}
					return PinnedQuerySummaryRecord(start: dates[.start], end: dates[.end])
				}
				if var card = self.currentCard {
					card.state = .ready(PinnedQuerySummary(records: values, evaluatedAt: self.date, includeRatings: ratings)); self.publish(card)
				}
				if self.records != nil { self.resolveForUI(samples, pin: pin, definition: definition) }
				self.index += 1
				// Avoid recursive synchronous Core Data completions and release each
				// card's full result before fetching the next card.
				self.environment.perform { [weak self] in self?.next() }
			}
		} catch { failed(error) }
	}

	private func resolve(_ pin: PinnedQueryReference) throws -> StoredQuery {
		guard let url = URL(string: pin.id),
			let id = environment.context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url),
			let stored = try environment.context.existingObject(with: id) as? StoredQuery,
			!stored.isDeleted, stored.parentQuery == nil else {
			throw dashboardError("This saved query is unavailable. Unpin it or choose another saved query.")
		}
		return stored
	}

	private func describe(_ query: Query) -> String {
		var text = query.expression?.description ?? "All records"
		if let child = query.subQuery { text += " · " + child.matcher.description + " (" + describe(child.query) + ")" }
		return text
	}

	private func failed(_ error: Error) {
		if var card = currentCard { card.state = .unavailable(error.localizedDescription); publish(card) }
		finishRecords(.failure(error)); query = nil; index += 1
		environment.perform { [weak self] in self?.next() }
	}

	private func publish(_ card: PinnedQueryCard) {
		DispatchQueue.main.async { [weak task, onCard] in guard task?.isCancelled == false else { return }; onCard(card) }
	}
	private func finishRecords(_ result: Result<PinnedQueryDashboardRecords, Error>) {
		guard let records = records else { return }
		DispatchQueue.main.async { [weak task] in guard task?.isCancelled == false else { return }; records(result) }
	}
	private func resolveForUI(_ samples: [Sample], pin: PinnedQueryReference, definition: [String]) {
		// A query has exactly one sample type. Worker managed objects are reduced
		// to IDs; HealthKit wrappers contain no Core Data objects.
		let ids = samples.compactMap { ($0 as? NSManagedObject)?.objectID }
		let health = ids.isEmpty ? samples : []
		DispatchQueue.main.async { [root, weak task, records, date] in
			guard task?.isCancelled == false, let records = records else { return }
			do {
				guard let url = URL(string: pin.id), let id = root.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url),
					let stored = try root.existingObject(with: id) as? StoredQuery, !stored.isDeleted else {
					throw dashboardError("The saved query changed before its results could open. Refresh and try again.")
				}
				guard try DashboardDefinitionSnapshot.capture(stored) == definition else {
					throw dashboardError("The saved query changed while its results were loading. Refresh and try again.")
				}
				let resolved: [Sample]
				if ids.isEmpty { resolved = health }
				else {
					resolved = try ids.map { id in
						guard let sample = try root.existingObject(with: id) as? Sample,
							let object = sample as? NSManagedObject, !object.isDeleted else {
							throw dashboardError("Matching records changed before they could open. Refresh and try again.")
						}
						return sample
					}
				}
				records(.success(PinnedQueryDashboardRecords(name: stored.name, query: try stored.convert(), samples: resolved, evaluatedAt: date)))
			} catch { records(.failure(error)) }
		}
	}
	private func finish() {
		query?.stop(); query = nil; environment.context.reset(); generation = nil
		DispatchQueue.main.async { [weak task, completion] in
			guard let task = task, !task.isCancelled else { return }; completion(); task.finish()
		}
	}
}

/// Compare definitions using copied scalar values, not managed objects from two
/// queues. Names are excluded so a rename keeps the pin and matching records.
enum DashboardDefinitionSnapshot {
	static func capture(_ root: NSManagedObject) throws -> [String] {
		var values = [String](), visited = Set<NSManagedObjectID>()
		func scalar(_ value: Any?) throws -> String {
			switch value {
			case nil: return "nil"
			case let value as String: return "string:" + value
			case let value as NSNumber: return "number:" + value.stringValue
			case let value as Date: return "date:\(value.timeIntervalSinceReferenceDate.bitPattern)"
			case let value as Data: return "data:" + value.base64EncodedString()
			case let value as Dosage: return "dosage:\(value.amount.bitPattern):" + value.unit
			case let value as TimeDuration: return "duration:\(value.inUnit(.second).bitPattern)"
			case let value as Frequency: return "frequency:\(value.timesPerTimeUnit.bitPattern):\(value.timeUnit)"
			case let value as TimeOfDay: return "time:\(value.hour):\(value.minute):\(value.second)"
			default: throw dashboardError("This saved query contains a value that cannot be read safely.")
			}
		}
		func visit(_ object: NSManagedObject, depth: Int) throws {
			guard depth < 64, visited.count < 2048, visited.insert(object.objectID).inserted else {
				throw dashboardError("This saved query contains a cycle or is too deeply nested.")
			}
			values.append(object.entity.name ?? "")
			values.append(object.objectID.uriRepresentation().absoluteString)
			for key in object.entity.attributesByName.keys.sorted() {
				if object is StoredQuery && key == "name" { continue }
				values.append(key); values.append(try scalar(object.value(forKey: key)))
			}
			for key in ["storedExpression", "storedSubQuery", "storedExpression1", "storedExpression2", "storedSubExpression"] {
				guard object.entity.relationshipsByName[key] != nil else { continue }
				values.append(key)
				if let child = object.value(forKey: key) as? NSManagedObject { try visit(child, depth: depth + 1) }
				else { values.append("nil") }
			}
		}
		try visit(root, depth: 0)
		return values
	}
}
