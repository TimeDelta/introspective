//
//  Answer.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/25/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

class Answer: NSObject {

	fileprivate(set) var parts: [String: [NSObject]]

	override init() {
		self.parts = [String: [NSObject]]()
	}

	func addPart(_ partName: String, _ partValues: [NSObject]) {
		parts[partName] = partValues
	}
}
