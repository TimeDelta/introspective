import CoreData
import Foundation

import AttributeRestrictions
import Attributes
import BooleanAlgebra
import Common
import DependencyInjection
import Queries
import Samples

/// A query definition can leave its owning queue only after its mutable values
/// and managed references have been reduced to values and permanent identities.
/// Restoring resolves those identities in the reader's own store generation.
internal struct QueryInspectionDefinition: Equatable {
	private let root: QueryNode

	static func capture(_ query: Query) throws -> QueryInspectionDefinition {
		var budget = CaptureBudget()
		return QueryInspectionDefinition(root: try QueryNode.capture(query, budget: &budget, depth: 0))
	}

	/// Call on the supplied context's owning queue.
	func restore(in context: NSManagedObjectContext) throws -> Query { try root.restore(in: context) }

	private struct CaptureBudget {
		var queries = Set<ObjectIdentifier>()
		var expressions = Set<ObjectIdentifier>()
		var nodes = 0
		mutating func visit() throws {
			nodes += 1
			guard nodes <= 512 else { throw definitionError("This query has too many conditions to inspect.") }
		}
	}

	private final class QueryNode: Equatable {
		let type: Sample.Type
		let mostRecent: Bool
		let expression: Expression?
		let matcher: Matcher?
		let child: QueryNode?
		init(type: Sample.Type, mostRecent: Bool, expression: Expression?, matcher: Matcher?, child: QueryNode?) {
			self.type = type; self.mostRecent = mostRecent; self.expression = expression
			self.matcher = matcher; self.child = child
		}

		static func capture(_ query: Query, budget: inout CaptureBudget, depth: Int) throws -> QueryNode {
			try budget.visit()
			guard depth < 32, budget.queries.insert(ObjectIdentifier(query)).inserted else {
				throw definitionError("This query contains a cycle or is nested too deeply.")
			}
			let type = try injected(QueryFactory.self).sampleTypeFor(query)
			let expression = try query.expression.map { try Expression.capture($0, type: type, budget: &budget, depth: 0) }
			let matcher = try query.subQuery.map { try Matcher.capture($0.matcher) }
			let child = try query.subQuery.map { try capture($0.query, budget: &budget, depth: depth + 1) }
			return QueryNode(type: type, mostRecent: query.mostRecentEntryOnly, expression: expression, matcher: matcher, child: child)
		}

		func restore(in context: NSManagedObjectContext) throws -> Query {
			let query = try injected(QueryFactory.self).queryFor(type)
			query.mostRecentEntryOnly = mostRecent
			query.expression = try expression?.restore(type: type, in: context)
			if let child = child, let matcher = matcher {
				query.subQuery = (try matcher.restore(in: context), try child.restore(in: context))
			}
			return query
		}

		static func == (lhs: QueryNode, rhs: QueryNode) -> Bool {
			ObjectIdentifier(lhs.type) == ObjectIdentifier(rhs.type) && lhs.mostRecent == rhs.mostRecent &&
				lhs.expression == rhs.expression && lhs.matcher == rhs.matcher && lhs.child == rhs.child
		}
	}

	private indirect enum Expression: Equatable {
		case and(Expression, Expression)
		case or(Expression, Expression)
		case not(Expression)
		case group(Expression)
		case leaf(Restriction)

		static func capture(_ expression: BooleanExpression, type: Sample.Type,
			budget: inout CaptureBudget, depth: Int) throws -> Expression {
			try budget.visit()
			guard depth < 32, budget.expressions.insert(ObjectIdentifier(expression as AnyObject)).inserted else {
				throw definitionError("This condition contains a cycle or is nested too deeply.")
			}
			defer { budget.expressions.remove(ObjectIdentifier(expression as AnyObject)) }
			func capture(_ expression: BooleanExpression?) throws -> Expression {
				guard let expression = expression else { throw definitionError("This query has an incomplete condition.") }
				return try Self.capture(expression, type: type, budget: &budget, depth: depth + 1)
			}
			switch expression {
			case let expression as AndExpression: return .and(try capture(expression.expression1), try capture(expression.expression2))
			case let expression as OrExpression: return .or(try capture(expression.expression1), try capture(expression.expression2))
			case let expression as NotExpression: return .not(try capture(expression.subExpression))
			case let expression as BooleanExpressionGroup: return .group(try capture(expression.subExpression))
			case let restriction as AttributeRestriction: return .leaf(try Restriction.capture(restriction, type: type))
			default: throw definitionError("This condition cannot be inspected safely.")
			}
		}

		func restore(type: Sample.Type, in context: NSManagedObjectContext) throws -> BooleanExpression {
			switch self {
			case let .and(left, right): return AndExpression(try left.restore(type: type, in: context), try right.restore(type: type, in: context))
			case let .or(left, right): return OrExpression(try left.restore(type: type, in: context), try right.restore(type: type, in: context))
			case let .not(child): return NotExpression(try child.restore(type: type, in: context))
			case let .group(child): return BooleanExpressionGroup(try child.restore(type: type, in: context))
			case let .leaf(restriction): return try restriction.restore(type: type, in: context)
			}
		}
	}

