//
//  DateAttribute.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol DateAttribute: Attribute {

	var includeTime: Bool { get }
	var earliestDate: Date? { get }
	var latestDate: Date? { get }
}
