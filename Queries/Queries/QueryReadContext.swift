import CoreData
import Foundation

import Common
import Samples

/// A read-only query tree uses one managed-object queue and one captured clock.
/// The caller owns the context and must not transfer its managed objects to UI.
public final class QueryReadContext {
	public let context: NSManagedObjectContext
	private let date: Date
	private let convertTimeZones: Bool
	private let cancellation: () -> Bool
	private let cacheHealthResults: Bool
	private var healthReads: [ObjectIdentifier: HealthRead] = [:]
	private var healthUnitLabels: [ObjectIdentifier: String] = [:]
	private var healthAttributeUnitLabels: [ObjectIdentifier: [Int16: String]] = [:]
	public var isCancelled: Bool { cancellation() }
	var cachesHealthResults: Bool { cacheHealthResults }

	public init(context: NSManagedObjectContext, date: Date, convertTimeZones: Bool,
		cacheHealthResults: Bool = false,
		isCancelled: @escaping () -> Bool = { false }) {
		self.context = context
		self.date = date
		self.convertTimeZones = convertTimeZones
		self.cacheHealthResults = cacheHealthResults
		cancellation = isCancelled
	}

	/// Inspection alone opts into retaining one unfiltered Health read per type.
	/// All access occurs on this context's owning queue. A pending entry also
	/// coalesces equal-type root/subqueries, which can start before either finishes.
	enum HealthReadResult {
		case samples([Sample])
		case failure(Error)
	}
	private enum HealthRead {
		case pending([(HealthReadResult) -> Void])
		case completed(HealthReadResult)
	}

	/// The unit used for this inspection's captured quantity values. Call only
	/// on the context's owning queue; nil means no successful unit read occurred.
	public func capturedHealthUnit(for type: Sample.Type, attributeID: Int16? = nil) -> String? {
		let key = ObjectIdentifier(type)
		if let attributeID = attributeID, let unit = healthAttributeUnitLabels[key]?[attributeID] { return unit }
		return healthUnitLabels[key]
	}

	func recordCapturedHealthUnit(_ unit: String, for type: Sample.Type, attributeID: Int16? = nil) {
		guard cacheHealthResults, !isCancelled else { return }
		let key = ObjectIdentifier(type)
		if let attributeID = attributeID { healthAttributeUnitLabels[key, default: [:]][attributeID] = unit }
		else { healthUnitLabels[key] = unit }
	}

	/// Returns true only when the caller should initiate the underlying read.
	func beginHealthRead(for type: Sample.Type, completion: @escaping (HealthReadResult) -> Void) -> Bool {
		guard cacheHealthResults else { return true }
		guard !isCancelled else { return false }
		let key = ObjectIdentifier(type)
		switch healthReads[key] {
		case let .completed(result)?: completion(result); return false
		case var .pending(waiters)?:
			waiters.append(completion); healthReads[key] = .pending(waiters); return false
		case nil:
			healthReads[key] = .pending([completion]); return true
		}
	}

	/// Returns true when the cache owns delivery, including after cancellation.
	/// Failed filters never enter this cache: they belong to an individual query.
	func completeHealthRead(for type: Sample.Type, with result: HealthReadResult) -> Bool {
		guard cacheHealthResults else { return false }
		let key = ObjectIdentifier(type)
		guard !isCancelled else { healthReads.removeValue(forKey: key); return true }
		guard case let .pending(waiters)? = healthReads[key] else { return true }
		healthReads[key] = .completed(result)
		for completion in waiters {
			guard !isCancelled else { break }
			completion(result)
		}
		return true
	}

	public func perform(_ action: @escaping () -> Void) {
		context.perform { self.execute(action) }
	}

	/// Use only while already executing on the context's owning queue.
	public func execute(_ action: () -> Void) {
		QueryReadScope.with(date: date, convertTimeZones: convertTimeZones, action)
	}
}

public protocol ReadContextQuery: Query {
	var readContext: QueryReadContext? { get set }
}

/// Configure every node together so nested queries cannot fall back to the
/// main context. Invalid trees leave all nodes unchanged.
public func configureReadContext(_ query: Query, context: QueryReadContext) throws {
	var visited = Set<ObjectIdentifier>()
	var nodes = [ReadContextQuery]()
	var current: Query? = query
	while let query = current {
		guard nodes.count < 32, visited.insert(ObjectIdentifier(query)).inserted else {
			throw GenericError("Query contains a cycle or is nested too deeply.")
		}
		guard let node = query as? ReadContextQuery else {
			throw GenericError("This query does not support isolated background reads.")
		}
		nodes.append(node)
		current = query.subQuery?.query
	}
	for node in nodes { node.readContext = context }
}
