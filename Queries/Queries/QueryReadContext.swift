import CoreData
import Foundation

import Common

/// A read-only query tree uses one managed-object queue and one captured clock.
/// The caller owns the context and must not transfer its managed objects to UI.
public final class QueryReadContext {
	public let context: NSManagedObjectContext
	private let date: Date
	private let convertTimeZones: Bool
	private let cancellation: () -> Bool
	public var isCancelled: Bool { cancellation() }

	public init(context: NSManagedObjectContext, date: Date, convertTimeZones: Bool,
		isCancelled: @escaping () -> Bool = { false }) {
		self.context = context
		self.date = date
		self.convertTimeZones = convertTimeZones
		cancellation = isCancelled
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
