//
//  TextAttribute.swft
//  Introspective
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol TextAttributeDelegate {
	func isValid(value: String?) -> Bool
	func errorMessageFor(invalidValue: String?) -> String
}

public final class TextAttribute: AttributeBase<String>, ComparableAttribute {
	public final override var typeName: String {
		"Text"
	}

	private final let delegate: TextAttributeDelegate?

	public init(
		id: Int16,
		name: String,
		pluralName: String? = nil,
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false,
		delegate: TextAttributeDelegate? = nil
	) {
		self.delegate = delegate
		super.init(
			id: id,
			name: name,
			pluralName: pluralName,
			description: description,
			variableName: variableName,
			optional: optional
		)
	}

	public final override func isValid(value: Any?) -> Bool {
		if value == nil {
			return optional
		}
		if let castedValue = value as? String {
			return isValid(value: castedValue)
		}
		return false
	}

	public final func isValid(value: String?) -> Bool {
		if value == nil { return optional }
		return delegate?.isValid(value: value) ?? true
	}

	public final func errorMessageFor(invalidValue: String?) -> String {
		if !optional && (invalidValue == nil || invalidValue == "") { return "Value is required" }
		return delegate?.errorMessageFor(invalidValue: invalidValue) ?? ""
	}

	public final override func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		if !optional && value == nil { throw UnsupportedValueError(attribute: self, is: nil) }
		guard let castedValue = value as? String else {
			throw TypeMismatchError(attribute: self, wasA: type(of: value))
		}
		return castedValue
	}

	public final override func typedValuesAreEqual(_ first: String, _ second: String) -> Bool {
		first == second
	}
}
