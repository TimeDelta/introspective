//
//  QuantityRestriction.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

class QuantityRestriction<ValueType>: NSObject {

	fileprivate(set) var attribute: String
	fileprivate(set) var comparison: NSComparisonPredicate.Operator
	fileprivate(set) var value: ValueType

	init(attribute: String, _ comparison: NSComparisonPredicate.Operator, value: ValueType) {
		self.attribute = attribute
		self.comparison = comparison
		self.value = value
	}
}
