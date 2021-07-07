//
//  SelectOneAttributeRestriction.swift
//  AttributeRestrictions
//
//  Created by Bryan Nova on 7/3/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes

public protocol SelectOneAttributeRestriction: AttributeRestriction {
	var value: Any? { get }

	var selectOneAttribute: SelectOneAttribute { get }
}
