//
//  Tag.swift
//  Introspective
//
//  Created by Bryan Nova on 11/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//
//

import Foundation
import CoreData

public class Tag: NSManagedObject, CoreDataObject {

	// MARK: CoreData stuff

	public static let entityName = "Tag"

	// MARK: - Equality

	public static func ==(lhs: Tag, rhs: Tag) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final func equalTo(_ other: Tag) -> Bool {
		return name.localizedLowercase == other.name.localizedLowercase
	}

	// MARK: - Other

	public final override var description: String {
		return "Tag named '\(name)'"
	}
}
