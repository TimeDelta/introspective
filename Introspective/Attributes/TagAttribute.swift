//
//  TagAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 11/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class TagAttribute: AttributeBase, SelectOneAttribute {

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

	public final override func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		guard let castedValue = value as? Tag else { throw AttributeError.typeMismatch }
		return castedValue.name
	}

	// MARK: - SelectAttribute Functions

	public final func indexOf(possibleValue: Any, in values: [Any]? = nil) -> Int? {
		guard let castedValue = possibleValue as? Tag else {
			return nil
		}
		let values: [Tag] = (values as? [Tag]) ?? fetchAllTags()
		return values.index(of: castedValue)
	}

	// MARK: - SelectOneAttribute Functions

	public func valuesAreEqual(_ first: Any?, _ second: Any?) -> Bool {
		guard let castedFirst = first as? Tag else {
			log.error("Failed to cast first value when testing tag equality: %@", String(describing: first))
			return false
		}
		guard let castedSecond = second as? Tag else {
			log.error("Failed to cast second value when testing tag equality: %@", String(describing: first))
			return false
		}
		return castedFirst == castedSecond
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
}
