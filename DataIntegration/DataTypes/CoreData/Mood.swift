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

	var maxRating: Double { get set }
	var rating: Double { get set }
	var note: String? { get set }
	var timestamp: Date { get set }
}

public final class MoodImpl: NSManagedObject, Mood {

	private typealias Me = MoodImpl

	public static func ==(lhs: MoodImpl, rhs: MoodImpl) -> Bool {
		return lhs.equalTo(rhs)
	}

	public static let entityName = "Mood"

	public static let rating = DoubleAttribute(name: "Mood Rating", pluralName: "Mood Ratings", variableName: "rating")
	public static let maxRating = DoubleAttribute(name: "Max Mood Rating", pluralName: "Max mood rating", variableName: "maxRating")
	public static let note = TextAttribute(name: "Note", pluralName: "Notes", variableName: "note")
	public static let attributes: [Attribute] = [CommonSampleAttributes.timestamp, rating, maxRating, note]

	public final let name: String = "Mood"
	public final override var description: String { return "A quantitative reflection on your mood." }
	public final override var debugDescription: String {
		return "Mood with rating = \(rating), timestamp = \(timestamp), and note = \(note ?? "nil")"
	}

	public final let dataType: DataTypes = .mood
	public final let attributes: [Attribute] = Me.attributes

	public final func dates() -> [DateType: Date] {
		return [.start: timestamp]
	}

	public final func value(of attribute: Attribute) throws -> Any {
		if attribute.name == Me.rating.name {
			return rating
		}
		if attribute.name == CommonSampleAttributes.timestamp.name {
			return timestamp
		}
		if attribute.name == Me.note.name {
			return note
		}
		throw AttributeError.unknownAttribute
	}

	public final func set(attribute: Attribute, to value: Any) throws {
		if attribute.name == Me.rating.name {
			guard let castedValue = value as? Double else { throw AttributeError.typeMismatch }
			rating = castedValue
			return
		}
		if attribute.name == CommonSampleAttributes.timestamp.name {
			guard let castedValue = value as? Date else { throw AttributeError.typeMismatch }
			timestamp = castedValue
			return
		}
		if attribute.name == Me.note.name {
			guard let castedValue = value as? String else { throw AttributeError.typeMismatch }
			note = castedValue
			return
		}
		throw AttributeError.unknownAttribute
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
}
