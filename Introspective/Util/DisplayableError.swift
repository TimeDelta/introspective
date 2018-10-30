//
//  DisplayableError.swift
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

public final class GenericDisplayableError: DisplayableError {

	public final let displayableTitle: String
	public final let displayableDescription: String?

	public init(title: String, description: String? = nil) {
		displayableTitle = title
		displayableDescription = description
	}
}
