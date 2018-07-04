//
//  Answer.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/25/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class Answer: NSObject {

	public var finalAnswer: String
	public var otherRelevantInformation: [String: [NSObject]]

	public override init() {
		finalAnswer = "Unknown"
		otherRelevantInformation = [String: [NSObject]]()
	}
}
