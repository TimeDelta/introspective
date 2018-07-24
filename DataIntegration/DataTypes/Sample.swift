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

public protocol Sample {

	var dates: [DateType: Date] { get }
	var dataType: DataTypes { get }
	var attributes: [Attribute] { get }

	func value<ValueType>(of attribute: Attribute) throws -> ValueType
	func setValue<ValueType>(of attribute: Attribute, to value: ValueType) throws
}


/// An abstract base class for everything that implements the Sample protocol
public class AnySample: Sample {

	public var dates: [DateType: Date]
	public var dataType: DataTypes { get { fatalError("Must override") } }
	public var attributes: [Attribute] { get { fatalError("Must override") } }

	public init() {
		dates = [.start: Date()]
	}

	public init(_ dateType: DateType, _ date: Date) {
		dates = [DateType: Date]()
		dates[dateType] = date
	}

	public init(_ dates: [DateType: Date]) {
		self.dates = dates
	}

	public func value<ValueType>(of attribute: Attribute) throws -> ValueType {
		fatalError("Must override")
	}

	public func setValue<ValueType>(of attribute: Attribute, to value: ValueType) throws {
		fatalError("Must override")
	}
}
