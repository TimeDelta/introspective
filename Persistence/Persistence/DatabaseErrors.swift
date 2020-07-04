//
//  DatabaseErrors.swift
//  Introspective
//
//  Created by Bryan Nova on 1/11/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

public final class FailedToInstantiateObject: Error {
	private final let objectTypeName: String
	public final var localizedDescription: String {
		"Failed to instantiate object of type \(objectTypeName)"
	}

	public init(objectTypeName: String) {
		self.objectTypeName = objectTypeName
	}
}

public final class UnknownManagedObjectContext: Error {
	public final var localizedDescription: String {
		"Unable to determine NSManagedObjectContext for object"
	}
}
