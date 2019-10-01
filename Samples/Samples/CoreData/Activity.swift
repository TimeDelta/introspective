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
import CSV

import Attributes
import Common
import DependencyInjection
import Persistence

public class Activity: NSManagedObject, CoreDataSample {

	private typealias Me = Activity

	// MARK: - CoreData Stuff

	public static let entityName = "Activity"

	// MARK: - Display Information

	public static let name = "Activity"
	public static let description = ""

	// MARK: - Attributes

	public static let nameAttribute = TextAttribute(name: "Name", pluralName: "Names", description: "The name of this activity", variableName: "definition.name")
	public static let noteAttribute = TextAttribute(name: "Note", pluralName: "Notes", variableName: "note")
	public static let tagsAttribute = ActivityTagsAttribute(variableName: "tags")
	public static let durationAttribute = DurationAttribute()
	public static let sourceAttribute = TypedEquatableSelectOneAttribute<String>(
		name: "Source",
		typeName: "Activity Source",
		pluralName: "Sources",
		possibleValues: Sources.ActivitySourceNum.values.map{ $0.description },
		possibleValueToString: { $0 })

	public static let defaultDependentAttribute: Attribute = durationAttribute
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.startDate

	public static let attributes: [Attribute] = [
		nameAttribute,
		durationAttribute,
		CommonSampleAttributes.startDate,
		CommonSampleAttributes.optionalEndDate,
		noteAttribute,
		tagsAttribute,
		sourceAttribute,
	]
	public final let attributes: [Attribute] = Me.attributes

	// MARK: - Instance Variables

	public final let attributedName: String = Me.name
	public final override var description: String {
		return "What you are doing at a specific point in time."
	}

	public final var start: Date {
		get {
			return DependencyInjector.get(CoreDataSampleUtil.self).convertTimeZoneIfApplicable(
				for: startDate,
				timeZoneId: startDateTimeZoneId)
		}
		set {
			startDate = newValue
			if source == Sources.ActivitySourceNum.introspective.rawValue && startDateTimeZoneId == nil {
				startDateTimeZoneId = DependencyInjector.get(CalendarUtil.self).currentTimeZone().identifier
			}
		}
	}
	public final var end: Date? {
		get {
			if let endDate = endDate {
				return DependencyInjector.get(CoreDataSampleUtil.self).convertTimeZoneIfApplicable(
					for: endDate,
					timeZoneId: endDateTimeZoneId)
			}
			return nil
		}
		set {
			endDate = newValue
			if source == Sources.ActivitySourceNum.introspective.rawValue && endDateTimeZoneId == nil && endDate != nil {
				endDateTimeZoneId = DependencyInjector.get(CalendarUtil.self).currentTimeZone().identifier
			}
			if endDate == nil {
				endDateTimeZoneId = nil
			}
		}
	}
	public final var duration: Duration {
		// use raw unconverted dates to avoid issues caused by start and end being in
		// different time zones such as negative durations
		return Duration(start: startDate, end: endDate)
	}

	// MARK: - Sample Functions

	public func dates() -> [DateType : Date] {
		var dates = [DateType : Date]()
		dates[.start] = start
		if let end = end {
			dates[.end] = end
		}
		return dates
	}

