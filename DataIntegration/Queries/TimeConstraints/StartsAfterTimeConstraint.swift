//
//  StartsAfterTimeConstraint.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class StartsAfterTimeConstraint: TimeConstraint {

	fileprivate typealias Me = StartsAfterTimeConstraint

	public static let dateAttribute = DateTimeAttribute(name: "Date", latestDate: Date())
	public static var attributes: [Attribute] = [
		dateAttribute,
	]

	public let name = "Starts after date and time"
	public let attributes: [Attribute] = Me.attributes
	public var description: String {
		return "Starts after " + DependencyInjector.util.calendarUtil.string(for: date)
	}

	public var date: Date

	public required init() {
		date = Date()
	}

	public func value(of attribute: Attribute) throws -> Any {
		if attribute.name != Me.dateAttribute.name {
			throw AttributeError.unknownAttribute
		}
		return date
	}

	public func set(attribute: Attribute, to value: Any) throws {
		if attribute.name != Me.dateAttribute.name {
			throw AttributeError.unknownAttribute
		}
		guard let castedValue = value as? Date else { throw AttributeError.typeMismatch }
		date = castedValue
	}

	public func isValid() -> Bool {
		return true
	}

	public func sampleAdheres(_ sample: Sample) -> Bool {
		return sample.dates[.start]!.isAfterDate(date, granularity: .second)
	}
}
