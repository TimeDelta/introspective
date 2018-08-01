//
//  DoubleAttributeRestriction.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class DoubleAttributeRestriction: AnyAttributeRestriction {

	override func isValid(attribute: Attribute) -> Bool {
		return attribute is DoubleAttribute
	}
}
