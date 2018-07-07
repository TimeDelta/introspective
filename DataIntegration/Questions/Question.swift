//
//  Question.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

protocol Question {

	func parse(callback: (Error?) -> ())
	func answer(callback: @escaping (Answer?, Error?) -> ())
}
