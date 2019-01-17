//
//  Mood.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData

public protocol Mood: CoreDataSample {

	static var rating: DoubleAttribute { get }
	static var maxRating: DoubleAttribute { get }
	static var note: TextAttribute { get }

	var minRating: Double { get set }
	var maxRating: Double { get set }
	var rating: Double { get set }
	var note: String? { get set }
	var timestamp: Date { get set }

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
		possibleValues: Sources.moodSources,
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

	// MARK: - Instance Variables

	public final let attributedName: String = "Mood"
	public final override var description: String { return Me.description }

	// MARK: - Sample Functions

	public final func dates() -> [DateType: Date] {
		return [.start: timestamp]
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.maxRating) {
			return maxRating
		}
		if attribute.equalTo(Me.rating) {
			return rating
		}
		if attribute.equalTo(CommonSampleAttributes.timestamp) {
			return timestamp
		}
		if attribute.equalTo(Me.note) {
			return note
		}
		if attribute.equalTo(Me.sourceAttribute) {
			return Sources.resolveMoodSource(source)
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
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

	public final func setSource(_ source: Sources.MoodSourceNum) {
		self.source = source.rawValue
	}

	// MARK: - Equatable

	public static func ==(lhs: MoodImpl, rhs: MoodImpl) -> Bool {
		return lhs.equalTo(rhs)
	}

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
		return rating == other.rating && note == other.note && timestamp == other.timestamp
	}

	// MARK: - Debug

	public final override var debugDescription: String {
		return "Mood with rating = \(rating), timestamp = \(timestamp), and note = \(note ?? "nil")"
	}
}
