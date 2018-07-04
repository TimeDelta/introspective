//
//  Result.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class Result: NSObject {

	public fileprivate(set) var finalAnswer: Any
	public fileprivate(set) var returnType: ReturnType

	public init(_ finalAnswer: Any, _ returnType: ReturnType) {
		self.finalAnswer = finalAnswer
		self.returnType = returnType
	}
}
