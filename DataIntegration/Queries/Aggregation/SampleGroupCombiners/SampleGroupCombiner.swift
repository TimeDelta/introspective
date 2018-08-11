//
//  SampleGroupCombiner.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol SampleGroupCombiner: CustomStringConvertible {

	static var name: String { get }
	var descriptionIsPlural: Bool { get }

	init()

	func combine(groups: [(Any, [Sample])], groupedBy groupAttribute: Attribute, combinationAttribute: Attribute) -> [Sample]
}
