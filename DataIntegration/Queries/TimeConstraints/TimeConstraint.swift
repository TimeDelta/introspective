//
//  TimeConstraint.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

public protocol TimeConstraint: Parameterized {

	func isValid() -> Bool
	func sampleAdheres(_ sample: Sample) -> Bool
}
