import Foundation
import CoreData
import CSV
import Attributes
import Common
import Persistence

/// User configuration is separate from historical response snapshots.
public final class StressorDefinition: NSManagedObject, CoreDataObject {
	public static let entityName = "StressorDefinition"
	@NSManaged public var id: UUID
	@NSManaged public var name: String
	@NSManaged public var createdAt: Date
	@NSManaged public var archived: Bool
	@NSManaged public var displayOrder: Int64
	@nonobjc public class func fetchRequest() -> NSFetchRequest<StressorDefinition> { NSFetchRequest(entityName: entityName) }
}

public final class StressCheckIn: NSManagedObject, CoreDataSample, SearchableSample {
	public static let entityName = "StressCheckIn"
	public static let name = "Stress Check-in"
	public static let ratingAttribute = IntegerAttribute(id: 0, name: "Overall Stress", variableName: "overallRating")
	public static let noteAttribute = TextAttribute(id: 1, name: "Note", variableName: "note", optional: true)
	public static let kindAttribute = TextAttribute(id: 2, name: "Measurement Kind", variableName: "measurementKind")
	public static let scaleAttribute = IntegerAttribute(id: 3, name: "Scale Version", variableName: "scaleVersion")
	public static let attributes: [Attribute] = [CommonSampleAttributes.timestamp, ratingAttribute, noteAttribute, kindAttribute, scaleAttribute]
	public static let defaultDependentAttribute: Attribute = ratingAttribute
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.timestamp
	public static let dateAttributes: [DateType: DateAttribute] = [.start: CommonSampleAttributes.timestamp]
	public var attributes: [Attribute] { Self.attributes }
	public var attributedName: String { Self.name }
	public override var description: String { "Overall stress: " + (StressRating(rawValue: Int(overallRating))?.title ?? "Invalid rating") }
	@NSManaged public var id: UUID
	@NSManaged public var timestamp: Date
	@NSManaged public var overallRating: Int16
	@NSManaged public var note: String?
	@NSManaged public var measurementKind: String
	@NSManaged public var scaleVersion: Int16
	@NSManaged public var responses: Set<StressorResponse>
	@nonobjc public class func fetchRequest() -> NSFetchRequest<StressCheckIn> { NSFetchRequest(entityName: entityName) }
	public var orderedResponses: [StressorResponse] {
		responses.sorted { left, right in
			if left.displayOrder != right.displayOrder { return left.displayOrder < right.displayOrder }
			return left.stressorID.uuidString < right.stressorID.uuidString
		}
	}
	public var draft: StressCheckInDraft {
		StressCheckInDraft(date: timestamp, overallRating: Int(overallRating), note: note,
			responses: orderedResponses.map { $0.draft }, measurementKind: measurementKind, scaleVersion: Int(scaleVersion))
	}
	public func dates() -> [DateType: Date] { [.start: timestamp] }
	public func matchesSearchString(_ text: String) -> Bool {
		(description + " " + (note ?? "") + " " + orderedResponses.map { $0.nameSnapshot }.joined(separator: " "))
			.range(of: text, options: [.caseInsensitive, .diacriticInsensitive]) != nil
	}
	public func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(CommonSampleAttributes.timestamp) { return timestamp }
		if attribute.equalTo(Self.ratingAttribute) { return Int(overallRating) }
		if attribute.equalTo(Self.noteAttribute) { return note }
		if attribute.equalTo(Self.kindAttribute) { return measurementKind }
		if attribute.equalTo(Self.scaleAttribute) { return Int(scaleVersion) }
		throw UnknownAttributeError(attribute: attribute, for: self)
	}
	public func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(CommonSampleAttributes.timestamp), let date = value as? Date, date.timeIntervalSinceReferenceDate.isFinite {
			timestamp = date
			for response in responses { response.timestamp = date }
			return
		}
		if attribute.equalTo(Self.ratingAttribute), let rating = value as? Int, StressRating(rawValue: rating) != nil { overallRating = Int16(rating); return }
		if attribute.equalTo(Self.noteAttribute), value == nil || value is String {
			guard ((value as? String)?.count ?? 0) <= 4000 else { throw GenericDisplayableError(title: "Use a note of up to 4,000 characters.") }
			note = value as? String; return
		}
		throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
	}
	public static let exportFileDescription = "Stress check-ins"
	public static func exportHeaderRow(to csv: CSVWriter) throws {
		try csv.write(row: ["Check-in ID", "Timestamp", "Overall Stress", "Measurement Kind", "Scale Version", "Note", "Timestamp Reference Seconds"], quotedAtIndex: { _ in true })
	}
	public func export(to csv: CSVWriter) throws {
		for field in [id.uuidString, StressCSV.timestamp(timestamp), String(overallRating), measurementKind, String(scaleVersion), note ?? "", String(timestamp.timeIntervalSinceReferenceDate)] {
			try csv.write(field: field, quoted: true)
		}
	}
}

