//
//  Sample.swift
//  Introspective
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

public enum DateType {
	case start
	case end
}

public protocol Sample: Attributed {

	static var name: String { get }

	static var attributes: [Attribute] { get }
	static var defaultDependentAttribute: Attribute { get }
	static var defaultIndependentAttribute: Attribute { get }

	func dates() -> [DateType: Date]
	func equalTo(_ otherSample: Sample) -> Bool
}

extension Sample {

	public func equalTo(_ otherSample: Sample) -> Bool {
		if name != otherSample.name { return false }
		if description != otherSample.description { return false }
		if dates() != otherSample.dates() { return false }
		if type(of: self) != type(of: otherSample) { return false }
		if attributes.count != otherSample.attributes.count { return false }
		for attribute in attributes {
			let index = otherSample.attributes.index(where: { (a: Attribute) -> Bool in return a.equalTo(attribute) })
			if index == nil { return false }
		}
		for attribute in attributes {
			switch (attribute) {
				case is DateAttribute:
					let myDate = try! value(of: attribute) as! Date
					let otherDate = try! otherSample.value(of: attribute) as! Date
					if myDate != otherDate { return false }
					break
				case is IntegerAttribute:
					let myInt = try! value(of: attribute) as! Int
					let otherInt = try! otherSample.value(of: attribute) as! Int
					if myInt != otherInt { return false }
					break
				case is DoubleAttribute:
					let myDouble = try! value(of: attribute) as! Double
					let otherDouble = try! otherSample.value(of: attribute) as! Double
					if myDouble != otherDouble { return false }
					break
				default:
					os_log("Sample - Need to include equal comparison for attribute type: %@", type: .debug, String(describing: type(of: attribute)))
			}
		}
		return true
	}
}

public class CommonSampleAttributes {

	public static let timestamp = DateTimeAttribute(name: "Timestamp", pluralName: "Timestamps", variableName: "timestamp")
	public static let startDate = DateTimeAttribute(name: "Start date", pluralName: "Start dates", variableName: "startDate")
	public static let endDate = DateTimeAttribute(name: "End date", pluralName: "End dates", variableName: "endDate")
}
