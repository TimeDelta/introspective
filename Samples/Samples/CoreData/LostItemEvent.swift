import Foundation
import CoreData
import CSV
import Attributes
import Common
import DependencyInjection
import Persistence

public final class LostItemEvent: NSManagedObject, CoreDataSample, SearchableSample {
	public static let entityName = "LostItemEvent"
	public static let name = "Lost Item Event"
	public static let change = IntegerAttribute(id: 0, name: "Change", pluralName: "Changes", variableName: "delta")
	public static let noteAttribute = TextAttribute(id: 1, name: "Note", pluralName: "Notes", variableName: "note", optional: true)
	public static let attributes: [Attribute] = [CommonSampleAttributes.timestamp, change, noteAttribute]
	public static let defaultDependentAttribute: Attribute = change
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.timestamp
	public static let dateAttributes: [DateType: DateAttribute] = [.start: CommonSampleAttributes.timestamp]
	public var attributes: [Attribute] { Self.attributes }
	public var attributedName: String { Self.name }
	public override var description: String { delta > 0 ? "Lost item" : "Found item" }
	@NSManaged public var timestamp: Date
	@NSManaged public var delta: Int16
	@NSManaged public var note: String?
	@nonobjc public class func fetchRequest() -> NSFetchRequest<LostItemEvent> { NSFetchRequest(entityName: entityName) }
	public func dates() -> [DateType: Date] { [.start: timestamp] }
	public func matchesSearchString(_ text: String) -> Bool {
		(description + " " + (note ?? "")).range(of: text, options: [.caseInsensitive, .diacriticInsensitive]) != nil
	}
	public func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Self.change) { return Int(delta) }
		if attribute.equalTo(Self.noteAttribute) { return note }
		if attribute.equalTo(CommonSampleAttributes.timestamp) { return timestamp }
		throw UnknownAttributeError(attribute: attribute, for: self)
	}
	public func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(Self.change), let value = value as? Int, [-1, 1].contains(value) { delta = Int16(value); return }
		if attribute.equalTo(Self.noteAttribute), value == nil || value is String { note = value as? String; return }
		if attribute.equalTo(CommonSampleAttributes.timestamp), let value = value as? Date { timestamp = value; return }
		throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
	}
	public static let exportFileDescription = "Lost item events"
	private static var exportTimestampFormatter: ISO8601DateFormatter {
		let key = "Introspective.LostItemEvent.exportTimestampFormatter"
		if let formatter = Thread.current.threadDictionary[key] as? ISO8601DateFormatter { return formatter }
		let formatter = ISO8601DateFormatter()
		formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
		Thread.current.threadDictionary[key] = formatter
		return formatter
	}
	public static func exportHeaderRow(to csv: CSVWriter) throws { try csv.write(row: ["Timestamp", "Change", "Note"], quotedAtIndex: { _ in true }) }
	public func export(to csv: CSVWriter) throws {
		let formatter = Self.exportTimestampFormatter
		for field in [formatter.string(from: timestamp), String(delta), note ?? ""] { try csv.write(field: field, quoted: true) }
	}

	@discardableResult public static func record(change: Int, at date: Date = Date(), note: String? = nil) throws -> LostItemEvent {
		guard [-1, 1].contains(change) else { throw GenericDisplayableError(title: "Use +1 for lost or −1 for found.") }
		let database = injected(Database.self)
		let transaction = try database.viewContextTransaction(for: Self.self, sortedBy: "timestamp")
		let event = try transaction.new(Self.self)
		event.delta = Int16(change); event.timestamp = date; event.note = note
		try transaction.commit()
		return try database.pull(savedObject: event)
	}
}
