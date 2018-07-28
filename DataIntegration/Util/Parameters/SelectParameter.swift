//
//  SelectParameter.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol SelectParameter: Parameter {

	var possibleValues: [Any] { get }
	func indexOf(possibleValue: Any) -> Int?
}
