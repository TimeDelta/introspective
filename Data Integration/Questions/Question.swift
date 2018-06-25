//
//  Question.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

class Question: NSObject {

	var questionText: String
	var questionParts: [String]

	init(text: String) {
		questionText = text
		questionParts = [String]()
	}

	func parse() {

	}

	func answer() {

	}
}
