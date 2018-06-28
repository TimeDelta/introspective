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

	public static let Average = Operations("Average")
	public static let Count = Operations("Count")
	public static let Max = Operations("Maximum")
	public static let Min = Operations("Minimum")
	public static let Sum = Operations("Total")

	fileprivate static let map = [Tags.average: Average, Tags.count: Count, Tags.max: Max, Tags.min: Min, Tags.sum: Sum]

	public enum ErrorTypes: Error {
		case UnknownOperationType
	}

	fileprivate(set) var stringRepresenation: String

	fileprivate init(_ stringRepresentation: String) {
		self.stringRepresenation = stringRepresentation
	}

	public static func from(tag: NLTag) throws -> Operations {
		let operation = map[tag]
		if operation == nil {
			throw ErrorTypes.UnknownOperationType
		}
		return operation!
	}
}
