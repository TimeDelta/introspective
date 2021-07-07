//
//  IntegerAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 9/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol IntegerAttributeRestriction: AttributeRestriction {
	var typedValue: Int { get }
}
