//
//  SingleTagAttributeRestriction.swift
//  AttributeRestrictions
//
//  Created by Bryan Nova on 7/3/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import Foundation

import Samples

public protocol SingleTagAttributeRestriction: AttributeRestriction {
	var tagName: String { get }
}
