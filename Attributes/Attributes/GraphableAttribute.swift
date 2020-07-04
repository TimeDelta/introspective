//
//  GraphableAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 8/1/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

public protocol GraphableAttribute: Attribute {
	func graphableValueFor(_ value: Any) throws -> Double
}
