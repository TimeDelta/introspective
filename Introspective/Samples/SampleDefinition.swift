//
//  SampleDefinition.swift
//  Introspective
//
//  Created by Bryan Nova on 9/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol SampleDefinition {

	var name: String { get }
	var description: String { get }

	var attributes: [AttributeBase] { get }
	var startDateAttribute: AttributeBase { get }
	var endDateAttribute: AttributeBase? { get }
}
