//
//  AnySample.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

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
}
