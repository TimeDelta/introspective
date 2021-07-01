//
//  DoubleAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 9/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol DoubleAttributeRestriction: AttributeRestriction {

	var typedValue: Double { get }
}