	private struct Parameter: Equatable {
		let id: Int16
		let value: Value
	}

	private struct Restriction: Equatable {
		let type: AttributeRestriction.Type
		let attributeID: Int16
		let parameters: [Parameter]

		static func capture(_ restriction: AttributeRestriction, type: Sample.Type) throws -> Restriction {
			guard let attribute = type.attributes.first(where: {
				$0.id == restriction.restrictedAttribute.id && typeOf($0) == typeOf(restriction.restrictedAttribute) &&
					$0.variableName == restriction.restrictedAttribute.variableName
			}) else { throw definitionError("The condition's attribute is unavailable for this data type.") }
			let restrictionType = Swift.type(of: restriction)
			var supported = injected(AttributeRestrictionFactory.self).typesFor(attribute)
			if attribute is DurationAttribute { supported.append(LessThanDurationAttributeRestriction.self) }
			guard supported.contains(where: { ObjectIdentifier($0) == ObjectIdentifier(restrictionType) }) else {
				throw definitionError("This condition type cannot be inspected safely.")
			}
			// Some historical single-tag convenience initializers omit attributes.
			// The canonical metadata still identifies the value without copying a Tag.
			let parameters: [Parameter]
			if let restriction = restriction as? HasTagAttributeRestriction {
				parameters = [Parameter(id: 0, value: try Value.capture(restriction.tag))]
			} else if let restriction = restriction as? DoesNotHaveTagAttributeRestriction {
				parameters = [Parameter(id: 0, value: try Value.capture(restriction.tag))]
			} else if let restriction = restriction as? HasOneOfTagAttributeRestriction {
				parameters = [Parameter(id: 0, value: try Value.capture(restriction.tags))]
			} else if let restriction = restriction as? DoesNotHaveOneOfTagAttributeRestriction {
				parameters = [Parameter(id: 0, value: try Value.capture(restriction.tags))]
			} else if let restriction = restriction as? SelectOneAttributeRestriction {
				parameters = [Parameter(id: attribute.id, value: try Value.capture(restriction.value))]
			} else {
				parameters = try restriction.attributes.map {
					Parameter(id: $0.id, value: try Value.capture(restriction.value(of: $0)))
				}
			}
			return Restriction(type: restrictionType, attributeID: attribute.id, parameters: parameters)
		}

		func restore(type sampleType: Sample.Type, in context: NSManagedObjectContext) throws -> AttributeRestriction {
			guard let attribute = sampleType.attributes.first(where: { $0.id == attributeID }) else {
				throw definitionError("The condition's attribute is no longer available.")
			}
			// These initializers otherwise read possibleValues[0]. A direct value
			// avoids database-backed selection lists and preserves the exact choice.
			if ObjectIdentifier(type) == ObjectIdentifier(EqualToSelectOneAttributeRestriction.self) ||
				ObjectIdentifier(type) == ObjectIdentifier(NotEqualToSelectOneAttributeRestriction.self) {
				guard let select = attribute as? SelectOneAttribute, parameters.count == 1,
					let value = try parameters[0].value.restore(in: context) else {
					throw definitionError("The condition's selected value is unavailable.")
				}
				if ObjectIdentifier(type) == ObjectIdentifier(EqualToSelectOneAttributeRestriction.self) {
					return EqualToSelectOneAttributeRestriction(restrictedAttribute: attribute, value: value, valueAttribute: select)
				}
				return NotEqualToSelectOneAttributeRestriction(restrictedAttribute: attribute, value: value, valueAttribute: select)
			}
			let restriction = type.init(restrictedAttribute: attribute)
			// TagAttribute.equalTo consults its database-backed choices even for
			// identical metadata. Do not use the generic value/set path for tags.
			if restriction is HasTagAttributeRestriction || restriction is DoesNotHaveTagAttributeRestriction {
				guard parameters.count == 1, let tag = try parameters[0].value.restore(in: context) as? Tag else {
					throw definitionError("The condition's referenced tag is unavailable.")
				}
				if let restriction = restriction as? HasTagAttributeRestriction { restriction.tag = tag }
				if let restriction = restriction as? DoesNotHaveTagAttributeRestriction { restriction.tag = tag }
				return restriction
			}
			if restriction is HasOneOfTagAttributeRestriction || restriction is DoesNotHaveOneOfTagAttributeRestriction {
				guard parameters.count == 1, let tags = try parameters[0].value.restore(in: context) as? [Tag] else {
					throw definitionError("The condition's referenced tags are unavailable.")
				}
				if let restriction = restriction as? HasOneOfTagAttributeRestriction { restriction.tags = tags }
				if let restriction = restriction as? DoesNotHaveOneOfTagAttributeRestriction { restriction.tags = tags }
				return restriction
			}
			for parameter in parameters {
				guard let field = restriction.attributes.first(where: { $0.id == parameter.id }) else {
					throw definitionError("The condition's configuration is no longer supported.")
				}
				try restriction.set(attribute: field, to: parameter.value.restore(in: context))
			}
			return restriction
		}

