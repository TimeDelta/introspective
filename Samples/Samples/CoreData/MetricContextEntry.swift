import Foundation
import CoreData
import CSV
import Attributes
import Common
import DependencyInjection
import Persistence

public enum ContextMetric: String, CaseIterable {
	case all, activeEnergy, steps, workouts, lostItems
	public var title: String {
		switch self {
		case .all: return "All metrics"
		case .activeEnergy: return "Active Energy"
		case .steps: return "Steps"
		case .workouts: return "Workouts"
		case .lostItems: return "Lost Items"
		}
	}
	public var limitations: String {
		switch self {
		case .all: return "Context can help explain changes in recorded measurements. An association does not establish its cause or measure ADHD severity."
		case .activeEnergy: return "Energy estimates depend on the device and data source, time worn, fit, activity type, and body measurements. Missing wearable time can lower recorded energy."
		case .steps: return "Step counts depend on carrying or wearing a device. Vehicle or hand movement can add false steps; walking aids and some activities can cause missed steps."
		case .workouts: return "Workout counts depend on manual logging, automatic detection, and imported records. Counts do not describe duration or intensity, and duplicate imports can inflate them."
		case .lostItems: return "Counts depend on what you log and opportunities to lose or find things. Travel, changes in routine, and finding items lost before tracking began can change the totals."
		}
	}
}

public enum ContextCategory: String, CaseIterable {
	case illness = "Illness", travel = "Travel", exercise = "Unusual exercise", device = "Device not worn"
	case routine = "Routine change", medication = "Medication change", other = "Other"
}

public final class MetricContextEntry: NSManagedObject, CoreDataSample, SearchableSample {
	public static let entityName = "MetricContextEntry"
	public static let name = "Metric Context"
	public static let categoryAttribute = TypedEquatableSelectOneAttribute<String>(id: 0, name: "Context", typeName: "Context", possibleValues: ContextCategory.allCases.map { $0.rawValue }, variableName: "category", possibleValueToString: { $0 })
	public static let metricAttribute = TypedEquatableSelectOneAttribute<String>(id: 1, name: "Metric", typeName: "Metric", possibleValues: ContextMetric.allCases.map { $0.rawValue }, variableName: "metricKey", possibleValueToString: { ContextMetric(rawValue: $0)?.title ?? $0 })
	public static let noteAttribute = TextAttribute(id: 2, name: "Note", variableName: "note", optional: true)
	public static let endAttribute = DateTimeAttribute(id: 3, name: "End Date", variableName: "endDate", optional: true)
	public static let attributes: [Attribute] = [CommonSampleAttributes.timestamp, categoryAttribute, metricAttribute, noteAttribute, endAttribute]
	public static let defaultDependentAttribute: Attribute = categoryAttribute
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.timestamp
	public static let dateAttributes: [DateType: DateAttribute] = [.start: CommonSampleAttributes.timestamp, .end: endAttribute]
	public var attributes: [Attribute] { Self.attributes }
	public var attributedName: String { Self.name }
	public override var description: String { category }
	@NSManaged public var timestamp: Date
	@NSManaged public var endDate: Date?
	@NSManaged public var metricKey: String
	@NSManaged public var category: String
	@NSManaged public var note: String?
	public var metric: ContextMetric { ContextMetric(rawValue: metricKey) ?? .all }
	@nonobjc public class func fetchRequest() -> NSFetchRequest<MetricContextEntry> { NSFetchRequest(entityName: entityName) }
	public func dates() -> [DateType: Date] {
		var result: [DateType: Date] = [.start: timestamp]
		if let end = endDate { result[.end] = end }
		return result
	}
	public func matchesSearchString(_ text: String) -> Bool {
		(category + " " + metric.title + " " + (note ?? "")).range(of: text, options: [.caseInsensitive, .diacriticInsensitive]) != nil
	}
	public func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(CommonSampleAttributes.timestamp) { return timestamp }
		if attribute.equalTo(Self.endAttribute) { return endDate }
		if attribute.equalTo(Self.categoryAttribute) { return category }
		if attribute.equalTo(Self.metricAttribute) { return metricKey }
		if attribute.equalTo(Self.noteAttribute) { return note }
		throw UnknownAttributeError(attribute: attribute, for: self)
	}
	public func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(CommonSampleAttributes.timestamp), let date = value as? Date { timestamp = date; return }
		if attribute.equalTo(Self.endAttribute), value == nil || value is Date { endDate = value as? Date; return }
		if attribute.equalTo(Self.categoryAttribute), let text = value as? String, ContextCategory(rawValue: text) != nil { category = text; return }
		if attribute.equalTo(Self.metricAttribute), let text = value as? String, ContextMetric(rawValue: text) != nil { metricKey = text; return }
		if attribute.equalTo(Self.noteAttribute), value == nil || value is String { note = value as? String; return }
		throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
	}
	public static func request(metric: ContextMetric = .all, interval: DateInterval? = nil) -> NSFetchRequest<MetricContextEntry> {
		let request = fetchRequest()
		var predicates: [NSPredicate] = []
		if metric != .all { predicates.append(NSPredicate(format: "metricKey IN %@", [ContextMetric.all.rawValue, metric.rawValue])) }
		if let interval = interval {
			guard interval.duration > 0 else { request.predicate = NSPredicate(value: false); return request }
			predicates.append(NSPredicate(format: "timestamp < %@ AND ((endDate != nil AND endDate > %@) OR (endDate == nil AND timestamp >= %@))", interval.end as NSDate, interval.start as NSDate, interval.start as NSDate))
		}
		request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
		return request
	}
	@discardableResult public static func record(category: ContextCategory, metric: ContextMetric, at date: Date, until end: Date? = nil, note: String? = nil) throws -> MetricContextEntry {
		guard date.timeIntervalSinceReferenceDate.isFinite else { throw GenericDisplayableError(title: "Choose a valid start time.") }
		if let end = end {
			guard end.timeIntervalSinceReferenceDate.isFinite && end >= date else { throw GenericDisplayableError(title: "The end must be after the start.") }
		}
		let transaction = try injected(Database.self).viewContextTransaction(for: Self.self, sortedBy: "timestamp")
		let event = try transaction.new(Self.self)
		event.timestamp = date; event.endDate = end == date ? nil : end
		event.category = category.rawValue; event.metricKey = metric.rawValue; event.note = note
		try transaction.commit()
		return try injected(Database.self).pull(savedObject: event)
	}
	public static let exportFileDescription = "Metric context"
	public static func exportHeaderRow(to csv: CSVWriter) throws { try csv.write(row: ["Timestamp", "End", "Context", "Metric", "Note"], quotedAtIndex: { _ in true }) }
	public func export(to csv: CSVWriter) throws {
		let key = "Introspective.MetricContextEntry.ISO8601"
		let formatter: ISO8601DateFormatter
		if let cached = Thread.current.threadDictionary[key] as? ISO8601DateFormatter { formatter = cached }
		else {
			formatter = ISO8601DateFormatter(); formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
			Thread.current.threadDictionary[key] = formatter
		}
		for field in [formatter.string(from: timestamp), endDate.map(formatter.string(from:)) ?? "", category, metricKey, note ?? ""] {
			try csv.write(field: field, quoted: true)
		}
	}
}
