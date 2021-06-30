//
//  StringOperation.swift
//  AttributeRestrictions
//
//  Created by Bryan Nova on 6/30/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import Foundation

/// This class is used for storage purposes only
internal enum StringOperation: Int16 {
	case contains = 0
	case startsWith = 1
	case endsWith = 2
	case equalTo = 3
	case notEqualTo = 4
	case isEmpty = 5
	case isNotEmpty = 6
}
