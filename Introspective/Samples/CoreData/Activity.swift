//
//  Activity.swift
//  Introspective
//
//  Created by Bryan Nova on 11/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import Foundation
import CoreData

public class Activity: NSManagedObject, CoreDataSample {

	private typealias Me = Activity

	// MARK: - CoreData Stuff

	public static let entityName = "Activity"

	// MARK: - Display Information

	public static let name = "Activity"
	public static let description = ""

	// MARK: - Attributes

	public static let nameAttribute = TextAttribute(name: "Name", pluralName: "Names", description: "The name of this activity", variableName: "definition.name")
	public static let endDateAttribute = DateTimeAttribute(name: "End Date", pluralName: "End Dates", variableName: "endDate", optional: true)
	public static let noteAttribute = TextAttribute(name: "Note", pluralName: "Notes", variableName: "note")
	public static let tagsAttribute = TagsAttribute()
	public static let durationAttribute = DurationAttribute()

	public static let defaultDependentAttribute: Attribute = durationAttribute
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.startDate

	public static let attributes: [Attribute] = [
		nameAttribute,
		durationAttribute,
		CommonSampleAttributes.startDate,
		endDateAttribute,
		noteAttribute,
		tagsAttribute,
	]
	public final let attributes: [Attribute] = Me.attributes

	// MARK: - Instance Variables

	public final let attributedName: String = Me.name
	public final override var description: String {
		return "What you are doing at a specific point in time."
	}

	public final var duration: Duration {
		return Duration(start: startDate, end: endDate)
	}

	// MARK: - Sample Functions

	public func dates() -> [DateType : Date] {
		var dates = [DateType : Date]()
		dates[.start] = startDate
		if let endDate = endDate {
			dates[.end] = endDate
		}
		return dates
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.nameAttribute) {
			return definition.name
		}
		if attribute.equalTo(Me.durationAttribute) {
			return duration
		}
		if attribute.equalTo(CommonSampleAttributes.startDate) {
			return startDate
		}
		if attribute.equalTo(Me.endDateAttribute) {
			return endDate
		}
		if attribute.equalTo(Me.tagsAttribute) {
			var tags = tagsArray()
			tags.append(contentsOf: definition.tagsArray())
			return tags
		}
		if attribute.equalTo(Me.noteAttribute) {
			return note
		}
		throw AttributeError.unknownAttribute
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(Me.nameAttribute) {
			guard let castedValue = value as? String else { throw AttributeError.typeMismatch }
			definition.name = castedValue
			DependencyInjector.db.save()
			return
		}
		if attribute.equalTo(CommonSampleAttributes.startDate) {
			guard let castedValue = value as? Date else { throw AttributeError.typeMismatch }
			startDate = castedValue
			DependencyInjector.db.save()
			return
		}
		if attribute.equalTo(Me.endDateAttribute) {
			if !(value is Date?) { throw AttributeError.typeMismatch }
			endDate = (value as! Date?)
			DependencyInjector.db.save()
			return
		}
		if attribute.equalTo(Me.noteAttribute) {
			if !(value is String?) { throw AttributeError.typeMismatch }
			note = (value as! String?)
			DependencyInjector.db.save()
			return
		}
		if attribute.equalTo(Me.tagsAttribute) {
			guard let castedValue = value as? [Tag] else { throw AttributeError.typeMismatch }
			try setTags(castedValue)
			return
		}
		throw AttributeError.unknownAttribute
	}

	// MARK: - Other

	/// - Returns: Only tags directly associated with this `Activity`.
	///            Does not include tags associated with this activitiy's `ActivityDefinition`.
	public final func tagsArray() -> [Tag] {
		return tags.allObjects as! [Tag]
	}

	/// - Note: Only sets tags associated with this `Activity`.
	///         Does not remove any tags associated with this activity's `ActivityDefinition`.
	public final func setTags(_ newTags: [Tag]) throws {
		removeAllTags()
		for tag in newTags {
			let tagToAdd = try DependencyInjector.db.pull(savedObject: tag, fromSameContextAs: self)
			if !tagToAdd.isFault {
				addToTags(tagToAdd)
			} else if !tag.isFault {
				addToTags(tag)
			}
		}
		DependencyInjector.db.save()
	}

	// MARK: - Equatable

	public static func ==(lhs: Activity, rhs: Activity) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is Activity) { return false }
		let other = otherAttributed as! Activity
		return equalTo(other)
	}

	public final func equalTo(_ otherSample: Sample) -> Bool {
		if !(otherSample is Activity) { return false }
		let other = otherSample as! Activity
		return equalTo(other)
	}

	public final func equalTo(_ other: Activity) -> Bool {
		return definition.equalTo(other.definition) &&
			startDate == other.startDate &&
			endDate == other.endDate &&
			tagsArray().elementsEqual(other.tagsArray(), by: { $0.equalTo($1) }) &&
			note == other.note
	}

	// MARK: - Debug

	public final override var debugDescription: String {
		var timestampText = startDate.debugDescription
		if let endDate = endDate {
			timestampText = "from " + timestampText + " to " + endDate.debugDescription
		} else {
			timestampText = "starting at " + timestampText
		}
		let noteText = note ?? "nil"
		var tagsText = ""
		for tag in tagsArray() {
			tagsText += tag.name + ", "
		}
		if !tagsText.isEmpty {
			tagsText.removeLast()
			tagsText.removeLast()
		}
		return "Activity named '\(definition.name)' '\(timestampText)', with tags [\(tagsText)] and note: '\(noteText)'"
	}

	// MARK: - Helper Functions

	private final func removeAllTags() {
		for tag in tagsArray() {
			removeFromTags(tag)
		}
	}
}
