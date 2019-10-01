//
//  SelectAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol SelectAttribute: Attribute {

	var possibleValues: [Any] { get }

	/// - Parameter values: If `nil`, return the index within the `possibleValues` array, otherwise return the index within `values`.
	func indexOf(possibleValue: Any, in values: [Any]?) -> Int?
}

public extension SelectAttribute {

	/// - Parameter values: If `nil`, return the index within the `possibleValues` array, otherwise return the index within `values`.
	func indexOf(possibleValue: Any, in values: [Any]? = nil) -> Int? {
		return indexOf(possibleValue: possibleValue, in: values)
	}
}
