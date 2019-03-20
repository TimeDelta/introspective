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

public protocol Mood: CoreDataSample {

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
		pluralName: "Sources",
		possibleValues: Sources.MoodSourceNum.values.map{ $0.description },
		possibleValueToString: { $0 })
	public static let minRating = DoubleAttribute(name: "Min Mood Rating", pluralName: "Min mood ratings", variableName: "minRating")
	public static let maxRating = DoubleAttribute(name: "Max Mood Rating", pluralName: "Max mood ratings", variableName: "maxRating")

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

	// MARK: - Display Information

	public final let attributedName: String = "Mood"
	public final override var description: String { return Me.description }

	// MARK: - Instance Variables

	public final var note: String? {
		get { return storedNote }
		set {
			guard storedNote != newValue else { return }
			storedNote = newValue
			if let note = storedNote {
				sendValueUpdateNotification(.moodNoteUpdated, [.text: note])
			} else {
				sendValueUpdateNotification(.moodNoteUpdated)
			}
		}
	}
	public final var rating: Double {
		get { return storedRating }
		set {
			guard storedRating != newValue else { return }
			storedRating = newValue
			sendValueUpdateNotification(.moodRatingUpdated, [.number: storedRating])
		}
	}
	public final var minRating: Double {
		get { return storedMinRating }
		set {
			guard storedMinRating != newValue else { return }
			storedMinRating = newValue
			sendValueUpdateNotification(.moodMinRatingUpdated, [.number: storedMinRating])
		}
	}
	public final var maxRating: Double {
		get { return storedMaxRating }
		set {
			guard storedMaxRating != newValue else { return }
			storedMaxRating = newValue
			sendValueUpdateNotification(.moodMaxRatingUpdated, [.number: storedMaxRating])
		}
	}
	public final var date: Date {
		get {
			return DependencyInjector.util.coreDataSample.convertTimeZoneIfApplicable(for: timestamp, timeZoneId: timestampTimeZoneId)
		}
		set {
			guard timestamp != newValue else { return }
			timestamp = newValue
			if storedSource == Sources.MoodSourceNum.introspective.rawValue && timestampTimeZoneId == nil {
				timestampTimeZoneId = TimeZone.autoupdatingCurrent.identifier
			}
			sendValueUpdateNotification(.moodTimestampUpdated, [.date: timestamp])
		}
	}

	// MARK: - Sample Functions

	public final func dates() -> [DateType: Date] {
		return [.start: date]
	}

	// MARK: - Export

	public static let exportFileDescription: String = "Moods"

	public static func exportHeaderRow(to csv: CSVWriter) throws {
		try csv.write(
			row: [
				"Timestamp",
				"Time Zone",
				"Rating",
				"Minimum Allowed Rating",
				"Maximum Allowed Rating",
				"Note",
				"Source",
			],
			quotedAtIndex: { _ in true })
	}

	public func export(to csv: CSVWriter) throws {
		let timestampText = DependencyInjector.util.calendar.string(for: timestamp, dateStyle: .full, timeStyle: .full)
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
			date = castedValue
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
		self.storedSource = source.rawValue
		if source == Sources.MoodSourceNum.introspective && timestampTimeZoneId == nil {
			timestampTimeZoneId = TimeZone.autoupdatingCurrent.identifier
		}
	}

	// MARK: - Helper Functions

	private final func sendValueUpdateNotification(_ name: NotificationName, _ info: [UserInfoKey: Any]? = nil) {
		DependencyInjector.util.notification.post(.moodUpdated, object: self, qos: .userInteractive)
		DependencyInjector.util.notification.post(name, object: self, userInfo: info, qos: .userInteractive)
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

extension MoodImpl {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<MoodImpl> {
		return NSFetchRequest<MoodImpl>(entityName: "Mood")
	}

	@NSManaged fileprivate var storedNote: String?
	@NSManaged fileprivate var storedRating: Double
	@NSManaged fileprivate var timestamp: Date
	@NSManaged fileprivate var timestampTimeZoneId: String?
	@NSManaged fileprivate var storedMinRating: Double
	@NSManaged fileprivate var storedMaxRating: Double
	@NSManaged fileprivate var storedSource: Int16
}
