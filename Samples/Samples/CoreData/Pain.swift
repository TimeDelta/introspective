//
//  Pain.swift
//  Samples
//
//  Created by Bryan Nova on 6/16/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import CoreData
import CSV
import Foundation

import Attributes
import Common
import DependencyInjection

public protocol Pain: CoreDataSample, SearchableSample {
	static var rating: DoubleAttribute { get }
	static var maxRating: DoubleAttribute { get }
	static var note: TextAttribute { get }

	var minRating: Double { get set }
	var maxRating: Double { get set }
	var rating: Double { get set }
	var location: String? { get set }
	var note: String? { get set }
	var date: Date { get set }
	var timeZone: TimeZone? { get set }
}

public final class PainImpl: NSManagedObject, Pain {
	private typealias Me = PainImpl

	// MARK: - CoreData Stuff

	public static let entityName = "Pain"

	// MARK: - Display Information

	public static let name = "Pain"
	public static let description = "How much pain you're experiencing."

	// MARK: - Attributes

	public static let rating = DoubleAttribute(
		id: 0,
		name: "Pain Rating",
		pluralName: "Pain Ratings",
		variableName: "rating"
	)
	public static let note = TextAttribute(id: 1, name: "Note", pluralName: "Notes", variableName: "note")
	public static let location = TextAttribute(
		id: 2,
		name: "Location",
		pluralName: "Locations"
	)
	public static let minRating = DoubleAttribute(
		id: 3,
		name: "Min Allowed Pain Rating",
		pluralName: "Min allowed pain ratings",
		variableName: "minRating"
	)
	public static let maxRating = DoubleAttribute(
		id: 4,
		name: "Max Allowed Pain Rating",
		pluralName: "Max allowed pain ratings",
		variableName: "maxRating"
	)

	public static let defaultDependentAttribute: Attribute = rating
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.timestamp

	public static let attributes: [Attribute] = [
		CommonSampleAttributes.timestamp,
		rating,
		location,
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

	public final let attributedName: String = "Pain"
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
			if timestampTimeZoneId == nil {
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
		[.start: date]
	}

	// MARK: - Export

	public static let exportFileDescription: String = "Pains"

	// MARK: Export Column Names

	public static let timestampColumn = "Timestamp"
	public static let timeZoneColumn = "Time Zone"
	public static let ratingColumn = "Rating"
	public static let minRatingColumn = "Minimum Allowed Rating"
	public static let maxRatingColumn = "Maximum Allowed Rating"
	public static let locationColumn = "Location"
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
				locationColumn,
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
		try csv.write(field: location ?? "", quoted: true)
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
		if attribute.equalTo(Me.location) {
			return location
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
			if timestampTimeZoneId == nil {
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

	// MARK: - Equatable

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is Pain) { return false }
		let other = otherAttributed as! Pain
		return equalTo(other)
	}

	public final func equalTo(_ otherSample: Sample) -> Bool {
		if !(otherSample is Pain) { return false }
		let other = otherSample as! Pain
		return equalTo(other)
	}

	public final func equalTo(_ other: Pain) -> Bool {
		rating == other.rating &&
			minRating == other.minRating &&
			maxRating == other.maxRating &&
			note == other.note &&
			date == other.date
	}

	// MARK: - Debug

	public final override var debugDescription: String {
		"Pain with rating = \(rating), timestamp = \(timestamp), and note = \(note ?? "nil")"
	}
}

// MARK: - CoreData

public extension PainImpl {
	@nonobjc class func fetchRequest() -> NSFetchRequest<PainImpl> {
		NSFetchRequest<PainImpl>(entityName: "Pain")
	}

	@NSManaged var note: String?
	@NSManaged var rating: Double
	@NSManaged fileprivate var timestamp: Date
	@NSManaged fileprivate var timestampTimeZoneId: String?
	@NSManaged var location: String?
	@NSManaged var minRating: Double
	@NSManaged var maxRating: Double
}
