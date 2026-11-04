import CoreData
import Foundation
import HealthKit

import BooleanAlgebra
import Common
import DependencyInjection
import Persistence
import Queries
import Samples
import Settings

/// Only a permanent identity crosses the sample's owning queue.
enum QueryInspectionRecordID: Equatable {
	case stored(NSManagedObjectID)
	case health(UUID)

	static func capture(_ sample: Sample) throws -> QueryInspectionRecordID {
		if let object = sample as? NSManagedObject {
			guard !object.isDeleted, !object.objectID.isTemporaryID else {
				throw inspectionError("Save this record before inspecting its match.")
			}
			return .stored(object.objectID)
		}
		if let id = (sample as? HealthKitSample)?.sourceIdentifier { return .health(id) }
		throw inspectionError("This record does not have a supported stable identity.")
	}

	func matches(_ sample: Sample) -> Bool {
		switch self {
		case let .stored(id): return (sample as? NSManagedObject)?.objectID == id
		case let .health(id): return (sample as? HealthKitSample)?.sourceIdentifier == id
		}
	}
}

struct QueryInspectionCount {
	let matched: Int
	let selectedRecordMatches: Bool?
}

struct QueryInspectionReport {
	let explanation: QueryExplanation
	let evaluatedAt: Date
	let counts: [String: QueryInspectionCount]
	let diagnostics: [String]
}

/// Cancelling releases the worker through its own managed-object queue.
final class QueryInspectionTask {
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

protocol QueryInspectionLoading: AnyObject {
	@discardableResult func inspect(_ definition: QueryInspectionDefinition, selectedRecord: QueryInspectionRecordID?,
		completion: @escaping (Result<QueryInspectionReport, Error>) -> Void) -> QueryInspectionTask
}

/// The user explicitly requests these wider diagnostic reads. Each count is an
/// independent execution of an actual condition/group, never a sum of children
/// or a guessed complement. The original query and Results are never mutated.
final class QueryInspectionService: QueryInspectionLoading {
	private let suppliedContext: NSManagedObjectContext?
	private let suppliedConversion: Bool?
	private let clock: () -> Date
	private let timeout: TimeInterval
	init(context: NSManagedObjectContext? = nil, convertTimeZones: Bool? = nil,
		clock: @escaping () -> Date = Date.init, timeout: TimeInterval = 60) {
		suppliedContext = context; suppliedConversion = convertTimeZones
		self.clock = clock; self.timeout = max(0.01, timeout)
	}

	func inspect(_ definition: QueryInspectionDefinition, selectedRecord: QueryInspectionRecordID?,
		completion: @escaping (Result<QueryInspectionReport, Error>) -> Void) -> QueryInspectionTask {
		let task = QueryInspectionTask()
		let start = { [self, weak task] in
			guard let task = task, !task.isCancelled else { return }
			do {
				let root = suppliedContext ?? injected(Database.self).fetchedResultsController(type: StoredQuery.self,
					sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]).managedObjectContext
				guard let coordinator = root.persistentStoreCoordinator else {
					throw inspectionError("The database is not ready. Try again after it opens.")
				}
				let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
				context.persistentStoreCoordinator = coordinator; context.undoManager = nil
				let date = clock()
				guard date.timeIntervalSinceReferenceDate.isFinite else { throw inspectionError("The inspection date is invalid.") }
				let worker = QueryInspectionWorker(context: context, definition: definition,
					conversion: suppliedConversion ?? injected(Settings.self).convertTimeZones,
					date: date, selectedRecord: selectedRecord, task: task, completion: completion)
				task.onCancel { worker.cancel() }
				worker.start(timeout: timeout)
			} catch {
				completion(.failure(error)); task.finish()
			}
		}
		if Thread.isMainThread { start() } else { DispatchQueue.main.async(execute: start) }
		return task
	}
}

private final class QueryInspectionWorker {
	private struct Point {
		let path: String
		let query: Query
		let isRoot: Bool
	}
	private let environment: QueryReadContext
	private let definition: QueryInspectionDefinition
	private let conversion: Bool
	private let date: Date
	private let calendarSignature: [String]
	private let selectedRecord: QueryInspectionRecordID?
	private weak var task: QueryInspectionTask?
	private let completion: (Result<QueryInspectionReport, Error>) -> Void
	private var rootQuery: Query?
	private var points: [Point] = []
	private var index = 0
	private var active: Query?
	private var counts: [String: QueryInspectionCount] = [:]
	private var finished = false

