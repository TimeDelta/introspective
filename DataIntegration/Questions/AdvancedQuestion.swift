//
//  AdvancedQuestion.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class AdvancedQuestion: Question {

	public var questionParts: [Query<AnySample>]

	public init() {
		questionParts = [Query<AnySample>]()
	}

	func parse(callback: (Error?) -> ()) {} // no need to do anything

	func answer(callback: @escaping (Answer?, Error?) -> ()) {

	}
}
