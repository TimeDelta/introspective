//
//  DateOperation.swift
//  AttributeRestrictions
//
//  Created by Bryan Nova on 6/30/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import Foundation

internal enum DateOperation: Int16 {

	case onDate = 0
	case beforeDate = 1
	case afterDate = 2
	case beforeDateAndTime = 3
	case afterDateAndTime = 4
}
