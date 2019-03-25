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

public class GenericDisplayableError: DisplayableError {

	public final let displayableTitle: String
	public final let displayableDescription: String?

	public final var localizedDescription: String {
		var text = displayableTitle
		if let description = displayableDescription {
			text += ": \(description)"
		}
		return text
	}

	public init(title: String, description: String? = nil) {
		displayableTitle = title
		displayableDescription = description
	}
}

public final class NotOverriddenError: Error {

	private final let functionName: String
	public final var localizedDescription: String {
		return "Must override \(functionName)"
	}

	public init(functionName: String) {
		self.functionName = functionName
	}
}

public final class UnknownSampleTypeError: Error {

	private final let sampleType: Sample.Type
	public final var localizedDescription: String {
		return "Unknown sample type: \(sampleType.name)"
	}

	public init(_ sampleType: Sample.Type) {
		self.sampleType = sampleType
	}
}

public final class GenericError: Error {

	private final let message: String
	public final var localizedDescription: String {
		return message
	}

	public init(_ message: String) {
		self.message = message
	}
}
