//
//  ImporterErrors.swift
//  Introspective
//
//  Created by Bryan Nova on 10/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class InvalidFileFormatError: DisplayableError {

	public final let displayableTitle: String = "Invalid file format"
	public final let displayableDescription: String?

	public init(_ specificError: String? = nil) {
		displayableDescription = specificError
	}
}

public final class AmbiguousUpdateToExistingDataError: DisplayableError {

	public final let displayableTitle: String = "Ambiguous update requested"
	public final let displayableDescription: String?

	public init(_ specificError: String?) {
		displayableDescription = specificError
	}
}
