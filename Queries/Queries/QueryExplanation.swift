import Foundation
import HealthKit
import SwiftDate

import Attributes
import AttributeRestrictions
import BooleanAlgebra
import Common
import DependencyInjection
import Samples

/// Display values only. This tree never executes, rewrites, or persists a query.
public enum QueryExplanationKind: String {
	case condition, all, any, not, group
}

public struct QueryExplanationNode {
	public let path: String
	public let kind: QueryExplanationKind
	public let text: String
	public let details: [String]
	public let children: [QueryExplanationNode]
}

/// A reference type allows an immutable, recursively nested subquery description.
/// There are no samples, managed objects, closures, or mutable expressions in this value.
public final class QueryExplanation {
	public let path: String
	public let sampleTypeName: String
	public let root: QueryExplanationNode?
	public let subquery: QueryExplanation?
	public let matcherDescription: String?
	public let notes: [String]

	fileprivate init(path: String, sampleTypeName: String, root: QueryExplanationNode?,
		subquery: QueryExplanation?, matcherDescription: String?, notes: [String]) {
		self.path = path; self.sampleTypeName = sampleTypeName; self.root = root
		self.subquery = subquery; self.matcherDescription = matcherDescription; self.notes = notes
	}
}

public enum QueryExplanationError: Error, LocalizedError {
	case unsupported, invalid, tooComplex
	public var errorDescription: String? {
		switch self {
		case .unsupported: return "This query contains a condition that cannot be explained safely. No approximation was made."
		case .invalid: return "This query has an incomplete or invalid condition. Review it in the query editor."
		case .tooComplex: return "This query is too deeply nested or complex to inspect safely."
		}
	}
}

public enum QueryExplanationBuilder {
	public static func explain(query: Query, evaluatedAt: Date, convertTimeZones: Bool) throws -> QueryExplanation {
		guard evaluatedAt.timeIntervalSince1970.isFinite, evaluatedAt >= .distantPast, evaluatedAt <= .distantFuture else { throw QueryExplanationError.invalid }
		var builder = Builder(date: evaluatedAt, convertTimeZones: convertTimeZones)
		return try builder.stage(query, index: 0)
	}

	private struct Builder {
		let date: Date
		let convertTimeZones: Bool
		var activeQueries = Set<ObjectIdentifier>()
		var activeExpressions = Set<ObjectIdentifier>()
		var nodes = 0

		mutating func stage(_ query: Query, index: Int) throws -> QueryExplanation {
			guard index < 32 else { throw QueryExplanationError.tooComplex }
			let identifier = ObjectIdentifier(query)
			guard activeQueries.insert(identifier).inserted else { throw QueryExplanationError.invalid }
			defer { activeQueries.remove(identifier) }
			let sampleType: Sample.Type
			do { sampleType = try QueryFactoryImpl().sampleTypeFor(query) }
			catch { throw QueryExplanationError.unsupported }
			let path = "q\(index)"
			var units: [Int16: String] = [:]
			if let context = (query as? ReadContextQuery)?.readContext {
				for attribute in sampleType.attributes {
					if let label = context.capturedHealthUnit(for: sampleType, attributeID: attribute.id) { units[attribute.id] = label }
				}
			}
			let root = try query.expression.map { try expression($0, path: path + "/expression", depth: 0,
				sampleType: sampleType, capturedUnits: units) }
			var child: QueryExplanation?
			var matcher: String?
			if let subquery = query.subQuery {
				matcher = try matcherText(subquery.matcher)
				child = try stage(subquery.query, index: index + 1)
			}
			var notes = ["All conditions retain their original grouping. OR counts can overlap and must not be added together.",
				"Relative dates are evaluated at " + instant(date) + ". Calendar periods use the device calendar and time zone.",
				convertTimeZones ? "Time zone conversion is on: the query uses the app's converted record timestamps." :
					"Time zone conversion is off: the query uses the original record timestamps.",
				"Missing values are not assumed to be zero. Condition and NOT counts follow the query's actual matching rules."]
			if query.mostRecentEntryOnly {
				notes.append("This query stores a most-recent-only request, but the current query engine does not apply that flag to its results. A subquery matcher's most-recent option is applied separately.")
			}
			if sampleType is HealthKitSample.Type {
				notes.append("Health counts include only records Health makes available to this app. An empty result cannot distinguish no records from restricted read access. Health reads are not an atomic snapshot with the app's database.")
				if units.isEmpty, sampleType is HealthKitQuantitySample.Type || sampleType is BloodPressure.Type {
					notes.append("Health quantity units shown in this preview are the currently loaded units. Inspecting counts captures the units used for that read.")
				}
			}
			return QueryExplanation(path: path, sampleTypeName: sampleType.name, root: root,
				subquery: child, matcherDescription: matcher, notes: notes)
		}

