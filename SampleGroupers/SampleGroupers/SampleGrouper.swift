//
//  SampleGrouper.swift
//  Introspective
//
//  Created by Bryan Nova on 8/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Samples

public protocol SampleGrouper: Attributed {

	/// Keep this short so that it fits in the display
	static var userVisibleDescription: String { get }

	init(sampleType: Sample.Type)
	init(attributes: [Attribute])

	func group(samples: [Sample]) throws -> [(Any, [Sample])]
	func groupNameFor(value: Any) throws -> String
	func groupValuesAreEqual(_ first: Any, _ second: Any) throws -> Bool

	/// create and return a deep copy of this object
	func copy() -> SampleGrouper

	func equalTo(_ otherGrouper: SampleGrouper) -> Bool
}
