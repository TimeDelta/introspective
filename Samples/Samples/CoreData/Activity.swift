//
//  Activity.swift
//  Introspective
//
//  Created by Bryan Nova on 11/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import CoreData
import CSV
import Foundation

import Attributes
import Common
import DependencyInjection
import Persistence

public class Activity: NSManagedObject, CoreDataSample, SearchableSample {
	private typealias Me = Activity

	private static let log = Log()

	// MARK: - CoreData Stuff

	public static let entityName = "Activity"

	// MARK: - Display Information

	public static let name = "Activity"
	public static let description = ""

	// MARK: - Attributes

	public static let nameAttribute = TextAttribute(
		name: "Name",
		pluralName: "Names",
		description: "The name of this activity",
		variableName: "definition.name"
	)
	public static let noteAttribute = TextAttribute(name: "Note", pluralName: "Notes", variableName: "note")
	public static let tagsAttribute = ActivityTagsAttribute(variableName: "tags")
	public static let durationAttribute = DurationAttribute()
	public static let sourceAttribute = TypedEquatableSelectOneAttribute<String>(
		name: "Source",
		typeName: "Activity Source",
		pluralName: "Sources",
		possibleValues: Sources.ActivitySourceNum.values.map { $0.description },
		possibleValueToString: { $0 }
	)

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
	public static var dateAttributes: [DateType: DateAttribute] = [
		.start: CommonSampleAttributes.startDate,
		.end: CommonSampleAttributes.endDate,
	]

	// MARK: - Destructor

	deinit {
		cleanUp()
	}

	// MARK: - Searching

	public func matchesSearchString(_ searchString: String) -> Bool {
		definition.name.localizedCaseInsensitiveContains(searchString) ||
			(note?.localizedCaseInsensitiveContains(searchString) ?? false) ||
			hasTag(searchString) ||
			getSource().description.localizedLowercase == searchString.localizedLowercase
	}

	// MARK: - Instance Variables

	public final let attributedName: String = Me.name
	public final override var description: String {
		"What you are doing at a specific point in time."
	}

	public final var start: Date {
		get {
			injected(CoreDataSampleUtil.self).convertTimeZoneIfApplicable(
				for: startDate,
				timeZoneId: startDateTimeZoneId
			)
		}
		set {
			startDate = newValue
			if source == Sources.ActivitySourceNum.introspective.rawValue && startDateTimeZoneId == nil {
				startDateTimeZoneId = injected(CalendarUtil.self).currentTimeZone().identifier
			}
		}
	}

	public final var end: Date? {
		get {
			if let endDate = endDate {
				return injected(CoreDataSampleUtil.self).convertTimeZoneIfApplicable(
					for: endDate,
					timeZoneId: endDateTimeZoneId
				)
			}
			return nil
		}
		set {
			endDate = newValue
			if source == Sources.ActivitySourceNum.introspective
				.rawValue && endDateTimeZoneId == nil && endDate != nil {
				endDateTimeZoneId = injected(CalendarUtil.self).currentTimeZone().identifier
			}
			if endDate == nil {
				endDateTimeZoneId = nil
			}
		}
	}

	public final var duration: TimeDuration {
		// use raw unconverted dates to avoid issues such as negative durations
		// caused by start and end being in different time zones
		TimeDuration(start: startDate, end: endDate)
	}

	public final var startDateTimeZone: String? { startDateTimeZoneId }
	public final var endDateTimeZone: String? { endDateTimeZoneId }

	// MARK: - Testing Purposes

	public final var storedStartDate: Date { startDate }
	public final var storedEndDate: Date? { endDate }

	// MARK: - Sample Functions