	public final func graphableValue(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.durationAttribute) {
			return duration.inUnit(.hour)
		}
		return try value(of: attribute)
	}

	// MARK: - Export

	public static let exportFileDescription: String = "Activities"

	public static func exportHeaderRow(to csv: CSVWriter) throws {
		try ActivityDefinition.exportHeaderRow(to: csv)
		try csv.write(field: "Start", quoted: true)
		try csv.write(field: "Start Time Zone", quoted: true)
		try csv.write(field: "End", quoted: true)
		try csv.write(field: "End Time Zone", quoted: true)
		try csv.write(field: "Note", quoted: true)
		try csv.write(field: "Extra Tags", quoted: true)
		try csv.write(field: "Instance Source", quoted: true)
	}

	public final func export(to csv: CSVWriter) throws {
		try definition.export(to: csv)

		let startText = DependencyInjector.get(CalendarUtil.self).string(for: startDate, dateStyle: .full, timeStyle: .full)
		try csv.write(field: startText, quoted: true)

		let startTimeZone = startDateTimeZoneId ?? ""
		try csv.write(field: startTimeZone, quoted: true)

		if let endDate = endDate {
			let endText = DependencyInjector.get(CalendarUtil.self).string(for: endDate, dateStyle: .full, timeStyle: .full)
			try csv.write(field: endText, quoted: true)
		} else {
			try csv.write(field: "", quoted: true)
		}

		let endTimeZone = endDateTimeZoneId ?? ""
		try csv.write(field: endTimeZone, quoted: true)

		try csv.write(field: note ?? "", quoted: true)

		let tags = tagsArray().map{ $0.name }.joined(separator: "|")
		try csv.write(field: tags, quoted: true)

		let sourceText = Sources.resolveActivitySource(source).description
		try csv.write(field: sourceText, quoted: true)
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
			return start
		}
		if attribute.equalTo(CommonSampleAttributes.optionalEndDate) {
			return end
		}
		if attribute.equalTo(Me.tagsAttribute) {
			var tags = tagsArray()
			tags.append(contentsOf: definition.tagsArray())
			return tags
		}
		if attribute.equalTo(Me.noteAttribute) {
			return note
		}
		if attribute.equalTo(Me.sourceAttribute) {
			return Sources.resolveActivitySource(source).description
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(Me.nameAttribute) {
			guard let castedValue = value as? String else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}

			let fetchRequest: NSFetchRequest<ActivityDefinition> = ActivityDefinition.fetchRequest()
			fetchRequest.predicate = NSPredicate(format: "name == %@", castedValue)
			let matchingDefinitions = try DependencyInjector.get(Database.self).query(fetchRequest)
			if matchingDefinitions.count == 0 {
				throw UnsupportedValueError(attribute: attribute, of: self, is: value)
			}

			definition = try DependencyInjector.get(Database.self).pull(savedObject: matchingDefinitions[0], fromSameContextAs: self)
			return
		}
		if attribute.equalTo(CommonSampleAttributes.startDate) {
			guard let castedValue = value as? Date else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			startDate = castedValue
			if source == Sources.ActivitySourceNum.introspective.rawValue && startDateTimeZoneId == nil {
				startDateTimeZoneId = DependencyInjector.get(CalendarUtil.self).currentTimeZone().identifier
			}
			return
		}
		if attribute.equalTo(CommonSampleAttributes.optionalEndDate) {
			if !(value is Date?) {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			endDate = (value as! Date?)
			if source == Sources.ActivitySourceNum.introspective.rawValue && endDateTimeZoneId == nil && endDate != nil {
				endDateTimeZoneId = DependencyInjector.get(CalendarUtil.self).currentTimeZone().identifier
			}
			if endDate == nil {
				endDateTimeZoneId = nil
			}
			return
		}
		if attribute.equalTo(Me.noteAttribute) {
			if !(value is String?) {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			note = (value as! String?)
			return
		}
		if attribute.equalTo(Me.tagsAttribute) {
			guard let castedValue = value as? [Tag] else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			try setTags(castedValue)
			return
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	// MARK: - Other

	public final func getSource() -> Sources.ActivitySourceNum {
		return Sources.resolveActivitySource(source)
	}

	public final func setSource(_ source: Sources.ActivitySourceNum) {
		self.source = source.rawValue
		if source == Sources.ActivitySourceNum.introspective && startDateTimeZoneId == nil {
			startDateTimeZoneId = DependencyInjector.get(CalendarUtil.self).currentTimeZone().identifier
		}
		if source == Sources.ActivitySourceNum.introspective && endDateTimeZoneId == nil && endDate != nil {
			endDateTimeZoneId = DependencyInjector.get(CalendarUtil.self).currentTimeZone().identifier
		}
	}

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
			let tagToAdd = try DependencyInjector.get(Database.self).pull(savedObject: tag, fromSameContextAs: self)
			addToTags(tagToAdd)
		}
	}

	// MARK: - Equatable

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

// MARK: - CoreData

public extension Activity {

	@nonobjc class func fetchRequest() -> NSFetchRequest<Activity> {
		return NSFetchRequest<Activity>(entityName: "Activity")
	}

	@NSManaged fileprivate var startDate: Date
	@NSManaged fileprivate var startDateTimeZoneId: String?
	@NSManaged fileprivate var endDate: Date?
	@NSManaged fileprivate var endDateTimeZoneId: String?
	@NSManaged var note: String?
	@NSManaged var definition: ActivityDefinition
	@NSManaged var tags: NSSet
	@NSManaged var source: Int16

	@objc(addTagsObject:)
	@NSManaged func addToTags(_ value: Tag)

	@objc(removeTagsObject:)
	@NSManaged func removeFromTags(_ value: Tag)

	@objc(addTags:)
	@NSManaged func addToTags(_ values: NSSet)

	@objc(removeTags:)
	@NSManaged func removeFromTags(_ values: NSSet)
}
