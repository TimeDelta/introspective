//
//  DosageAttributeRestriction.swift
//  AttributeRestrictions
//
//  Created by Bryan Nova on 6/30/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common

public protocol DosageAttributeRestriction: AttributeRestriction {

	var value: Dosage { get }
	var attribute: Attribute { get }
}
