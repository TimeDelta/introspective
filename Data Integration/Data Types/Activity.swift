//
//  Activity.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

class Activity: NSObject {

	var name: String
	var tags: NSArray

	override init() {
		name = ""
		tags = NSArray()
	}
}
