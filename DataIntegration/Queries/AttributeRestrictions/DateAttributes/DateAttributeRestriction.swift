//
//  DateAttributeRestriction.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class DateAttributeRestriction: AnyAttributeRestriction {

	final override func isValid(attribute: Attribute) -> Bool {
		return attribute is DateAttribute
	}
}
