//
//  StartsOnDateTimeConstraint.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class StartsOnDateTimeConstraint: TimeConstraint {

	fileprivate typealias Me = StartsOnDateTimeConstraint

	public static let dateAttribute = DateOnlyAttribute(name: "Date")
	public static var attributes: [Attribute] = [
		dateAttribute,
	]

	public let name: String = "Starts on date"
	public let attributes: [Attribute] = Me.attributes
	public var description: String {
		let dateText = try! Me.dateAttribute.convertToString(from: date)
		return "Starts on " + dateText
	}

	public var date: Date {
		didSet {
			date = DependencyInjector.util.calendarUtil.start(of: .day, in: date)
		}
	}

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
		return DependencyInjector.util.calendarUtil.date(sample.dates[.start]!, occursOnSame: .day, as: date)
	}
}