//
//  Mood.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData

public class Mood: NSManagedObject, CoreDataSample {

	fileprivate typealias Me = Mood

	public static let entityName = "Mood"

	public static let maxRating = 7.0
	public static let notRated = Double.nan
	public static let moodRating = DoubleAttribute(name: "Mood Rating", pluralName: "Mood Ratings")
	public static let note = TextAttribute(name: "Note", pluralName: "Notes")
	public static let attributes: [Attribute] = [CommonSampleAttributes.timestamp, moodRating, note]

	public let maxRating: Double = Me.maxRating

	public let name: String = "Mood"
	public override var description: String { return "A quantitative reflection on your mood." }

	public let dataType: DataTypes = .mood
	public let attributes: [Attribute] = Me.attributes

	public func dates() -> [DateType: Date] {
		return [.start: timestamp]
	}

	public func value(of attribute: Attribute) throws -> Any {
		if attribute.name == Me.moodRating.name {
			return rating
		}
		if attribute.name == CommonSampleAttributes.timestamp.name {
			return timestamp
		}
		if attribute.name == Me.note.name {
			return note
		}
		throw SampleError.unknownAttribute
	}

	public func set(attribute: Attribute, to value: Any) throws {
		if attribute.name == Me.moodRating.name {
			guard let castedValue = value as? Double else { throw SampleError.typeMismatch }
			rating = castedValue
			return
		}
		if attribute.name == CommonSampleAttributes.timestamp.name {
			guard let castedValue = value as? Date else { throw SampleError.typeMismatch }
			timestamp = castedValue
			return
		}
		if attribute.name == Me.note.name {
			guard let castedValue = value as? String else { throw SampleError.typeMismatch }
			note = castedValue
			return
		}
		throw SampleError.unknownAttribute
	}
}