		mutating func expression(_ value: BooleanExpression, path: String, depth: Int,
			sampleType: Sample.Type, capturedUnits: [Int16: String]) throws -> QueryExplanationNode {
			guard depth < 64, nodes < 1024 else { throw QueryExplanationError.tooComplex }
			nodes += 1
			// All supported expression nodes are classes. Reject unknown values before
			// invoking their description, validity checks, evaluator, or copy methods.
			guard value is AndExpression || value is OrExpression || value is NotExpression ||
				value is BooleanExpressionGroup || value is AttributeRestriction else { throw QueryExplanationError.unsupported }
			let identifier = ObjectIdentifier(value as AnyObject)
			guard activeExpressions.insert(identifier).inserted else { throw QueryExplanationError.invalid }
			defer { activeExpressions.remove(identifier) }
			let kind: QueryExplanationKind
			let text: String
			let details: [String]
			let expressions: [BooleanExpression]
			if let and = value as? AndExpression {
				guard let left = and.expression1, let right = and.expression2 else { throw QueryExplanationError.invalid }
				kind = .all; text = "ALL of these conditions (AND)"; details = ["The same record must satisfy both branches."]; expressions = [left, right]
			} else if let or = value as? OrExpression {
				guard let left = or.expression1, let right = or.expression2 else { throw QueryExplanationError.invalid }
				kind = .any; text = "ANY of these conditions (OR)"; details = ["A record satisfying both branches is counted once in this group."]; expressions = [left, right]
			} else if let not = value as? NotExpression {
				guard let child = not.subExpression else { throw QueryExplanationError.invalid }
				kind = .not; text = "NOT the following condition or group"; details = ["Negation applies to the complete child group. Missing values follow the actual query rules."]; expressions = [child]
			} else if let group = value as? BooleanExpressionGroup {
				guard let child = group.subExpression else { throw QueryExplanationError.invalid }
				kind = .group; text = "Grouped conditions"; details = ["These parentheses are preserved."]; expressions = [child]
			} else if let restriction = value as? AttributeRestriction {
				let leaf = try leafText(restriction, sampleType: sampleType, capturedUnit: capturedUnits[restriction.restrictedAttribute.id])
				kind = .condition; text = leaf.text
				if restriction is ActivityHasTagAttributeRestriction || restriction is ActivityDoesNotHaveTagAttributeRestriction ||
					restriction is ActivityHasOneOfTagAttributeRestriction || restriction is ActivityDoesNotHaveOneOfTagAttributeRestriction {
					details = leaf.details + ["This activity-tag condition includes tags on the activity definition as well as tags on the individual activity record."]
				} else { details = leaf.details }
				expressions = []
			} else { throw QueryExplanationError.unsupported }
			var children: [QueryExplanationNode] = []
			for (index, child) in expressions.enumerated() {
				children.append(try expression(child, path: path + "/\(index)", depth: depth + 1,
					sampleType: sampleType, capturedUnits: capturedUnits))
			}
			return QueryExplanationNode(path: path, kind: kind, text: text, details: details, children: children)
		}