	init(context: NSManagedObjectContext, definition: QueryInspectionDefinition, conversion: Bool, date: Date,
		selectedRecord: QueryInspectionRecordID?, task: QueryInspectionTask,
		completion: @escaping (Result<QueryInspectionReport, Error>) -> Void) {
		self.definition = definition; self.conversion = conversion; self.date = date
		calendarSignature = Self.calendarSignature(at: date)
		self.selectedRecord = selectedRecord; self.task = task; self.completion = completion
		environment = QueryReadContext(context: context, date: date, convertTimeZones: conversion,
			cacheHealthResults: true, isCancelled: { [weak task] in task?.isCancelled != false })
	}

	func start(timeout: TimeInterval) {
		DispatchQueue.main.asyncAfter(deadline: .now() + timeout) { [weak self] in
			self?.environment.perform { [weak self] in
				guard let self = self, !self.finished else { return }
				self.finish(.failure(inspectionError("Inspection took too long. Add narrower conditions or try again. No query was changed.")))
			}
		}
		environment.perform { [self] in
			guard task?.isCancelled == false else { cleanup(); return }
			do {
				// Pin lazily, force a store read, then hold the concrete generation
				// for this whole inspection. Never reset between condition reads.
				try environment.context.setQueryGenerationFrom(.current)
				let read = StoredQuery.fetchRequest(); read.fetchLimit = 1; read.returnsObjectsAsFaults = false
				_ = try environment.context.fetch(read)
				guard let token = environment.context.queryGenerationToken, token !== NSQueryGenerationToken.current else {
					throw inspectionError("Could not capture a consistent database snapshot.")
				}
				let query = try definition.restore(in: environment.context)
				rootQuery = query
				_ = try QueryExplanationBuilder.explain(query: query, evaluatedAt: date, convertTimeZones: conversion)
				try add(query, depth: 0)
				next()
			} catch { finish(.failure(error)) }
		}
	}

	func cancel() { environment.perform { [self] in finished = true; cleanup() } }

	private func add(_ query: Query, depth: Int) throws {
		let path = "q\(depth)"
		let factory = injected(QueryFactory.self)
		let type = try factory.sampleTypeFor(query)
		let all = try factory.queryFor(type)
		points.append(Point(path: path + "/all", query: all, isRoot: depth == 0))
		if let expression = query.expression {
			// If one unsupported SQL predicate makes the original tree fall back
			// to its evaluator, inspect its children through that same evaluator.
			// Otherwise standalone child SQL could explain different nil rules.
			let evaluateInMemory = !(type is HealthKitSample.Type) && expression.predicate() == nil
			try add(expression, path: path + "/expression", type: type, isRoot: depth == 0,
				evaluateInMemory: evaluateInMemory)
		}
		points.append(Point(path: path + "/results", query: query, isRoot: depth == 0))
		if let child = query.subQuery?.query { try add(child, depth: depth + 1) }
	}

	private func add(_ expression: BooleanExpression, path: String, type: Sample.Type, isRoot: Bool,
		evaluateInMemory: Bool) throws {
		let query = try injected(QueryFactory.self).queryFor(type)
		query.expression = evaluateInMemory ? InspectionEvaluationExpression(expression) : expression
		points.append(Point(path: path, query: query, isRoot: isRoot))
		switch expression {
		case let value as AndExpression:
			try add(value.expression1, path: path + "/0", type: type, isRoot: isRoot, evaluateInMemory: evaluateInMemory)
			try add(value.expression2, path: path + "/1", type: type, isRoot: isRoot, evaluateInMemory: evaluateInMemory)
		case let value as OrExpression:
			try add(value.expression1, path: path + "/0", type: type, isRoot: isRoot, evaluateInMemory: evaluateInMemory)
			try add(value.expression2, path: path + "/1", type: type, isRoot: isRoot, evaluateInMemory: evaluateInMemory)
		case let value as NotExpression:
			try add(value.subExpression, path: path + "/0", type: type, isRoot: isRoot, evaluateInMemory: evaluateInMemory)
		case let value as BooleanExpressionGroup:
			try add(value.subExpression, path: path + "/0", type: type, isRoot: isRoot, evaluateInMemory: evaluateInMemory)
		default: break
		}
	}

