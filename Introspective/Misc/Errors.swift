//
//  Errors.swift
//  Introspective
//
//  Created by Bryan Nova on 7/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol DisplayableError: Error {

	var displayableTitle: String { get }
	var displayableDescription: String? { get }
}

public class GenericDisplayableError: GenericError, DisplayableError {

	public final let displayableTitle: String
	public final let displayableDescription: String?

	public init(title: String, description: String? = nil) {
		displayableTitle = title
		displayableDescription = description
		var text = displayableTitle
		if let description = displayableDescription {
			text += ": \(description)"
		}
		super.init(text)
	}
}

public class GenericError: Error {

	private final let callStack: [String]
	private final let message: String
	public final var description: String {
		return message + "\nStack Trace:\n\t" + callStack.joined(separator: "\n\t")
	}

	public init(_ message: String) {
		callStack = Thread.callStackSymbols
		self.message = message
	}
}

public final class NotOverriddenError: GenericError {

	public init(functionName: String) {
		super.init("Must override \(functionName)")
	}
}

public final class UnknownSampleTypeError: GenericError {

	public init(_ sampleType: Sample.Type) {
		super.init("Unknown sample type: \(sampleType.name)")
	}
}
