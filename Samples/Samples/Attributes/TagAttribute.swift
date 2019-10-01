//
//  TagAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 11/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData

import Attributes
import Common
import DependencyInjection
import Persistence

public final class TagAttribute: TypedSelectOneAttribute<Tag> {

	// MARK: - Initializers

	public init(
		name: String = "Tag",
		pluralName: String? = "Tags",
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false)
	{
		super.init(
			name: name,
			typeName: "Tag",
			pluralName: pluralName,
			description: description,
			variableName: variableName,
			optional: optional,
			possibleValues: {
				do {
					let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
					fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
					return try DependencyInjector.get(Database.self).query(fetchRequest)
				} catch {
					Log().error("Failed to fetch tags: %@", errorInfo(error))
					return []
				}
			},
			possibleValueToString: { $0.name },
			areEqual: { $0.equalTo($1) })
	}
}