		func leafText(_ restriction: AttributeRestriction, sampleType: Sample.Type, capturedUnit: String?) throws -> (text: String, details: [String]) {
			guard Self.supportedRestrictions.contains(ObjectIdentifier(type(of: restriction))) else { throw QueryExplanationError.unsupported }
			let attribute = restriction.restrictedAttribute
			guard sampleType.attributes.contains(where: {
				$0.id == attribute.id && type(of: $0) == type(of: attribute) && $0.name == attribute.name && $0.variableName == attribute.variableName
			}) else { throw QueryExplanationError.invalid }
			let name = attribute.name
			let calendar = injected(CalendarUtil.self)
			if let current = restriction as? InCurrentTimeUnitDateAttributeRestriction {
				try validUnit(current.timeUnit)
				return (name + " is in the current " + unitName(current.timeUnit),
					["From " + instant(calendar.start(of: current.timeUnit, in: date)) + " through " + instant(calendar.end(of: current.timeUnit, in: date)) + "; both boundaries are included. A missing date does not match."])
			}
			if let past = restriction as? InThePastXTimeUnitsDateAttributeRestriction {
				try validUnit(past.timeUnit)
				guard (0...1_000_000).contains(past.numberOfTimeUnits) else { throw QueryExplanationError.invalid }
				var components = DateComponents(); components.setValue(past.numberOfTimeUnits, for: past.timeUnit)
				let start = date - components
				return (name + " is in the past \(past.numberOfTimeUnits) " + unitName(past.timeUnit, plural: past.numberOfTimeUnits != 1),
					["From " + instant(start) + " through " + instant(date) + "; both boundaries are included. This is a rolling calendar lookback, not the previous complete calendar period. A missing date does not match."])
			}
			if let on = restriction as? OnDateAttributeRestriction {
				try validDate(on.date)
				if convertTimeZones {
					return (name + " is on the same calendar day as " + instant(on.date), ["The converted record date must share the selected calendar day. A missing date does not match."])
				}
				return (name + " is on the same calendar day as " + instant(on.date),
					["Stored-date filtering runs from " + instant(calendar.start(of: .day, in: on.date)) + " through " + instant(calendar.end(of: .day, in: on.date)) + "; both boundaries are included. In-memory evaluation compares calendar-day components instead, so fractional timestamps in the last second of the day can differ from stored-date filtering. Inspection follows the query's actual evaluation path. A missing date does not match."])
			}
			if let after = restriction as? AfterDateAndTimeAttributeRestriction {
				try validDate(after.date)
				return (name + " is strictly after " + instant(after.date), ["The boundary itself is excluded, including its stored fractional seconds. A missing date does not match."])
			}
			if let before = restriction as? BeforeDateAndTimeAttributeRestriction {
				try validDate(before.date)
				return (name + " is strictly before " + instant(before.date), ["The boundary itself is excluded, including its stored fractional seconds. A missing date does not match."])
			}
			if let after = restriction as? AfterDateAttributeRestriction {
				try validDate(after.date)
				return (name + " is after the stored date boundary " + instant(after.date), ["The boundary is excluded. Date-only edits normally place this boundary at the end of the selected day. In-memory date-only comparisons use whole seconds; inspection uses the query's actual matching rule. A missing date does not match."])
			}
			if let before = restriction as? BeforeDateAttributeRestriction {
				try validDate(before.date)
				return (name + " is before the stored date boundary " + instant(before.date), ["The boundary is excluded. Date-only edits normally place this boundary at the start of the selected day. In-memory date-only comparisons use whole seconds; inspection uses the query's actual matching rule. A missing date does not match."])
			}
			if let after = restriction as? AfterTimeOfDayAttributeRestriction {
				return (name + " is strictly after the time of day " + (try timeText(after.timeOfDay)), ["Time-of-day comparisons use whole seconds and ignore fractional seconds. The selected second is excluded. A missing date does not match."])
			}
			if let before = restriction as? BeforeTimeOfDayAttributeRestriction {
				return (name + " is strictly before the time of day " + (try timeText(before.timeOfDay)), ["Time-of-day comparisons use whole seconds and ignore fractional seconds. The selected second is excluded. A missing date does not match."])
			}
			if let weekday = restriction as? OnDayOfWeekAttributeRestriction {
				let days = weekday.daysOfWeek.sorted().map { $0.fullDayName }.joined(separator: ", ")
				return (name + " is on " + (days.isEmpty ? "none of the weekdays" : days), ["The weekday is determined from the record's date. A missing date does not match."])
			}
			if let has = restriction as? HasTagAttributeRestriction {
				guard let tag = has.tag else { throw QueryExplanationError.invalid }
				return (name + " has tag " + quoted(tag.name), ["Tag comparisons follow the existing query's name and case rules."])
			}
			if let lacks = restriction as? DoesNotHaveTagAttributeRestriction {
				guard let tag = lacks.tag else { throw QueryExplanationError.invalid }
				return (name + " does not have tag " + quoted(tag.name), ["A tag condition's treatment of missing tags follows the actual query rule."])
			}
			if let has = restriction as? HasOneOfTagAttributeRestriction {
				return (name + " has at least one of these tags: " + has.tags.map { quoted($0.name) }.joined(separator: ", "), ["Matching more than one listed tag still counts the record once."])
			}
			if let lacks = restriction as? DoesNotHaveOneOfTagAttributeRestriction {
				return (name + " has none of these tags: " + lacks.tags.map { quoted($0.name) }.joined(separator: ", "), ["A tag condition's treatment of missing tags follows the actual query rule."])
			}
			if restriction is EmptyStringAttributeRestriction { return (name + " is empty", ["Both an empty string and a missing value match."]) }
			if restriction is NotEmptyStringAttributeRestriction { return (name + " is not empty", ["An empty string or missing value does not match."]) }
			let stringNote = "Text comparisons ignore case. Counts use the query's actual text and missing-value rules."
			if let contains = restriction as? ContainsStringAttributeRestriction { return (name + " contains " + quoted(contains.substring), [stringNote]) }
			if let starts = restriction as? StartsWithStringAttributeRestriction { return (name + " starts with " + quoted(starts.prefix), [stringNote]) }
			if let ends = restriction as? EndsWithStringAttributeRestriction { return (name + " ends with " + quoted(ends.suffix), [stringNote]) }
			if let equal = restriction as? EqualToSelectOneAttributeRestriction {
				guard equal.value != nil else { throw QueryExplanationError.invalid }
				let value = try equal.selectOneAttribute.convertToDisplayableString(from: equal.value)
				return (name + " equals " + quoted(value), [])
			}
			if let unequal = restriction as? NotEqualToSelectOneAttributeRestriction {
				guard unequal.value != nil else { throw QueryExplanationError.invalid }
				let value = try unequal.selectOneAttribute.convertToDisplayableString(from: unequal.value)
				return (name + " does not equal " + quoted(value), ["A missing value follows the condition's existing comparison rules."])
			}
			let quantityUnit = healthUnit(sampleType, attribute: attribute, capturedUnit: capturedUnit)
			if let text = try comparison(restriction, as: Double.self, format: { number in
				guard number.isFinite else { throw QueryExplanationError.invalid }
				return String(number) + (quantityUnit.map { " " + $0 } ?? "")
			}) { return (text, quantityUnit.map { ["Quantity unit: " + $0 + "."] } ?? []) }
			if let text = try comparison(restriction, as: Int.self, format: { String($0) }) { return (text, []) }
			if let text = try comparison(restriction, as: String.self, format: { quoted($0) }) { return (text, [stringNote]) }
			if let text = try comparison(restriction, as: TimeDuration.self, format: {
				let seconds = $0.inUnit(.second); guard seconds.isFinite else { throw QueryExplanationError.invalid }
				return String(seconds) + " seconds"
			}) { return (text, ["Duration comparisons use elapsed time, expressed here in seconds."]) }
			if let text = try comparison(restriction, as: Dosage.self, format: {
				guard $0.amount.isFinite else { throw QueryExplanationError.invalid }; return $0.description
			}) { return (text, ["Dosages retain their stored amount and unit; comparisons use the app's existing dosage conversion."]) }
			if let text = try comparison(restriction, as: Frequency.self, format: {
				guard $0.timesPerTimeUnit.isFinite, $0.timesPerTimeUnit >= 0, Frequency.supportedTimeUnits.contains($0.timeUnit) else { throw QueryExplanationError.invalid }
				return $0.description
			}) { return (text, []) }
			throw QueryExplanationError.unsupported
		}

