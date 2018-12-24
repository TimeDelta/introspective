//
//  GlobalFunctions.swift
//  Introspective
//
//  Created by Bryan Nova on 12/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

func isOptional(_ instance: Any?) -> Bool {
	let mirror = Mirror(reflecting: instance as Any)
	let style = mirror.displayStyle
	return style == .optional
}