	public func dates() -> [DateType: Date] {
		var dates = [DateType: Date]()
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

	// MARK: Export Column Names

	public static let startColumn = "Start"
	public static let startTimeZoneColumn = "Start Time Zone"
	public static let endColumn = "End"
	public static let endTimeZoneColumn = "End Time Zone"
	public static let noteColumn = "Note"
	public static let tagsColumn = "Extra Tags"
	public static let sourceColumn = "Instance Source"

	// MARK: Export Functions

	public static func exportHeaderRow(to csv: CSVWriter) throws {
		try ActivityDefinition.exportHeaderRow(to: csv)
		try csv.write(field: startColumn, quoted: true)
		try csv.write(field: startTimeZoneColumn, quoted: true)
		try csv.write(field: endColumn, quoted: true)
		try csv.write(field: endTimeZoneColumn, quoted: true)
		try csv.write(field: noteColumn, quoted: true)
		try csv.write(field: tagsColumn, quoted: true)
		try csv.write(field: sourceColumn, quoted: true)
	}

	public final func export(to csv: CSVWriter) throws {
		try definition.export(to: csv)

		let startText = injected(CalendarUtil.self)
			.string(for: startDate, dateStyle: .full, timeStyle: .full)
		try csv.write(field: startText, quoted: true)

		let startTimeZone = startDateTimeZoneId ?? ""
		try csv.write(field: startTimeZone, quoted: true)

		if let endDate = endDate {
			let endText = injected(CalendarUtil.self)
				.string(for: endDate, dateStyle: .full, timeStyle: .full)
			try csv.write(field: endText, quoted: true)
		} else {
			try csv.write(field: "", quoted: true)
		}

		let endTimeZone = endDateTimeZoneId ?? ""
		try csv.write(field: endTimeZone, quoted: true)

		try csv.write(field: note ?? "", quoted: true)

		let tags = tagsArray().map { $0.name }.joined(separator: "|")
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

			guard let newDefinition = try injected(ActivityDAO.self).getDefinitionWith(name: castedValue) else {
				throw UnsupportedValueError(attribute: attribute, of: self, is: value)
			}

			definition = try injected(Database.self).pull(savedObject: newDefinition, fromSameContextAs: self)
			return
		}
		if attribute.equalTo(CommonSampleAttributes.startDate) {
			guard let castedValue = value as? Date else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			startDate = castedValue
			if source == Sources.ActivitySourceNum.introspective.rawValue && startDateTimeZoneId == nil {
				startDateTimeZoneId = injected(CalendarUtil.self).currentTimeZone().identifier
			}
			return
		}
		if attribute.equalTo(CommonSampleAttributes.optionalEndDate) {
			if !(value is Date?) {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			endDate = (value as! Date?)
			if source == Sources.ActivitySourceNum.introspective.rawValue
				&& endDateTimeZoneId == nil
				&& endDate != nil
			{
				endDateTimeZoneId = injected(CalendarUtil.self).currentTimeZone().identifier
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

	// MARK: Time Zone

	public final func setStartTimeZone(_ timeZone: TimeZone?) {
		startDateTimeZoneId = timeZone?.identifier
	}

	public final func setEndTimeZone(_ timeZone: TimeZone?) {
		endDateTimeZoneId = timeZone?.identifier
	}

	// MARK: Source

	public final func getSource() -> Sources.ActivitySourceNum {
		Sources.resolveActivitySource(source)
	}

	public final func setSource(_ source: Sources.ActivitySourceNum) {
		self.source = source.rawValue
		if source == Sources.ActivitySourceNum.introspective && startDateTimeZoneId == nil {
			startDateTimeZoneId = injected(CalendarUtil.self).currentTimeZone().identifier
		}
		if source == Sources.ActivitySourceNum.introspective && endDateTimeZoneId == nil && endDate != nil {
			endDateTimeZoneId = injected(CalendarUtil.self).currentTimeZone().identifier
		}
	}

	// MARK: Tags

	/// - Returns: Only tags directly associated with this `Activity`.
	///            Does not include tags associated with this activitiy's `ActivityDefinition`.
	public final func tagsArray() -> [Tag] {
		tags.allObjects as! [Tag]
	}

	/// - Note: Only sets tags associated with this `Activity`.
	///         Does not remove any tags associated with this activity's `ActivityDefinition`.
	public final func setTags(_ newTags: [Tag]) throws {
		removeAllTags()
		for tag in newTags {
			let tagToAdd = try injected(Database.self).pull(savedObject: tag, fromSameContextAs: self)
			addToTags(tagToAdd)
		}
	}

	public final func hasTag(_ targetName: String) -> Bool {
		if var tags = tags.allObjects as? [Tag] {
			tags.append(contentsOf: definition.tagsArray())
			return !tags.filter { t in t.name.localizedLowercase == targetName.localizedLowercase }.isEmpty
		}
		Me.log.error("Failed to cast activity tags array")
		return false
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
		definition.equalTo(other.definition) &&
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
		NSFetchRequest<Activity>(entityName: "Activity")
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