		func comparison<T: Comparable>(_ restriction: AttributeRestriction, as: T.Type, format: (T) throws -> String) throws -> String? {
			let operation: String
			let value: T
			if let comparison = restriction as? TypedLessThanAttributeRestrictionBase<T> { operation = "is less than"; value = comparison.value }
			else if let comparison = restriction as? TypedLessThanOrEqualToAttributeRestrictionBase<T> { operation = "is at most"; value = comparison.value }
			else if let comparison = restriction as? TypedGreaterThanAttributeRestrictionBase<T> { operation = "is greater than"; value = comparison.value }
			else if let comparison = restriction as? TypedGreaterThanOrEqualToAttributeRestrictionBase<T> { operation = "is at least"; value = comparison.value }
			else if let comparison = restriction as? TypedEqualToAttributeRestrictionBase<T> {
				guard let typed = comparison.value as? T else { throw QueryExplanationError.invalid }; operation = "equals"; value = typed
			} else if let comparison = restriction as? TypedNotEqualToAttributeRestrictionBase<T> {
				guard let typed = comparison.value as? T else { throw QueryExplanationError.invalid }; operation = "does not equal"; value = typed
			} else { return nil }
			return restriction.restrictedAttribute.name + " " + operation + " " + (try format(value))
		}

		func matcherText(_ matcher: SubQueryMatcher) throws -> String {
			let suffix: String
			if matcher.mostRecentOnly {
				suffix = matcher is SameEndDatesSubQueryMatcher ? " Only the reference record with the latest end is used; this is not necessarily the latest start." :
					" Only the reference record with the latest start is used."
			} else { suffix = " A match to any qualifying reference record is sufficient." }
			if let within = matcher as? WithinXCalendarUnitsSubQueryMatcher {
				try validUnit(within.timeUnit)
				guard within.numberOfTimeUnits >= 0 else { throw QueryExplanationError.invalid }
				return "Keep records with a start or end within \(within.numberOfTimeUnits) whole calendar " + unitName(within.timeUnit, plural: true) + " of a reference start or end, in either direction. The limit is inclusive; whole calendar-unit distance is used, not exact elapsed duration." + suffix
			}
			if let before = matcher as? WithinXCalendarUnitsBeforeSubQueryMatcher {
				try validUnit(before.timeUnit)
				guard before.numberOfTimeUnits >= 0 else { throw QueryExplanationError.invalid }
				return "Keep records whose end (or start if there is no end) is strictly before a reference start, by at most \(before.numberOfTimeUnits) whole calendar " + unitName(before.timeUnit, plural: true) + ". Equal instants do not match; the distance limit is inclusive. A zero-unit window matches no records." + suffix
			}
			if let after = matcher as? WithinXCalendarUnitsAfterSubQueryMatcher {
				try validUnit(after.timeUnit)
				guard after.numberOfTimeUnits >= 0 else { throw QueryExplanationError.invalid }
				return "Keep records whose start is strictly after a reference end (or reference start if there is no end), by at most \(after.numberOfTimeUnits) whole calendar " + unitName(after.timeUnit, plural: true) + ". Equal instants do not match; the distance limit is inclusive. A zero-unit window matches no records." + suffix
			}
			if let same = matcher as? InSameCalendarUnitSubQueryMatcher {
				try validUnit(same.timeUnit)
				return "Keep records whose start shares the same calendar " + unitName(same.timeUnit) + " as a reference start, or whose end shares that calendar period with a reference end." + suffix
			}
			if matcher is SameStartDatesSubQueryMatcher { return "Keep records whose start timestamp equals a reference start timestamp. The current matcher also treats two missing starts as equal." + suffix }
			if matcher is SameEndDatesSubQueryMatcher { return "Keep records whose end timestamp equals a reference end timestamp. The current matcher also treats two missing ends as equal." + suffix }
			if matcher is SameDatesSubQueryMatcher { return "Keep records whose start and end timestamps both equal the corresponding reference timestamps. Two missing ends are treated as equal." + suffix }
			throw QueryExplanationError.unsupported
		}