		static func == (lhs: Restriction, rhs: Restriction) -> Bool {
			ObjectIdentifier(lhs.type) == ObjectIdentifier(rhs.type) && lhs.attributeID == rhs.attributeID && lhs.parameters == rhs.parameters
		}
		private static func typeOf(_ attribute: Attribute) -> ObjectIdentifier { ObjectIdentifier(Swift.type(of: attribute)) }
	}

	private struct Matcher: Equatable {
		let type: SubQueryMatcher.Type
		let parameters: [Value]
		static func capture(_ matcher: SubQueryMatcher) throws -> Matcher {
			let supported: [SubQueryMatcher.Type] = [WithinXCalendarUnitsSubQueryMatcher.self,
				WithinXCalendarUnitsBeforeSubQueryMatcher.self, WithinXCalendarUnitsAfterSubQueryMatcher.self,
				InSameCalendarUnitSubQueryMatcher.self, SameDatesSubQueryMatcher.self,
				SameStartDatesSubQueryMatcher.self, SameEndDatesSubQueryMatcher.self]
			let type = Swift.type(of: matcher)
			guard supported.contains(where: { ObjectIdentifier($0) == ObjectIdentifier(type) }) else {
				throw definitionError("This subquery relationship cannot be inspected safely.")
			}
			return Matcher(type: type, parameters: try matcher.attributes.map { try Value.capture(matcher.value(of: $0)) })
		}
		func restore(in context: NSManagedObjectContext) throws -> SubQueryMatcher {
			let matcher = type.init()
			guard matcher.attributes.count == parameters.count else {
				throw definitionError("This subquery configuration is no longer supported.")
			}
			// Historical matcher metadata reuses ID 0 for both recency and the
			// numeric window. The declared field order disambiguates those fields.
			for (attribute, value) in zip(matcher.attributes, parameters) {
				try matcher.set(attribute: attribute, to: value.restore(in: context))
			}
			return matcher
		}
		static func == (lhs: Matcher, rhs: Matcher) -> Bool {
			ObjectIdentifier(lhs.type) == ObjectIdentifier(rhs.type) && lhs.parameters == rhs.parameters
		}
	}

	private enum Value: Equatable {
		case none, bool(Bool), integer(Int), double(Double), string(String), date(Date), component(Calendar.Component)
		case day(Int), duration(Double), dosage(Double, String), frequency(Double, Calendar.Component), time(Int, Int, Int)
		case object(Reference), tags([Reference]), sleep(Int), protection(Int)

		static func capture(_ value: Any?) throws -> Value {
			guard let value = value else { return .none }
			switch value {
			case let value as NSManagedObject: return .object(try Reference.capture(value))
			case let value as [Tag]: return .tags(try value.map(Reference.capture))
			case let value as Bool: return .bool(value)
			case let value as Int: return .integer(value)
			case let value as Double:
				guard value.isFinite else { throw definitionError("A condition contains an invalid number.") }
				return .double(value)
			case let value as String: return .string(value)
			case let value as Date:
				guard value.timeIntervalSinceReferenceDate.isFinite else { throw definitionError("A condition contains an invalid date.") }
				return .date(value)
			case let value as Calendar.Component: return .component(value)
			case let value as DayOfWeek: return .day(value.intValue)
			case let value as TimeDuration:
				guard value.inUnit(.second).isFinite else { throw definitionError("A condition contains an invalid duration.") }
				return .duration(value.inUnit(.second))
			case let value as Dosage:
				guard value.amount.isFinite else { throw definitionError("A condition contains an invalid dosage.") }
				return .dosage(value.amount, value.unit)
			case let value as Frequency:
				guard value.timesPerTimeUnit.isFinite, Frequency.supportedTimeUnits.contains(value.timeUnit) else {
					throw definitionError("A condition contains an invalid frequency.")
				}
				return .frequency(value.timesPerTimeUnit, value.timeUnit)
			case let value as TimeOfDay:
				guard (0..<24).contains(value.hour), (0..<60).contains(value.minute), (0..<60).contains(value.second) else {
					throw definitionError("A condition contains an invalid time of day.")
				}
				return .time(value.hour, value.minute, value.second)
			case let value as Sleep.State:
				guard let index = Sleep.State.allValues.firstIndex(where: { $0 == value }) else {
					throw definitionError("A condition contains an unsupported sleep state.")
				}
				return .sleep(index)
			case let value as SexualActivity.Protection:
				guard let index = SexualActivity.Protection.allValues.firstIndex(where: { $0 == value }) else {
					throw definitionError("A condition contains an unsupported selection.")
				}
				return .protection(index)
			default: throw definitionError("A condition contains a value that cannot be inspected safely.")
			}
		}

