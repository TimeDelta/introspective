//
//  Tag.swift
//  Introspective
//
//  Created by Bryan Nova on 11/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import CoreData
import Foundation

import Persistence

public class Tag: NSManagedObject, CoreDataObject {
	// MARK: CoreData stuff

	public static let entityName = "Tag"

	// MARK: - Equality

	public final func equalTo(_ other: Tag) -> Bool {
		name.localizedLowercase == other.name.localizedLowercase
	}

	// MARK: - Other

	override public final var description: String {
		"Tag named '\(name)'"
	}
}
