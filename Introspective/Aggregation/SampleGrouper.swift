//
//  SampleGrouper.swift
//  Introspective
//
//  Created by Bryan Nova on 8/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol SampleGrouper: Attributed {

	init()

	func group(samples: [Sample], by attribute: Attribute) -> [(Any, [Sample])]
}