		func healthUnit(_ sampleType: Sample.Type, attribute: Attribute, capturedUnit: String?) -> String? {
			guard attribute is DoubleAttribute else { return nil }
			if let capturedUnit = capturedUnit { return capturedUnit }
			switch sampleType {
			case is ActiveEnergy.Type: return attribute.id == ActiveEnergy.energyBurned.id ? "kcal" : nil
			case is Weight.Type: return Weight.unit.unitString
			case is LeanBodyMass.Type: return LeanBodyMass.unit.unitString
			case is DietarySugar.Type: return DietarySugar.unit.unitString
			case is BodyMassIndex.Type: return "BMI (dimensionless)"
			case is HeartRate.Type: return HeartRate.unit.unitString
			case is RestingHeartRate.Type: return RestingHeartRate.unit.unitString
			case is Steps.Type: return attribute.id == Steps.stepCount.id ? Steps.unit.unitString : nil
			case is BloodPressure.Type: return attribute.id == BloodPressure.systolic.id ? BloodPressure.systolicUnit.unitString : BloodPressure.diastolicUnit.unitString
			case is Workout.Type: return attribute.id == Workout.energy.id ? "kcal" : (attribute.id == Workout.distance.id ? "m" : nil)
			default: return nil
			}
		}

		func validDate(_ date: Date) throws {
			guard date.timeIntervalSince1970.isFinite, date >= .distantPast, date <= .distantFuture else { throw QueryExplanationError.invalid }
		}
		func timeText(_ time: TimeOfDay) throws -> String {
			guard (0...23).contains(time.hour), (0...59).contains(time.minute), (0...59).contains(time.second) else { throw QueryExplanationError.invalid }
			return String(format: "%02d:%02d:%02d", time.hour, time.minute, time.second)
		}
		func validUnit(_ unit: Calendar.Component) throws {
			guard [.year, .quarter, .month, .weekOfMonth, .weekOfYear, .day, .hour, .minute, .second, .nanosecond].contains(unit) else { throw QueryExplanationError.invalid }
		}
		func unitName(_ unit: Calendar.Component, plural: Bool = false) -> String {
			let name: String
			switch unit {
			case .weekOfYear: name = "week of year"
			case .weekOfMonth: name = "week of month"
			default: name = unit.description.lowercased()
			}
			return name + (plural ? "s" : "")
		}
		func quoted(_ value: String) -> String { "“" + value.replacingOccurrences(of: "\n", with: "\\n").replacingOccurrences(of: "\r", with: "\\r").replacingOccurrences(of: "“", with: "\\“").replacingOccurrences(of: "”", with: "\\”") + "”" }
		func instant(_ value: Date) -> String {
			let formatter = DateFormatter()
			formatter.locale = Locale(identifier: "en_US_POSIX")
			formatter.timeZone = .autoupdatingCurrent
			formatter.calendar = .autoupdatingCurrent
			formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
			let text = formatter.string(from: value)
			// DateFormatter's fractional-second symbols can pad millisecond values
			// with zeroes. Read the stored instant's actual nanosecond component.
			let fraction = Calendar.autoupdatingCurrent.component(.nanosecond, from: value)
			formatter.dateFormat = "XXXXX"
			return text + String(format: ".%09d", fraction) + " " + formatter.string(from: value) + " (" + formatter.timeZone.identifier + ")"
		}

