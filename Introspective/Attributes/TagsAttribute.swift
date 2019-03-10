//
//  TagsAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 11/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class TagsAttribute: TypedMultiSelectAttribute<Tag> {

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
					return try DependencyInjector.db.query(Tag.fetchRequest())
				} catch {
					Log().error("Failed to fetch tags: %@", errorInfo(error))
					return []
				}
			},
			possibleValueToString: { $0.name })
	}
}
