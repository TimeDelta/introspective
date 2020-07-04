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

open class GenericDisplayableError: GenericError, DisplayableError {
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

open class GenericError: Error {
	private final let callStack: [String]
	private final let message: String
	public final var description: String {
		message + "\nStack Trace:\n\t" + callStack.joined(separator: "\n\t")
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
