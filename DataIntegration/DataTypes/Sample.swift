//
//  Sample.swift
//  DataIntegration
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

public enum SampleError: Error {
	case typeMismatch
	case unknownAttribute
}

public protocol Sample: Attributed {

	var dates: [DateType: Date] { get }
	var dataType: DataTypes { get }

	func equalTo(_ otherSample: Sample) -> Bool
}

extension Sample {

	public func equalTo(_ otherSample: Sample) -> Bool {
		if name != otherSample.name { return false }
		if description != otherSample.description { return false }
		if dates != otherSample.dates { return false }
		if dataType != otherSample.dataType { return false }
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
					os_log("Sample - Need to include equal comparison for attribute type: $@", type: .debug, String(describing: type(of: attribute)))
			}
		}
		return true
	}
}

/// An abstract base class for everything that implements the Sample protocol
public class SampleBase: Sample, Equatable {

	public static func == (lhs: SampleBase, rhs: SampleBase) -> Bool {
		return lhs.equalTo(rhs)
	}

	public static let startDate = DateTimeAttribute(name: "Start date")
	public static let endDate = DateTimeAttribute(name: "End date")

	public var name: String { get { fatalError("Must override") } }
	public var description: String { get { fatalError("Must override") } }

	public var dates: [DateType: Date]
	public var dataType: DataTypes { get { fatalError("Must override") } }
	public var attributes: [Attribute] { get { fatalError("Must override") } }

	public required init() {
		dates = [.start: Date()]
	}

	public init(_ dateType: DateType, _ date: Date) {
		dates = [DateType: Date]()
		dates[dateType] = date
	}

	public init(_ dates: [DateType: Date]) {
		self.dates = dates
	}

	public func value(of attribute: Attribute) throws -> Any {
		fatalError("Must override")
	}

	public func set(attribute: Attribute, to value: Any) throws {
		fatalError("Must override")
	}
}
