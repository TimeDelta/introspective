//
//  Operations.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import NaturalLanguage

class Operations: NSObject {

	static let Average = Operations("Average")
	static let Count = Operations("Count")
	static let Max = Operations("Maximum")
	static let Min = Operations("Minimum")
	static let Sum = Operations("Total")

	enum ErrorTypes: Error {
		case UnknownOperationType
	}

	fileprivate(set) var stringRepresenation: String

	fileprivate init(_ stringRepresentation: String) {
		self.stringRepresenation = stringRepresentation
	}

	static func from(tag: NLTag) throws -> Operations {
		switch(tag) {
			case Tags.average:
				return Average
			case Tags.count:
				return Count
			case Tags.max:
				return Max
			case Tags.min:
				return Min
			case Tags.sum:
				return Sum
			default:
				throw ErrorTypes.UnknownOperationType
		}
	}
}
