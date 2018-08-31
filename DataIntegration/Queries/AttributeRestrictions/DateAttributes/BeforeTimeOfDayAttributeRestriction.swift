//
//  BeforeTimeOfDayAttributeRestriction.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/12/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class BeforeTimeOfDayAttributeRestriction: DateAttributeRestriction, Equatable {

	private typealias Me = BeforeTimeOfDayAttributeRestriction

	public static func ==(lhs: BeforeTimeOfDayAttributeRestriction, rhs: BeforeTimeOfDayAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public static let timeAttribute = TimeOfDayAttribute(
		name: "Time",
		pluralName: "Times",
		description: "The time of day before which a date must occur to pass this restriction")
	public static var attributes: [Attribute] = [
		timeAttribute,
	]

	public final override var name: String { return "Before time of day" }
	public final override var description: String {
		let timeText = try! Me.timeAttribute.convertToDisplayableString(from: timeOfDay)
		return "Before " + timeText
	}

	public final var timeOfDay: TimeOfDay

	public required convenience init(attribute: Attribute) {
		self.init(attribute: attribute, timeOfDay: TimeOfDay())
	}

	public init(attribute: Attribute, timeOfDay: TimeOfDay = TimeOfDay()) {
		self.timeOfDay = timeOfDay
		super.init(attribute: attribute, attributes: Me.attributes)
	}

	public final override func value(of attribute: Attribute) throws -> Any {
		if attribute.name != Me.timeAttribute.name {
			throw AttributeError.unknownAttribute
		}
		return timeOfDay
	}

	public final override func set(attribute: Attribute, to value: Any) throws {
		if attribute.name != Me.timeAttribute.name {
			throw AttributeError.unknownAttribute
		}
		guard let castedValue = value as? TimeOfDay else { throw AttributeError.typeMismatch }
		timeOfDay = castedValue
	}

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		guard let sampleDate = try sample.value(of: restrictedAttribute) as? Date else { throw AttributeError.typeMismatch }
		return sampleDate < timeOfDay
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is BeforeTimeOfDayAttributeRestriction) { return false }
		let other = otherAttributed as! BeforeTimeOfDayAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is BeforeTimeOfDayAttributeRestriction) { return false }
		let other = otherRestriction as! BeforeTimeOfDayAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: BeforeTimeOfDayAttributeRestriction) -> Bool {
		return restrictedAttribute.equalTo(other.restrictedAttribute) && timeOfDay == other.timeOfDay
	}
}
