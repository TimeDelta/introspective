//
//  QuantityRestriction.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import NaturalLanguage
import os

public struct AttributeRestriction: CustomStringConvertible {

	public var operation: QueryOperation?
	public var attribute: Attribute
	public var comparison: AttributeComparisonType = .equals
	public var values: [Any]

	public init(_ attribute: Attribute) {
		self.attribute = attribute
		self.values = [Any]()
	}

	public var description: String {
		var description = ""
		if operation != nil {
			description += operation!.kind.description + " "
		}

		description += attribute.description + " "

		if operation != nil && operation!.aggregationUnit != nil {
			description += "per " + CalendarUtil.componentNames[operation!.aggregationUnit!]! + " "
		}

		description += comparison.description + " "

		for v in values {
			if attribute.isString {
				description += "\""
			}
			description += String(describing: v)
			if attribute.isString {
				description += "\""
			}
			description += ", "
		}
		description.removeLast()
		description.removeLast()

		return description
	}
}
