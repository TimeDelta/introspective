//
//  ImporterErrors.swift
//  Introspective
//
//  Created by Bryan Nova on 10/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Common

public final class InvalidFileFormatError: GenericDisplayableError {

	public init(_ specificError: String? = nil) {
		super.init(title: "Invalid file format", description: specificError)
	}
}

public final class AmbiguousUpdateToExistingDataError: GenericDisplayableError {

	public init(_ specificError: String?) {
		super.init(title: "Ambiguous update requested", description: specificError)
	}
}

public final class MissingRequiredFieldError: GenericDisplayableError {

	public init(_ missingFieldName: String, recordNumber: Int) {
		super.init(
			title: "Missing \(missingFieldName)",
			description: "There is no \(missingFieldName) value for record \(recordNumber)"
		)
	}
}
