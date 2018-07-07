//
//  AdvancedQuestion.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class AdvancedQuestion: Question {

	public fileprivate(set) var questionParts: [QuestionPart]

	public init() {
		questionParts = [QuestionPart]()
	}

	func parse(callback: (Error?) -> ()) {

	}

	func answer(callback: @escaping (Answer?, Error?) -> ()) {

	}
}
