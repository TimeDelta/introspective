//
//  AttributeErrors.swift
//  Introspective
//
//  Created by Bryan Nova on 1/5/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

public class AttributeError: Error {
	fileprivate final let attribute: Attribute

	fileprivate init(_ attribute: Attribute) {
		self.attribute = attribute
	}
}

public final class TypeMismatchError: AttributeError {
	fileprivate final let attributedObject: Attributed?
	private final var valueType: Any.Type
	public final var localizedDescription: String {
		if let attributedObject = attributedObject {
			return "Type mismatch for '\(attribute.name)' of '\(attributedObject.attributedName)': was a \(String(describing: valueType))"
		}
		return "Type mismatch for attribute named '\(attribute.name)': was a \(String(describing: valueType))"
	}

	public init(attribute: Attribute, of attributedObject: Attributed? = nil, wasA valueType: Any.Type) {
		self.valueType = valueType
		self.attributedObject = attributedObject
		super.init(attribute)
	}
}

public final class UnsupportedValueError: AttributeError {
	private final let attributedObject: Attributed?
	private final var value: Any?
	public final var localizedDescription: String {
		if let attributedObject = attributedObject {
			return "Unsupported value for '\(attribute.name)' of '\(attributedObject.attributedName)': \(String(describing: value ?? "nil"))"
		}
		return "Unsupported value for '\(attribute.name)': \(String(describing: value ?? "nil"))"
	}

	public init(attribute: Attribute, of attributedObject: Attributed? = nil, is value: Any?) {
		self.value = value
		self.attributedObject = attributedObject
		super.init(attribute)
	}
}

public final class UnknownAttributeError: AttributeError {
	private final let attributedObject: Attributed
	public final var localizedDescription: String {
		"'\(attributedObject.attributedName)' does not have an attribute named '\(attribute.name)'"
	}

	public init(attribute: Attribute, for attributedObject: Attributed) {
		self.attributedObject = attributedObject
		super.init(attribute)
	}
}