		private static let supportedRestrictions = Set(supportedRestrictionTypes.map { ObjectIdentifier($0) })
		private static let supportedRestrictionTypes: [AttributeRestriction.Type] = [
			ContainsStringAttributeRestriction.self, StartsWithStringAttributeRestriction.self, EndsWithStringAttributeRestriction.self,
			EqualToStringAttributeRestriction.self, NotEqualToStringAttributeRestriction.self, EmptyStringAttributeRestriction.self, NotEmptyStringAttributeRestriction.self,
			LessThanDoubleAttributeRestriction.self, LessThanOrEqualToDoubleAttributeRestriction.self, EqualToDoubleAttributeRestriction.self, GreaterThanOrEqualToDoubleAttributeRestriction.self, GreaterThanDoubleAttributeRestriction.self, NotEqualToDoubleAttributeRestriction.self,
			LessThanIntegerAttributeRestriction.self, LessThanOrEqualToIntegerAttributeRestriction.self, EqualToIntegerAttributeRestriction.self, GreaterThanOrEqualToIntegerAttributeRestriction.self, GreaterThanIntegerAttributeRestriction.self, NotEqualToIntegerAttributeRestriction.self,
			LessThanDurationAttributeRestriction.self, LessThanOrEqualToDurationAttributeRestriction.self, EqualToDurationAttributeRestriction.self, GreaterThanOrEqualToDurationAttributeRestriction.self, GreaterThanDurationAttributeRestriction.self, NotEqualToDurationAttributeRestriction.self,
			LessThanDosageAttributeRestriction.self, LessThanOrEqualToDosageAttributeRestriction.self, EqualToDosageAttributeRestriction.self, GreaterThanOrEqualToDosageAttributeRestriction.self, GreaterThanDosageAttributeRestriction.self, NotEqualToDosageAttributeRestriction.self,
			LessThanFrequencyAttributeRestriction.self, LessThanOrEqualToFrequencyAttributeRestriction.self, EqualToFrequencyAttributeRestriction.self, GreaterThanOrEqualToFrequencyAttributeRestriction.self, GreaterThanFrequencyAttributeRestriction.self, NotEqualToFrequencyAttributeRestriction.self,
			EqualToSelectOneAttributeRestriction.self, NotEqualToSelectOneAttributeRestriction.self,
			InCurrentTimeUnitDateAttributeRestriction.self, InThePastXTimeUnitsDateAttributeRestriction.self, BeforeDateAttributeRestriction.self, AfterDateAttributeRestriction.self, BeforeDateAndTimeAttributeRestriction.self, AfterDateAndTimeAttributeRestriction.self, BeforeTimeOfDayAttributeRestriction.self, AfterTimeOfDayAttributeRestriction.self, OnDayOfWeekAttributeRestriction.self, OnDateAttributeRestriction.self,
			HasTagAttributeRestriction.self, DoesNotHaveTagAttributeRestriction.self, HasOneOfTagAttributeRestriction.self, DoesNotHaveOneOfTagAttributeRestriction.self,
			ActivityHasTagAttributeRestriction.self, ActivityDoesNotHaveTagAttributeRestriction.self, ActivityHasOneOfTagAttributeRestriction.self, ActivityDoesNotHaveOneOfTagAttributeRestriction.self,
		]
	}
}