/// Each offered stressor has an explicit state; missing ratings never become zero.
public final class StressorResponse: NSManagedObject, CoreDataSample, SearchableSample {
	public static let entityName = "StressorResponse"
	public static let name = "Stressor Response"
	public static let ratingAttribute = IntegerAttribute(id: 0, name: "Stress Rating", variableName: "ratingValue", optional: true)
	public static let statusAttribute = TypedEquatableSelectOneAttribute<String>(id: 1, name: "Response Status", typeName: "Response Status", variableName: "statusKey", possibleValues: StressResponseStatus.allCases.map { $0.rawValue }, possibleValueToString: { StressResponseStatus(rawValue: $0)?.title ?? $0 })
	public static let stressorAttribute = TextAttribute(id: 2, name: "Stressor", variableName: "nameSnapshot")
	public static let stressorIDAttribute = TextAttribute(id: 3, name: "Stressor ID", variableName: "stressorKey")
	public static let attributes: [Attribute] = [CommonSampleAttributes.timestamp, ratingAttribute, statusAttribute, stressorAttribute, stressorIDAttribute]
	public static let defaultDependentAttribute: Attribute = ratingAttribute
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.timestamp
	public static let dateAttributes: [DateType: DateAttribute] = [.start: CommonSampleAttributes.timestamp]
	public var attributes: [Attribute] { Self.attributes }
	public var attributedName: String { Self.name }
	public override var description: String { nameSnapshot + ": " + (rating.flatMap { StressRating(rawValue: $0)?.title } ?? status.title) }
	@NSManaged public var stressorID: UUID
	/// String counterpart supports ordinary saved-query text restrictions on stable IDs.
	@NSManaged public var stressorKey: String
	@NSManaged public var nameSnapshot: String
	@NSManaged public var displayOrder: Int64
	@NSManaged public var statusKey: String
	@NSManaged public var ratingValue: NSNumber?
	@NSManaged public var timestamp: Date
	@NSManaged public var checkIn: StressCheckIn
	@nonobjc public class func fetchRequest() -> NSFetchRequest<StressorResponse> { NSFetchRequest(entityName: entityName) }
	public var status: StressResponseStatus { StressResponseStatus(rawValue: statusKey) ?? .skipped }
	public var rating: Int? { statusKey == StressResponseStatus.rated.rawValue ? ratingValue?.intValue : nil }
	public var draft: StressResponseDraft {
		StressResponseDraft(stressorID: stressorID, nameSnapshot: nameSnapshot, order: Int(displayOrder), status: status, rating: rating)
	}
	public func dates() -> [DateType: Date] { [.start: timestamp] }
	public func matchesSearchString(_ text: String) -> Bool {
		(nameSnapshot + " " + status.title + " " + (checkIn.note ?? ""))
			.range(of: text, options: [.caseInsensitive, .diacriticInsensitive]) != nil
	}
	public func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(CommonSampleAttributes.timestamp) { return timestamp }
		if attribute.equalTo(Self.ratingAttribute) { return rating }
		if attribute.equalTo(Self.statusAttribute) { return statusKey }
		if attribute.equalTo(Self.stressorAttribute) { return nameSnapshot }
		if attribute.equalTo(Self.stressorIDAttribute) { return stressorKey }
		throw UnknownAttributeError(attribute: attribute, for: self)
	}
	public func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(CommonSampleAttributes.timestamp), let date = value as? Date, date.timeIntervalSinceReferenceDate.isFinite {
			checkIn.timestamp = date
			for response in checkIn.responses { response.timestamp = date }
			return
		}
		if attribute.equalTo(Self.ratingAttribute), value == nil || value is Int {
			if let rating = value as? Int {
				guard StressRating(rawValue: rating) != nil else { throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value)) }
				ratingValue = NSNumber(value: rating); statusKey = StressResponseStatus.rated.rawValue
			} else { ratingValue = nil; statusKey = StressResponseStatus.skipped.rawValue }
			return
		}
		if attribute.equalTo(Self.statusAttribute), let key = value as? String, let status = StressResponseStatus(rawValue: key) {
			guard status != .rated || ratingValue.flatMap({ StressRating(rawValue: $0.intValue) }) != nil else {
				throw GenericDisplayableError(title: "Choose a rating for a rated response.")
			}
			statusKey = key
			if status != .rated { ratingValue = nil }
			return
		}
		throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
	}
	public static let exportFileDescription = "Stressor responses"
	public static func exportHeaderRow(to csv: CSVWriter) throws {
		try csv.write(row: ["Check-in ID", "Timestamp", "Stressor ID", "Stressor", "Status", "Rating", "Measurement Kind", "Scale Version", "Note", "Timestamp Reference Seconds"], quotedAtIndex: { _ in true })
	}
	public func export(to csv: CSVWriter) throws {
		for field in [checkIn.id.uuidString, StressCSV.timestamp(timestamp), stressorID.uuidString, nameSnapshot, statusKey,
			rating.map(String.init) ?? "", checkIn.measurementKind, String(checkIn.scaleVersion), checkIn.note ?? "", String(timestamp.timeIntervalSinceReferenceDate)] {
			try csv.write(field: field, quoted: true)
		}
	}
}

private enum StressCSV {
	// The readable ISO column may round to milliseconds. The additional reference-
	// seconds field preserves Date's exact stored Double for precision-based proxies.
	// See docs/timestamp-precision.md before changing timestamp serialization.
	static func timestamp(_ date: Date) -> String {
		let key = "Introspective.StressCSV.ISO8601"
		let formatter: ISO8601DateFormatter
		if let cached = Thread.current.threadDictionary[key] as? ISO8601DateFormatter { formatter = cached }
		else {
			formatter = ISO8601DateFormatter(); formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
			Thread.current.threadDictionary[key] = formatter
		}
		return formatter.string(from: date)
	}
}
