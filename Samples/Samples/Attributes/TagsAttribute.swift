//
//  TagsAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 11/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

import Attributes
import Common
import DependencyInjection
import Persistence

public class TagsAttribute: TypedMultiSelectAttribute<Tag> {
	public final override var typeName: String {
		"Tags"
	}

	// MARK: - Initializers

	public init(
		name: String = "Tags",
		pluralName: String? = "Tags",
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false
	) {
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
					return try DependencyInjector.get(Database.self).query(fetchRequest)
				} catch {
					Log().error("Failed to fetch tags: %@", errorInfo(error))
					return []
				}
			},
			possibleValueToString: { $0.name }
		)
	}
}

/// Just to be able to identify it for tag attribute restrictions
/// because it has to be treated differently since a tag can come from
/// the activity definition as well as the activity's tags variable
public final class ActivityTagsAttribute: TagsAttribute {}
