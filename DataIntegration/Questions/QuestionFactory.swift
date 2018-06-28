//
//  QuestionFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

class QuestionFactory: NSObject {

	func question(text: String) -> Question {
		return Question(text: text)
	}

	func answer() -> Answer {
		return Answer()
	}

	func labels() -> Labels {
		return Labels()
	}
}
