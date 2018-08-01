//
//  StartsAfterDateOnlyTimeConstraint.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class StartsAfterDateOnlyTimeConstraint: TimeConstraint {

	fileprivate typealias Me = StartsAfterDateOnlyTimeConstraint

	public static let dateAttribute = DateOnlyAttribute(name: "Date", latestDate: Date())
	public static var attributes: [Attribute] = [
		dateAttribute,
	]

	public let name: String = "Starts after date"
	public let attributes: [Attribute] = Me.attributes
	public var description: String {
		let dateText = try! Me.dateAttribute.convertToString(from: date)
		return "Starts after " + dateText
	}

	public var date: Date {
		didSet {
			date = DependencyInjector.util.calendarUtil.end(of: .day, in: date)
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
		return sample.dates[.start]!.isAfterDate(date, granularity: .second)
	}
}
