//
//  AfterTimeOfDayAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 8/12/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class AfterTimeOfDayAttributeRestriction: DateAttributeRestriction, Equatable {

	// MARK: - Static Variables

	private typealias Me = AfterTimeOfDayAttributeRestriction
	public static let timeAttribute = TimeOfDayAttribute(
		name: "Time",
		pluralName: "Times",
		description: "The time of day after which a date must occur to pass this constraint")
	public static var attributes: [Attribute] = [
		timeAttribute,
	]

	// MARK: - Display Information

	public final override var attributedName: String { return "After time of day" }
	public final override var description: String {
		do {
			let timeText = try Me.timeAttribute.convertToDisplayableString(from: timeOfDay)
			return "After " + timeText
		} catch {
			log.error("Failed to convert time of day to displayable string: %@", errorInfo(error))
			return "After " + timeOfDay.toString()
		}
	}

	// MARK: - Instance Variables

	public final var timeOfDay: TimeOfDay
	private final let log = Log()

	// MARK: - Initializers

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, timeOfDay: TimeOfDay())
	}

	public init(restrictedAttribute: Attribute, timeOfDay: TimeOfDay = TimeOfDay()) {
		self.timeOfDay = timeOfDay
		super.init(restrictedAttribute: restrictedAttribute, attributes: Me.attributes)
	}

	// MARK: - Attribute Functions

	public final override func value(of attribute: Attribute) throws -> Any? {
		if !attribute.equalTo(Me.timeAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		return timeOfDay
	}

	public final override func set(attribute: Attribute, to value: Any?) throws {
		if !attribute.equalTo(Me.timeAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		guard let castedValue = value as? TimeOfDay else {
			throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
		}
		timeOfDay = castedValue
	}

	// MARK: - Attribute Restriction Functions

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		if sampleValue == nil { return false }
		guard let sampleDate = sampleValue as? Date else {
			throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: sampleValue))
		}
		return sampleDate > timeOfDay
	}

	// MARK: - Equality

	public static func ==(lhs: AfterTimeOfDayAttributeRestriction, rhs: AfterTimeOfDayAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is AfterTimeOfDayAttributeRestriction) { return false }
		let other = otherAttributed as! AfterTimeOfDayAttributeRestriction
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is AfterTimeOfDayAttributeRestriction) { return false }
		let other = otherRestriction as! AfterTimeOfDayAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: AfterTimeOfDayAttributeRestriction) -> Bool {
		return restrictedAttribute.equalTo(other.restrictedAttribute) && timeOfDay == other.timeOfDay
	}
}
