//
//  Sample.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

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
}


/// An abstract base class for everything that implements the Sample protocol
public class SampleBase: Sample {

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