		func restore(in context: NSManagedObjectContext) throws -> Any? {
			switch self {
			case .none: return nil
			case let .bool(value): return value
			case let .integer(value): return value
			case let .double(value): return value
			case let .string(value): return value
			case let .date(value): return value
			case let .component(value): return value
			case let .day(value): return DayOfWeek.fromInt(value)
			case let .duration(value): return TimeDuration(value)
			case let .dosage(amount, unit): return Dosage(amount, unit)
			case let .frequency(amount, unit):
				guard let value = Frequency(amount, unit) else { throw definitionError("The condition's frequency is invalid.") }
				return value
			case let .time(hour, minute, second):
				let value = TimeOfDay(); value.hour = hour; value.minute = minute; value.second = second; return value
			case let .object(reference): return try reference.resolve(in: context)
			case let .tags(references): return try references.map { reference -> Tag in
				guard let tag = try reference.resolve(in: context) as? Tag else { throw definitionError("A referenced tag is unavailable.") }
				return tag
			}
			case let .sleep(value): return Sleep.State.allValues[value]
			case let .protection(value): return SexualActivity.Protection.allValues[value]
			}
		}

	}

	/// Identity alone is insufficient: tag predicates read tag.name. Include
	/// referenced scalar values so a rename is also a definition edit, while
	/// retaining neither the original object nor its managed context.
	private struct Reference: Equatable {
		let id: NSManagedObjectID
		let fingerprint: [String]

		static func capture(_ object: NSManagedObject) throws -> Reference {
			guard !object.isDeleted, !object.objectID.isTemporaryID, object.managedObjectContext != nil else {
				throw definitionError("Save the condition's referenced data before inspecting it.")
			}
			return Reference(id: object.objectID, fingerprint: try scalars(of: object))
		}

		func resolve(in context: NSManagedObjectContext) throws -> NSManagedObject {
			guard let store = id.persistentStore, context.persistentStoreCoordinator?.persistentStores.contains(store) == true,
				let object = try? context.existingObject(with: id), !object.isDeleted else {
				throw definitionError("The condition references data that is no longer available.")
			}
			guard try Self.scalars(of: object) == fingerprint else {
				throw definitionError("Data referenced by this condition changed. Inspect the updated query again.")
			}
			return object
		}

		private static func scalars(of object: NSManagedObject) throws -> [String] {
			func scalar(_ value: Any?) throws -> String {
				switch value {
				case nil: return "nil"
				case let value as String: return "string:" + value
				case let value as NSNumber: return "number:" + value.stringValue
				case let value as Date: return "date:\(value.timeIntervalSinceReferenceDate.bitPattern)"
				case let value as Data: return "data:" + value.base64EncodedString()
				case let value as UUID: return "uuid:" + value.uuidString
				case let value as URL: return "url:" + value.absoluteString
				case let value as Dosage: return "dosage:\(value.amount.bitPattern):" + value.unit
				case let value as TimeDuration: return "duration:\(value.inUnit(.second).bitPattern)"
				case let value as Frequency: return "frequency:\(value.timesPerTimeUnit.bitPattern):\(value.timeUnit)"
				case let value as TimeOfDay: return "time:\(value.hour):\(value.minute):\(value.second)"
				default: throw definitionError("Referenced data contains a value that cannot be inspected safely.")
				}
			}
			var values = [String]()
			for key in object.entity.attributesByName.keys.sorted() {
				values.append(key); values.append(try scalar(object.value(forKey: key)))
			}
			return values
		}
	}
}

private func definitionError(_ message: String) -> Error {
	NSError(domain: "QueryInspectionDefinition", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
}
