//
//  Mood.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData
import CSV

import Attributes
import Common
import DependencyInjection

public protocol Mood: CoreDataSample, SearchableSample {

	static var rating: DoubleAttribute { get }
	static var maxRating: DoubleAttribute { get }
	static var note: TextAttribute { get }

	var minRating: Double { get set }
	var maxRating: Double { get set }
	var rating: Double { get set }
	var note: String? { get set }
	var date: Date { get set }

	func setSource(_ source: Sources.MoodSourceNum)
}

public final class MoodImpl: NSManagedObject, Mood {

	private typealias Me = MoodImpl

	// MARK: - CoreData Stuff

	public static let entityName = "Mood"

	// MARK: - Display Information

	public static let name = "Mood"
	public static let description = "A quantitative reflection on your mood."

	// MARK: - Attributes

	public static let rating = DoubleAttribute(name: "Mood Rating", pluralName: "Mood Ratings", variableName: "rating")
	public static let note = TextAttribute(name: "Note", pluralName: "Notes", variableName: "note")
	public static let sourceAttribute = TypedEquatableSelectOneAttribute<String>(
		name: "Source",
		typeName: "Mood Source",
		pluralName: "Sources",
		possibleValues: Sources.MoodSourceNum.values.map{ $0.description },
		possibleValueToString: { $0 })
	public static let minRating = DoubleAttribute(
		name: "Min Allowed Mood Rating",
		pluralName: "Min allowed mood ratings",
		variableName: "minRating")
	public static let maxRating = DoubleAttribute(
		name: "Max Allowed Mood Rating",
		pluralName: "Max allowed mood ratings",
		variableName: "maxRating")

	public static let defaultDependentAttribute: Attribute = rating
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.timestamp

	public static let attributes: [Attribute] = [
		CommonSampleAttributes.timestamp,
		rating,
		note,
		sourceAttribute,
		minRating,
		maxRating,
	]
	public final let attributes: [Attribute] = Me.attributes

	// MARK: - Searching

	public func matchesSearchString(_ searchString: String) -> Bool {
		return (note?.localizedCaseInsensitiveContains(searchString) ?? false)
	}

	// MARK: - Instance Variables

	public final let attributedName: String = "Mood"
	public final override var description: String { return Me.description }
	public final var date: Date {
		get {
			return DependencyInjector.get(CoreDataSampleUtil.self).convertTimeZoneIfApplicable(
				for: timestamp,
				timeZoneId: timestampTimeZoneId)
		}
		set {
			timestamp = newValue
			if source == Sources.MoodSourceNum.introspective.rawValue && timestampTimeZoneId == nil {
				timestampTimeZoneId = TimeZone.autoupdatingCurrent.identifier
			}
		}
	}
	public final var timeZone: TimeZone? {
		get {
			if let timeZoneId = timestampTimeZoneId {
				return TimeZone(identifier: timeZoneId)
			}
			return nil
		}
		set { timestampTimeZoneId = newValue?.identifier }
	}

	// MARK: - Sample Functions

	public final func dates() -> [DateType: Date] {
		return [.start: date]
	}

	// MARK: - Export

	public static let exportFileDescription: String = "Moods"

	// MARK: Export Column Names

	public static let timestampColumn = "Timestamp"
	public static let timeZoneColumn = "Time Zone"
	public static let ratingColumn = "Rating"
	public static let minRatingColumn = "Minimum Allowed Rating"
	public static let maxRatingColumn = "Maximum Allowed Rating"
	public static let noteColumn = "Note"
	public static let sourceColumn = "Source"

	// MARK: Export Functions

	public static func exportHeaderRow(to csv: CSVWriter) throws {
		try csv.write(
			row: [
				timestampColumn,
				timeZoneColumn,
				ratingColumn,
				minRatingColumn,
				maxRatingColumn,
				noteColumn,
				sourceColumn,
			],
			quotedAtIndex: { _ in true })
	}

	public func export(to csv: CSVWriter) throws {
		let timestampText = DependencyInjector.get(CalendarUtil.self).string(for: timestamp, dateStyle: .full, timeStyle: .full)
		try csv.write(field: timestampText, quoted: true)

		try csv.write(field: timestampTimeZoneId ?? "", quoted: true)
		try csv.write(field: String(rating), quoted: true)
		try csv.write(field: String(minRating), quoted: true)
		try csv.write(field: String(maxRating), quoted: true)
		try csv.write(field: note ?? "", quoted: true)

		let sourceText = Sources.resolveMoodSource(source).description
		try csv.write(field: sourceText, quoted: true)
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.rating) {
			return rating
		}
		if attribute.equalTo(Me.minRating) {
			return minRating
		}
		if attribute.equalTo(Me.maxRating) {
			return maxRating
		}
		if attribute.equalTo(CommonSampleAttributes.timestamp) {
			return date
		}
		if attribute.equalTo(Me.note) {
			return note
		}
		if attribute.equalTo(Me.sourceAttribute) {
			return Sources.resolveMoodSource(source).description
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(Me.minRating) {
			guard let castedValue = value as? Double else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			minRating = castedValue
			return
		}
		if attribute.equalTo(Me.maxRating) {
			guard let castedValue = value as? Double else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			maxRating = castedValue
			return
		}
		if attribute.equalTo(Me.rating) {
			guard let castedValue = value as? Double else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			rating = castedValue
			return
		}
		if attribute.equalTo(CommonSampleAttributes.timestamp) {
			guard let castedValue = value as? Date else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			timestamp = castedValue
			if source == Sources.MoodSourceNum.introspective.rawValue && timestampTimeZoneId == nil {
				timestampTimeZoneId = TimeZone.autoupdatingCurrent.identifier
			}
			return
		}
		if attribute.equalTo(Me.note) {
			if !(value is String?) {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			let castedValue = value as! String?
			note = castedValue
			return
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	// MARK: - Other

	public final func getSource() -> Sources.MoodSourceNum {
		return Sources.resolveMoodSource(source)
	}

	public final func setSource(_ source: Sources.MoodSourceNum) {
		self.source = source.rawValue
		if source == Sources.MoodSourceNum.introspective && timestampTimeZoneId == nil {
			timestampTimeZoneId = TimeZone.autoupdatingCurrent.identifier
		}
	}

	// MARK: - Equatable

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is Mood) { return false }
		let other = otherAttributed as! Mood
		return equalTo(other)
	}

	public final func equalTo(_ otherSample: Sample) -> Bool {
		if !(otherSample is Mood) { return false }
		let other = otherSample as! Mood
		return equalTo(other)
	}

	public final func equalTo(_ other: Mood) -> Bool {
		return rating == other.rating &&
			minRating == other.minRating &&
			maxRating == other.maxRating &&
			note == other.note &&
			date == other.date
	}

	// MARK: - Debug

	public final override var debugDescription: String {
		return "Mood with rating = \(rating), timestamp = \(timestamp), and note = \(note ?? "nil")"
	}
}

// MARK: - CoreData

public extension MoodImpl {

	@nonobjc class func fetchRequest() -> NSFetchRequest<MoodImpl> {
		return NSFetchRequest<MoodImpl>(entityName: "Mood")
	}

	@NSManaged var note: String?
	@NSManaged var rating: Double
	@NSManaged fileprivate var timestamp: Date
	@NSManaged fileprivate var timestampTimeZoneId: String?
	@NSManaged var minRating: Double
	@NSManaged var maxRating: Double
	@NSManaged var source: Int16
}
