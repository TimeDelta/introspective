//
//  Aggregation.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol Aggregator: Attributed {

	func aggregate(samples: [Sample]) throws -> [(Aggregatable, [Sample])]
}