	private func next() {
		guard !finished, task?.isCancelled == false else { return }
		guard calendarSignature == Self.calendarSignature(at: date) else {
			finish(.failure(inspectionError("The device calendar or time zone changed during inspection. Inspect again to use the new date boundaries.")))
			return
		}
		guard index < points.count else {
			do {
				guard let query = rootQuery else { throw inspectionError("The query explanation is unavailable.") }
				// Health quantities have now initialized their units. Render using
				// the labels captured with those cached numeric sample values.
				let explanation = try QueryExplanationBuilder.explain(query: query, evaluatedAt: date, convertTimeZones: conversion)
				finish(.success(QueryInspectionReport(explanation: explanation, evaluatedAt: date,
					counts: counts, diagnostics: diagnostics())))
			} catch { finish(.failure(error)) }
			return
		}
		let point = points[index]
		do {
			try configureReadContext(point.query, context: environment)
			active = point.query
			point.query.runQuery { [weak self, weak query = point.query] (result: QueryResult?, error: Error?) in
				guard let self = self, !self.finished, self.task?.isCancelled == false,
					let query = query, self.active === query else { return }
				self.active = nil
				if let error = error, !(error is NoSamplesFoundQueryError) { self.finish(.failure(error)); return }
				let samples = result?.samples ?? []
				self.counts[point.path] = QueryInspectionCount(matched: samples.count,
					selectedRecordMatches: point.isRoot ? self.selectedRecord.map { selected in samples.contains(where: selected.matches) } : nil)
				self.index += 1
				// A context hop releases this result and avoids recursive synchronous
				// callbacks when the query consists entirely of Core Data nodes.
				self.environment.perform { [weak self] in self?.next() }
			}
		} catch { finish(.failure(error)) }
	}

	private func diagnostics() -> [String] {
		var messages = ["Counts for each condition or group are independent reads of all visible records of that data type. OR counts overlap; never add them. NOT uses the query engine's missing-value rules, rather than subtracting its child's count."]
		let total = counts["q0/all"]?.matched ?? 0
		let final = counts["q0/results"]?.matched ?? 0
		if total == 0 {
			messages.append("No visible records of this type were found in this snapshot. Check that records exist and that the selected data type is correct.")
		} else if final == 0 {
			let beforeRelation = counts["q0/expression"]?.matched ?? total
			if beforeRelation == 0 {
				messages.append("No records satisfy the complete condition tree. Review the condition counts, date boundaries, units, and missing optional values. Conditions can each match records separately while their AND group matches none.")
			} else {
				messages.append("The conditions match \(beforeRelation) records, but the subquery relationship leaves no matches. Check its reference records, date relationship, and most-recent setting.")
			}
		}
		if selectedRecord != nil {
			if counts["q0/all"]?.selectedRecordMatches != true {
				messages.append("The selected record is no longer visible in this snapshot. It may have changed or been deleted since Results were loaded.")
			} else if counts["q0/results"]?.selectedRecordMatches == false {
				messages.append("The selected record does not match this snapshot's complete query. Results or relative dates may have changed; refresh Results to compare.")
			} else { messages.append("The selected record satisfies the complete query in this snapshot. Its condition and group rows show the independently checked matches.") }
		}
		messages.append("Inspection never removes a condition, changes Results, or interprets unsupported requests. Edit the builder yourself to change a query.")
		return messages
	}

	private func finish(_ result: Result<QueryInspectionReport, Error>) {
		guard !finished else { return }
		finished = true; cleanup()
		DispatchQueue.main.async { [weak task, completion] in
			guard let task = task, !task.isCancelled else { return }
			completion(result); task.finish()
		}
	}

	private func cleanup() {
		active?.stop(); active = nil
		points.removeAll(); rootQuery = nil
		environment.context.reset()
		try? environment.context.setQueryGenerationFrom(nil)
	}

	private static func calendarSignature(at date: Date) -> [String] {
		let calendar = Calendar.autoupdatingCurrent
		let zone = TimeZone.autoupdatingCurrent
		return [String(describing: calendar.identifier), String(calendar.firstWeekday),
			String(calendar.minimumDaysInFirstWeek), calendar.timeZone.identifier,
			String(calendar.timeZone.secondsFromGMT(for: date)), zone.identifier,
			String(zone.secondsFromGMT(for: date)), calendar.locale?.identifier ?? ""]
	}
}

private func inspectionError(_ message: String) -> Error {
	NSError(domain: "QueryInspection", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
}

/// A diagnostic child inherits its complete expression's execution strategy.
/// This wrapper is never saved or shown as a user-authored expression.
private struct InspectionEvaluationExpression: BooleanExpression {
	let expression: BooleanExpression
	init(_ expression: BooleanExpression) { self.expression = expression }
	var description: String { expression.description }
	func evaluate(_ parameters: [UserInfoKey: Any]?) throws -> Bool { try expression.evaluate(parameters) }
	func isValid() -> Bool { expression.isValid() }
	func copy() -> BooleanExpression { InspectionEvaluationExpression(expression.copy()) }
	func equalTo(_ other: BooleanExpression) -> Bool {
		guard let other = other as? InspectionEvaluationExpression else { return false }
		return expression.equalTo(other.expression)
	}
	func predicate() -> NSPredicate? { nil }
}
