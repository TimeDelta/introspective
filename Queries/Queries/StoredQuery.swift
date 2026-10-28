import CoreData
import Foundation

import BooleanAlgebra
import Common
import DependencyInjection
import Persistence
import Samples

public final class StoredQuery: NSManagedObject, CoreDataObject {
	public static let entityName = "Query"

	public func convert() throws -> Query { try convert(depth: 0) }

	private func convert(depth: Int) throws -> Query {
		guard depth < 32 else { throw GenericError("Saved query is nested too deeply.") }
		let factory = injected(SampleFactory.self)
		guard let sampleType = factory.allTypes().first(where: { factory.sampleTypeId(for: $0) == sampleTypeId }) else {
			throw GenericError("This saved query uses an unsupported data type.")
		}
		let query = try injected(QueryFactory.self).queryFor(sampleType)
		query.expression = try storedExpression?.convert()
		query.mostRecentEntryOnly = mostRecentEntryOnly
		if let child = storedSubQuery {
			guard let data = matcherData else { throw GenericError("Saved subquery matcher is missing.") }
			let matcher = try JSONDecoder().decode(SavedMatcher.self, from: data).restore()
			query.subQuery = (matcher, try child.convert(depth: depth + 1))
		}
		return query
	}

	public func populate(from query: Query, withName name: String, using transaction: Transaction) throws {
		try populate(from: query, withName: name, using: transaction, visited: [])
	}

	private func populate(from query: Query, withName name: String, using transaction: Transaction,
		visited: Set<ObjectIdentifier>) throws {
		guard visited.count < 32, !visited.contains(ObjectIdentifier(query)) else {
			throw GenericError("Query contains a cycle or is nested too deeply.")
		}
		guard query.expression?.isValid() != false else { throw GenericError("The query contains an invalid restriction.") }
		if let expression = query.expression { _ = try expression.partsForEditing() }
		var visited = visited
		visited.insert(ObjectIdentifier(query))
		self.name = try StoredQueriesDAOImpl.validName(name)
		let sampleType = try injected(QueryFactory.self).sampleTypeFor(query)
		sampleTypeId = injected(SampleFactory.self).sampleTypeId(for: sampleType)
		guard sampleTypeId >= 0 else { throw GenericError("This query type cannot be saved.") }
		mostRecentEntryOnly = query.mostRecentEntryOnly
		storedExpression = try query.expression?.stored(for: sampleType, using: transaction)
		if let sub = query.subQuery {
			matcherData = try JSONEncoder().encode(SavedMatcher(sub.matcher))
			let child = try transaction.new(StoredQuery.self)
			try child.populate(from: sub.query, withName: name, using: transaction, visited: visited)
			storedSubQuery = child
		}
	}

	@nonobjc public class func fetchRequest() -> NSFetchRequest<StoredQuery> { NSFetchRequest(entityName: entityName) }
	@NSManaged public var name: String
	@NSManaged public var sampleTypeId: Int16
	@NSManaged public var mostRecentEntryOnly: Bool
	@NSManaged public var storedExpression: StoredBooleanExpression?
	@NSManaged public var storedSubQuery: StoredQuery?
	@NSManaged public var parentQuery: StoredQuery?
	@NSManaged public var matcherData: Data?
}

/// Stable identifiers and scalar values; never archive arbitrary matcher classes.
private struct SavedMatcher: Codable {
	// Append only: these positions are persisted.
	private static let types: [SubQueryMatcher.Type] = [WithinXCalendarUnitsSubQueryMatcher.self,
		WithinXCalendarUnitsBeforeSubQueryMatcher.self, WithinXCalendarUnitsAfterSubQueryMatcher.self,
		InSameCalendarUnitSubQueryMatcher.self, SameDatesSubQueryMatcher.self,
		SameStartDatesSubQueryMatcher.self, SameEndDatesSubQueryMatcher.self]
	private static let units: [Calendar.Component] = [.year, .quarter, .month, .weekOfMonth, .weekOfYear,
		.day, .hour, .minute, .second, .nanosecond]
	var kind: Int
	var mostRecent: Bool
	var count: Int?
	var unit: String?

	init(_ matcher: SubQueryMatcher) throws {
		guard let index = Self.types.firstIndex(where: { $0 == type(of: matcher) }) else {
			throw GenericError("This subquery matcher cannot be saved.")
		}
		kind = index
		mostRecent = matcher.mostRecentOnly
		switch matcher {
		case let m as WithinXCalendarUnitsSubQueryMatcher: count = m.numberOfTimeUnits; unit = String(describing: m.timeUnit)
		case let m as WithinXCalendarUnitsBeforeSubQueryMatcher: count = m.numberOfTimeUnits; unit = String(describing: m.timeUnit)
		case let m as WithinXCalendarUnitsAfterSubQueryMatcher: count = m.numberOfTimeUnits; unit = String(describing: m.timeUnit)
		case let m as InSameCalendarUnitSubQueryMatcher: unit = String(describing: m.timeUnit)
		default: break
		}
	}

	func restore() throws -> SubQueryMatcher {
		guard Self.types.indices.contains(kind) else { throw GenericError("Unsupported saved matcher.") }
		var matcher = Self.types[kind].init()
		matcher.mostRecentOnly = mostRecent
		if kind < 4 {
			guard let unit = Self.units.first(where: { String(describing: $0) == self.unit }) else {
				throw GenericError("Invalid saved calendar unit.")
			}
			if kind < 3 && count == nil { throw GenericError("Missing saved matcher amount.") }
			switch matcher {
			case let m as WithinXCalendarUnitsSubQueryMatcher: m.numberOfTimeUnits = count!; m.timeUnit = unit
			case let m as WithinXCalendarUnitsBeforeSubQueryMatcher: m.numberOfTimeUnits = count!; m.timeUnit = unit
			case let m as WithinXCalendarUnitsAfterSubQueryMatcher: m.numberOfTimeUnits = count!; m.timeUnit = unit
			case let m as InSameCalendarUnitSubQueryMatcher: m.timeUnit = unit
			default: break
			}
		}
		return matcher
	}
}
