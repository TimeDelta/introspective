//
//  Fatigue.swift
//  Samples
//
//  Created by Bryan Nova on 12/8/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import CoreData
import CSV
import Foundation

import Attributes
import Common
import DependencyInjection

public protocol Fatigue: CoreDataSample, SearchableSample {
	static var rating: DoubleAttribute { get }
	static var maxRating: DoubleAttribute { get }
	static var note: TextAttribute { get }

	var minRating: Double { get set }
	var maxRating: Double { get set }
	var rating: Double { get set }
	var note: String? { get set }
	var date: Date { get set }
}

public final class FatigueImpl: NSManagedObject, Fatigue {
	private typealias Me = FatigueImpl

	// MARK: - CoreData Stuff

	public static let entityName = "Fatigue"

	// MARK: - Display Information

	public static let name = "Fatigue"
	public static let description = "A quantitative reflection on your fatigue."

	// MARK: - Attributes

	public static let rating = DoubleAttribute(
		id: 0,
		name: "Fatigue Rating",
		pluralName: "Fatigue Ratings",
		variableName: "rating"
	)
	public static let note = TextAttribute(id: 1, name: "Note", pluralName: "Notes", variableName: "note")
	public static let minRating = DoubleAttribute(
		id: 2,
		name: "Min Allowed Fatigue Rating",
		pluralName: "Min allowed fatigue ratings",
		variableName: "minRating"
	)
	public static let maxRating = DoubleAttribute(
		id: 3,
		name: "Max Allowed Fatigue Rating",
		pluralName: "Max allowed fatigue ratings",
		variableName: "maxRating"
	)

	public static let defaultDependentAttribute: Attribute = rating
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.timestamp

	public static let attributes: [Attribute] = [
		CommonSampleAttributes.timestamp,
		rating,
		note,
		minRating,
		maxRating,
	]
	public final let attributes: [Attribute] = Me.attributes
	public static var dateAttributes: [DateType: DateAttribute] = [
		.start: CommonSampleAttributes.timestamp,
	]

	// MARK: - Searching

	public func matchesSearchString(_ searchString: String) -> Bool {
		(note?.localizedCaseInsensitiveContains(searchString) ?? false)
	}

	// MARK: - Instance Variables

	public final let attributedName: String = "Fatigue"
	public final override var description: String { Me.description }
	public final var date: Date {
		get {
			injected(CoreDataSampleUtil.self).convertTimeZoneIfApplicable(
				for: timestamp,
				timeZoneId: timestampTimeZoneId
			)
		}
		set {
			timestamp = newValue
			timestampTimeZoneId = TimeZone.autoupdatingCurrent.identifier
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
		[.start: date]
	}

	// MARK: - Export

	public static let exportFileDescription: String = "Fatigue"

	// MARK: Export Column Names

	public static let timestampColumn = "Timestamp"
	public static let timeZoneColumn = "Time Zone"
	public static let ratingColumn = "Rating"
	public static let minRatingColumn = "Minimum Allowed Rating"
	public static let maxRatingColumn = "Maximum Allowed Rating"
	public static let noteColumn = "Note"

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
			],
			quotedAtIndex: { _ in true }
		)
	}

	public func export(to csv: CSVWriter) throws {
		let timestampText = injected(CalendarUtil.self)
			.string(for: timestamp, dateStyle: .full, timeStyle: .full)
		try csv.write(field: timestampText, quoted: true)

		try csv.write(field: timestampTimeZoneId ?? "", quoted: true)
		try csv.write(field: String(rating), quoted: true)
		try csv.write(field: String(minRating), quoted: true)
		try csv.write(field: String(maxRating), quoted: true)
		try csv.write(field: note ?? "", quoted: true)
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
			timestampTimeZoneId = TimeZone.autoupdatingCurrent.identifier
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

	// MARK: - Equatable

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is Fatigue) { return false }
		let other = otherAttributed as! Fatigue
		return equalTo(other)
	}

	public final func equalTo(_ otherSample: Sample) -> Bool {
		if !(otherSample is Fatigue) { return false }
		let other = otherSample as! Fatigue
		return equalTo(other)
	}

	public final func equalTo(_ other: Fatigue) -> Bool {
		rating == other.rating &&
			minRating == other.minRating &&
			maxRating == other.maxRating &&
			note == other.note &&
			date == other.date
	}

	// MARK: - Debug

	public final override var debugDescription: String {
		"Fatigue with rating = \(rating), timestamp = \(timestamp), and note = \(note ?? "nil")"
	}
}

// MARK: - CoreData

public extension FatigueImpl {
	@nonobjc class func fetchRequest() -> NSFetchRequest<FatigueImpl> {
		NSFetchRequest<FatigueImpl>(entityName: "Fatigue")
	}

	@NSManaged var note: String?
	@NSManaged var rating: Double
	@NSManaged fileprivate var timestamp: Date
	@NSManaged fileprivate var timestampTimeZoneId: String?
	@NSManaged var minRating: Double
	@NSManaged var maxRating: Double
}
