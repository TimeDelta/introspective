//
//  AfterTimeOfDayAttributeRestriction.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/12/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class AfterTimeOfDayAttributeRestriction: DateAttributeRestriction, Equatable {

	fileprivate typealias Me = AfterTimeOfDayAttributeRestriction

	public static func ==(lhs: AfterTimeOfDayAttributeRestriction, rhs: AfterTimeOfDayAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public static let timeAttribute = TimeOfDayAttribute(
		name: "Time",
		pluralName: "Times",
		description: "The time of day after which a date must occur to pass this constraint")
	public static var attributes: [Attribute] = [
		timeAttribute,
	]

	public override var name: String { return "After time of day" }
	public override var description: String {
		let timeText = try! Me.timeAttribute.convertToDisplayableString(from: timeOfDay)
		return "After " + timeText
	}

	public var timeOfDay: TimeOfDay

	public required convenience init(attribute: Attribute) {
		self.init(attribute: attribute, timeOfDay: TimeOfDay())
	}

	public init(attribute: Attribute, timeOfDay: TimeOfDay = TimeOfDay()) {
		self.timeOfDay = timeOfDay
		super.init(attribute: attribute, attributes: Me.attributes)
	}

	public override func value(of attribute: Attribute) throws -> Any {
		if attribute.name != Me.timeAttribute.name {
			throw AttributeError.unknownAttribute
		}
		return timeOfDay
	}

	public override func set(attribute: Attribute, to value: Any) throws {
		if attribute.name != Me.timeAttribute.name {
			throw AttributeError.unknownAttribute
		}
		guard let castedValue = value as? TimeOfDay else { throw AttributeError.typeMismatch }
		timeOfDay = castedValue
	}

	public override func samplePasses(_ sample: Sample) throws -> Bool {
		guard let sampleDate = try sample.value(of: restrictedAttribute) as? Date else { throw SampleError.typeMismatch }
		return sampleDate > timeOfDay
	}

	public func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is AfterTimeOfDayAttributeRestriction) { return false }
		let other = otherAttributed as! AfterTimeOfDayAttributeRestriction
		return equalTo(other)
	}

	public func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is AfterTimeOfDayAttributeRestriction) { return false }
		let other = otherRestriction as! AfterTimeOfDayAttributeRestriction
		return equalTo(other)
	}

	public func equalTo(_ other: AfterTimeOfDayAttributeRestriction) -> Bool {
		return timeOfDay == other.timeOfDay
	}
}
