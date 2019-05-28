//
//  TagsAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 11/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData

public final class TagsAttribute: TypedMultiSelectAttribute<Tag> {

	public final override var typeName: String {
		return "Tags"
	}

	// MARK: - Initializers

	public init(
		name: String = "Tags",
		pluralName: String? = "Tags",
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false)
	{
		super.init(
			name: name,
			pluralName: pluralName,
			description: description,
			variableName: variableName,
			optional: optional,
			possibleValues: {
				do {
					let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
					fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
					return try DependencyInjector.db.query(fetchRequest)
				} catch {
					Log().error("Failed to fetch tags: %@", errorInfo(error))
					return []
				}
			},
			possibleValueToString: { $0.name })
	}
}
