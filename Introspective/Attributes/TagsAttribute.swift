//
//  TagsAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 11/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class TagsAttribute: AttributeBase, MultiSelectAttribute {

	// MARK: - Instance Variables

	public final var possibleValues: [Any] {
		return fetchAllTags()
	}

	private final let log = Log()

	// MARK: - Initializers

	public override init(
		name: String = "Tags",
		pluralName: String? = "Tags",
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false)
	{
		super.init(name: name, pluralName: pluralName, description: description, variableName: variableName, optional: optional)
	}

	// MARK: - Attribute Functions

	public override func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		if let castedValue = value as? Set<Tag> {
			let tags = castedValue.map{ $0 }
			return convertTagsIntoDisplayString(tags)
		}
		if let castedValue = value as? [Tag] {
			return convertTagsIntoDisplayString(castedValue)
		}
		if let castedValue = value as? Tag {
			return castedValue.name
		}
		throw TypeMismatchError(attribute: self, wasA: type(of: value))
	}

	// MARK: - MultiSelectAttribute Functions

	public final func valueAsArray(_ value: Any) throws -> [Any] {
		if let castedValue = value as? Set<Tag> {
			return castedValue.map{ $0 }
		}
		if let castedValue = value as? [Tag] {
			return castedValue
		}
		throw UnsupportedValueError(attribute: self, is: value)
	}

	public final func valueFromArray(_ value: [Any]) throws -> Any {
		guard let castedValue = value as? [Tag] else {
			throw TypeMismatchError(attribute: self, wasA: type(of: value))
		}
		return Set<Tag>(castedValue)
	}

	// MARK: - SelectAttribute Functions

	public final func indexOf(possibleValue: Any, in values: [Any]? = nil) -> Int? {
		guard let castedValue = possibleValue as? Tag else {
			return nil
		}
		let values: [Tag] = (values as? [Tag]) ?? fetchAllTags()
		return values.index(of: castedValue)
	}

	public final func convertPossibleValueToDisplayableString(_ value: Any) throws -> String {
		guard let castedValue = value as? Tag else {
			throw TypeMismatchError(attribute: self, wasA: type(of: value))
		}
		return castedValue.name
	}

	// MARK: - Helper Functions

	private final func fetchAllTags() -> [Tag] {
		do {
			return try DependencyInjector.db.query(Tag.fetchRequest())
		} catch {
			log.error("Failed to fetch tags: %@", errorInfo(error))
			return []
		}
	}

	private final func convertTagsIntoDisplayString(_ tags: [Tag]) -> String {
		var text = ""
		for index in 0 ..< tags.count {
			if index > 0 && index < tags.count - 1 {
				text += ", "
			}
			if index == tags.count - 1 {
				text += " or "
			}
			text += tags[index].name
		}
		return text
	}
}
