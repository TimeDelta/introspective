//
//  FrequencyAttributeRestriction.swift
//  AttributeRestrictions
//
//  Created by Bryan Nova on 7/1/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common

public protocol FrequencyAttributeRestriction: AttributeRestriction {
	var typedValue: Frequency { get }
}
