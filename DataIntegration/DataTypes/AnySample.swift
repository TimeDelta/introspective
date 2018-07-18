//
//  AnySample.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

public class AnySample: SampleBase {

	public override var name: String { return realName }
	public override var description: String { return realDescription }
	public override var dataType: DataTypes { return .heartRate } // TODO - change this to custom once custom data types are supported
	public override var attributes: [Attribute] {
		return realAttributes
	}

	fileprivate var realName: String = ""
	fileprivate var realDescription: String = ""
	fileprivate var realAttributes: [Attribute]
	fileprivate var attributeValues: [String: Any]

	public required init() {
		realAttributes = [Attribute]()
		attributeValues = [String: Any]()
		super.init()
	}

	init(name: String, description: String = "", attributes: [Attribute], attributeValues: [String: Any] = [String: Any]()) {
		self.realAttributes = attributes
		self.attributeValues = attributeValues
		super.init()
	}

	public override func value(of attribute: Attribute) throws -> Any {
		guard let value = attributeValues[attribute.name] else { throw SampleError.unknownAttribute }
		return value
	}

	public override func set(attribute: Attribute, to value: Any) throws {
		guard let _ = realAttributes.first(where: { a in return a.name == attribute.name }) else { throw SampleError.unknownAttribute }
		attributeValues[attribute.name] = value
	}

	public override func equalTo(_ otherSample: Sample) -> Bool {
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
					os_log("AnySample - Need to include equal comparison for attribute type: $@", type: .debug, String(describing: type(of: attribute)))
			}
		}
		return true
	}
}
